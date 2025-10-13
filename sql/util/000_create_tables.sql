CREATE TABLE util.session_batch_review (
    review_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_code     TEXT,
    product_name     TEXT,
    vendor_name      TEXT,
    quantity_used    NUMERIC(7,2),
    role             TEXT,
    reason           TEXT,          -- e.g. 'NO_MATCH_PRODUCT', 'NO_MATCH_VENDOR'
    created_at       TIMESTAMPTZ DEFAULT now()
);