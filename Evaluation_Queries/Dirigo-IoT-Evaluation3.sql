WITH Empty_Load AS (
  SELECT 
    eo.ocel_object_id,
    et.ocel_time,
    'weigh the empty truck' AS activity_type
  FROM event_object eo
  JOIN event_WeighEmptyTruck et ON eo.ocel_event_id = et.ocel_id
  UNION
  SELECT 
    eo.ocel_object_id,
    ra.ocel_time,
    'load truck' AS activity_type
  FROM event_object eo
  JOIN event_LoadTruck ra ON eo.ocel_event_id = ra.ocel_id
),
entry_events AS (
  SELECT ocel_object_id, MIN(ocel_time) AS entry_time
  FROM Empty_Load
  WHERE activity_type = 'weigh the empty truck'
  GROUP BY ocel_object_id
),
registration_events AS (
  SELECT ocel_object_id, MIN(ocel_time) AS registration_time
  FROM  Empty_Load
  WHERE activity_type = 'load truck'
  GROUP BY ocel_object_id
)
SELECT
  e.ocel_object_id,
  e.entry_time,
  r.registration_time,
  ROUND((strftime('%s', r.registration_time) - strftime('%s', e.entry_time)) / 60.0, 2) AS duration_minutes
FROM entry_events e
JOIN registration_events r ON e.ocel_object_id = r.ocel_object_id
WHERE duration_minutes > 20;
-- tr11	2024-05-02 00:43:25	2024-05-02 01:04:51	21.43
-- tr12	2024-05-01 21:55:46	2024-05-01 22:18:47	23.02
-- tr32	2024-05-01 15:27:34	2024-05-01 15:57:15	29.68
-- tr4	2024-05-01 11:49:44	2024-05-01 12:10:44	21.0
-- tr5	2024-05-01 07:33:21	2024-05-01 07:53:41	20.33
-- tr50	2024-05-02 00:50:42	2024-05-02 01:14:06	23.4
-- tr9	2024-05-01 12:42:52	2024-05-01 13:07:33	24.68


SELECT
ocel_id,
"Truck location validity", 
COUNT(*) AS occurrence_count
FROM object_Truck
WHERE ocel_id = 'tr32'
AND ocel_time BETWEEN '2024-05-01 15:27:34' AND '2024-05-01 15:57:15'
GROUP BY "Truck location validity"
ORDER BY occurrence_count DESC;
-- tr32	Unauthorised	5

SELECT
ocel_id,
"Truck location validity", 
COUNT(*) AS occurrence_count
FROM object_Truck
WHERE ocel_id = 'tr12'
AND ocel_time BETWEEN '2024-05-01 21:55:46' AND '2024-05-01 22:18:47'
GROUP BY "Truck location validity"
ORDER BY occurrence_count DESC;
-- tr32	Unauthorised	2


