use sakila;

-- ¿Quiénes son los clientes que han gastado más de $150 USD en total? 

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id 
HAVING SUM(amount) > 150;

WITH ganancias AS (
SELECT customer_id, SUM(amount) AS 'cantidad'
FROM payment
GROUP BY customer_id 
)
SELECT * FROM ganancias
WHERE cantidad > 150;

-- ¿Qué películas tenemos disponibles en la Tienda 1 que están totalmente 
-- agotadas (o no existen) en la Tienda 2, 
-- para evaluar una transferencia de stock?

WITH tienda_uno AS (
SELECT * FROM inventory 
WHERE store_id = 1 ),
tienda_dos AS (
SELECT * FROM inventory 
WHERE store_id = 2 
) 
SELECT * FROM tienda_uno 
LEFT JOIN tienda_dos 
ON tienda_uno.film_id = tienda_dos.film_id 
WHERE tienda_dos.store_id IS NULL;

-- ¿Qué películas tienen una duración de alquiler mayor al promedio?
 
SELECT *
FROM film
WHERE rental_duration > (SELECT AVG(rental_duration) FROM film);
 
 
SELECT * FROM film 
WHERE rental_rate = (SELECT MAX(rental_rate) FROM film);

-- 								Taller Práctico de SQL: De Subconsultas a CTEs
-- 											Base de Datos SAKILA

/*Ejercicio 1 (Subconsultas)
Obtén los títulos de todas las películas en las que ha actuado la actriz "UMA WOOD".
•	Pista: Necesitas conectar actor -> film_actor -> film. Usa subconsultas en el WHERE.*/

select
	f.title,
    concat(a.first_name,' ',a.last_name) nombre_actor
from actor a 
inner join film_actor fa 
	on a.actor_id = fa.actor_id
inner join film f 
	on fa.film_id = f.film_id
where concat(a.first_name,' ',a.last_name) = (
	select
	concat(first_name,' ',last_name) nombre
	from actor
	where first_name = 'UMA' and last_name = 'WOOD');

 /*Ejercicio 2 (Subconsultas + CTE)
Encuentra los clientes que han alquilado al menos una película de la categoría 'Action'.
•	Pista: Intenta definir una CTE que obtenga todos los film_id de la categoría 'Action' 
y luego úsala para filtrar la tabla inventory y rental.*/

with peliculasDeAccion as (
select f.film_id 
from film_category f
join category c
on f.category_id = c.category_id
where c.name = 'AVENTURA'
)
 
select  distinct c.customer_id as idCliente,
		CONCAT(c.first_name, ' ', c.last_name) AS nombre
from customer c
join rental r
		on c.customer_id = r.customer_id
join inventory i
		on i.inventory_id = r.inventory_id
where i.film_id in (
					select film_id 
					from peliculasDeAccion
)
order by idCliente
;


/*Desafío Final: ¡Solo con CTEs!
Estos ejercicios deben ser resueltos exclusivamente utilizando la estructura WITH ... AS.

Ejercicio 3 (Reto Individual 1)

Problema: Identifica al cliente que ha gastado más dinero en total. Debes mostrar su nombre completo y 
el monto total gastado, pero solo si ese monto es mayor al promedio de gasto de todos los clientes.

1.	Crea una CTE para calcular el gasto total por cliente.*/

WITH gasto_total AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS nombre,
        SUM(p.amount) AS monto_total_gastado
    FROM customer c
    INNER JOIN payment p
        ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)

SELECT
    nombre,
    monto_total_gastado
FROM gasto_total
WHERE monto_total_gastado > (
    SELECT AVG(monto_total_gastado)
    FROM gasto_total
)
ORDER BY monto_total_gastado DESC
LIMIT 1;

select * from payment;

-- 2.	Crea otra CTE para calcular el promedio de esos totales.

WITH gasto_total AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS nombre,
        SUM(p.amount) AS monto_total_gastado
    FROM customer c
    INNER JOIN payment p
        ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)

SELECT
    nombre,
    monto_total_gastado
FROM gasto_total
WHERE monto_total_gastado > (
    SELECT AVG(monto_total_gastado)
    FROM gasto_total
)
ORDER BY monto_total_gastado DESC
LIMIT 1;

-- 3.	Une ambas en tu consulta final.

-- ESTA QUERY REUNE TODOS LOS PUNTOS DEL EJERCICIO 3

WITH Gasto_cliente AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS nombre,
           SUM(p.amount) AS total_gastado
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
),
promedio_gasto AS (
    SELECT AVG(total_gastado) AS promedio
    FROM Gasto_cliente
)
SELECT g.nombre, g.total_gastado
FROM Gasto_cliente g, promedio_gasto p
WHERE g.total_gastado > p.promedio
ORDER BY g.total_gastado DESC
LIMIT 1;


/*Ejercicio 4 (Reto Individual 1)
Problema: Queremos saber cuántas películas de "duración larga" tiene cada categoría.
1.	Define una CTE llamada peliculas_largas que seleccione las películas con una duración superior a 120 minutos.*/

-- 2.	En la consulta principal, une esta CTE con film_category y category para contar cuántas hay por cada nombre de categoría.

with peliculasLargas as (
select 
     film_id
from film 
where length > 120 
)

select c.name, count(*) as peliculasTotales
from peliculasLargas p
join film_category f
on p.film_id = f.film_id
join category c
on f.category_id = c.category_id
group by c.name
order by peliculasTotales Desc
;



-- ==================================================================================================================================

-- cuales peliculas duran mas que el promedio pero tiene un precio alquiler menor al promedio
 
-- Promedio de duración 
-- Promedio precio alquiler 

SELECT title, length, rental_rate 
FROM film 
WHERE length > (SELECT AVG(length) FROM film) 
AND rental_rate < (SELECT AVG(rental_rate) FROM film);

-- Encontrar todas las películas que tengan inventario 
-- De la tabla peliculas, filtrar en la tabla inventario
 
SELECT * 
FROM film 
WHERE film_id IN (
SELECT DISTINCT(film_id) 
FROM inventory)
;

-- ¿Cuáles son los clientes que han realizado
-- al menos un pago de alto valor 
-- (por ejemplo, superior a $10 USD

SELECT * -- concat(first_name, ' ', last_name) AS nombre_cliente
FROM customer 
WHERE customer_id IN (
SELECT DISTINCT(customer_id) 
FROM payment
where amount > 10);

select * from payment;

-- Películas con más de 5 copias en el inventario
 
SELECT * FROM (										-- FORMA 1
SELECT film_id, COUNT(*) AS total_copias
FROM inventory 
GROUP BY film_id 
) t
WHERE  t.total_copias > 5;
--
 
WITH t AS (									-- FORMA 2
SELECT film_id, COUNT(*) AS total_copias
FROM inventory 
GROUP BY film_id 
)
SELECT * FROM t 
WHERE t.total_copias > 5;

 












