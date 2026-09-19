use prueba;

-- ===== FORMA RAPIDA DE CREAR TABLAS CON ATRIBUTOS
-- se conoce como CTAS (Create Table As Select). 
-- Permite crear una tabla nueva tomando la estructura de una consulta y, normalmente, también sus datos.

create table frutas as
select categoria
from productos
limit 0;

select * from productos;
-- Crear una tabla llamada clientes_activos con la misma estructura de customer, pero sin datos.
use sakila;

create table clientes_activos as
select *
from customer 
limit 0;

select * from peliculas_accion;

-- Crear una tabla llamada peliculas_accion que contenga únicamente la estructura

create table peliculas_accion as
select
film_id,
title,
rating
from film
limit 0;

-- Crear una tabla llamada pagos con: payment_id, customer_id, amount

create table pagos as
select payment_id, customer_id, amount
from payment
limit 0;

-- Crear una tabla llamada empleados con la estructura de: first_name, last_name, email.
create table empleados as
select first_name, last_name, email
from customer
limit 0;

-- Crear una tabla llamada inventario con: inventory_id, film_id, store_id

create table inventario as
select inventory_id, film_id, store_id
from inventory
limit 0;

-- Crear una tabla llamada productos_premium usando la tabla productos, pero solamente con: nombre y precio

use prueba;

create table productos_premium as
select nombre, precio
from productos
limit 0;

-- =================== CARGA DE DATOS RAPIDAMENTE
use callcenter;

INSERT INTO dimpais (Country)
SELECT DISTINCT Country
FROM callcenter
ORDER BY Country ASC;

-- crea una tabla llamada dimcategoria, Llénala con las categorías únicas de la tabla llamadas_enero.

CREATE TABLE dimCategoria(
    Categoria VARCHAR(50)
);
use callcenter;

INSERT INTO dimCategoria (Category)
SELECT DISTINCT Category
FROM llamadas_enero
ORDER BY Category ASC;

select * from llamadas_enero;

-- crea la tabla dimAgente con una columna (Agent_ID) e insertar todos los agentes sin repetir

create table dimAgente(
	Agent_ID varchar (30)
);

INSERT INTO dimAgente (Agent_ID)
SELECT DISTINCT Agent_ID
FROM llamadas_enero
ORDER BY Agent_ID ASC;

select * from dimAgente;

-- crea una dimension de turnos shift, inserta todos los turnos distintos ordenados alfabeticamente
use llamadas_enero;

insert into dimshift (shift)
select distinct shift
from llamadas_enero
order by shift asc;












































