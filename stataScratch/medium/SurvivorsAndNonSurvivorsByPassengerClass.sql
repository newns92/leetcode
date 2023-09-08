/*
Make a report showing the number of survivors and non-survivors by passenger class.

Classes are categorized based on the pclass value as:
- pclass = 1: first_class
- pclass = 2: second_classs
- pclass = 3: third_class

Output the number of survivors and non-survivors by each class.

titanic
passengerid:    nt
survived:       int
pclass:         int
name:           varchar
sex:            varchar
age:            float
sibsp:          int
parch:          int
ticket:         varchar
fare:           float
cabin:          varchar
embarked:       varchar
*/


-- ATTEMPT: CASE statements within Aggregate SUM fxn to avoid GROUP BY on pclass
SELECT
    -- pclass,
    -- SUM(survived) AS survived,
    -- COUNT(passengerid) - SUM(survived) AS non_survived
    survived,
    SUM(
        CASE
            WHEN pclass = 1
            THEN 1
            ELSE 0
        END
    ) AS first_class,
    SUM(
        CASE
            WHEN pclass = 2
            THEN 1
            ELSE 0
        END
    ) AS second_class,    
    SUM(
        CASE
            WHEN pclass = 3
            THEN 1
            ELSE 0
        END
    ) AS third_class
FROM titanic
-- GROUP BY pclass
GROUP BY survived
-- LIMIT 3
;