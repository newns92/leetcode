/*
Find the number of apartments per nationality that are owned by people under 30 years old.

Output the nationality along with the number of apartments.

Sort records by the apartments count in descending order.

airbnb_hosts
host_id:        int
nationality:    varchar
gender:         varchar
age:            int

airbnb_units
host_id:    int
unit_id:    varchar
unit_type:  varchar
n_beds:     int
n_bedrooms: int
country:    varchar
city:       varchar
*/

-- ATTEMPT
SELECT -- DISTINCT  -- shouldn't need this DISTINCT with a LEFT JOIN, but do for some reason?
    airbnb_hosts.nationality,
    COUNT(DISTINCT airbnb_units.unit_id) AS apartment_count
FROM airbnb_hosts
LEFT JOIN airbnb_units ON
    airbnb_hosts.host_id = airbnb_units.host_id
WHERE airbnb_hosts.age < 30 AND
    LOWER(unit_type) = 'apartment'
GROUP BY airbnb_hosts.nationality
ORDER BY apartment_count DESC
-- LIMIT 10
;


-- ATTEMPT 2: Mostly similar, minor differences in syntax and formatting
SELECT
    -- hosts.host_id AS host_id,
    -- Broken down by nationality
    hosts.nationality AS nationality,
    -- Use unit ID for apartment counting
    COUNT(DISTINCT units.unit_id) AS num_units
FROM airbnb_hosts AS hosts
LEFT JOIN airbnb_units AS units
    ON hosts.host_id = units.host_id
WHERE
    -- Owned by people under 30
    hosts.age < 30
    -- Looking for APARTMENTS
    AND lower(units.unit_type) = 'apartment'
GROUP BY nationality -- hosts.host_id
-- Sort accordingly to see who owns the most apartments
ORDER BY num_units DESC
LIMIT 1
;