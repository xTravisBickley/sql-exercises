	WITH q1 AS (
		SELECT
			user_id,
			device_type,
			sum(minutes_watched) AS total_minutes,
			count(DISTINCT show_id) AS DISTINCT_shows,
			DENSE_RANK() OVER (PARTITION BY user_id ORDER BY sum(minutes_watched) DESC) AS device_rank_for_user
		FROM sf.viewings v
		GROUP BY
			user_id, device_type
	)
	SELECT * FROM q1
	WHERE device_rank_for_user < 3
	ORDER BY user_id;
	;