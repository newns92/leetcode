/*
You're given a dataset of health inspections. Count the number of violation in an inspection in 'Roxanne Cafe' for each year. 

If an inspection resulted in a violation, there will be a value in the 'violation_id' column. 

Output the number of violations by year in ascending order.

sf_restaurant_health_violations
business_id:            int
business_name:          varchar
business_address:       varchar
business_city:          varchar
business_state:         varchar
business_postal_code:   float
business_latitude:      float
business_longitude:     float
business_location:      varchar
business_phone_number:  float
inspection_id:          varchar
inspection_date:        datetime
inspection_score:       float
inspection_type:        varchar
violation_id:           varchar
violation_description:  varchar
risk_category:          varchar
*/


-- ATTEMPT 1
SELECT
    EXTRACT(YEAR FROM inspection_date) AS year,
    -- COUNT will ignore NULLs by default
    COUNT(violation_id) AS n_inspections
FROM sf_restaurant_health_violations
WHERE LOWER(business_name) = 'roxanne cafe'
    -- AND violation_id IS NOT NULL
GROUP BY EXTRACT(YEAR FROM inspection_date)
ORDER BY n_inspections ASC
;


-- ATTEMPT 2:
SELECT
    EXTRACT(YEAR FROM inspection_date) AS inspection_year,
    COUNT(violation_id) AS num_violations
FROM sf_restaurant_health_violations
WHERE LOWER(business_name) = 'roxanne cafe'
    -- if inspection resulted in a violation, `violation_id` will contain a value
    AND violation_id IS NOT NULL
GROUP BY inspection_year
ORDER BY inspection_year ASC
;