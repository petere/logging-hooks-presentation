while true; do
	psql -d pagila -c "choke" >/dev/null 2>&1
	sleep 120
done
