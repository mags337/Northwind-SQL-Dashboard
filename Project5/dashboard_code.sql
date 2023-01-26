SELECT "category__via__categoryid"."categoryname" AS "categoryname", count(*) AS "count"
FROM "public"."product"
LEFT JOIN "public"."category" "category__via__categoryid" ON "public"."product"."categoryid" = "category__via__categoryid"."categoryid"
GROUP BY "category__via__categoryid"."categoryname"
ORDER BY "category__via__categoryid"."categoryname" ASC
;

select c.categoryname, round(sum(od.unitprice*od.quantity)) as revenue
from category c  
join product p  on c.categoryid = p.categoryid 
join order_detail od on od.productid = p.productid 
group by c.categoryname 
order by revenue desc
;

SELECT "Country Code"."countryISO" AS "countryISO", count(*) AS "count"
FROM "public"."customer"
LEFT JOIN "public"."country_code" "Country Code" ON "public"."customer"."country" = "Country Code"."countryname"
GROUP BY "Country Code"."countryISO"
ORDER BY "Country Code"."countryISO" ASC
;

SELECT "Country Code"."countryISO" AS "countryISO", count(*) AS "count"
FROM "public"."supplier"
LEFT JOIN "public"."country_code" "Country Code" ON "public"."supplier"."country" = "Country Code"."countryname"
GROUP BY "Country Code"."countryISO"
ORDER BY "Country Code"."countryISO" ASC
;

select 
	customerid,
	shipcountry, 
	orderid,
	orderdate,
	shippeddate,
	shipvia,
	cast (shippeddate as date) - cast (orderdate as date) as shippedtime
from orders o
join country_code cc 
on o.shipcountry = cc.countryname
;

select 
	shipcountry, 
	shipvia,
	avg(cast (shippeddate as date) - cast (orderdate as date)) as avg_shippedtime
from orders o
join country_code cc 
on o.shipcountry = cc.countryname
group by o.shipcountry, o.shipvia
;

SELECT "Country Code"."countryname" AS "countryname", count(*) AS "count"
FROM "public"."orders"
LEFT JOIN "public"."country_code" "Country Code" ON "public"."orders"."shipcountry" = "Country Code"."countryname"
GROUP BY "Country Code"."countryname"
ORDER BY "Country Code"."countryname" ASC
;

select c.companyname, c.country, round(sum(od.unitprice*od.quantity)) as revenue
from customer c
join orders o on o.customerid = c.customerid  
join order_detail od on od.orderid = o.orderid
join country_code cc on c.country = cc.countryname 
group by c.companyname, c.country 
order by revenue desc
fetch first 10 rows only
;

select s.companyname, s.country, round(sum(od.unitprice*od.quantity)) as revenue
from order_detail od
join orders o on od.orderid = o.orderid 
join product p on od.productid = p.productid 
join supplier s on p.supplierid = s.supplierid
group by s.companyname, s.country 
order by revenue desc
fetch first 10 rows only
;