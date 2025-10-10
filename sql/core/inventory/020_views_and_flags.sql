SET SEARCH_PATH = core;


-----
--
CREATE OR REPLACE VIEW core.v_available_batches AS
SELECT
    bi.batch_inventory_id,
    bi.product_id,
    p.product_name,
    pt.product_type_name,
    bi.quantity_weight as original_qty,
    bi.qty_on_hand,
    bi.received_date,
    bi.best_before_date,
    bi.is_in_stock,
    o.order_date,
    v.vendor_name
FROM core.batch_inventory bi
    JOIN core.products p ON p.product_id = bi.product_id
    JOIN ref.product_types pt ON pt.product_type_id = p.product_type_id
    LEFT JOIN core.order_items oi ON oi.order_item_id = bi.order_item_id
    LEFT JOIN core.orders o ON o.order_id = oi.order_id
    LEFT JOIN core.vendors v ON v.vendor_id = p.vendor_id
WHERE bi.is_in_stock = TRUE
ORDER BY bi.received_date ASC, bi.batch_inventory_id ASC;

-------
-- current inventory
CREATE VIEW core.current_inventory
AS
with sum_batch_id as
    (
    select product_id, sum(coalesce(quantity_used,0))
    from batch_inventory bi
    left join core.session_batch_inventory sbi on bi.batch_inventory_id = sbi.batch_inventory_id
    group by bi.batch_inventory_id
    )
select
    p.product_name,
    bi.qty_on_hand - coalesce(sum, 0) as qty_left
from sum_batch_id sbi
join batch_inventory bi on bi.product_id = sbi.product_id
join products p on p.product_id = sbi.product_id
where product_type_id != (
    select product_type_id
    from ref.product_types
    where product_type_name = 'Equipment');


--------
-- view to see your most recent session
CREATE OR REPLACE VIEW core.v_latest_session_id AS
SELECT session_id, session_code, session_date, rating
FROM core.sessions
ORDER BY session_date DESC, session_id DESC
LIMIT 1;

select * from core.current_inventory;

-- Step 1: Find your latest session_id

--SELECT session_id FROM core.v_latest_session_id;

-- Step 2: Find available batches for your product
/*
SELECT batch_inventory_id, product_name, qty_on_hand
FROM core.v_available_batches
WHERE product_name LIKE '%No6%';
*/
-- Step 3: Add
/*
INSERT INTO core.session_batch_inventory (session_id, batch_inventory_id, quantity_used, role_id)
VALUES
    (?, ?, ?, (SELECT role_id FROM ref.roles WHERE role_name = '?')),
    (?, ?, ?, (SELECT role_id FROM ref.roles WHERE role_name = '?'));
 */