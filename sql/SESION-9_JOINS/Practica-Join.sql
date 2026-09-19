use callcenter;

select * 
from llamadas_enero lle
join dimagente da
on lle.agent_id = da.id_agente;

select * from dimagente;
-- ========================================= TALLER 6 MODULO 2 JOINS =====================================================
-- INNER JOIN
/*1. Listar el nombre completo de los clientes y la cantidad de alquileres que han 
realizado.
Agrupar por cliente y mostrar solo aquellos que hayan hecho más de 5 alquileres.*/

use sakila;

select 	cu.first_name, 
		cu.last_name,
		count(re.rental_id) AS 'cantidad de alquileres'
from rental re
inner join customer cu
on re.customer_id = cu.customer_id
group by cu.first_name, 
		cu.last_name,
        cu.customer_id
having count(re.rental_id) > 5; 

select * from customer;
select * from rental;

-- LEFT JOIN
/*2. Mostrar todos los clientes, hayan alquilado o no, junto con la cantidad de 
alquileres realizados.
Agrupar por cliente y mostrar solo aquellos con 3 o más alquileres.*/
        
select 	cu.first_name, 
		cu.last_name,
		count(re.rental_id) AS 'cantidad de alquileres'
from rental re
left join customer cu
on re.customer_id = cu.customer_id
group by cu.first_name, 
		cu.last_name,
        cu.customer_id
having count(re.rental_id) > 3; 
        

/*3. Listar todos los títulos de películas junto con la cantidad de veces que han 
sido alquiladas.
Incluir las películas que no se han alquilado nunca. Mostrar solo aquellas que sí 
tienen al menos una renta.*/

select  f.title,
		count(re.rental_id) AS 'cantidad de alquileres' 
from film f
left join inventory inv
on f.film_id = inv.film_id
left join rental re
on inv.inventory_id = re.inventory_id
group by f.title
having count(re.rental_id) > 0; 


-- RIGHT JOIN
/*4. Listar todas las películas que han sido alquiladas y cuántas veces.
Usar RIGHT JOIN entre rental e inventory, agrupando por título. Mostrar solo las 
que se han alquilado más de 10 veces*/

select f.title, f.film_id, count(re.rental_id) AS 'cantidad alquiler'
from film f 
inner join inventory inv
on f.film_id = inv.film_id
right join rental re
on inv.inventory_id = re.inventory_id
group by f.film_id, f.title
having count(re.rental_id) > 10;

use sakila;
select * from rental;
select * from inventory; -- segundo join inventory_id
select * from film;

/*UNION
5. Unir dos listas: una con clientes de la tienda 1 y otra con los de la tienda 2.
Agrupar por tienda y contar cuántos clientes hay por cada una. Mostrar solo las 
tiendas con más de 200 clientes.*/

select store_id, count(distinct c.customer_id) as Clientes, 'Tienda 1' as tienda 
from customer c
WHERE store_id = 1
group by store_id
having count(distinct c.customer_id)> 200
 
union
 
select store_id, count(distinct c.customer_id) as Clientes, 'Tienda 2' as tienda 
from customer c
WHERE store_id = 2
group by store_id
having count(distinct c.customer_id) > 200;

select * from customer;
select * from store; -- ON = store_id



/*6. Unir la lista de clientes que han alquilado películas con la de quienes no han 
alquilado.
Agrupar por tipo ("alquiló" vs. "no alquiló") y contar cuántos clientes hay en cada 
grupo.*/


select
tipo,
COUNT(*) as cantidad_clientes
from (
 
-- Clientes que si alquilaron
 
select
c.customer_id,
'alquilo' as tipo
from customer c
inner join rental r
on c.customer_id = r.customer_id
group by c.customer_id
 
union all
 
-- Clientes que nunca alquilaron
 
select
c.customer_id,
'no alquilo' as tipo
from customer c
left join rental r
on c.customer_id = r.customer_id
where r.customer_id is null
) as clientes
group by tipo;

-- ===============================================

select count(distinct c.customer_id) as Clientes, 'Alquilo' as tipo 
from customer c
inner join rental r
on c.customer_id = r.customer_id
group by tipo
 
union
 
select count(distinct c.customer_id) as Clientes, 'No Alquilo' as tipo 
from customer c
left join rental r
on c.customer_id = r.customer_id
where  r.rental_id is null;


/*- INNER JOIN con múltiples tablas

7. Mostrar el nombre de los empleados y la cantidad de pagos que han procesado.
Usar JOIN entre payment, staff y rental. Agrupar por empleado y mostrar solo 
aquellos que han procesado más de 200 pagos.*/

select st.first_name, 
		st.last_name,
		count(P.payment_id) AS 'cantidad pagos'
from payment p 
inner join staff st
on p.staff_id = st.staff_id
inner join rental re
on p.rental_id = re.rental_id
group by st.first_name, st.last_name
having count(P.payment_id) > 200;

select * from rental;
select * from payment; -- ON: staff_id
select * from staff;

/*- RIGHT JOIN entre actores y películas
8. Listar todos los actores y la cantidad de películas en las que han participado.
Usar RIGHT JOIN entre film_actor y actor. Agrupar por actor y mostrar solo 
aquellos con más de 20 películas*/

select ac.actor_id, concat(ac.first_name,' ', ac.last_name) AS 'actor', count(fa.film_id) AS 'cantidad de peliculas'
from film_actor fa
right join actor ac
on fa.actor_id = ac.actor_id
group by ac.actor_id, ac.first_name, ac.last_name
having count(fa.film_id) > 20;

select * from film_actor;






