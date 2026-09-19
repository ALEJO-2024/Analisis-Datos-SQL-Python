-- Funciones de Fecha
SET lc_time_names = 'es_CO';-- cambiar salida a español
 
SELECT rental_date, 
year(rental_date) año, 
month(rental_date)mes, 
day(rental_date) dia,
DAYNAME(rental_date) nombre_dia,
monthname(rental_date)
FROM rental;

-- Funciones de Hora

SELECT (rental_date),
date (rental_date) fecha, 
time(rental_date) hora
from rental;


SELECT rental_date, return_date, -- Genera una nueva columna con los dias de diferencia
datediff(return_date, rental_date) 'Dias en Renta'
from rental;

-- ==================================================Consultas Basicas SQL=================================
-- PARTE 1: FUNCIONES DE FECHA

-- 1 Encuentra las películas que fueron lanzadas hace exactamente 18 años desde la fecha actual.

SELECT title, release_year
FROM film
WHERE release_year = YEAR(CURRENT_DATE()) - 20;

SELECT * from film;

-- 2 Calcula cuántos días han pasado desde el alquiler más reciente en la base de datos.

SELECT DATEDIFF(CURRENT_DATE(), MAX(rental_date)) AS dias_ultimo_alquiler
FROM rental;

-- 3 Extrae el año en que se realizó la primera renta registrada en la base de datos.

SELECT year (min(rental_date)) año_minimo
from rental;

-- 4 Muestra el día de la semana en que se realizó la mayor cantidad de rentas

SELECT dayname (max(rental_date)) Mayor_Cantidad_Ventas
from rental;


-- 5 Muestra todas las películas alquiladas entre el 1 de enero de 2005 y el 31 de diciembre de 2005

select count(*) Todas_las_Peliculas_Alquiladas
from rental
WHERE (rental_date) BETWEEN '2005-01-01' AND '2005-12-31';

SELECT * from customer;
SELECT * from category;

-- Parte 2: Funciones de Cadenas

-- 6. Trae una lista de los clientes cuyo nombre comience con la letra 'J'.

SELECT * 
from customer
WHERE first_name like 'J%';

-- 7. Muestra el nombre y apellido de los empleados, concatenados en una sola columna y en mayúsculas.

SELECT CONCAT(First_name, ' ', last_name) 'Nombre y Apellido'
FROM customer;

-- 8. Reemplaza todas las ocurrencias de la palabra "ACTION" por "AVENTURA" en los nombres de las categorías de películas.

UPDATE category
SET name = 'AVENTURA'
WHERE name = 'ACTION';


-- 9. Encuentra los actores cuyo nombre tenga exactamente 5 letras.

SELECT first_name
FROM actor
WHERE first_name LIKE '_____' ; -- 5 guiones bajos

SELECT * from ACTOR;

/*10. Muestra los primeros tres caracteres del título de cada película.

LEFT() es una función que extrae una cantidad determinada de caracteres desde el lado izquierdo (inicio) de una cadena de texto.

Sintaxis: LEFT(cadena, cantidad)
  cadena: el texto del que quieres extraer caracteres.
  cantidad: el número de caracteres que deseas obtener desde el inicio.*/

SELECT LEFT(title, 3) AS primeros_tres_caracteres -- 
FROM film;


-- Parte 3: Funciones de Agregación (esta pendiente porque no hemos visto JOINS)
use sakila;

-- 11. Calcula el número total de películas alquiladas por cada cliente.

select 	cu.first_name, 
		cu.last_name,
		count(re.rental_id) AS 'cantidad de alquileres'
from customer cu
inner join rental re
on cu.customer_id = re.customer_id
group by cu.first_name, 
		cu.last_name,
        cu.customer_id;
        
select * from rental;
SELECT * from customer;

-- 12. Encuentra el monto total recaudado por rentas en cada tienda.

select 	st.store_id, sum(p.amount) AS 'monto total'
from payment p
inner join staff st
on p.staff_id = st.staff_id 
group by st.store_id;
      
 select * from payment;
 select * from staff;
 

-- 13. Muestra el promedio de la duración de las películas por cada categoría.

select avg(f.length) AS 'promedio_duracion', ca.name AS 'categoria'
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category ca
on fc.category_id = ca.category_id
group by ca.name;

select * from film_category;
show tables;
        
select * FROM film;
select * FROM category;

-- 14. Calcula el ingreso total generado por cada película en la base de datos.

select f.film_id, f.title, sum(p.amount) AS monto_total
from payment p
inner join rental r
on p.rental_id = r.rental_id
inner join inventory inv
on r.inventory_id = inv.inventory_id
inner join film f
on  inv.film_id = f.film_id
group by f.film_id, f.title;

select * from payment;
select * from staff;
select * from film;
select * from category;

-- 15. Encuentra la categoría con la mayor cantidad de películas y muestra cuántas películas pertenecen a esa categoría.

select ca.category_id, count(f.film_id) AS cantidad_peliculas, ca.name AS 'categoria'
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category ca
on fc.category_id = ca.category_id
group by ca.category_id, ca.name
order by cantidad_peliculas desc
limit 1;


-- ======= EJEMPLOS =============

SELECT rating, AVG(length), MIN(rental_rate)
FROM film
GROUP BY rating;


SELECT rating, AVG(length), MIN(rental_rate), COUNT(title)
FROM film
GROUP BY rating;

SELECT rating, release_year, AVG(length), MIN(rental_rate), COUNT(title)
FROM film
GROUP BY rating, release_year;

-- Cuanto dinero genero cada empleado?
SELECT staff_id, SUM(amount) Total_Ventas
FROM payment
GROUP BY staff_id;

SELECT * from payment;













