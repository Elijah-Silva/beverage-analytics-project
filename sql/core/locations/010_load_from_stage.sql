SET search_path TO core;

INSERT INTO core.locations (location_name, address, city, state, country_code_id, latitude, longitude)
SELECT l.location_name, l.address, l.city, l.state, cc.country_code_id, l.latitude, l.longitude
FROM stage.locations l
JOIN ref.country_codes  cc  ON cc.country_code  = l.country_code;
