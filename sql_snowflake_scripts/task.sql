CREATE OR REPLACE TASK load_raw_data_task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 2 * * * UTC'
AS
CALL load_raw_data();

ALTER TASK load_raw_data_task RESUME;


