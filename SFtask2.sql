WITH views AS (
	SELECT user_id, show_id
	FROM sf.viewings
),
paid_users AS (
	SELECT DISTINCT v.user_id
	FROM views v
	JOIN sf.subscriptions s 
		ON v.user_id = s.user_id
	JOIN sf."plans" p 
		ON s.plan_id = p.plan_id
	WHERE monthly_price > 0
),
unpaid_users AS (
	SELECT DISTINCT user_id
	FROM views v
	WHERE user_id NOT IN (SELECT user_id FROM paid_users)
),
bad_shows AS (
	SELECT s.show_id
	FROM views v JOIN sf.shows s ON v.show_id = s.show_id
	WHERE v.user_id IN (SELECT user_id FROM unpaid_users)
),
good_shows AS (
	SELECT s.show_id, s.title
	FROM views v JOIN sf.shows s ON v.show_id = s.show_id
	WHERE s.show_id NOT IN (SELECT show_id FROM bad_shows)
)
SELECT DISTINCT * FROM good_shows;