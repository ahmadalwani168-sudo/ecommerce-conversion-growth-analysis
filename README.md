# E-commerce Conversion Analysis (GA4 + BigQuery)

## Overview
This project analyzes user behavior in an e-commerce funnel using GA4 BigQuery data.  
The objective is to identify conversion differences across devices and uncover opportunities to improve revenue performance.

---

## Data
- Source: Google Analytics 4 (BigQuery public dataset)
- Table: `ga4_obfuscated_sample_ecommerce.events_*`

---

## Methodology

- Defined funnel: **view_item → purchase**
- Aggregated data at **user level** using `MAX(IF())` to avoid duplicate events
- Created binary event flags (1 = occurred, 0 = not occurred)
- Calculated totals using `SUM()`
- Computed conversion rate using `SAFE_DIVIDE()` to handle division by zero
- Segmented results by **device category**

---

## Results

| Device  | Conversion Rate |
|--------|----------------|
| Desktop | 2.9% |
| Mobile  | 1.8% |
| Tablet  | 0.0% |

---

## Visualization

![Conversion by Device](conversion_by_device.png)

---

## Key Insights

- Desktop users convert the best (~2.9%)
- Mobile conversion is ~40% lower than desktop
- Significant drop-off on mobile suggests friction in the user journey
- Tablet shows no conversions (likely low traffic or poor UX)

---

## Business Recommendations

- Improve mobile checkout flow (reduce steps, simplify forms)
- Optimize mobile page speed (critical for conversion)
- Conduct A/B testing on mobile UX (layout, CTA placement)
- Analyze mobile drop-off in deeper funnel steps (next step)

---

## SQL (Core Query)

```sql
WITH funnel AS (
  SELECT
    user_pseudo_id,
    device.category AS category,
    MAX(IF(event_name = 'view_item', 1, 0)) AS view_item,
    MAX(IF(event_name = 'purchase', 1, 0)) AS purchase
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id, category
)

SELECT
  category,
  SUM(view_item) AS view_item_users,
  SUM(purchase) AS purchase_users,
  SAFE_DIVIDE(SUM(purchase), SUM(view_item)) AS conversion_rate
FROM funnel
GROUP BY category
ORDER BY conversion_rate DESC;

ORDER BY conversion_rate DESC;
```

### Tools 
Google BigQuery (SQL)
Excel (Data Visualization)
GitHub (Project documentation)
