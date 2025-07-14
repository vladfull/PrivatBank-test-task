-- Scheduled task 2 - update status

CREATE OR REPLACE FUNCTION update_status()
RETURNS void AS $$
DECLARE
    is_even_second BOOLEAN := extract(second from clock_timestamp())::int % 2 = 0;
BEGIN
    IF is_even_second THEN
        UPDATE T1 SET status = 1
        WHERE status = 0 AND id % 2 = 0;
    ELSE
        UPDATE T1 SET status = 1
        WHERE status = 0 AND id % 2 = 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule('update_status_every_3s', '* * * * *',
$$
DO $do$
DECLARE 
    i INT := 0;
BEGIN
    WHILE i < 20 LOOP
        PERFORM update_status();
        PERFORM pg_sleep(3);
        i := i + 1;
    END LOOP;
END;
$do$
$$);

SELECT * FROM cron.job;

SELECT 
    jobid,
    command,
    status,
    runid,
    start_time,
    end_time,
    return_message
FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 20;

-- SELECT cron.unschedule('insert_every_5s');
-- SELECT cron.unschedule('update_status_every_3s');