/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 

Output one of the following statements for each record in the table:
- Equilateral: It's a triangle with 3 sides of equal length.
- Isosceles: It's a triangle with 2 sides of equal length.
- Scalene: It's a triangle with 3 sides of differing lengths
- Not A Triangle: The given values of A, B, and C don't form a triangle (combined value of 2 sides and is not larger than that of the other side)
*/


SELECT
    -- a,
    -- b,
    -- c,
    CASE
        -- must do not a triangle first
        WHEN (a + b <= c) OR (b + c <= a) OR (a + c <= b)
            THEN 'Not A Triangle'    
        WHEN a = b AND b = c -- implies a = c
            THEN 'Equilateral'
        WHEN (a = b AND b <> c) OR (a <> b AND b = c) OR (a = c AND b <> c)
            THEN 'Isosceles'
        WHEN a <> b AND b <> c AND a <> c
            THEN 'Scalene'
    END AS test
FROM triangles
;