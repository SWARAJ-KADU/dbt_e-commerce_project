USE WAREHOUSE COMPUTE_WH;
USE DATABASE OLIST_DB;


create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::748955970209:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://dbt-project-bucket/')
  COMMENT = 's3 integration object';

CREATE OR REPLACE file format FILEFORMAT.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    TRIM_SPACE = TRUE;

desc integration s3_int;

CREATE OR REPLACE stage STAGING.csv_folder
    URL = 's3://dbt-project-bucket/olist_dataset/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = FILEFORMAT.csv_fileformat;

LIST @STAGING.csv_folder;

-- customers
COPY INTO RAW.customers
FROM(
    SELECT
        $1,$2,$3,$4,$5,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_customers_dataset.csv
);

--geolocation
COPY INTO RAW.geolocation
FROM (
    SELECT
        $1::STRING  AS zip_code_prefix,
        $2::NUMBER(20,15) AS lat,
        $3::NUMBER(20,15) AS lng,
        $4::STRING  AS city,
        $5::STRING  AS state,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_geolocation_dataset.csv
);


--ORDER_ITEMS
COPY INTO RAW.order_items
FROM (
    SELECT
        $1 AS order_id,
        $2::NUMBER(2) AS order_item_id,
        $3 AS product_id,
        $4 AS seller_id,
        $5::TIMESTAMP AS shipping_limit_date,
        $6::NUMBER(7,2) AS price,
        $7::NUMBER(7,2) AS freight_value,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_items_dataset.csv
);

--order_payments
COPY INTO RAW.order_payments
FROM (
    SELECT
        $1 AS order_id,
        $2::NUMBER AS payment_sequential,
        $3 AS payment_type,
        $4::NUMBER(3,0) AS payment_installments,
        $5::NUMBER(7,2) AS payment_value,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_payments_dataset.csv
);

--order_reviews
COPY INTO RAW.order_reviews
FROM (
    SELECT
        $1 AS review_id,
        $2 AS order_id,
        $3::NUMBER(3,0) AS review_score,
        $4 AS review_comment_title,
        $5 AS review_comment_message,
        $6::TIMESTAMP AS review_creation_date,
        $7::TIMESTAMP AS review_answer_timestamp,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_reviews_dataset.csv
);

--orders
COPY INTO RAW.orders
FROM (
    SELECT
        $1 AS order_id,
        $2 AS customer_id,
        $3 AS order_status,
        $4::TIMESTAMP AS order_purchase_timestamp,
        $5::TIMESTAMP AS order_approve_at,
        $6::TIMESTAMP AS order_delivered_carrier_date,
        $7::TIMESTAMP AS order_delivered_customer_date,
        $8::TIMESTAMP AS order_estimated_delivery_date,
        current_timestamp() AS ingested_at
    FROM @STAGING.csv_folder/olist_orders_dataset.csv
);

--products
COPY INTO RAW.products
FROM @STAGING.csv_folder/olist_products_dataset.csv;

--sellers
COPY INTO RAW.sellers
FROM @STAGING.csv_folder/olist_sellers_dataset.csv;

--category
COPY INTO RAW.product_category
FROM @STAGING.csv_folder/product_category_name_translation.csv;

