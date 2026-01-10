CREATE OR REPLACE PROCEDURE load_raw_data()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

-- customers
COPY INTO RAW.customers
FROM (
    SELECT
        $1,$2,$3,$4,$5,
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_customers_dataset.csv
);

-- geolocation
COPY INTO RAW.geolocation
FROM (
    SELECT
        $1::STRING  AS zip_code_prefix,
        $2::NUMBER(20,15) AS lat,
        $3::NUMBER(20,15) AS lng,
        $4::STRING  AS city,
        $5::STRING  AS state,
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_geolocation_dataset.csv
);

-- order_items
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
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_items_dataset.csv
);

-- order_payments
COPY INTO RAW.order_payments
FROM (
    SELECT
        $1 AS order_id,
        $2::NUMBER AS payment_sequential,
        $3 AS payment_type,
        $4::NUMBER(3,0) AS payment_installments,
        $5::NUMBER(7,2) AS payment_value,
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_payments_dataset.csv
);

-- order_reviews
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
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_order_reviews_dataset.csv
);

-- orders
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
        CURRENT_TIMESTAMP() AS ingested_at
    FROM @STAGING.csv_folder/olist_orders_dataset.csv
);

-- products
COPY INTO RAW.products
FROM @STAGING.csv_folder/olist_products_dataset.csv;

-- sellers
COPY INTO RAW.sellers
FROM @STAGING.csv_folder/olist_sellers_dataset.csv;

-- category
COPY INTO RAW.product_category
FROM @STAGING.csv_folder/product_category_name_translation.csv;

RETURN 'RAW load completed successfully';

END;
$$;
