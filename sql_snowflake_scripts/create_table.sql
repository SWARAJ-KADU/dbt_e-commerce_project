USE WAREHOUSE COMPUTE_WH;
USE DATABASE OLIST_DB;
USE SCHEMA RAW;

create or replace table customers(
    customer_unique_id string primary key,
    customer_id string,
    zip_code_prefix string,
    city string,
    state string,
    ingested_at timestamp default current_timestamp()
);

create or replace table geolocation(
    zip_code_prefix string,
    lat number(20, 15),
    lng number(20, 15),
    city string,
    state string,
    ingested_at timestamp default current_timestamp()
);

create or replace table order_items(
    order_id string,
    order_item_id number(2),
    product_id string,
    seller_id string,
    shipping_limit_date timestamp,
    price number(7, 2),
    freight_value number(7, 2),
    ingested_at timestamp default current_timestamp()
);

create or replace table order_payments(
    order_id string,
    payment_sequential number,
    payment_type string,
    payment_installments number(3, 0),
    payment_value number(7, 2),
    ingested_at timestamp default current_timestamp()
);

create or replace table order_reviews(
    review_id string,
    order_id string,
    review_score number(3, 0),
    review_comment_title string,
    review_comment_message string,
    review_creation_date timestamp,
    review_answer_timestamp timestamp,
    ingested_at timestamp default current_timestamp()
);

create or replace table orders(
    order_id string primary key,
    customer_id string,
    order_status string,
    order_purchase_timestamp timestamp,
    order_approve_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp,
    ingested_at timestamp default current_timestamp()
);

create or replace table products(
    product_id string primary key,
    product_category_name string,
    product_name_length number(6, 0),
    product_description_length number(6, 0),
    product_photos_qty number(6, 0),
    product_weight_g number(6, 0),
    product_length_cm number(6, 0),
    product_height_cm number(6, 0),
    product_width_cm number(6, 0)
);

create or replace table sellers(
    seller_id string primary key,
    zip_code_prefix string,
    city string,
    state string
);

create or replace table product_category(
    product_category_name string,
    product_category_name_english string
);

