WITH get_shows AS (
	SELECT
		u.country_code,
		v.show_id,
					sum(v.minutes_watched)/60.0 AS
		total_hours
	FROM viewings v
		JOIN users u
		ON v.user_id = u.user_id
	GROUP BY u.country_code, v.show_id
),
get_avgs AS (
	SELECT country_code, avg(total_hours) AS avg_hours
	FROM get_shows
	GROUP BY country_code
)
SELECT
	gs.country_code,
	gs.show_id,
	s.title,
	floor(gs.total_hours),
--	ga.avg_hours,
		dense_rank() OVER (PARTITION BY gs.country_code ORDER BY gs.total_hours DESC)
	AS hit_rank_in_country
FROM get_shows gs
	JOIN shows s
		ON gs.show_id = s.show_id
	JOIN get_avgs ga
		ON gs.country_code = ga.country_code
WHERE gs.total_hours > ga.avg_hours;
