-- 2.1
SELECT *
FROM object_Truck
WHERE Truck_Weight_Status = 'abnormal';
-- tr26

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
),
entryRegister AS (
SELECT
  e.ocel_object_id,
  e.entry_time,
  r.registration_time,
  ROUND((strftime('%s', r.registration_time) - strftime('%s', e.entry_time)) / 60.0, 2) AS duration_minutes
FROM entry_events e
JOIN registration_events r ON e.ocel_object_id = r.ocel_object_id
)
SELECT *FROM entryRegister WHERE ocel_object_id = 'tr26';
-- tr26	2024-05-01 13:38:42	2024-05-01 13:40:52	2.17

SELECT
ocel_id,
"Truck location validity", 
COUNT(*) AS occurrence_count
FROM object_Truck
WHERE ocel_id = 'tr26'
AND ocel_time BETWEEN '2024-05-01 13:38:42' AND '2024-05-01 13:40:52';
-- tr26 unauthorised 1

SELECT *
FROM object_IoTobject
WHERE ocel_object_id = 'tr26'
AND  ocel_IoTobject_id LIKE 'WS%';
-- WS20	tr26	Weight sensor measuring empty truck weight	2024-05-01 13:44:32
