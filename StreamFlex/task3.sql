WITH payments AS (
	SELECT
		subscription_id, amount
	FROM sf.payments WHERE is_refund = FALSE AND amount > 0
),
avg_payments AS (
	SELECT country_code, avg(amount) AS avg_payment
	FROM payments p1
	JOIN sf.subscriptions s
		ON p1.subscription_id = s.subscription_id
	JOIN sf.users u
		ON s.user_id = u.user_id
	GROUP BY country_code
	HAVING avg(amount) > (SELECT max(monthly_price) FROM sf."plans")
)
SELECT * FROM avg_payments;