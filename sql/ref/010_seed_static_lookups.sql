SET SEARCH_PATH = ref;

-- Seed product types
INSERT INTO product_types (product_type_name)
VALUES
	('Coffee'),
	('Tea'),
	('Teaware'),
	('Coffeeware');

-- Seed brewing methods
INSERT INTO brewing_methods (brewing_method_name)
VALUES
	('Gongfu'),
	('Western'),
	('Grandpa'),
	('Kyusu'),
	('Cold Brew'),
	('Matcha'),
	('Espresso'),
	('Filter'),
	('Moka'),
	('Pour Over');

INSERT INTO session_locations (session_location_name)
VALUES
	('Home'),
	('Shop'),
	('Outdoors'),
	('Work'),
	('Ceremonial');

INSERT INTO order_status (order_status_name)
VALUES
	('Pending'),
	('Placed'),
	('Shipped'),
	('Received'),
	('Cancelled'),
	('Returned');

INSERT INTO roles (role_name)
VALUES
	('Kettle'),
	('Teapot'),
	('Gongfu'),
	('Faircup'),
	('Cup');

INSERT INTO varietals (varietal_name)
VALUES
	('Arabica'),
	('Robusta'),
	('Liberica'),
	('Excelsa'),
	('Yabukita'),
	('Saemidori'),
  	('Okumidori'),
  	('Asatsuyu'),
  	('Tieguanyin'),
 	('Longjing'),
 	('Da Hong Pao'),
  	('Bai Mudan'),
  	('Shou Mei'),
  	('Sheng Pu-erh'),
  	('Shou Pu-erh'),
 	('Silver Needle'),
	('Jin Jun Mei'),
  	('Huangshan Maofeng'),
  	('Sencha'),
  	('Gyokuro'),
	('Castillo');

INSERT INTO processing_methods (processing_method_name)
VALUES
  	('Washed'),
  	('Natural'),
  	('Honey'),
  	('Wet-Hulled'),
  	('Anaerobic'),
  	('Carbonic Maceration'),
  	('Roasted'),
  	('Steamed'),
  	('Pan-Fired'),
  	('Sun-Dried'),
  	('Withered'),
  	('Rolled'),
  	('Oxidized'),
  	('Fermented'),
  	('Aged'),
  	('Compressed'),
  	('Blended'),
	('Thermal Shock Washed');

INSERT INTO materials (material_name, category)
VALUES
  -- Ceramics
  	('Porcelain', 'Ceramic'),
  	('Stoneware', 'Ceramic'),
  	('Earthenware', 'Ceramic'),
  	('Bone China', 'Ceramic'),
  	('Clay', 'Ceramic'),

  -- Glass
 	('Glass', 'Glass'),
  	('Borosilicate Glass', 'Glass'),

  -- Metals
  	('Cast Iron', 'Metal'),
  	('Copper', 'Metal'),
  	('Brass', 'Metal'),
  	('Stainless Steel', 'Metal'),
  	('Silver', 'Metal'),

  -- Natural Materials
  	('Wood', 'Natural'),
  	('Bamboo', 'Natural'),

  -- Synthetic
  	('Plastic', 'Synthetic');


INSERT INTO clay_types (clay_type_name)
VALUES
  	('Zisha'),
  	('Hongni'),
  	('Duan Ni'),
  	('Zhuni'),
  	('Hei Ni'),
  	('Ben Shan Lü Ni'),
  	('Tieli Ni'),
  	('Qing Shui Ni'),
  	('Tokoname'),
  	('Banko'),
  	('Shigaraki'),
  	('Bizen'),
  	('Seto'),
  	('Karatsu'),
  	('Iga'),
  	('Mashiko');