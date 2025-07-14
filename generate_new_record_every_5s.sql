-- Scheduled task 1 - generate new record every 5s
CREATE EXTENSION pg_cron;

CREATE OR REPLACE FUNCTION insert_into_t1()
RETURNS void AS $$
DECLARE
    msg jsonb;
BEGIN
    msg := jsonb_build_object(
        'invoice_id', floor(random() * 10000)::int,
        'client_id', floor(random() * 1000)::int,
        'operation_type', (ARRAY['online', 'offline'])[floor(random()*2 + 1)]
    );

    INSERT INTO T1(date, total, status, operation_guid, message)
    VALUES (
        CURRENT_DATE,
        round((random()*1000)::numeric, 2),
        0,
        gen_random_uuid(),
        msg
    );
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule('insert_every_5s', '* * * * *', 
$$
DO $do$
DECLARE 
    i INT := 0;
BEGIN
    WHILE i < 12 LOOP
        PERFORM insert_into_t1();
        PERFORM pg_sleep(5);
        i := i + 1;
    END LOOP;
END;
$do$
$$);

SELECT * FROM cron.job;