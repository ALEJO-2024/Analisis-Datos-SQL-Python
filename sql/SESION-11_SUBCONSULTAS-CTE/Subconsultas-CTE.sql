use sakila;

-- ¿Quiénes son los clientes que han gastado más de $150 USD
-- en total? 
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id 
HAVING SUM(amount) > 150

WITH ganancias AS (
SELECT customer_id, SUM(amount) AS 'cantidad'
FROM payment
GROUP BY customer_id 
)
SELECT * FROM ganancias
WHERE cantidad > 150

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
WHERE tienda_dos.store_id IS NULL


-- ¿Qué películas tienen una duración de alquiler mayor al promedio?
 
SELECT *

FROM film

WHERE rental_duration > (SELECT AVG(rental_duration) FROM film)
 
 
 SELECT * FROM film 
WHERE rental_rate = (SELECT MAX(rental_rate) FROM film;

use callcenter;

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






