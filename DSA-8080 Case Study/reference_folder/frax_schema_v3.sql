CREATE TABLE IF NOT EXISTS frax_transactions (
    transaction_id INT PRIMARY KEY
    ,access_list JSONB
    ,block_number INT
    ,block_time DATE
    ,frax_data TEXT
    ,from_data TEXT
    ,gas_limit FLOAT
    ,gas_price FLOAT
    ,gas_used FLOAT
    ,hash_value TEXT
    ,index_value FLOAT
    ,max_fee_per_gas FLOAT
    ,max_priority_fee_per_gas FLOAT
    ,nounc FLOAT
    ,priority_fee_per_gas FLOAT
    ,success BOOLEAN
    ,to_value TEXT
    ,type_value TEXT
    ,value_transactions FLOAT
    ,date_id INT REFERENCES date_table (date_id)
);

CREATE TABLE IF NOT EXISTS frax_traces (
    trace_id INT PRIMARY KEY
    ,block_number INT
    ,block_time DATE
    ,call_type TEXT
    ,error TEXT
    ,from_data TEXT
    ,gas FLOAT
    ,gas_used FLOAT
    ,input_data TEXT
    ,output_data TEXT
    ,sub_traces INT
    ,success BOOLEAN
    ,to_value TEXT
    ,tx_hash TEXT
    ,tx_index FLOAT
    ,tx_success BOOLEAN
    ,type_value TEXT
    ,value_traces FLOAT
    ,date_id INT REFERENCES date_table (date_id)
);

CREATE TABLE IF NOT EXISTS frax_contracts (
    contracts_address TEXT PRIMARY KEY
    ,base BOOLEAN
    ,code TEXT
    ,created_at DATE
    ,dynamic_contracts BOOLEAN
    ,factory TEXT
    ,contracts_id INT
    ,contracts_name TEXT
    ,contracts_namespace TEXT
    ,updated_at DATE
    ,created_date_id INT REFERENCES date_table (date_id)
    ,updated_date_id INT REFERENCES date_table (date_id)
);

CREATE TABLE IF NOT EXISTS frax_logs (
    log_id INT PRIMARY KEY
    ,block_time DATE
    ,contract_address TEXT REFERENCES frax_contracts (contracts_address)
    ,log_data TEXT
    ,logs_index FLOAT
    ,topic1 TEXT
    ,topic2 TEXT
    ,topic3 TEXT
    ,topic4 TEXT
    ,tx_hash TEXT
    ,tx_index FLOAT
    ,date_id INT REFERENCES date_table (date_id)
);

CREATE TABLE IF NOT EXISTS date_table (
    date_id SERIAL PRIMARY KEY
    ,date DATE
);

CREATE TABLE IF NOT EXISTS frax_price (
    date_id INT REFERENCES date_table (date_id)
    ,date DATE
    ,price FLOAT
    ,symbol TEXT
    ,PRIMARY KEY (date, symbol)
);

/* CREATE TABLE IF NOT EXISTS fxs_price (
    date DATE  PRIMARY KEY
    ,price FLOAT
    ,symbol TEXT
    ,date_id INT REFERENCES date_table (date_id)
); */

CREATE TABLE IF NOT EXISTS frax_main (
    block_hash TEXT 
    ,transaction_id INT REFERENCES frax_transactions (transaction_id)
    ,trace_id INT REFERENCES frax_traces (trace_id)
    ,log_id INT REFERENCES frax_logs (log_id)
);
