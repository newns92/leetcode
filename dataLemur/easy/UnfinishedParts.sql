/*
Tesla is investigating production bottlenecks and they need your help to extract the relevant data. 
Write a query to determine which parts have begun the assembly process but are not yet finished.

Assumptions:
    - parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
    - An unfinished part is one that lacks a finish_date.

parts_assembly:
Column Name	    Type
part	        string
finish_date	    datetime
assembly_step	integer
*/

SELECT
  part,
  assembly_step
FROM parts_assembly
WHERE finish_date IS NULL
;