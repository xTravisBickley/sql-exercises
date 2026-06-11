WITH RECURSIVE referrers AS (
	SELECT user_id, full_name, 0 AS level,
		user_id::text AS PATH, referrer_user_id
	FROM sf.users WHERE user_id = 1
	
	UNION ALL
	
	SELECT u.user_id, u.full_name, level+1,
		concat(r.path, ' > ' || u.user_id::text), u.referrer_user_id
	FROM referrers r
	JOIN sf.users u ON u.referrer_user_id = r.user_id
	WHERE level < 10
)
SELECT user_id, full_name, level, path FROM referrers;
