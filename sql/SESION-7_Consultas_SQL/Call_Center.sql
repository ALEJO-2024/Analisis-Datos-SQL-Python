create database callcenter;
use callcenter;
/*3: Muestre todas las columnas de las primeras 10 llamadas registradas en la tabla.*/

select	* from llamadas_enero
limit 10;

/*4: Liste únicamente el Call_ID, Country y categoría de todas las llamadas.*/

select ï»¿Call_ID, Country, category
from llamadas_enero;

-- 5: Muestre todas las llamadas que sean del país Colombia.

select ï»¿Call_ID, Country
from llamadas_enero
where Country = 'Colombia';

-- 6: Liste las llamadas donde el tipo de problema sea "Problemas tecnicos" del país Honduras.

select category, Country
from llamadas_enero
where category = 'Problemas tecnicos' and country = 'Honduras'
order by country;


-- 7: Muestre las llamadas de México donde el turno sea T1 antes de las 10:00 am.
ALTER TABLE llamadas_enero
MODIFY COLUMN time TIME;

select country, shift, Time
from llamadas_enero
where shift = 'T1' and time < '10:00' and country = 'México';

select * from llamadas_enero;

-- 8: Liste las llamadas donde el país sea Argentina o Chile, ordenadas alfabéticamente por país.

select ï»¿Call_ID, country											
from llamadas_enero
where country = 'Argentina' or country = 'Chile'
order by country asc;


-- 9: Muestre las llamadas con duración (Duration_min) mayor a 150 minutos, ordenadas de mayor a menor duración.


select ï»¿Call_ID, Duration_min 					-- RESPUESTA DA VACIO
from llamadas_enero
where Duration_min > 150
order by Duration_min desc;

-- 10: Liste todas las llamadas donde el agente sea AG_003 y el tipo de problema sea "Acceso y cuenta".

select ï»¿Call_ID, Agent_ID, category
from llamadas_enero
where Agent_ID = 'AG_003' and category = 'Acceso y cuenta';

-- 11: Muestre las llamadas donde la duración esté entre 5 y 7 minutos, ordenadas por duración ascendente.

select ï»¿Call_ID, Duration_min				
from llamadas_enero
where Duration_min between 5 and 7	
order by Duration_min asc;

select * from llamadas_enero;


-- 12: Liste las llamadas donde el país NO sea México, mostrando solo Call_ID, Country y Category.

select ï»¿Call_ID, Country, Category				
from llamadas_enero
where Country not in ('Mexico');


-- 13: Cuente el total de llamadas registradas en la tabla para cada asesor del turno T3.

select (shift) AS Turno, Agent_ID, count(ï»¿Call_ID) AS 'total_llamadas'
from llamadas_enero
where shift = 'T3'
group by shift, Agent_ID;

select * from llamadas_enero;

-- 14: Calcule la duración promedio (AVG) de las llamadas por categoría.

select ï»¿Call_ID, category, avg(Duration_min) AS 'duracion_promedio'
from llamadas_enero
group by category, ï»¿Call_ID;

-- 15: Cuente cuántas llamadas hubo por cada país (Country), 
-- mostrando el país y el total de llamadas, ordenado de mayor a menor cantidad.

select Country, count(ï»¿Call_ID) AS 'total_llamadas'
from llamadas_enero
group by Country
order by count(ï»¿Call_ID) desc;


-- 16: Muestre el tipo de problema (Categoría) con el mayor número de llamadas registradas.

select Category, count(ï»¿Call_ID) AS 'total_llamadas'
from llamadas_enero
group by Category;

/*17: Liste los agentes (AgentID) que hayan atendido más de 500 llamadas en cada turno, 
mostrando el ID del agente y el total atendido, ordenados de mayor a menor.*/

select Shift, Agent_ID, count(*) AS 'total_llamadas'			
from llamadas_enero
group by Shift, Agent_ID
having count(*) > 500
order by count(*) desc;

/* 18: Por cada país, calcule la duración de las llamadas para cada categoría, 
solo muestre aquellos países cuyo promedio de duración sea mayor a 120 minutos y 
ordénelos por país de forma alfabética y por cantidad de mayor a menor.  */

select country, avg(Duration_min) AS 'promedio_llamadas', count(*) AS 'cantidad_llamadas'		
from llamadas_enero								-- LAS DURACIONES DE LAS LLAMADAS NO SUPERAN LOS 120 MINUTOS
where Duration_min > 120
group by country
order by country asc, count(*) desc;

-- 19 (ALTER): Agregue una nueva columna llamada Pais_Codigo de tipo VARCHAR(5) a la tabla llamadas_enero.

alter table llamadas_enero
add column pais_codigo varchar (5);

select * from llamadas_enero;

-- 20 (UPDATE): Actualice la columna Pais_Codigo con el valor "COL" para todas las llamadas donde el país sea Colombia.
SET SQL_SAFE_UPDATES = 0;

update llamadas_enero
set pais_codigo = 'COL'
where country = 'Colombia';

-- Bonus: Cambie el nombre de la columna *Queue_Time_sec* por *Queue_Time_min* y convierte los datos de esta columna a minutos

ALTER TABLE llamadas_enero
RENAME COLUMN Queue_Time_sec TO Queue_Time_min;

SELECT Queue_Time_min, (Queue_Time_min / 60) AS minutos
FROM llamadas_enero;


