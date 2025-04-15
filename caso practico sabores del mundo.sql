-- CASO PRACTICO SQL


--Objetivo
--Identificar cuáles son los productos del menú que han tenido más éxito 
--y cuales son los que menos han gustado a los clientes.

-- Analisis exploratorio de las tablas.

select distinct * 
from menu_items
order by item_name ;
--usando la querry anterior se identifican los items que contiene el menu. 
--Los items cuentan con las columnas de menu_item_id, item_name, category y price


--número de artículos en el menú.
--Total de 32 items sin duplicados

--¿Cuál es el artículo menos caro y el más caro en el menú?
select *
from menu_items
order by price desc;
--
select *
from menu_items
order by price ASC;
--R= el articulo mas caro es de $19 y el mas barato de $5.

--¿Cuántos platos americanos hay en el menú?
select*
from menu_items
where category='American';
--R= el menu cuenta con un total de 6 platos americanos.


--¿Cuál es el precio promedio de los platos?
select Round(avg(price),2) as precio_promedio
from menu_items;

-- R= el precio promedio de los platos es de $13.29


-- De Order_details
--Datos que han sido recolectados de la tabla order_details.

select distinct * 
from order_details;
--La querry anterior nos ayuda a analizar las ordenes del restaurante desde el 2023-01-01 hasta el 2023-03-31

-- cuenta con 5 columnas como order_detals_id, order_id, order_date, order_time y item_id.

--Ambas tablas cuentan con columnas relacionadas como son "menu_item_id" de "menu_items" y "item_id" de "order_details"

--¿Cuántos pedidos únicos se realizaron en total?
select distinct * 
from order_details
order by 2;

--R= 12234 entradas sin duplicados en order_details_id pero si con multiples entradas en order_id

--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
select order_id, count(*) as cantidad_articulos
from order_details
where order_id>0
group by 1
order by 2 desc
limit 5;

--R las 5 ordenes que tuvieron mayor cantidad de articulos vendidos son 440, 2675, 3473, 4305, 443 con 14 articulos c/u



--¿Cuándo se realizó el primer pedido y el último pedido?
--el primer pedido fue en 2023-01-01
Select distinct order_date 
from order_details
order by 1 asc
limit 1;

-- el ultimo pedido fue en 2023-03-31
Select order_date 
from order_details 
order by 1 desc
limit 1;


--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?

-- total de pedidos por mes
select order_date, count(*) as total_pedidos
from order_details
where order_date < '2023-01-06'
group by 1
order by 1;

--conteo total de pedidos en el periodo indicado
select count(*) as total_pedidos
from order_details
where order_date between '2023-01-01' and '2023-01-05';




--Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
--1.- Realizar un left join entre entre order_details y menu_items con el identificador
--item_id(tabla order_details) y menu_item_id(tabla menu_items).
select * from menu_items;
select* from order_details;

SELECT od.item_id, mi.item_name
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id = mi.menu_item_id 
GROUP BY od.item_id, mi.item_name
ORDER BY od.item_id; 

--opcion B
SELECT distinct od.item_id, mi.item_name
FROM order_details AS od
JOIN menu_items AS mi
ON od.item_id = mi.menu_item_id
order by 1,2 desc;

--1:
--Con la siguiente query podemos identificar el total de los productos vendidos 
--organizado por item_id y item_name añadiendo una columna de contador "pedido_tota"
--para saber el total de pedidos por producto
--
SELECT od.item_id, mi.item_name, COUNT(*) AS Pedido_total
FROM order_details AS od
JOIN menu_items AS mi
ON od.item_id = mi.menu_item_id
GROUP BY od.item_id, mi.item_name
ORDER BY Pedido_total DESC;

--B solo se muestra la columna de item_name y se agrega contador para 
--indicar la cantidad de veces que fue pedido
SELECT mi.item_name, COUNT(od.order_id) AS Pedido_total
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY Pedido_total DESC;

--2:
--Query para poder indentificar la categoria de los platillos que se ordenaron
--junto con los nombres

select mi.item_name, mi.category 
from order_details as od
left join menu_items as mi
on od.item_id = mi.menu_item_id
group by mi,item_name, mi.category
order by mi.category;

--lo mismo? ┑(￣Д ￣)┍
select item_name, category
from menu_items
group by 1, 2
order by 2;

--3:
--Identificar en que fecha se pidieron que platillos
-- inlcuye fecha y nombre del platillo ordenado
select od.order_date, mi.item_name
	from order_details as od
	left join menu_items as mi
on od.item_id=mi.menu_item_id
order by 1, 2;

--4:
--Muestra los platillos y cuántas veces fueron pedidos por categoría.
select mi.category, mi.item_name, count(od.order_id) as pedido_total
from order_details as od
left join menu_items as mi
on od.item_id = mi.menu_item_id
group by 1, 2
order by 3 desc;



--5:Muestra cada platillo (item_name), su categoría, 
--y la primera fecha en que fue ordenado.
select mi.item_name, mi.category, min(od.order_date) as fecha_primer_pedido
from order_details as od
join menu_items as mi
on od.item_id = mi.menu_item_id
group by 1, 2
order by 3 desc;






