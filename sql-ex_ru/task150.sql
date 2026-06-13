WITH dates AS (
    SELECT DISTINCT date
    FROM Income
),
point_min_max AS (
    SELECT point,
           min(date) AS min_date,
           max(date) AS max_date
    FROM Income
    GROUP BY point
)
SELECT p.point,
       (SELECT max(date) FROM dates WHERE date < p.min_date) AS date1,
       p.min_date,
       p.max_date,
       (SELECT min(date) FROM dates WHERE date > p.max_date) AS date2
FROM point_min_max p;
