WITH daily_revenues AS (
	SELECT
		country_code,
		paid_at::date AS revenue_date,
		sum(amount) as daily_revenue
	FROM sf.payments p
	JOIN sf.subscriptions s
			ON p.subscription_id = s.subscription_id
	JOIN sf.users u
			ON s.user_id = u.user_id
	WHERE amount > 0 AND is_refund = FALSE
	GROUP BY country_code, paid_at::date
)
SELECT
	revenue_date,
	country_code,
	daily_revenue,
	sum(daily_revenue) OVER (
			PARTITION BY country_code ORDER BY revenue_date
			ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	) AS rolling_7d_revenue
FROM daily_revenues
ORDER BY country_code, revenue_date;