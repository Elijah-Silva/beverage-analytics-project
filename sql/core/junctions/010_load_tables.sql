SET search_path TO core;

INSERT INTO core.product_countries (product_id, country_code_id)
WITH get_country_names
AS
    (SELECT
         product_id,
         TRIM(UNNEST(string_to_array(p.region, ','))) as country_name
    FROM
        core.products p)
SELECT gcn.product_id, cc.country_code_id
FROM ref.country_codes cc
    JOIN get_country_names gcn ON gcn.country_name = cc.country_name;