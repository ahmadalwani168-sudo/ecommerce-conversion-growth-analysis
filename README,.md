# E-commerce Conversion Analysis (GA4 + BigQuery)

## 📊 Overview

This project analyzes user behavior in an e-commerce funnel using Google Analytics 4 (GA4) data in BigQuery. The goal is to understand how users move through the purchase process and identify where drop-offs occur.

1

## 🎯 Business Problem

High website traffic does not always lead to high sales.
This project aims to identify:

* Where users drop off in the funnel
* Which traffic sources perform best
* How conversion rates vary across channels



## 📁 Data

* Source: Google Analytics 4 (BigQuery public dataset)
* Table: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`



## 🧠 Methodology

### Funnel Definition

* View Item
* Add to Cart
* Begin Checkout
* Purchase

### Approach

* Aggregated data at **user level** using `MAX(IF())`
* Counted users per step using `COUNTIF()`
* Calculated conversion rate using `SAFE_DIVIDE()`


## 💻 SQL (Core Query)

```sql
WITH funnel AS (
  SELECT
    user_pseudo_id,
    traffic_source.source AS source,

    MAX(IF(event_name = 'view_item', 1, 0)) AS viewed_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS added_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS started_checkout,
    MAX(IF(event_name = 'purchase', 1, 0)) AS purchased

  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id, source
)

SELECT
  source,
  COUNTIF(viewed_item = 1) AS viewed_users,
  COUNTIF(purchased = 1) AS purchased_users,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(purchased = 1),
      COUNTIF(viewed_item = 1)
    ) * 100, 2
  ) AS conversion_rate
FROM funnel
GROUP BY source
ORDER BY viewed_users DESC;
```



## 📈 Key Insights

* **Google** drives the highest traffic and total purchases, but has a lower conversion rate
* **Direct traffic** has a higher conversion rate, indicating stronger purchase intent
* There is a significant drop-off between *view_item* and *add_to_cart*
![Conversion by Device](1.png)



## 💡 Business Recommendations

* Optimize landing pages for traffic from Google
* Improve targeting and ad relevance to increase conversion
* Leverage direct traffic through loyalty programs and retention strategies



## 🚀 Skills Demonstrated

* SQL (BigQuery)
* Funnel Analysis
* Conversion Rate Analysis
* Data Aggregation (user-level)
* Business Insight Generation


