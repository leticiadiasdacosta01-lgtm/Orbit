CREATE TABLE IF NOT EXISTS fact_dre_entry (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER NOT NULL,
    account_id INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    cost_center_id INTEGER,
    amount REAL NOT NULL,
    CONSTRAINT uq_dre_entry UNIQUE (date_id, account_id, company_id, cost_center_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(id),
    FOREIGN KEY (account_id) REFERENCES dim_account(id),
    FOREIGN KEY (company_id) REFERENCES dim_company(id),
    FOREIGN KEY (cost_center_id) REFERENCES dim_cost_center(id)
);

CREATE TABLE IF NOT EXISTS fact_indicator_value (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER NOT NULL,
    indicator_id INTEGER NOT NULL,
    company_id INTEGER,
    value REAL NOT NULL,
    CONSTRAINT uq_indicator_value UNIQUE (date_id, indicator_id, company_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(id),
    FOREIGN KEY (indicator_id) REFERENCES dim_indicator(id),
    FOREIGN KEY (company_id) REFERENCES dim_company(id)
);

CREATE TABLE IF NOT EXISTS import_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dataset TEXT NOT NULL,
    file_name TEXT NOT NULL,
    status TEXT NOT NULL,
    rows_processed INTEGER NOT NULL DEFAULT 0,
    errors TEXT,
    imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
