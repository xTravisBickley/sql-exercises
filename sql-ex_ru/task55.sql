WITH cte AS (
	SELECT class, min(launched) as launched
	FROM Ships
	GROUP BY class
)
SELECT c.class, launched
FROM cte s
RIGHT JOIN Classes c ON c.class = s.class
