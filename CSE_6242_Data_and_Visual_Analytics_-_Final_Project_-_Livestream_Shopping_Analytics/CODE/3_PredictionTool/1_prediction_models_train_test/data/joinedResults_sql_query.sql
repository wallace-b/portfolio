CREATE TABLE joinedResults
AS
SELECT customer_id, campaign_id, date, viewers, pageviews, avg_duration_per_viewer, chats, likes, clicks_sum, click_revenue_sum_usd
FROM (
SELECT *, duration/viewers AS avg_duration_per_viewer
FROM base_data AS t1
INNER JOIN (
SELECT campaign_id, SUM(clicks) AS clicks_sum, SUM(click_revenue)/1300 AS click_revenue_sum_usd
FROM click_revenue_data
GROUP BY campaign_id) AS t2
ON t1.campaign_id = t2.campaign_id
)