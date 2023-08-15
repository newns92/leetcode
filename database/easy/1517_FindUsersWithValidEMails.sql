/*
Write a solution to find the users who have valid emails.

A valid e-mail has a prefix name and a domain where:
    - The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. 
        - The prefix name must start with a letter.
    - The domain is '@leetcode.com'.

Return the result table in any order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
| mail          | varchar |
+---------------+---------+
user_id is the PK for this table.
This table contains information of the users signed up in a website. Some e-mails are invalid.
*/

-- REGEX 1
SELECT
    user_id,
    name,
    mail
FROM Users
-- INSTR functions search string for substring
-- https://stackoverflow.com/questions/4389571/how-to-select-a-substring-in-oracle-sql-up-to-a-specific-character
WHERE SUBSTR(mail, INSTR(mail, '@'), LENGTH(mail) - 1) = '@leetcode.com'
    -- Starts with a letter
    --  - ^ asserts the start of the string
    --  - [A-Za-z] matches any uppercase or lowercase letter
    --  - [A-Za-z0-9_.-]+$ matches any character that is:
    --      - a letter (upper or lower case), digit, underscore '_', period '.', or dash '-'. after the initial letter
    --      - ? indicates that the preceding element in the regex is optional
    --      - + ensures that there must be one or more of these allowed characters
    --      - $ indicates the end of the string
    AND REGEXP_LIKE(SUBSTR(mail, 0, INSTR(mail, '@') - 1), '^[A-Za-z][A-Za-z0-9_.-]?+$')
;

-- REGEX 2
SELECT
    user_id,
    name,
    mail
FROM Users
-- INSTR functions search string for substring
-- https://stackoverflow.com/questions/4389571/how-to-select-a-substring-in-oracle-sql-up-to-a-specific-character
WHERE SUBSTR(mail, INSTR(mail, '@'), LENGTH(mail) - 1) = '@leetcode.com'
    -- Starts with a letter
    --  - ^ asserts the start of the string
    --  - [A-Za-z] matches any uppercase or lowercase letter
    --  - [A-Za-z0-9_.-]+$ matches any character that is:
    --      - a letter (upper or lower case), digit, underscore '_', period '.', or dash '-'. after the initial letter
    --      - * indicates 0 or more of the characters from the preceding charset
    --      - $ indicates the end of the string
    AND REGEXP_LIKE(SUBSTR(mail, 0, INSTR(mail, '@') - 1), '^[A-Za-z][A-Za-z0-9_.-]*$')
;

-- Single Line REGEX
SELECT
    user_id,
    name,
    mail
FROM Users
WHERE
    --  - ^ asserts the start of the string
    --  - [A-Za-z] matches any uppercase or lowercase letter
    --  - [A-Za-z0-9_.-]+$ matches any character that is:
    --      - a letter (upper or lower case), digit, underscore '_', period '.', or dash '-'. after the initial letter
    --      - * indicates 0 or more of the characters from the preceding charset
    --      - \. specifies that we want a period in the domain
    -- AND 
    REGEXP_LIKE(mail, '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\.com')
;