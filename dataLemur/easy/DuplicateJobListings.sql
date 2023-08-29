/*
Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
Write a query to retrieve the count of companies that have posted duplicate job listings.

Definition:
- Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

job_listings:
Column Name	    Type
job_id	        integer
company_id	    integer
title	        string
description	    string
*/

-- ATTEMPT 1: CTE
WITH Dupes AS (
  SELECT
    COUNT(job_id) AS listings
    -- AS duplicate_companies
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(job_id) > 1
)

SELECT
  COUNT(listings) AS duplicate_companies
FROM Dupes
;