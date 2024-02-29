/*
Find the total number of downloads for paying and non-paying users by date. 

Include only records where non-paying customers have more downloads than paying customers. 

The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

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