while true; do
	for i in $(seq 1 200) x; do
		psql -d pagila -c "select * from actor_info where actor_id = $i" >/dev/null
		sleep 1
	done
done
