-- T1 table creation
create table T1 (
date DATE not null,
id BIGSERIAL primary key,
total numeric(18,2) not null,
status smallint not null,
operation_guid UUID not null,
message jsonb not null,
CHECK(
	message ?  'invoice_id' and
	message ?  'client_id' and
	message ?  'operation_type' and
	message ->> 'operation_type' IN ('online', 'offline')
));