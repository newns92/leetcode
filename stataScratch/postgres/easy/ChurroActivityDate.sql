/*
Find the activity date and the pe_description of facilities with the name 'STREET CHURROS' and with a score of less than 95 points.

los_angeles_restaurant_health_inspections:
serial_number:          varchar
activity_date:          datetime
facility_name:          varchar
score:                  int
grade:                  varchar
service_code:           int
service_description:    varchar
employee_id:            varchar
facility_address:       varchar
facility_city:          varchar
facility_id:            varchar
facility_state:         varchar
facility_zip:           varchar
owner_id:               varchar
owner_name:             varchar
pe_description:         archar
program_element_pe:     int
program_name:           varchar
program_status:         varchar
record_id:              varchar
*/

SELECT
    activity_date,
    pe_description
FROM los_angeles_restaurant_health_inspections -- AS la_rest_inspections
WHERE LOWER(facility_name) = 'street churros' AND
    score < 95
;