from sqlalchemy import Float, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base


class FactDREEntry(Base):
    __tablename__ = "fact_dre_entry"
    __table_args__ = (
        UniqueConstraint(
            "date_id",
            "account_id",
            "company_id",
            "cost_center_id",
            name="uq_dre_entry"
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    date_id: Mapped[int] = mapped_column(ForeignKey("dim_date.id"), nullable=False)
    account_id: Mapped[int] = mapped_column(ForeignKey("dim_account.id"), nullable=False)
    company_id: Mapped[int] = mapped_column(ForeignKey("dim_company.id"), nullable=False)
    cost_center_id: Mapped[int] = mapped_column(ForeignKey("dim_cost_center.id"), nullable=True)
    amount: Mapped[float] = mapped_column(Float, nullable=False)

    date = relationship("DimDate")
    account = relationship("DimAccount")
    company = relationship("DimCompany")
    cost_center = relationship("DimCostCenter")


class FactIndicatorValue(Base):
    __tablename__ = "fact_indicator_value"
    __table_args__ = (
        UniqueConstraint(
            "date_id",
            "indicator_id",
            "company_id",
            name="uq_indicator_value"
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    date_id: Mapped[int] = mapped_column(ForeignKey("dim_date.id"), nullable=False)
    indicator_id: Mapped[int] = mapped_column(ForeignKey("dim_indicator.id"), nullable=False)
    company_id: Mapped[int] = mapped_column(ForeignKey("dim_company.id"), nullable=True)
    value: Mapped[float] = mapped_column(Float, nullable=False)

    date = relationship("DimDate")
    indicator = relationship("DimIndicator")
    company = relationship("DimCompany")
