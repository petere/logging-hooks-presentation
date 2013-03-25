while true; do
	psql -d dellstore2 -c "select count(*) from orders" >/dev/null
	sleep 60
done
