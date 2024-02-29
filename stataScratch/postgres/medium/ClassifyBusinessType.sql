/*
Classify each business as either a restaurant, cafe, school, or other.
- A restaurant should have the word 'restaurant' in the business name.
- A cafe should have either 'cafe', 'café', or 'coffee' in the business name.
- A school should have the word 'school' in the business name.
- All other businesses should be classified as 'other'.

Output the business name and their classification.

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


-- ATTEMPT: CASE with an OR condition
SELECT DISTINCT
    business_name,
    CASE
        WHEN LOWER(business_name) LIKE '%restaurant%'
            THEN 'restaurant'
        -- Oracle: WHERE CONTAINS(t.something, 'bla OR foo OR batz', 1) > 0
        -- WHEN LOWER(business_name) LIKE IN ('%cafe%', '%café%', '%coffee%')
        WHEN LOWER(business_name) LIKE '%cafe%' OR
                LOWER(business_name) LIKE '%café%' OR
                LOWER(business_name) LIKE '%coffee%'
            THEN 'cafe'
        WHEN LOWER(business_name) LIKE '%school%'
            THEN 'school'
        ELSE 'other'
    END AS business_type
FROM sf_restaurant_health_violations
;