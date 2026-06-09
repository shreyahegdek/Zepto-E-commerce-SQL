select * from zepto

alter table zepto
ADD sku_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY

--count of rows
select count(*) from zepto

--null values
 select * from zepto where Category is null 
 or name is null
 or mrp is null
 or discountPercent is null
 or availableQuantity is null
 or discountedSellingPrice is null
 or weightInGms is null
 or outOfStock is null
 or quantity is null

 --different product category
 select distinct(Category) from zepto order by Category
 
 
 --product outOfstock vs instock

   select outOfStock, count(sku_id)
   from zepto group by outOfStock

--product names present multiple times

select name,COUNT(sku_id) as "No of SKUs" 
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) DESC

--product with price =0

select * from zepto where mrp=0 or discountedSellingPrice=0


--Cherry Blossom Liquid Shoe Polish Neutral  mrp=0 , so we need to delete it from table

delete from zepto where mrp=0

--mrp and discountedSellingPrice is currently in paise ,so we need it in rupee 
--we will update the mrp and discountedSellingPrice in rupee

--convert paise to rupee
update zepto
set mrp=mrp*100,
discountedSellingPrice=discountedSellingPrice*100


--Q1. Find the top 10 best-value products based on the discount percentage

select * from zepto

SELECT TOP 10 name, mrp, discountPercent 
FROM zepto
ORDER BY discountPercent DESC,name desc

-- Q2.What are the products with high MRP but out of stock
 select  distinct name,mrp from zepto where mrp>300 and 
 outOfStock = 'true' order by mrp desc

 --Q3. Calculate Estimated Revenue for each category

 select category,
 sum(discountedSellingPrice*availableQuantity) as Estimated_Revenue
 from zepto  group by category order by Estimated_Revenue

 -- Q4.Find all the products where mrp is greater than 500 and discount is less than 10%.

 select distinct name,mrp,discountPercent 
 from zepto 
 where mrp>500 AND discountPercent<10 
 order by mrp desc,discountPercent desc

 -- Q5.Identify the top 5 categories offering the highest average dicount percentage

  select
  top 5 category,CAST(ROUND(AVG(discountPercent), 2) AS DECIMAL(10,2))as highest_dicountPercentage 
  from zepto
  group by category order by highest_dicountPercentage desc

  --Q6.Find the price per gram for products above 100g and sort by best value
 
  SELECT 
    name,discountedSellingPrice,weightInGms,
    CAST(discountedSellingPrice / weightInGms AS DECIMAL(10,4)) AS price_per_gram
FROM 
    zepto
WHERE 
    weightInGms > 100
ORDER BY 
    price_per_gram desc


  --Q7.Group the products into categories like low,medium,bulk

  select DISTINCT name, weightInGms,
  case when weightInGms<1000 THEN 'Low'
       when weightInGms<5000 then 'Medium'
	   else 'bulk'
	   END as weight_category
   from zepto

   --Q8.what is the Total inventory weight per category

   select category,
   sum(weightInGms* availableQuantity) as total_weight
   from zepto
   group by Category order by total_weight