/*
Find matching hosts and guests pairs in a way that they are both of the same gender and nationality.

Output the host id and the guest id of matched pair.

airbnb_hosts
host_id:        int
nationality:    varchar
gender:         varchar
age:            int

airbnb_guests
guest_id:       int
nationality:    varchar
gender:         varchar
age:            int
*/

SELECT DISTINCT
    airbnb_hosts.host_id,
    airbnb_guests.guest_id
FROM airbnb_hosts
INNER JOIN airbnb_guests ON
    airbnb_hosts.nationality = airbnb_guests.nationality AND
    airbnb_hosts.gender = airbnb_guests.gender
;