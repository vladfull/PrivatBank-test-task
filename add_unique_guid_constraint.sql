-- Ensuring the uniqueness of data by operation_guid field
ALTER TABLE T1
ADD CONSTRAINT operation_guid_unique UNIQUE (operation_guid);