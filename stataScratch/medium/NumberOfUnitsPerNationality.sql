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