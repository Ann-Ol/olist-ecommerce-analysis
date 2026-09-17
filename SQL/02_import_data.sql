
-- plik do terminala
\copy customers FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy products FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy sellers FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy geolocation FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy category_translation FROM '/Users/ann/Downloads/Analiza/DATA/RAW/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy orders FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy order_items FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy order_payments FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy order_reviews FROM '/Users/ann/Downloads/Analiza/DATA/RAW/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
