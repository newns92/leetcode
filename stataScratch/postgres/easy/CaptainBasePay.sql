/*
Find the base pay for Police Captains.
Output the employee name along with the corresponding base pay.

sf_public_salaries:
agency:             text
basepay:            double precision
benefits:           double precision
employeename:       text
id:                 bigint
jobtitle:           text
notes:              double precision
otherpay:           double precision
overtimepay:        double precision
status:             text
totalpay:           double precision
totalpaybenefits:   double precision
year:               bigint
*/

-- SELECT DISTINCT jobtitle FROM sf_public_salaries;

SELECT
    employeename AS employee_name,
    basepay AS base_pay
FROM sf_public_salaries
WHERE LOWER(jobtitle) = 'captain iii (police department)'
;
