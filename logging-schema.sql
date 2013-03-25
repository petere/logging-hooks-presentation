CREATE TABLE logging (
	log_time timestamp with time zone default current_timestamp,
	database text,
	elevel int,
	message text
);
