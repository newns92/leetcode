/*
Find libraries from the 2016 circulation year that have no email address provided but have their notice preference set to email. 
In your solution, output their home library code.

library_usage:
age_range:                      text
circulation_active_month        text
circulation_active_year:        double precision
home_library_code:              text
home_library_definition:        text
notice_preference_code:         text
notice_preference_definition:   text
outside_of_county:              boolean
patron_type_code:               bigint
patron_type_definition:         text
provided_email_address:         boolean
supervisor_district:            double precision
total_checkouts:                bigint
total_renewals:                 bigint
year_patron_registered:         bigint
 */

-- ATTEMPT 1 (Postgres)
-- SELECT DISTINCT
--     notice_preference_code,
--     notice_preference_definition
-- FROM library_usage
-- ;

SELECT DISTINCT
    home_library_code
FROM library_usage
WHERE
    circulation_active_year = 2016
    AND provided_email_address = False
    AND LOWER(notice_preference_code) = 'z'
;


-- ATTEMPT 2 (Oracle)
SELECT DISTINCT
    home_library_code
FROM library_usage
WHERE
    notice_preference_definition = 'email'
    AND circulation_active_year = 2016
    AND provided_email_address != 1
;