create database practica_final_sql;

use practica_final_sql;

CREATE TABLE clientes (
  id_cliente   INT PRIMARY KEY,
  nombre       VARCHAR(60),
  email        VARCHAR(80),
  ciudad       VARCHAR(40),
  segmento     VARCHAR(20)
);
INSERT INTO clientes VALUES
(1,'Ana Garcia',   'ana@mail.com',   'Bogota',  'VIP'),
(2,'Juan Lopez',   'juan@mail.com',  'Medellin','Frecuente'),
(3,'Maria Ruiz',   'maria@mail.com', 'Cali',    'Frecuente'),
(4,'Carlos Perez', 'carlos@mail.com','Bogota',  'Nuevo'),
(5,'Laura Torres', 'laura@mail.com', 'Bogota',  'VIP'),
(6,'Sofia Mora',   'sofia@mail.com', 'Cali',    'Nuevo'),
(7,'Diego Rios',   'diego@mail.com', 'Medellin','Frecuente');
 
CREATE TABLE pagos (
  id_pago      INT PRIMARY KEY,
  id_cliente   INT,
  fecha_pago   DATE,
  monto        DECIMAL(10,2),
  metodo       VARCHAR(20)
);
INSERT INTO pagos VALUES
(101,1,'2025-01-10',150000,'Credito'),
(102,2,'2025-01-15', 80000,'Debito'),
(103,3,'2025-02-01',120000,'Credito'),
(104,4,'2025-02-10', 45000,'Efectivo'),
(105,5,'2025-03-05',200000,'Credito'),
(106,1,'2025-03-20',175000,'Credito'),
(107,3,'2025-04-01', 90000,'Debito'),
(108,10,'2025-04-15',60000,'Efectivo'),
(109,11,'2025-05-01',30000,'Debito');
 
-- ¿Cuántos clientes distintos de Bogotá tienen segmento 'VIP' o 'Frecuente'?
-- Listalos por nombre en orden alfabético.

select distinct (count(*)) as clientes, nombre
from clientes
where ciudad != 'Bogota' and segmento in ('VIP', 'Frecuente')
group by nombre
order by nombre asc;

-- filtra los del segmento frecuente que no sean de bogota:
select nombre, ciudad, segmento
from clientes
where ciudad != 'bogota'
	and segmento in ('vip', 'frecuente')
order by nombre asc;

-- JOIN-GROUP BY-HAVING:

-- ¿Qué clientes VIP o Frecuentes han pagado más de $100.000 en total?
-- Muestra nombre, segmento y total pagado.

select c.nombre, c.segmento, sum(p.monto) as total_pagado
from clientes c
inner join pagos p
on c.id_cliente = p.id_cliente
where segmento in ('VIP', 'Frecuentes')
group by c.nombre, c.segmento
having sum(p.monto) > 100000
order by total_pagado desc;

select * from pagos;





