/*
Meta/Facebook has developed a new programing language called Hack. To measure the popularity of Hack they ran a survey with their employees. 

The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. 

Due to an error, location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. 

Luckily the user IDs of employees completing the surveys were stored.

Based on the above, find the average popularity of the Hack per office location.

Output the location along with the average popularity.

facebook_employees:
id:         int
location:   varchar
age:        int
gender:     varchar
is_senior:  bool

facebook_hack_survey
employee_id:    int
age:            int
gender:         varchar
popularity:     int
*/

SELECT
    facebook_employees.location,
    AVG(facebook_hack_survey.popularity) AS hack_popularity
FROM facebook_employees
JOIN facebook_hack_survey ON
    facebook_employees.id = facebook_hack_survey.employee_id
GROUP BY facebook_employees.location
;


SELECT
    emp.location,
    AVG(survey.popularity) AS avg_popularity
FROM facebook_employees AS emp
LEFT JOIN facebook_hack_survey AS survey
    ON emp.id = survey.employee_id
GROUP BY emp.location
;