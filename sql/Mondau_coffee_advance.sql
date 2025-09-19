-- Monday Coffee -- Data Analysis

select * from city;
select * from products;
select * from customers;
select * from sales;

--Reports & Data Analysis

/* Coffee Consumers Count
How many people in each city are estimated to consume coffee,
given that 25% of the population does? */

Select city_name,
		ROUND((population * 0.25)/1000000,2) as coffee_consumers_millions,
		city_rank
from city
order by 2 desc;

/* Total Revenue from Coffee Sales
What is the total revenue generated from coffee sales 
across all cities in the last quarter of 2023?*/

select	ci.city_name,  
		sum(s.total) as total_revenue
from sales as s
join customers as c
on s.customer_id=c.customer_id
join city as ci
on ci.city_id= c.city_id
where EXTRACT(year from s.sale_date)=2023
and EXTRACT(Quarter from s.sale_date) =4
group by 1
order by 2 desc
;

/*Sales Count for Each Product
How many units of each coffee product have been sold? */

select p.product_id,p.product_name,count(s.sale_id) as total_orders from products as p
Left join sales as s
on p.product_id =s.product_id
Group by 1
order by 3 desc
;

/* Average Sales Amount per City
What is the average sales amount per customer in each city?*/

select *
from city;
select count(DISTINCT c.customer_id),ci.city_name, 
	sum(s.total) as avg_sales,
	ROUND(sum(s.total):: numeric /count(DISTINCT c.customer_id):: numeric, 2) as avg_sales_per_customer
	
from customers as c
join sales as s
on c.customer_id = s.customer_id
join  city as ci
on ci.city_id=c.city_id
group by 2
order by 3 desc
;

/*City Population and Coffee Consumers
Provide a list of cities along with their populations and estimated coffee consumers,
return city_name, total_current cx,estimated coffee consumers (25)*/


with city_table as
(select city_name,
		ROUND((population * 0.25)/1000000,2) as coffee_consumers
from city),
customer_table as

(select ci.city_name,
	count(DISTINCT c.customer_id) as unique_cx
from sales as s
Join customers as c
on c.customer_id = s.customer_id
join city as ci
on ci.city_id=c.city_id
group by 1)
select ct.city_name,
		ct.coffee_consumers,
		cit.unique_cx
from city_table as ct
join customer_table as cit
on ct.city_name=cit.city_name
;

/*Top Selling Products by City
What are the top 3 selling products in each city based on sales volume?*/


select * from 
(select ci.city_name,
	p.product_name,
	count(s.sale_id) as total_orders,
	DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id)DESC) as rank
from sales as s
join products as p
on s.product_id=p.product_id
Join customers as c
on c.customer_id=s.customer_id
join city as ci
on ci.city_id=c.city_id
group by 1,2) as t1
where rank <=3;


/*Customer Segmentation by City
How many unique customers are there in each city who have purchased coffee products? */

select count(distinct(c.customer_id)), 
		ci.city_name
from customers as c
join city as ci
on c.city_id =ci.city_id
join sales as s
on  s.customer_id = c.customer_id
join products as p
on s.product_id=p.product_id
where s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
group by 2;

/* Average Sale vs Rent
Find each city and their average sale per customer and avg rent per customer */


with city_table
as(
select count(DISTINCT c.customer_id) as total_cx,ci.city_name, 
	ROUND(sum(s.total):: numeric /count(DISTINCT c.customer_id):: numeric, 2) as avg_sales_per_customer
from customers as c
join sales as s
on c.customer_id = s.customer_id
join  city as ci
on ci.city_id=c.city_id
group by 2
order by 1 desc),
city_rent as
(select city_name,estimated_rent
from city)
select cr.city_name,
	cr.estimated_rent,
	ct.total_cx,
	ct.avg_sales_per_customer,
	ROUND(cr.estimated_rent::NUMERIC/ct.total_cx :: NUMERIC,2) as avg_rent_per_cx
from city_rent as cr
join city_table as ct
on cr.city_name=ct.city_name
order by 4 desc;

/* Monthly Sales Growth
Sales growth rate: Calculate the percentage growth (or decline) 
in sales over different time periods (monthly). by each city */

with monthly_sales as
(select ci.city_name,
	EXTRACT(Month from sale_date) as month,
	EXTRACT(Year from sale_date) as year,
	sum(s.total) as total_sale
from sales as s
join customers as c
on s.customer_id = c.customer_id
join city as ci
on ci.city_id=c.city_id
group by 1,2,3 
order by 1,3,2),
growth_ratio as
(
select 
	city_name,month,year, total_sale as cr_month_sale,
	 LAG(total_sale,1) OVER(PARTITION BY city_name ORDER BY YEAR,MONTH) as last_month_sale
from monthly_sales)

select city_name,month,year,
	cr_month_sale,
	last_month_sale,
	ROUND((cr_month_sale-last_month_sale)::NUMERIC/last_month_sale::numeric *100,2) as growth_ratio

from growth_ratio
where last_month_sale is not null
;

/* Market Potential Analysis
Identify top 3 city based on highest sales, return city name, total sale, 
total rent, total customers, estimated coffee consumer */

with city_table
as(
select count(DISTINCT c.customer_id) as total_cx,ci.city_name, sum(s.total) as total_revenue,
	ROUND(sum(s.total):: numeric /count(DISTINCT c.customer_id):: numeric, 2) as avg_sales_per_customer
from customers as c
join sales as s
on c.customer_id = s.customer_id
join  city as ci
on ci.city_id=c.city_id
group by 2
order by 1 desc),
city_rent as
(select city_name,estimated_rent,ROUND((population * 0.25)/1000000 ,3)as est_coffee_consumers_in_millions
from city)
select cr.city_name,
	ct.total_revenue,
	cr.estimated_rent as total_rent,
	ct.total_cx,
	est_coffee_consumers_in_millions,
	ct.avg_sales_per_customer,
	ROUND(cr.estimated_rent::NUMERIC/ct.total_cx :: NUMERIC,2) as avg_rent_per_cx
from city_rent as cr
join city_table as ct
on cr.city_name=ct.city_name
order by 2 desc;







