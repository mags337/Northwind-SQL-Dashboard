-- Get the names and the quantities in stock for each product.
select p.productname, od.quantity
from product p join order_detail od on od.productid = p.productid 
group by p.productname, od.quantity 
order by od.quantity desc;

-- Get a list of current products (Product ID and name).
select productname, productid, unitsinstock 
from product p 
where unitsinstock != 0
order by unitsinstock asc;

-- Get a list of the most and least expensive products (name and unit price).
select min(unitprice), max(unitprice) 
from product p 
where unitprice in (select max(unitprice) from product p2), (select min(unitprice) from product p3);

select p.productname, 
	min(unitprice) as min_price, 
	max(unitprice) as max_price 
from product p 
where unitprice in (select max(unitprice) from product p2), (select min(unitprice) from product p3);
group by p.productname ;

-- Get products that cost less than $20.
select productname, productid, unitprice  
from product p 
where unitprice <20;

-- Get products that cost between $15 and $25.
select productname, unitprice  
from product p 
where unitprice between 15 and 25;

-- Get products above average price.
select productname, unitprice 
from product p
group by productname, unitprice 
having unitprice > avg(unitprice);

-- Find the ten most expensive products.
select p.productname, round(unitprice)
from product p 
group by p.productname, p.unitprice 
order by p.unitprice desc
fetch first 10 rows only;

-- Get a list of discontinued products (Product ID and name).
select productid, productname, discontinued  
from product p 
where discontinued = 1;

-- Count current and discontinued products.
select discontinued, count(discontinued)
from product p 
group by discontinued;

-- Find products with less units in stock than the quantity on order.
select productname 
from product p 
where unitsinstock < unitsonorder;

-- Find the customer who had the highest order amount
select customerid, count(orderid) as orderss
from orders o 
group by customerid
order by orderss desc;

-- Get orders for a given employee and the according customer
select o.orderid, e.employeeid, c.customerid  
from employee e
join orders o on o.employeeid = e.employeeid 
join customer c on c.customerid = o.customerid
order by o.customerid asc;

-- Find the hiring age of each employee
select (e.hiredate - e.birthdate) as age
from employee e 

select AGE(e.hiredate, e.birthdate)
from employee e

select concat(e.firstname, ' ', e.lastname), DATE_PART('year', e.hiredate::date) - DATE_PART('year', e.birthdate::date) as hiring_age
from employee e;

-- More questions --

-- which of the costumers never made any orders? --
SELECT c.customerid, companyname 
FROM 
customer c  left JOIN orders o 
ON c.customerid = o.customerid
WHERE orderid is NULL;


-- select companyname, city --

select companyname, city
from customer c;


-- select 
select o.customerid, orderid, employeeid, shipname
from customer c join orders o 
on c.customerid = o.customerid


select * from customer c
where country = 'Germany'


select * from employee e
where country = 'USA'

-- group by --

-- count all employees (country, count of employees that live in this country)
select count, country as country_count from employee e 
group by e.country 


select country, count(*)
from employee e 
group by country 


-- who are the managers (id) and how many people are they managing --
select employeeid, count(customerid) as count_customers
from orders o 
group by o.employeeid 

select reportsto, count(employeeid)
from employee e 
where reportsto is not NULL
group by e.reportsto;

-- add the managers name to the count -- 
select e1.reportsto, e2.lastname, count(*) as cnt
from employee e1 
join employee e2
on cast(e1.reportsto as INTEGER) = e2.employeeid 
where e1.reportsto is not Null
group by e1.reportsto, e2.lastname;


-- Which employee is making the most money, ordered desc by revenue? --
-- revenue is coming from order details (unit price * quantity) --

orders orderid
orderdetails(unitprice*quantitiy) orderid
employee

SELECT e., round(sum(unitprice*quantity)) as revenue
FROM order_detail od 
INNER JOIN orders o ON od.orderid = o.orderid
INNER JOIN employee e ON e.employeeid = o.employeeid 
group by e.employeeid 
order by revenue desc
fetch first 10 rows only;


-- which category brings highest revenue, which lowest --
select c.categoryname, round(sum(od.unitprice*od.quantity)) as revenue
from category c  
join product p  on c.categoryid = p.categoryid 
join order_detail od on od.productid = p.productid 
group by c.categoryname 
order by revenue desc;

-- where are the suppliers distributed (name, city/country) -- in reference to where the highest buying customer (orders: shipcountry, shipcity) is 
-- -> are more suppliers needed in certain parts of the world 
-- which is the highest buying custumer? -- 
select c.companyname, c.country, round(sum(od.unitprice*od.quantity)) as revenue
from customer c
join orders o on o.customerid = c.customerid  
join order_detail od on od.orderid = o.orderid
join country_code cc on c.country = cc.countryname 
group by c.companyname, c.country 
order by revenue desc
fetch first 10 rows only;


-- merge supplier and country code list inner join
select *
from supplier s 
join country_code cc 
on s.country = cc.countryname;

-- which supplier supplies the most product (product id, unitprice/quantity) 
select s.companyname, s.country, round(sum(od.unitprice*od.quantity)) as revenue
from order_detail od
join orders o on od.orderid = o.orderid 
join product p on od.productid = p.productid 
join supplier s on p.supplierid = s.supplierid
group by s.companyname, s.country 
order by revenue desc
fetch first 10 rows only;

select round(sum(od.unitprice*od.quantity)) as revenue
from order_detail od

-- and also who supplies the highest selling (revenue) product (supplier, revenue, category)--

-- how fast does northwind get the required product to the customer -- (orderdate, shipdate, required date?, shipping companies are 3)

-- which customer get the product the slowest, where are they located, where are respective suppliers located --


-- shipvia = shiperid (3 options) who is fastest --
select * from shippers s 
-- -> three shipper companies
-- get deliverytime --

select 
	customerid,
	shipcountry, 
	shipvia,
	shippeddate,
	orderdate,
	cast (shippeddate as date) - cast (orderdate as date) as shippedtime
from orders o
join country_code cc 
on o.shipcountry = cc.countryname
order by shipvia asc
;

select 
	shipcountry, 
	shipvia,
	cast (shippeddate as date) - cast (orderdate as date) as shippedtime
from orders o
join country_code cc 
on o.shipcountry = cc.countryname 
order by shippedtime asc
;


-- which territory is each manager supervising -- 

select convert(shippeddate, getdate())
from orders o