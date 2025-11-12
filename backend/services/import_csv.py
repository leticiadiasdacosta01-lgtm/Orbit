from __future__ import annotations

import csv
from dataclasses import dataclass
from datetime import datetime
from io import StringIO, TextIOBase
from typing import Callable, Dict, Iterable, List, Tuple

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from ..database import SessionLocal
from ..models import (
    DimAccount,
    DimCompany,
    DimCostCenter,
    DimDate,
    DimIndicator,
    FactDREEntry,
    FactIndicatorValue,
    ImportHistory,
)
from ..utils.logger import get_logger


logger = get_logger()


@dataclass
class ColumnDefinition:
    name: str
    parser: Callable[[str], object]


class CSVValidationError(Exception):
    pass


def parse_date(value: str) -> datetime.date:
    for fmt in ("%Y-%m-%d", "%d/%m/%Y", "%Y%m%d"):
        try:
            return datetime.strptime(value.strip(), fmt).date()
        except ValueError:
            continue
    raise CSVValidationError(f"Formato de data inválido: {value}")


def parse_float(value: str) -> float:
    value = value.replace(".", "").replace(",", ".") if "," in value and value.count(",") == 1 else value
    try:
        return float(value)
    except ValueError as exc:
        raise CSVValidationError(f"Valor numérico inválido: {value}") from exc


def parse_str(value: str) -> str:
    return value.strip()


DATASET_SCHEMAS: Dict[str, List[ColumnDefinition]] = {
    "dre": [
        ColumnDefinition("date", parse_date),
        ColumnDefinition("account_code", parse_str),
        ColumnDefinition("account_name", parse_str),
        ColumnDefinition("account_type", parse_str),
        ColumnDefinition("company_code", parse_str),
        ColumnDefinition("company_name", parse_str),
        ColumnDefinition("cost_center_code", parse_str),
        ColumnDefinition("cost_center_name", parse_str),
        ColumnDefinition("amount", parse_float),
    ],
    "indicator": [
        ColumnDefinition("period", parse_date),
        ColumnDefinition("indicator_code", parse_str),
        ColumnDefinition("indicator_name", parse_str),
        ColumnDefinition("indicator_unit", parse_str),
        ColumnDefinition("company_code", parse_str),
        ColumnDefinition("company_name", parse_str),
        ColumnDefinition("value", parse_float),
    ],
}


def _ensure_columns(headers: Iterable[str], dataset: str) -> List[ColumnDefinition]:
    expected = DATASET_SCHEMAS.get(dataset)
    if expected is None:
        raise HTTPException(status_code=400, detail=f"Dataset desconhecido: {dataset}")

    header_list = [h.strip() for h in headers]
    expected_names = [col.name for col in expected]
    if header_list != expected_names:
        raise HTTPException(
            status_code=400,
            detail=f"Colunas inválidas para {dataset}. Esperado: {expected_names}"
        )
    return expected


def _get_or_create_date(session: Session, value: datetime.date) -> DimDate:
    instance = session.scalar(select(DimDate).where(DimDate.date == value))
    if instance:
        return instance
    instance = DimDate(date=value, year=value.year, month=value.month, day=value.day)
    session.add(instance)
    session.flush()
    return instance


def _get_or_create_company(session: Session, code: str, name: str) -> DimCompany:
    instance = session.scalar(select(DimCompany).where(DimCompany.code == code))
    if instance:
        if instance.name != name:
            instance.name = name
        return instance
    instance = DimCompany(code=code, name=name)
    session.add(instance)
    session.flush()
    return instance


def _get_or_create_cost_center(session: Session, company: DimCompany, code: str, name: str) -> DimCostCenter | None:
    if not code:
        return None
    instance = session.scalar(
        select(DimCostCenter).where(
            DimCostCenter.code == code,
            DimCostCenter.company_id == company.id,
        )
    )
    if instance:
        if instance.name != name:
            instance.name = name
        return instance
    instance = DimCostCenter(code=code, name=name, company_id=company.id)
    session.add(instance)
    session.flush()
    return instance


def _get_or_create_account(session: Session, code: str, name: str, account_type: str | None) -> DimAccount:
    instance = session.scalar(select(DimAccount).where(DimAccount.code == code))
    if instance:
        if instance.name != name:
            instance.name = name
        if account_type and instance.type != account_type:
            instance.type = account_type
        return instance
    instance = DimAccount(code=code, name=name, type=account_type)
    session.add(instance)
    session.flush()
    return instance


def _get_or_create_indicator(session: Session, code: str, name: str, unit: str | None) -> DimIndicator:
    instance = session.scalar(select(DimIndicator).where(DimIndicator.code == code))
    if instance:
        if instance.name != name:
            instance.name = name
        if unit and instance.unit != unit:
            instance.unit = unit
        return instance
    instance = DimIndicator(code=code, name=name, unit=unit)
    session.add(instance)
    session.flush()
    return instance


def _upsert_dre(session: Session, row: Dict[str, object]) -> None:
    date_dim = _get_or_create_date(session, row["date"])
    company_dim = _get_or_create_company(session, row["company_code"], row["company_name"])
    cost_center_dim = _get_or_create_cost_center(session, company_dim, row["cost_center_code"], row["cost_center_name"])
    account_dim = _get_or_create_account(session, row["account_code"], row["account_name"], row.get("account_type"))

    existing = session.scalar(
        select(FactDREEntry).where(
            FactDREEntry.date_id == date_dim.id,
            FactDREEntry.account_id == account_dim.id,
            FactDREEntry.company_id == company_dim.id,
            FactDREEntry.cost_center_id == (cost_center_dim.id if cost_center_dim else None),
        )
    )
    if existing:
        existing.amount = row["amount"]
    else:
        session.add(
            FactDREEntry(
                date_id=date_dim.id,
                account_id=account_dim.id,
                company_id=company_dim.id,
                cost_center_id=cost_center_dim.id if cost_center_dim else None,
                amount=row["amount"],
            )
        )


def _upsert_indicator(session: Session, row: Dict[str, object]) -> None:
    date_dim = _get_or_create_date(session, row["period"])
    company_dim = None
    if row["company_code"]:
        company_dim = _get_or_create_company(session, row["company_code"], row["company_name"])
    indicator_dim = _get_or_create_indicator(session, row["indicator_code"], row["indicator_name"], row.get("indicator_unit"))

    existing = session.scalar(
        select(FactIndicatorValue).where(
            FactIndicatorValue.date_id == date_dim.id,
            FactIndicatorValue.indicator_id == indicator_dim.id,
            FactIndicatorValue.company_id == (company_dim.id if company_dim else None),
        )
    )
    if existing:
        existing.value = row["value"]
    else:
        session.add(
            FactIndicatorValue(
                date_id=date_dim.id,
                indicator_id=indicator_dim.id,
                company_id=company_dim.id if company_dim else None,
                value=row["value"],
            )
        )


UPSERT_FUNCTIONS: Dict[str, Callable[[Session, Dict[str, object]], None]] = {
    "dre": _upsert_dre,
    "indicator": _upsert_indicator,
}


def _parse_rows(dataset: str, file_text: str) -> Tuple[List[Dict[str, object]], List[str]]:
    reader = csv.reader(StringIO(file_text))
    try:
        headers = next(reader)
    except StopIteration as exc:
        raise HTTPException(status_code=400, detail="Arquivo vazio") from exc

    schema = _ensure_columns(headers, dataset)
    parsed_rows: List[Dict[str, object]] = []
    errors: List[str] = []

    for line_number, values in enumerate(reader, start=2):
        if not any(v.strip() for v in values):
            continue
        if len(values) != len(schema):
            errors.append(f"Linha {line_number}: número de colunas inválido")
            continue
        parsed_row: Dict[str, object] = {}
        for definition, raw in zip(schema, values):
            try:
                parsed_row[definition.name] = definition.parser(raw)
            except CSVValidationError as exc:
                errors.append(f"Linha {line_number}: {exc}")
                break
        else:
            parsed_rows.append(parsed_row)
    return parsed_rows, errors


def import_csv(dataset: str, file_obj: TextIOBase) -> Dict[str, object]:
    file_obj.seek(0)
    file_text = file_obj.read()
    rows, errors = _parse_rows(dataset, file_text)
    upsert = UPSERT_FUNCTIONS.get(dataset)
    if upsert is None:
        raise HTTPException(status_code=400, detail=f"Dataset não suportado: {dataset}")

    import_summary = {
        "dataset": dataset,
        "rows": len(rows),
        "errors": errors,
    }

    session = SessionLocal()
    history = ImportHistory(
        dataset=dataset,
        file_name=getattr(file_obj, "name", "upload.csv"),
        status="processing",
        rows_processed=0,
    )
    session.add(history)
    session.flush()

    processed = 0
    try:
        for row in rows:
            upsert(session, row)
            processed += 1

        history.status = "success" if not errors else "partial"
        history.rows_processed = processed
        if errors:
            history.errors = "\n".join(errors[:20])

        session.commit()
        logger.info(
            "Importação '%s' concluída com %s linhas (status=%s)",
            dataset,
            processed,
            history.status,
        )
    except IntegrityError as exc:
        session.rollback()
        history.status = "failed"
        history.rows_processed = processed
        history.errors = str(exc)
        session.add(history)
        session.commit()
        logger.exception("Erro ao processar importação")
        raise HTTPException(status_code=400, detail="Erro ao salvar dados") from exc
    except Exception as exc:  # pylint: disable=broad-except
        session.rollback()
        history.status = "failed"
        history.rows_processed = processed
        history.errors = str(exc)
        session.add(history)
        session.commit()
        logger.exception("Erro inesperado durante importação")
        raise HTTPException(status_code=500, detail="Falha inesperada durante importação") from exc
    finally:
        session.close()

    return import_summary
