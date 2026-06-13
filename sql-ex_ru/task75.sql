SELECT p.maker,
       MAX(l.price) AS max_laptop,
       MAX(pc.price) AS max_pc,
       MAX(pr.price) AS max_printer
FROM Product p
LEFT JOIN Laptop l ON p.model = l.model AND l.price IS NOT NULL
LEFT JOIN PC pc ON p.model = pc.model AND pc.price IS NOT NULL
LEFT JOIN Printer pr ON p.model = pr.model AND pr.price IS NOT NULL
GROUP BY p.maker
HAVING MAX(l.price) IS NOT NULL 
    OR MAX(pc.price) IS NOT NULL 
    OR MAX(pr.price) IS NOT NULL;
