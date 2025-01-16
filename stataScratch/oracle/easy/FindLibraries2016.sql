-- Find libraries who haven't provided the email address in circulation 
--  year 2016 but their notice preference definition is set to email

-- Find libraries who haven't provided the email address in circulation 
-- year 2016 but their notice preference definition is set to email.
-- Output the library code.

/* Fields in library_usage:
patron_type_code:               int
patron_type_definition:         varchar
total_checkouts:                int
total_renewals:                 int
age_range:                      varchar
home_library_code:              varchar
home_library_definition:        varchar
circulation_active_month:       varchar
circulation_active_year:        float
notice_preference_code:         varchar
notice_preference_definition:   varchar
provided_email_address:         bool
year_patron_registered:         int
outside_of_county:              bool
supervisor_district:            float
*/

SELECT DISTINCT
    home_library_code
FROM library_usage
WHERE notice_preference_definition = 'email'
    AND circulation_active_year = 2016
    AND provided_email_address != 1
-- FETCH FIRST 3 ROWS ONLY