from datetime import date
from typing import List, Optional

from pydantic import BaseModel


class ImportResponse(BaseModel):
    dataset: str
    rows: int
    errors: List[str]


class DRESummaryItem(BaseModel):
    period: date
    account_code: str
    account_name: str
    account_type: Optional[str]
    total_amount: float


class IndicatorItem(BaseModel):
    indicator_code: str
    indicator_name: str
    unit: Optional[str]
    period: date
    company_code: Optional[str]
    company_name: Optional[str]
    value: float
