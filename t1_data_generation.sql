-- Data generation
CREATE EXTENSION pgcrypto;

CREATE OR REPLACE PROCEDURE generate_t1_table_data()
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER := 0;
    random_date DATE;
    random_total NUMERIC(18, 2);
    random_status smallint;
    random_guid UUID;
    operation_type TEXT;
BEGIN
    WHILE i < 100000 LOOP
        random_date := DATE '2025-03-01' + (random() * 121)::INT;
        random_total := ROUND((10 + random() * 990)::numeric, 2);
        random_status := CASE WHEN random() < 0.5 THEN 0 ELSE 1 END;
        random_guid := gen_random_uuid();
        operation_type := CASE WHEN random() < 0.5 THEN 'online' ELSE 'offline' END;

        INSERT INTO t1(date, total, status, operation_guid, message)
        VALUES (
            random_date,
            random_total,
            random_status,
            random_guid,
            jsonb_build_object(
                'invoice_id', (100000 + i)::TEXT,
                'client_id', (200000 + (i % 1000))::TEXT,
                'operation_type', operation_type
            )
        );

        i := i + 1;
    END LOOP;
END;
$$;

CALL generate_t1_table_data();

select * from T1;