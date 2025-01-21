/*
Rank guests based on the number of messages they've exchanged with the hosts. 

Guests with the same number of messages as other guests should have the same rank. 

Do not skip rankings if the preceding rankings are identical.

Output the rank, guest id, and number of total messages they've sent. 

Order by the highest number of total messages first.

airbnb_contacts
id_guest:       varchar
id_host:        varchar
id_listing:     varchar
ts_contact_at:  datetime
ts_reply_at:    datetime
ts_accepted_at: datetime
ts_booking_at:  datetime
ds_checkin:     datetime
ds_checkout:    datetime
n_guests:       int
n_messages:     int
*/


-- ATTEMPT 1: DENSE_RANK, order by AGG function
SELECT
    DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) AS ranking,
    id_guest,
    SUM(n_messages) AS sum_n_messages
FROM airbnb_contacts
GROUP BY id_guest
ORDER BY sum_n_messages DESC
-- LIMIT 5
;


-- ATTEMPT 2: DENSE_RANK, order by WINDOW function
SELECT
    -- ranking shouldn't skip numbers, even if guests share same rank
    DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) AS activity_rank,
    id_guest AS guest_id,
    SUM(n_messages) AS total_messages_sent
FROM airbnb_contacts
GROUP BY guest_id
ORDER BY activity_rank ASC
-- LIMIT 3
;