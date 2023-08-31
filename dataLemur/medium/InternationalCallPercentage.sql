/*
A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:
- The caller_id in phone_info table refers to both the caller and receiver.

phone_calls:
Column Name	    Type
caller_id	    integer
receiver_id	    integer
call_time	    timestamp

phone_info:
Column Name	    Type
caller_id	    integer
country_id	    integer
network	        integer
phone_number	string
*/

-- ATTEMPT 1a: 2 LEFT JOINs
SELECT
  -- phone_calls.caller_id,
  -- phone_calls.receiver_id,
  -- phone_calls.call_time,
  -- info1.country_id AS caller_country,
  -- info2.country_id AS receiver_country,
  -- CASE
  --   WHEN info1.country_id <> info2.country_id
  --   THEN 'international'
  --   ELSE 'domestic'
  -- END AS international_flag,
  ROUND(100.0 *
    SUM(
      CASE
        WHEN info1.country_id <> info2.country_id
        THEN 1 -- international
        ELSE 0 -- domestic
      END
    ) -- AS international_calls,
    /
    COUNT(phone_calls.call_time) -- AS total_calls
  , 1) AS international_calls_pct
FROM phone_calls
LEFT JOIN phone_info AS info1 ON
  phone_calls.caller_id = info1.caller_id
LEFT JOIN phone_info AS info2 ON
  phone_calls.receiver_id = info2.caller_id
-- WHERE info1.country_id <> info2.country_id
;


-- ATTEMPT 1b: Cleaned 2 LEFT JOINs 
SELECT
  ROUND(100.0 *
    SUM(
      CASE
        WHEN info1.country_id <> info2.country_id
        THEN 1 -- international
        ELSE 0 -- domestic
      END
    ) -- AS international_calls,
    /
    COUNT(phone_calls.call_time) -- AS total_calls
  , 1) AS international_calls_pct
FROM phone_calls
LEFT JOIN phone_info AS info1 ON
  phone_calls.caller_id = info1.caller_id
LEFT JOIN phone_info AS info2 ON
  phone_calls.receiver_id = info2.caller_id
;


-- Solution 2: FILTER
SELECT 
  ROUND(100.0 * 
    COUNT(*) FILTER (WHERE caller.country_id <> receiver.country_id) 
    /
    COUNT(*)
  , 1) AS international_calls_pct
FROM phone_calls AS calls
LEFT JOIN phone_info AS caller ON
  calls.caller_id = caller.caller_id
LEFT JOIN phone_info AS receiver ON
  calls.receiver_id = receiver.caller_id;