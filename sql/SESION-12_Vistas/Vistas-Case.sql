-- se requiere segmentar los pagos para la posterior agrupacion 
-- para ello se solicitan 3 categorias 
-- bajo < 2
-- medio entre 3 y 5 -BETWEEN
-- Alto mayor a 5
 
USE sakila;
 
SELECT payment_id,
	amount,
	CASE 
		WHEN amount < 2 THEN 'bajo'
        WHEN amount BETWEEN 2 AND 5 THEN 'Medio'
		ELSE 'Alto'
     END AS categoria_pago
FROM payment;

/*¿A qué público objetivo pertenece cada película según su clasificación (rating)?
Si rating 'G', 'PG' -> Familiar, ‘PG-13’-> Adolescentes, Si no Adultos */

SELECT film_id,
	   title,
	   rating,
	CASE 
		WHEN rating = 'G' or 'PG' THEN 'Familiar'
		WHEN rating = 'PG-13' THEN 'Adolescentes'
		ELSE 'Adultos'
     END AS publico_objetivo
FROM film;


-- clasificar las peliculas segun su tarifa de alquiler

SELECT
    title,
    rental_rate,
    CASE rental_rate
        WHEN 0.99 THEN 'Económica'
        WHEN 2.99 THEN 'Estándar'
        WHEN 4.99 THEN 'Premium'
        ELSE 'Otra'
    END AS categoria_precio
FROM film;

-- ¿Cómo tener una vista que solo muestre películas largas?

CREATE VIEW peliculas_largas AS
SELECT
	film_id,
	title,
	length
FROM film
WHERE length > 120;

select * from peliculas_largas;

-- CASE, WHEN EN CALLCENTER
use callcenter;

select * from llamadas_enero;

-- ASIGNACION DE CATEGORIA PARA FCR:

Select Date, agent_id , FCR ,
case 
	when FCR = 1 
	then 'Resuelta'
	else 'No Resuelta'
	end as Texto_FCR
from llamadas_enero;

-- ASIGNACION DE TURNOS FORMATO TEXTO PARA SHIFT:

Select agent_id , shift,
case 
	when shift = 'T1' then 'mañana' 
    when shift = 'T2' then 'tarde'
	else 'Noche'
end as turnos_text
from llamadas_enero;

-- UPDATE CON UN CASE:
SET SQL_SAFE_UPDATES = 0;
 
update dimshift
set nombre_shift = 
case
	when nombre_shift = 'Mañana' then 'Morning'
    when nombre_shift = 'Tarde' then 'Afternoon'
    else 'Nigth'
end;

select *
from dimshift;

/* 												Trabajo Autónomo 
Ahora es tu turno. Aplica los conceptos de CASE, Vistas y CTEs para resolver los siguientes problemas. 
Ejercicio 1: Clasificación de Clientes por Gasto 
Objetivo: Retomar el cálculo del gasto total por cliente, pero esta vez, segmentarlos.  
Punto de Partida: Puedes basarte en la consulta que creaste para el Ejercicio 1 del Taller de JOINs o el Ejercicio 3 del Taller de Subconsultas.
Tarea: Modifica esa consulta para mostrar el nombre completo de cada cliente, su gasto total y una nueva columna llamada 
nivel_cliente que los clasifique como: 
• 'Premium' si han gastado más de $150. 
• 'Regular' si han gastado entre $100 y $150. 
• 'Ocasional' si han gastado menos de $100. Pista: La forma más limpia de hacerlo es usando un CTE 
para el cálculo del gasto y luego un CASE en la consulta final. */

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

select nombre, monto_total_gastado,
case 
	when monto_total_gastado > 150 then 'Premium'
    when monto_total_gastado between 100 and 150 then 'Regular'
    else 'Ocasional'
end as nivel_cliente
from gasto_total;

select * from gasto_total;



 