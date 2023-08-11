/*
Report for every three line segments whether they can form a triangle.

Return the result table in any order.

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
In SQL, (x, y, z) is the primary key column for this table
Each row of this table contains the lengths of three line segments  
*/

-- For 3 segments to form a triangle, the sum of any 2 segments has to be larger than the 3rd one
SELECT
    x,
    y,
    z,
    CASE
        WHEN x + y > z AND x + z > y AND y + z > x
            THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle
;