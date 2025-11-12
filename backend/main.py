from datetime import date
from io import StringIO
from typing import Generator, List, Optional

from fastapi import Depends, FastAPI, File, HTTPException, Query, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from .database import SessionLocal, engine
from .models import (
    Base,
    DimAccount,
    DimCompany,
    DimDate,
    DimIndicator,
    FactDREEntry,
    FactIndicatorValue,
)
from .schemas import DRESummaryItem, ImportResponse, IndicatorItem
from .services.import_csv import import_csv
from .utils.logger import get_logger


logger = get_logger()

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Orbit Analytics API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()


@app.post("/api/import/{dataset}", response_model=ImportResponse)
async def upload_csv(dataset: str, file: UploadFile = File(...)):
    if file.content_type not in {"text/csv", "application/vnd.ms-excel", "application/octet-stream"}:
        raise HTTPException(status_code=400, detail="Tipo de arquivo inválido")
    content = await file.read()
    try:
        text = content.decode("utf-8-sig")
    except UnicodeDecodeError as exc:
        raise HTTPException(status_code=400, detail="Não foi possível decodificar o arquivo") from exc
    summary = import_csv(dataset, StringIO(text))
    return ImportResponse(**summary)


@app.get("/api/dre/resumo", response_model=List[DRESummaryItem])
def get_dre_summary(
    start_date: Optional[date] = Query(None, description="Data inicial"),
    end_date: Optional[date] = Query(None, description="Data final"),
    company_code: Optional[str] = Query(None, description="Código da empresa"),
    account_type: Optional[str] = Query(None, description="Tipo de conta"),
    db: Session = Depends(get_db),
):
    query = (
        select(
            DimDate.date.label("period"),
            DimAccount.code.label("account_code"),
            DimAccount.name.label("account_name"),
            DimAccount.type.label("account_type"),
            func.sum(FactDREEntry.amount).label("total_amount"),
        )
        .join(DimAccount, FactDREEntry.account_id == DimAccount.id)
        .join(DimDate, FactDREEntry.date_id == DimDate.id)
        .join(DimCompany, FactDREEntry.company_id == DimCompany.id)
        .group_by(DimDate.date, DimAccount.code, DimAccount.name, DimAccount.type)
        .order_by(DimDate.date)
    )

    if start_date:
        query = query.where(DimDate.date >= start_date)
    if end_date:
        query = query.where(DimDate.date <= end_date)
    if company_code:
        query = query.where(DimCompany.code == company_code)
    if account_type:
        query = query.where(DimAccount.type == account_type)

    result = db.execute(query).all()
    return [
        DRESummaryItem(
            period=row.period,
            account_code=row.account_code,
            account_name=row.account_name,
            account_type=row.account_type,
            total_amount=row.total_amount,
        )
        for row in result
    ]


@app.get("/api/indicadores", response_model=List[IndicatorItem])
def get_indicators(
    indicator_code: Optional[str] = Query(None, description="Filtrar por código de indicador"),
    company_code: Optional[str] = Query(None, description="Filtrar por empresa"),
    db: Session = Depends(get_db),
):
    query = (
        select(
            DimIndicator.code.label("indicator_code"),
            DimIndicator.name.label("indicator_name"),
            DimIndicator.unit.label("unit"),
            DimDate.date.label("period"),
            DimCompany.code.label("company_code"),
            DimCompany.name.label("company_name"),
            FactIndicatorValue.value.label("value"),
        )
        .join(DimIndicator, FactIndicatorValue.indicator_id == DimIndicator.id)
        .join(DimDate, FactIndicatorValue.date_id == DimDate.id)
        .join(DimCompany, FactIndicatorValue.company_id == DimCompany.id, isouter=True)
        .order_by(DimDate.date.desc())
    )

    if indicator_code:
        query = query.where(DimIndicator.code == indicator_code)
    if company_code:
        query = query.where(DimCompany.code == company_code)

    result = db.execute(query).all()
    return [
        IndicatorItem(
            indicator_code=row.indicator_code,
            indicator_name=row.indicator_name,
            unit=row.unit,
            period=row.period,
            company_code=row.company_code,
            company_name=row.company_name,
            value=row.value,
        )
        for row in result
    ]
