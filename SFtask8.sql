WITH user_stats AS (
	SELECT
		u.user_id,
		u.full_name,
		sum(minutes_watched) AS total_minutes,
		(
			SELECT sum(amount)
			FROM sf.payments p
			JOIN sf.subscriptions s
			ON s.subscription_id = p.subscription_id
			WHERE u.user_id = s.user_id AND p.amount > 0 AND p.is_refund = FALSE
		) AS
		paid_revenue,
		(
			SELECT count(user_id)
			FROM sf.subscriptions s
			WHERE u.user_id = s.user_id AND s.cancelled_at IS NULL
		) AS active_subscriptions
	FROM sf.users u LEFT JOIN sf.viewings v ON v.user_id = u.user_id
	GROUP BY u.user_id
)
(
	SELECT
		'minutes' AS metric_type,
		user_id,
		full_name,
		total_minutes AS metric_value,
		row_number() OVER (ORDER BY total_minutes DESC) AS rank_in_metric
	FROM user_stats WHERE total_minutes > 0 LIMIT 10
)
UNION ALL
(
	SELECT
		'revenue' AS metric_type,
		user_id,
		full_name,
		paid_revenue AS metric_value,
		row_number() OVER (ORDER BY paid_revenue DESC) AS rank_in_metric
	FROM user_stats WHERE paid_revenue > 0 LIMIT 10
);