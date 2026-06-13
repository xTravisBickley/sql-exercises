WITH min_ram_pc AS (
	SELECT model, speed
	FROM PC
	WHERE ram=(SELECT min(ram) FROM PC)
),
max_speed_among_min_ram_pc AS (
	SELECT model
	FROM min_ram_pc
	WHERE speed=(SELECT max(speed) FROM min_ram_pc)
),
printer_makers AS (
	SELECT DISTINCT maker
	FROM Product
	WHERE type='Printer'
)
SELECT DISTINCT maker
FROM Product
WHERE model IN (SELECT * FROM max_speed_among_min_ram_pc)
	AND maker IN (SELECT * FROM printer_makers)
