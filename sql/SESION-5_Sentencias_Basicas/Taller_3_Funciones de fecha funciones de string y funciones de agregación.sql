-- PARTE 1: FUNCIONES DE FECHA

-- 1. Películas lanzadas hace exactamente 18 años
SELECT title, release_year
FROM film
WHERE release_year = YEAR(CURDATE()) - 18;

-- 2. Días desde el alquiler más reciente
SELECT DATEDIFF(CURDATE(), 
MAX(rental_date)) AS dias_desde_ultimo_alquiler
FROM rental;

-- 3. Año de la primera renta
SELECT YEAR(MIN(rental_date)) AS primer_anio_renta
FROM rental;

-- 4. Día de la semana con más rentas
SELECT DAYNAME(rental_date) AS dia_semana, COUNT(*) AS total
FROM rental
GROUP BY dia_semana
ORDER BY total DESC
LIMIT 1;

-- 5. Películas alquiladas en 2005
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date BETWEEN '2005-01-01' AND '2005-12-31';

-- PARTE 2: FUNCIONES DE CADENA

-- 6. Clientes cuyo nombre empieza con 'J'
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'J%';

-- 7. Nombre completo en mayúsculas (empleados)
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS nombre_completo
FROM staff;

-- 8. Reemplazar "ACTION" por "AVENTURA"
SELECT REPLACE(name, 'ACTION', 'AVENTURA') AS categoria
FROM category;

-- 9. Actores con nombre de 5 letras
SELECT first_name, last_name
FROM actor
WHERE LENGTH(first_name) = 5;

-- 10. Primeros 3 caracteres del título
SELECT title, LEFT(title, 3) AS primeros_3
FROM film;

-- PARTE 3: FUNCIONES DE AGREGACIÓN

-- 11. Total de películas alquiladas por cliente
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- 12. Total recaudado por tienda
SELECT s.store_id, SUM(p.amount) AS total_recaudado
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 13. Promedio duración por categoría
SELECT c.name AS categoria, AVG(f.length) AS duracion_promedio
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name;

-- 14. Ingreso total por película
SELECT f.title, SUM(p.amount) AS ingreso_total
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title;

-- 15. Categoría con más películas
SELECT c.name, COUNT(fc.film_id) AS total_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY total_peliculas DESC
LIMIT 1;
