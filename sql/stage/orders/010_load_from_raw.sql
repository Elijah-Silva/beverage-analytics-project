SET search_path TO stage;

INSERT INTO stage.orders (vendor_name, order_date, order_number, shipping_cost, total_cost,
                            order_status, created_date, last_modified_date)
SELECT
    vendor_name,
    order_date::DATE,
    order_number,
    shipping_cost::NUMERIC(7,2),
    total_cost::NUMERIC(9,2),
    order_status,
    created_date::DATE,
    last_modified_date::DATE
FROM raw.orders;
