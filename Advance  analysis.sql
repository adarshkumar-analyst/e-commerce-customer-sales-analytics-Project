-- ====================================================
-- ***** Advance Analysis *******
-- ====================================================

-- 1 Rank Customer Lifetime value

select o.customer_id,
       c.country,
       c.membership_tier,
       round(sum(o.revenue),2) as lifetime_value,
       rank() over(order by sum(o.revenue) desc) as customer_rnk
from orders_clean o 
join customers_clean c 
on o.customer_id=c.customer_id
group by o.customer_id,c.country,c.membership_tier;

-- 2 Revenue Contribution by Customer Tier
SELECT 
    c.membership_tier,
    round(SUM(o.revenue),2) AS total_revenue,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.revenue) / COUNT(o.order_id), 2) AS avg_order_value
FROM orders_clean o
JOIN customers_clean c
ON o.customer_id = c.customer_id
GROUP BY c.membership_tier
ORDER BY total_revenue DESC;

--  3 High Value vs Low Value Customer Behavior
SELECT 
    c.is_high_spender,
    round(AVG(c.engagement_score),2) AS avg_engagement,
    round(AVG(c.avg_review_score),2) AS avg_review,
    round(SUM(o.total_amount_usd),2) AS total_revenue
FROM customers_clean c
JOIN orders_clean o
ON c.customer_id = o.customer_id
GROUP BY c.is_high_spender;

-- 4  Delivery Impact on Customer Rating
SELECT 
    CASE 
        WHEN delivery_days <= 2 THEN 'Fast'
        WHEN delivery_days <= 5 THEN 'Medium'
        ELSE 'Slow'
    END AS delivery_speed,
    round(AVG(customer_rating),2) AS avg_rating,
    COUNT(order_id) AS total_orders
FROM orders_clean
GROUP BY delivery_speed;

-- 5 Return Behavior Analysis
SELECT 
    category,
    payment_method,
    SUM(CASE WHEN returned = 1 THEN 1 ELSE 0 END) AS returned_orders,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(CASE WHEN returned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM orders_clean
GROUP BY category, payment_method
ORDER BY return_rate_pct DESC;

-- 6  Customer Segmentation
SELECT 
    customer_id,
    total_spend_usd,
    engagement_score,
    churned,
    CASE 
        WHEN is_high_spender = 1 AND is_loyalty_customer = 1 THEN 'VIP Customer'
        WHEN is_high_spender = 1 THEN 'High Value'
        WHEN is_at_risk = 1 THEN 'At Risk'
        ELSE 'Regular'
    END AS customer_segment
FROM customers_clean;





