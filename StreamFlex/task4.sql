WITH q1 AS (
	SELECT
		amount,
		is_refund,
		sum(amount) OVER() AS net_revenue
	FROM sf.payments
)
SELECT
	sum(amount) AS gross_revenue,
	net_revenue
FROM q1
WHERE amount > 0 AND is_refund = FALSE
GROUP BY net_revenue;