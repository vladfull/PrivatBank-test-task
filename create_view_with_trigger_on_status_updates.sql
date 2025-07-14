-- Creating MV with trigger on status updates

CREATE MATERIALIZED VIEW client_operation_totals AS
SELECT
    (message->>'client_id')::int AS client_id,
    (message->>'operation_type') AS operation_type,
    SUM(total) AS total_sum
FROM T1
WHERE status = 1
GROUP BY client_id, operation_type;

CREATE OR REPLACE FUNCTION refresh_client_operation_totals()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY client_operation_totals;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_refresh_client_operation_totals_on_status_update()
RETURNS trigger AS $$
BEGIN
    IF NEW.status = 1 AND OLD.status = 0 THEN
        PERFORM refresh_client_operation_totals();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_status
AFTER UPDATE ON T1
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION trigger_refresh_client_operation_totals_on_status_update();