use supply_db ;

/*
Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.

*/
SELECT 
    Product_Id, Product_Name
FROM
    category AS c
        JOIN
    product_info AS p ON c.ID = p.Category_Id
WHERE
    Name LIKE '%Golf%'
ORDER BY Product_Id;

-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. 
Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/

SELECT 
    Product_Name, sum(Sales) as Sales
FROM
    category AS c
         RIGHT JOIN
    product_info AS p ON c.Id = p.Category_Id
		 RIGHT JOIN
	ordered_items as oi on p.Product_Id = oi.Item_Id
WHERE
    Name LIKE '%Golf%'
GROUP BY Product_Name
ORDER BY sum(Sales) desc
limit 10;

-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

SELECT 
    Segment AS Customer_segment, COUNT(Order_Id) AS Orders
FROM
    customer_info AS c
        JOIN
    orders AS o ON c.Id = o.Customer_Id
GROUP BY Segment
ORDER BY Orders DESC;

-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

WITH Seg_Orders AS
(
SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
LEFT JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
WHERE Real_Shipping_Days=6
GROUP BY 1
)
SELECT
a.customer_segment,
ROUND(a.Orders/SUM(b.Orders)*100,1) AS percentage_order_split
FROM
Seg_Orders AS a
JOIN
Seg_Orders AS b
GROUP BY 1
ORDER BY 2 DESC;

-- **********************************************************************************************************************************
