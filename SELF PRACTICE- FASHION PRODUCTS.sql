select * from fashion_products$

--(1) To identify the 6 purchased brand
select distinct top 6 Brand
from fashion_products$

-- (2) To identify the most purchased women's clothing within Zara's brand
select distinct [Product Name], Brand, Category, count ([Product Name]) as Number_purchased
from fashion_products$
where brand= 'zara' and Category like 'women%'
group by Brand, [Product Name], Category
order by count ([product name]) desc;

-- (3) To identify the most purchased men's brand
select distinct Brand, Category, count (brand) as Number_purchased
from fashion_products$
where category like 'men%'
group by Brand, Category
order by count (brand) desc

--(4) To identify the most purchased kid's brand
select distinct brand, category, count (brand) as Number_purchased
from fashion_products$
where category like 'kid%'
group by Brand, Category
order by count(brand) desc

--(5) To identify the 5 best selling colours in each brand
select distinct top 5 brand, Color, count (color)
from fashion_products$
group by Brand, Color
order by count(color) desc

-- (6) The most purchased sizes in the women's category of dressess
select category, [Product Name], Size, count (size) as Number_purchased
from fashion_products$
where [Product Name] = 'dress' and Category like 'women%'
group by [Product Name], category, Size 
order by count (size) desc

-- (7) The total sales for each brand and order in descending order
select brand, sum (price) as total_sales
from fashion_products$
group by Brand
order by sum (price) desc

-- (8) The average sales for each brand and order in descending order
select brand, AVG (price) as Average_sales
from fashion_products$
group by Brand
order by AVG (price)

-- (9) The total number of purchases for each brand, category and Products where the order count exceeds 30.
select brand, category, [Product Name] ,count (*) as total_purchased
from fashion_products$
group by Brand, Category, [Product Name]
having count(*) > 30
order by Brand

-- (10) The maximum order gotten in the women's fashion category showing the brand as well where it came from
select TOP 1 brand, MAX([product name]) as max_order
from fashion_products$
where Category like 'women%'
group by Brand
order by MAX([product name]) desc

-- (11) The miniumum order products in the men's fashion category showing the brand as well
select TOP 1 brand, Min([product name]) as min_order
from fashion_products$
where Category like 'men%'
group by Brand
order by min([product name]) ASC

-- (12) The highest rated brand in the female category
select Brand as highest_rated_brand
from ( select Brand, AVG (Rating) as highest_rated_brand, DENSE_RANK() over (order by AVG(Rating) desc) as ranking
		from fashion_products$
		where Category like 'women%'
		group by Brand) as highest_rated_brand
where ranking = 1

-- (13) The highest rated brand in the male category
select Brand as highest_rated_brand
from ( select Brand, AVG (Rating) as highest_rated_brand, DENSE_RANK() over (order by AVG(Rating) desc) as ranking
		from fashion_products$
		where Category like 'men%'
		group by Brand) as highest_rated_brand
where ranking = 1

-- (14) The highest rated brand in the kid category
select Brand as highest_rated_brand
from ( select Brand, AVG (Rating) as highest_rated_brand, DENSE_RANK() over (order by AVG(Rating) desc) as ranking
		from fashion_products$
		where Category like 'kid%'
		group by Brand) as highest_rated_brand
where ranking = 1