/*
Find the base pay for Police Captains. Output the employee name along with the corresponding base pay.

sf_public_salaries:
id:                 int
employeename:       varchar
jobtitle:           varchar
basepay:            float
overtimepay:        float
otherpay:           float
benefits:           float
totalpay:           float
totalpaybenefits:   float
year:               int
notes:              date
timeagency:         varchar
status:             varchar
*/

SELECT
    employeename,
    basepay
FROM sf_public_salaries
WHERE jobtitle = 'CAPTAIN III (POLICE DEPARTMENT)'
--LIMIT 3
;