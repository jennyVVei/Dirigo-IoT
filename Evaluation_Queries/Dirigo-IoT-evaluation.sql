-- 1.1
WITH combined_table AS (
  SELECT 
    eo.ocel_object_id,
    et.ocel_time,
    'entry' AS activity_type
  FROM event_object eo
  JOIN event_Enterport et ON eo.ocel_event_id = et.ocel_id
  UNION
  SELECT 
    eo.ocel_object_id,
    ra.ocel_time,
    'registration' AS activity_type
  FROM event_object eo
  JOIN event_RegisterTruckArrival ra ON eo.ocel_event_id = ra.ocel_id
),
entry_events AS (
  SELECT ocel_object_id, MIN(ocel_time) AS entry_time
  FROM combined_table
  WHERE activity_type = 'entry'
  GROUP BY ocel_object_id
),
registration_events AS (
  SELECT ocel_object_id, MIN(ocel_time) AS registration_time
  FROM combined_table
  WHERE activity_type = 'registration'
  GROUP BY ocel_object_id
)
SELECT
  e.ocel_object_id,
  e.entry_time,
  r.registration_time,
  ROUND((strftime('%s', r.registration_time) - strftime('%s', e.entry_time)) / 60.0, 2) AS duration_minutes
FROM entry_events e
JOIN registration_events r ON e.ocel_object_id = r.ocel_object_id
WHERE duration_minutes >15;

--tr43	2024-05-01 13:04:56	2024-05-01 13:21:46	16.83
-- tr5	2024-05-01 07:15:11	2024-05-01 07:32:46	17.58



-- 1.2
SELECT
ocel_id,
"Truck location validity", 
COUNT(*) AS occurrence_count
FROM object_Truck
WHERE ocel_id = 'tr43'
AND ocel_time BETWEEN '2024-05-01 13:04:56' AND '2024-05-01 13:21:46'
GROUP BY "Truck location validity"
ORDER BY occurrence_count DESC;
-- tr43	Unauthorised	7

SELECT
ocel_id,
"Truck location validity", 
COUNT(*) AS occurrence_count
FROM object_Truck
WHERE ocel_id = 'tr5'
AND ocel_time BETWEEN '2024-05-01 07:15:11' AND '2024-05-01 07:32:46'
GROUP BY "Truck location validity"
ORDER BY occurrence_count DESC;
-- tr5	Unauthorised	8
-- 
