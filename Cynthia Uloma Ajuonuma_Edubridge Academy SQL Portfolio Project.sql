--Welcome to my page! Using the AdventureWorks database, 
--we tried to provide some insight into the performances of products, sales, employees, amongst others 
--just to support with data driven decision.

--(1) What is the revenue generated from the top 10 sold products reflecting the product name, product number, 
--colour, product id and the revenue generated

select top 10 SOD.ProductID, PP.Name, PP.ProductNumber, PP.Color, sum(SOD.LineTotal) as total_sales
from Sales.SalesOrderDetail as SOD
left join Production.Product as PP on SOD.ProductID = PP.ProductID
group by SOD.ProductID, PP.Name, PP.ProductNumber, PP.Color
order by total_sales desc

--(2) What is the most used channel by the customers for making orders?

select TOP 1
case when onlineorderflag = '1' then 'Electronic Channel'
else 'Physical Store' end as Type_of_Sales_Channel, count(*) as No_sales_channel
from Sales.SalesOrderHeader
group by OnlineOrderFlag
order by count(*) DESC

-- (3) Sequel to question (2) we would like to track the effciency of processing orders via the electronic channel and offline

select
case when onlineorderflag = '1' then 'Electronic Channel'
else 'Physical Store' end as Type_of_Sales_Channel, AVG(datediff(day,orderdate,shipdate)) as Avg_days_of_delivery
from Sales.SalesOrderHeader
group by OnlineOrderFlag
order by AVG(datediff(day,orderdate,shipdate)) desc

-- (4) We intend to know the distribution of sales in the different locations/regions.

SELECT ST.Name, ST.CountryRegionCode, SUM(SOD.LineTotal) as Total_sales
FROM Sales.SalesOrderDetail as SOD
left join Sales.SalesOrderHeader as SOH on SOD.SalesOrderID = SOH.SalesOrderID
join Sales.SalesTerritory as ST on SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name, ST.CountryRegionCode
order by sum(sod.linetotal) desc

-- (5) Showing the distribution of sales by the location/region, which region accounts for the highest sales

SELECT top 1 ST.Name, ST.CountryRegionCode, SUM(SOD.LineTotal) as Total_sales
FROM Sales.SalesOrderDetail as SOD
left join Sales.SalesOrderHeader as SOH on SOD.SalesOrderID = SOH.SalesOrderID
join Sales.SalesTerritory as ST on SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name, ST.CountryRegionCode
order by sum(sod.linetotal) desc

--(6) Which regions experienced over a 100% postive sales growth rate betweeen last year and the new year

Select Name, CountryRegionCode, (((SalesYTD-SalesLastYear)/SalesLastYear)*100) as sales_growth_rate
from Sales.SalesTerritory
where (((SalesYTD-SalesLastYear)/SalesLastYear)*100) > 100
order by sales_growth_rate desc

-- (7) Which regions experienced negative sales growth rate betweeen last year and the new year

Select Name, CountryRegionCode, (((SalesYTD-SalesLastYear)/SalesLastYear)*100) as sales_growth_rate
from Sales.SalesTerritory
where (((SalesYTD-SalesLastYear)/SalesLastYear)*100) <0
order by sales_growth_rate asc

-- (8) We want to find out the average days it takes for an order to be made 
--and when it is actually being delivered/shipped so as to improve the SLA processes.

select SOH.SalesOrderID, PP.Name, SOH.OrderDate, SOH.ShipDate, Avg (DATEDIFF(day,OrderDate,ShipDate)) as Avg_Delivery_days
from Sales.SalesOrderHeader as SOH 
join Sales.SalesOrderDetail as SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN Production.Product as PP on SOD.ProductID = PP.ProductID
group by SOH.SalesOrderID, PP.Name, SOH.OrderDate, SOH.ShipDate 
order by Avg_Delivery_days desc

-- (9) The company has a new management team and in line with achieving a low cost-income ratio, suggestions were made
-- regarding separating the email management of a full time employee and a contract employee. Kindly calculate the number of
-- full time employees and the number of contract employees we have in the organization asssuming contract employees have 'WC'
-- in their job title

select Employee_Categorization, count (*) as Employee_Categorization_Count
from (select
case when JobTitle like '%WC%' THEN 'Contract Employee'
else 'Full Time Employee' end as Employee_Categorization
from HumanResources.Employee) as Employee_Categorization
Group by Employee_Categorization
order by count (*) desc

--(10) In line with (7), a new email management team has been outsourced to manage the affairs of contract employees and to run 
-- an effective database, the new login ID becomes adventure-works@zoho\username for all contract employeees.Kindly effect.

select BusinessEntityID, JobTitle, 'adventure-works@zoho\' + right (LoginID, len(LoginID)- charindex('\',LoginID)) as New_LoginID
from HumanResources.Employee
WHERE JobTitle LIKE '%WC%'

-- (11) We would like to analyze our sales trends in the last one year to identify seasonality in our products.

select format(soh.OrderDate, 'MMMM yyyy') as MonthYear, sum(sod.LineTotal) as monthly_sales
from Sales.SalesOrderDetail as SOD
join Sales.SalesOrderHeader as SOH on SOD.SalesOrderID = SOH.SalesOrderID
where SOH.OrderDate between '2013-07-01' and '2014-06-30'
group by format(soh.OrderDate, 'MMMM yyyy')
order by sum(sod.LineTotal) desc

-- (12) We further thought of understanding the most ship method used by our customers

select top 1 sm.Name, count (*) as Ship_Method_Count
from Sales.Customer as SC
LEFT join Sales.SalesOrderHeader as SOH on SC.CustomerID = SOH.CustomerID
left join Purchasing.ShipMethod as SM on SOH.ShipMethodID = SM.ShipMethodID
Group by SM.Name
having sm.Name is not null
order by count(*) desc

--(13) Find out the total males and females in each dept

select D.GroupName, 
	SUM(case when E.Gender = 'M' then 1 else 0 end) AS Male_Count,
    SUM(case when E.Gender = 'F' then 1 else 0 end) AS Female_Count,
    COUNT(*) AS Total_Gender_Count
   from HumanResources.Employee AS E
JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON E.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
Group by D.GroupName

--(14) For diversity sake, we sought to gain more insight into the percentage of male employees to female in each dept

select D.GroupName,
    CAST(SUM(case when E.Gender = 'M' then 1 else 0 end) as float) / COUNT(*) * 100 AS Percentage_of_male,
    CAST(SUM(case when E.Gender = 'F' then 1 else 0 end) AS float) / COUNT(*) * 100 AS Percentage_of_female
from HumanResources.Employee AS E
JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON E.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
Group by D.GroupName

--(15) Assuming Covid year started in February 2011, management will 
--love to know the distribution of employees hired from then till date by gender.

select distinct year (hiredate)as hire_year, Gender, count(*) as Employee_count
from HumanResources.Employee
group by Gender, year (HireDate)
having year (HireDate) between '2011' and GETDATE()
order by year (hiredate)