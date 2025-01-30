/*
Find the total number of downloads for paying and non-paying users by date. 

Include only records where non-paying customers have more downloads than paying customers. 

The output should be sorted by earliest date first and contain 3 columns: date, non-paying downloads, paying downloads.

ms_user_dimension
user_id:    int
acc_id:     int

ms_acc_dimension
acc_id:             int
paying_customer:    varchar

ms_download_facts
date:       datetime
user_id:    int
downloads:  int
*/

-- ATTEMPT: SUM CASE within a CTE
With FullData AS (
    SELECT
        ms_download_facts.date,
        -- ms_acc_dimension.paying_customer,
        -- SUM(ms_download_facts.downloads) AS n_downloads
        SUM(
            CASE
                WHEN ms_acc_dimension.paying_customer = 'no'
                THEN downloads
            END
        ) AS non_paying_downloads,
        SUM(
            CASE
                WHEN ms_acc_dimension.paying_customer = 'yes'
                THEN downloads
            END
        ) AS paying_downloads    
    FROM ms_user_dimension
    LEFT JOIN ms_acc_dimension ON
        ms_user_dimension.acc_id = ms_acc_dimension.acc_id
    LEFT JOIN ms_download_facts ON
        ms_user_dimension.user_id = ms_download_facts.user_id
    GROUP BY
        ms_download_facts.date
    -- ORDER BY
    --     ms_download_facts.date ASC --, -- earliest date first
)


SELECT
    date,
    non_paying_downloads AS non_paying,
    paying_downloads AS paying
FROM FullData
WHERE non_paying_downloads > paying_downloads
ORDER BY date ASC
;


-- ATTEMPT 2: > comparison in the HAVING clause of a single SELECT statement (no CTE)
SELECT
    -- *,
    downloads.date,
    -- CASE
    --     WHEN accounts.paying_customer = 'yes'
    --     THEN downloads
    --     ELSE 0
    -- END AS test
    SUM(
        CASE
            WHEN accounts.paying_customer = 'no'
            THEN downloads
            ELSE 0
        END
    )
    AS total_downloads_nonpaying,    
    SUM(
        CASE
            WHEN accounts.paying_customer = 'yes'
            THEN downloads
            ELSE 0
        END
    )
    AS total_downloads_paying
FROM ms_user_dimension AS users
LEFT JOIN ms_acc_dimension AS accounts
    ON users.acc_id = accounts.acc_id
LEFT JOIN ms_download_facts AS downloads
    ON users.user_id = downloads.user_id
GROUP BY downloads.date
-- Include only records where non-paying customers have more downloads than paying customers
HAVING  -- total_downloads_nonpaying > total_downloads_paying
    SUM(
        CASE
            WHEN accounts.paying_customer = 'no'
            THEN downloads
            ELSE 0
        END
    )
    >
    SUM(
        CASE
            WHEN accounts.paying_customer = 'yes'
            THEN downloads
            ELSE 0
        END
    )
-- Output should be sorted by earliest date first
ORDER BY downloads.date ASC
-- LIMIT 10
;





-- Solution: Subquery with a subtraction in the WHERE clause
SELECT
    date,
    non_paying,
    paying
FROM (
    SELECT
        date,
        SUM(
            CASE
                WHEN paying_customer = 'yes'
                THEN downloads
            END
        ) AS paying,
        SUM(
            CASE
                WHEN paying_customer = 'no'
                THEN downloads
            END
        ) AS non_paying
    FROM ms_user_dimension
    INNER JOIN ms_acc_dimension ON
        ms_user_dimension.acc_id = ms_acc_dimension.acc_id
    INNER JOIN ms_download_facts ON
        ms_user_dimension.user_id = ms_download_facts.user_id
   GROUP BY date
   ORDER BY date
) t
WHERE (non_paying - paying) > 0
ORDER BY date ASC
;


-- SOLUTION 2 (NEWER): CTE similar to Attempt 1, but > 0 comparison in final WHERE clause
WITH download_totals AS (
    SELECT
        date,
        SUM(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying,
        SUM(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying
    FROM ms_user_dimension a
    INNER JOIN ms_acc_dimension b
        ON a.acc_id = b.acc_id
    INNER JOIN ms_download_facts c
        ON a.user_id = c.user_id
    GROUP BY date
)

SELECT
        date,
        non_paying,
        paying
FROM download_totals
WHERE (non_paying - paying) > 0
ORDER BY date ASC
;
