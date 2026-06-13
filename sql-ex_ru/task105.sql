WITH numbered AS (
    SELECT 
        maker,
        model,
        row_number() OVER (ORDER BY maker, model) AS alice,
        dense_rank() OVER (ORDER BY maker) AS bella
    FROM Product
)
SELECT 
    maker,
    model,
    alice,
    bella,
    min(alice) OVER (PARTITION BY maker) AS vika,
    max(alice) OVER (PARTITION BY maker) AS galina
FROM numbered
ORDER BY alice
