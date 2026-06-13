CREATE VIEW sf.active_premium_subscriptions AS
	SELECT
		subscription_id,
		s.plan_id,
		started_at,
		cancelled_at
	FROM sf.subscriptions s
	JOIN sf.plans p
		ON s.plan_id = p.plan_id
		AND s.cancelled_at IS NULL
		AND p.is_premium = TRUE
		AND p.is_active = TRUE
	WHERE
		p.is_premium = TRUE
		AND p.is_active = TRUE
WITH CHECK OPTION ;