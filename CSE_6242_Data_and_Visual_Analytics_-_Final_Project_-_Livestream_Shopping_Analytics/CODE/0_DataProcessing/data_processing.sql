SELECT
  campaign_id,
  MAX(title) as title,
  max(date(started_at)) as started_date,
  COUNT(uid) as totalviewer,
  ROUND(AVG(avg_duration), 2) as avg_session_duration,
  ROUND(sum(duration), 2) as total_duration,
  ROUND(sum(connect_count), 2) as connect_count,
  ROUND(sum(write_count), 2) as write_count,
  ROUND(sum(adore_count), 2) as adore_count 
FROM (
  SELECT
    c.campaign_id,
    uid,
    MAX(title) AS title,
    DATETIME(MAX(started_at), 'Asia/Seoul') AS started_at,
    DATETIME(MIN(connected_at), 'Asia/Seoul') AS first_connected_at,
    DATETIME(MAX(ended_at), 'Asia/Seoul') AS ended_at,
    MAX(user_id) AS user_id,
    MAX(name) AS user_name,
    COUNT(connected_at) AS connect_count,
    MAX(gender) AS gender,
    MAX(age) AS age,
    FLOOR(SUM(duration)/1000) AS duration,
    FLOOR(AVG(duration)/1000) AS avg_duration,
    SUM(write_count) AS write_count,
    SUM(adore_count) AS adore_count,
    DATETIME_DIFF(DATETIME(MAX(ended_at)), DATETIME(MAX(started_at)), SECOND) AS total_duration
  FROM (
    SELECT
      a.customer_id,
      a.campaign_id,
      a.uid,
      MAX(a.user_id) AS user_id,
      MAX(name) AS name,
      MAX(gender) AS gender,
      MAX(age) AS age,
      connected_at,
      MAX(duration) AS duration,
      MAX(write_count) AS write_count,
      MAX(adore_count) AS adore_count,
    FROM
      `activities' AS a
    GROUP BY
      customer_id,
      campaign_id,
      uid,
      connected_at) AS c
  LEFT JOIN (
    SELECT
      campaign_id,
      MAX(title) AS title,
      MAX(started_at) AS started_at,
      MAX(ended_at) AS ended_at
    FROM
      'mapping`
    WHERE
      started_at IS NOT NULL
      AND ended_at IS NOT NULL
    GROUP BY
      campaign_id ) AS b
  ON
    c.campaign_id = b.campaign_id
  WHERE
    connected_at >= started_at
    AND connected_at <= ended_at
  GROUP BY
    campaign_id,
    uid
  ORDER BY
    first_connected_at ASC )
GROUP BY
  campaign_id
ORDER BY
  campaign_id DESC