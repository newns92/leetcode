/*
There is a factory website that has several machines each running the same number of processes. 
Write an SQL query to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. 
The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the PK of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
*/

-- CTE's
WITH end_times AS (
  SELECT
    machine_id,
    process_id,
    timestamp AS end_time
  FROM Activity 
  WHERE activity_type = 'end'
),

start_times AS (
  SELECT
    machine_id,
    process_id,
    timestamp AS start_time
  FROM Activity 
  WHERE activity_type = 'start'  
)

SELECT
  end_times.machine_id,
  ROUND(AVG(end_times.end_time - start_times.start_time), 3) AS processing_time
FROM end_times
LEFT JOIN start_times ON
  end_times.machine_id = start_times.machine_id AND
    end_times.process_id = start_times.process_id
GROUP BY end_times.machine_id

-- Self-JOIN
SELECT
  Activity1.machine_id,
  ROUND(AVG(Activity2.timestamp - Activity1.timestamp), 3) AS processing_time
FROM Activity Activity1
JOIN Activity Activity2 ON
  Activity1.machine_id = Activity2.machine_id AND
    Activity1.process_id = Activity2.process_id AND
    Activity1.timestamp < Activity2.timestamp
GROUP BY Activity1.machine_id
