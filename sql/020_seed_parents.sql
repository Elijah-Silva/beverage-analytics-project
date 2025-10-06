-- =============================================
-- 020_seed_parents.sql
-- Purpose: Seed parent tables 
-- =============================================

SET search_path TO beverage;

BEGIN;

-- Reset parent tables
TRUNCATE TABLE
	vendors,
	products
RESTART IDENTITY CASCADE;

-- Seed vendors table
INSERT INTO vendors (vendor_name, country_code_id, currency_code_id)
SELECT v.vendor_name,
       ctry.country_code_id,
       curr.currency_code_id
FROM (
  VALUES
    ('Essence of Tea', 'CN', 'CNY'),
    ('Sazen Tea', 'JP', 'JPY'),
    ('white2tea', 'CN', 'CNY'),
    ('Yunnan Sourcing', 'CN', 'CNY'),
    ('Crimson Lotus', 'CN', 'CNY'),
    ('MudandLeaves', 'CA', 'CAN'),
    ('Bitterleaf Teas', 'CN', 'CNY'),
    ('Yinchen Studio', 'CN', 'CNY'),
    ('Ippodo', 'US', 'USD'),
    ('Eco-Cha', 'TW', 'TWD'),
    ('Wuyi Origin', 'CN', 'CNY'),
    ('Hibiki-An', 'JP', 'JPY'),
    ('Eight Ounce Coffee', 'CA', 'CAD')
) AS v(vendor_name, country_code, currency_code)
JOIN country_codes ctry
  ON ctry.country_code = v.country_code
JOIN currency_codes curr
  ON curr.currency_code = v.currency_code;

/* -- Lookup country and currency codes	
select * from country_codes where lower(country_name) LIKE lower('%Canada%');
select * from currency_codes where lower(currency_name) LIKE lower('%Cana%');
*/

-- Seed products table

COMMIT;