-- User-level Funnel Analysis (GA4 BigQuery Public Dataset)

WITH user_events AS (
  SELECT
    user_pseudo_id,
    event_name
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

funnel_flags AS (
  SELECT
    user_pseudo_id,

    MAX(IF(event_name = 'view_item', 1, 0)) AS viewed_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS added_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS began_checkout,
    MAX(IF(event_name = 'purchase', 1, 0)) AS purchased

  FROM user_events
  GROUP BY user_pseudo_id
)

SELECT
  COUNTIF(viewed_item = 1) AS users_view_item,
  COUNTIF(added_to_cart = 1) AS users_add_to_cart,
  COUNTIF(began_checkout = 1) AS users_begin_checkout,
  COUNTIF(purchased = 1) AS users_purchase,

  SAFE_DIVIDE(COUNTIF(added_to_cart = 1), COUNTIF(viewed_item = 1)) AS view_to_cart_cr,
  SAFE_DIVIDE(COUNTIF(began_checkout = 1), COUNTIF(added_to_cart = 1)) AS cart_to_checkout_cr,
  SAFE_DIVIDE(COUNTIF(purchased = 1), COUNTIF(began_checkout = 1)) AS checkout_to_purchase_cr

FROM funnel_flags;
