-- ========================= Taller Práctico #10 Construcción de un Modelo Estrella mediante Consultas SQL ====================

/* Objetivo del Taller
Diseñar y poblar un modelo estrella mediante consultas de extracción y transformación (CREATE TABLE ... AS SELECT e INSERT INTO ... SELECT), 
estableciendo llaves de relación para optimizar el análisis operativo del Call Center.
Base de Datos: Call Center
Plataforma: MySQL Workbench

Trabajo autónomo
1.	 carga de la tabla de datos cruda con el asistente para importación de datos de MySQL Workbench y nombrela ‘raw_call_center’
2.	Creación y Poblado de la Dimensión Categoría (dim_categoria)

Crea la tabla de dimensión dim_categoria directamente a partir de los valores únicos encontrados en el 
campo Category de la tabla raw_call_center. Debes generar una clave alfanumérica secuencial con la letra C al inicio
(C01, C02, etc.) para cada categoría.*/

use callcenter;
select * from raw_call_center;

ALTER TABLE raw_call_center
RENAME COLUMN ï»¿Call_ID TO registro_call;


create table dim_category as 
select 
concat('C', row_number()over() ) as id_categoria ,
category , 
'si' as Categoria_Activa
from (
	select 
	distinct(category) AS category
	from raw_call_center order by category asc
) as categoria_unicas;

select * from dim_category;

/*3.	Creación y Poblado de la Dimensión Agente (dim_agente)

Crea la tabla de dimensión dim_agente extrayendo los identificadores únicos de agentes (Agent_ID) 
presentes en la tabla ‘raw_call_center’ y asigne a los valores a cada fila según corresponda tomando la 
información de la hoja agente del archivo Dimensiones.xlsx*/

create table dim_agente as
select
Agent_ID,
null as nombre_agente ,
null as agente_activo ,
null as id_sup
from dim_agente
(select 
distinct(Agent_ID) AS Agent_ID
from raw_call_center order by Agent_ID asc
) as agentes_unicos;

select * from dim_agente; -- traigo la tabla completa para ver como esta creada y poblada

SET SQL_SAFE_UPDATES = 0; -- quito el modo seguro

-- muestra las caracterisiticas como fue creada la tabla, en este caso me interesa la logitud de caracteres
-- de las columnas nombre_agente, agente_activo y id_sup:
SHOW CREATE TABLE dim_agente; 

-- modifico su estructura ya que no me permite ingresar datos porque estaba configurado como binary (0):
ALTER TABLE dim_agente
MODIFY nombre_agente VARCHAR(100);

-- ahora puedo actualizar y poblar la tabla:
update dim_agente 
set nombre_agente = 'Laura Martínez', agente_activo = 'si', id_sup = 'SP01'
where Agent_ID = 'AG_005' ;

-- ingreso los valores faltantes:
insert into dim_agente (Agent_ID, nombre_agente, agente_activo, id_sup)
				values ('AG_001', 'María González', 'si', 'SP01'),
					   ('AG_005', 'Laura Martínez', 'si', 'SP01'),
					   ('AG_009', 'Valentina López', 'si', 'SP03'),
                       ('AG_014', 'Diego Vargas', 'si', 'SP02'),
                       ('AG_016', 'Luis Gomez', 'si', 'SP02');

-- este codigo fue porque ingrese por error los valores anteriores en dos veces, 
-- asi que los elimine para volverlos a subir con el query anterior:					
delete from dim_agente
where Agent_ID in ('AG_001', 'AG_005', 'AG_009', 'AG_014', 'AG_016');


/*4.	Creación y poblado de la tabla de dimensión dim_supervisor, a esta tabla es necesario insertarle los datos que
están en la la información de la hoja supervisor del archivo Dimensiones.xlsx*/

create table dim_supervisor (
id_supervisor varchar (20) primary key,
nombre_supervisor varchar (50),
supervisor_activo varchar (10)
);

select * from dim_supervisor;

insert into dim_supervisor (id_supervisor, nombre_supervisor, supervisor_activo)
values ('SP01',	'Cristian Aguirre',	'si'),
	   ('SP02',	'Rosa Ariza', 'si'),
       ('SP03',	'Andrea Mendoza', 'si');
       
-- 5. Creación y Poblado de la Dimensión Turno (dim_)xlsx

create table dim_shift (
id_shift int primary key,
acr_shift varchar (10),
nombre_shift varchar (50)
);

select * from dim_shift;

insert into dim_shift (id_shift, acr_shift,	nombre_shift)
values (1, 'T1', 'Mañana'),
	   (2, 'T2', 'Tarde'),
       (3, 'T3', 'Noche');

/*6.	Creación y Poblado de la Dimensión Pais (dim_Pais)
Crea la tabla de dimensión dim_pais directamente a partir de los valores únicos encontrados en el campo 
country de la tabla raw_call_center. Debes generar una clave alfanumérica secuencial con la letra P al inicio 
(P01, P02, etc.) para cada Pais de la lista.*/

create table dim_pais as
select 
    concat('P', lpad(row_number() over (order by country), 2, '0')) as id_pais,
    country as nombre_pais,
    -- generación del código iso mediante case
    case country
        when 'Argentina' 			then 'AR'
        when 'Bolivia' 				then 'BL'
        when 'Chile' 				then 'CL'
        when 'Colombia' 			then 'CO'
        when 'Costa rica' 			then 'CR'
        when 'Ecuador' 				then 'EC'
        when 'El Salvador' 			then 'SV'
        when 'Guatemala' 			then 'GT'
        when 'Honduras' 			then 'HN'
        when 'Mexico' 				then 'MX'
        when 'Nicaragua' 			then 'NI'
        when 'Panama' 				then 'PA'
        when 'Paraguay' 			then 'PY'
        when 'Peru' 				then 'PE'
        when 'Republica dominicana' then 'DM'
        when 'Uruguay' 				then 'UY'
        when 'Venezuela' 			then 'VE'
        else 'Revisar'
    end as iso_pais,
    -- generación de la región mediante case
    case country
        when 'Argentina' 			then 'Sudamerica'
        when 'Bolivia' 				then 'Sudamerica'
        when 'Chile' 				then 'Sudamerica'
        when 'Colombia' 			then 'Sudamerica'
        when 'Costa rica' 			then 'Sentroamerica'
        when 'Ecuador' 				then 'Sudamerica'
        when 'El Salvador' 			then 'Centroamerica'
        when 'Guatemala' 			then 'Centroamerica'
        when 'Honduras' 			then 'Centroamerica'
        when 'Mexico' 				then 'Centroamerica'
        when 'Nicaragua' 			then 'Centroamerica'
        when 'Panama' 				then 'Centroamerica'
        when 'Paraguay' 			then 'Sudamerica'
        when 'Peru' 				then 'Sudamerica'
        when 'Republica Dominicana' then 'Caribe'
        when 'Uruguay' 				then 'Sudamerica'
        when 'Venezuela' 			then 'Sudamerica'
        else 'Revisar'
    end as region_pais,
    'si' as pais_activo -- generación del estado del país
from (
    select distinct country 
    from raw_call_center 
    where country is not null
) as paises_raw;

-- asignar la llave primaria (primary key) a la dimensión:
alter table dim_pais 
add primary key (id_pais);

select * from dim_pais;

/*7.	Creación Estructurada de la Tabla de Hechos (fact_call_center)
Define la estructura física DDL de la tabla de hechos fact_call_center. 
La tabla debe contener la clave primaria de la llamada, campos de fecha/hora, 
llaves foráneas apuntando a cada tabla dim y las métricas numéricas del servicio.*/

-- Definición explícita de la estructura física:
CREATE TABLE fact_call_center (
    id_llamada VARCHAR(20) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_cliente VARCHAR(50) NOT NULL,

    -- Llaves de conexión hacia las dimensiones
    id_pais VARCHAR(3) NOT NULL,
    id_categoria VARCHAR(3) NOT NULL,
    id_shift INT NOT NULL,
    id_agente VARCHAR(20) NOT NULL,

    -- Métricas de rendimiento
    tiempo_espera_seg INT UNSIGNED DEFAULT 0,
    tiempo_hablado_min DECIMAL(5,2) DEFAULT 0.00,
    tiempo_retencion_min DECIMAL(5,2) DEFAULT 0.00,
    duracion_total_min DECIMAL(5,2) DEFAULT 0.00,
    tiempo_post_llamada_min DECIMAL(5,2) DEFAULT 0.00,

    -- KPIs de satisfacción
    csat INT UNSIGNED DEFAULT NULL,
    fcr TINYINT UNSIGNED DEFAULT NULL,
    nps INT UNSIGNED DEFAULT NULL,

    -- Llave primaria
    PRIMARY KEY (id_llamada),

    -- Llaves foráneas
    FOREIGN KEY (id_pais)
        REFERENCES dim_pais(id_pais),

    FOREIGN KEY (id_categoria)
        REFERENCES dim_category(id_categoria),

    FOREIGN KEY (id_shift)
        REFERENCES dim_shift(id_shift),

    FOREIGN KEY (id_agente)
        REFERENCES dim_agente(Agent_ID)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

select * from fact_call_center;

-- inserción masiva de datos transformados desde la tabla raw cruzando las dimensiones:
INSERT INTO fact_call_center (
    id_llamada,
    fecha,
    hora,
    id_cliente,
    id_pais,
    id_categoria,
    id_shift,
    id_agente,
    tiempo_espera_seg,
    tiempo_hablado_min,
    tiempo_retencion_min,
    duracion_total_min,
    tiempo_post_llamada_min,
    csat,
    fcr,
    nps
)
SELECT    
    r.registro_call AS id_llamada,

    STR_TO_DATE(r.Date, '%d/%m/%Y') AS fecha,

    CAST(r.Time AS TIME) AS hora,

    r.Customer_ID AS id_cliente,

    dp.id_pais,

    dc.id_categoria,

    ds.id_shift,

    da.Agent_ID AS id_agente,

    -- Métricas
    CAST(r.Queue_Time_sec AS UNSIGNED) AS tiempo_espera_seg,
    CAST(r.Talk_Time_min AS DECIMAL(5,2)) AS tiempo_hablado_min,
    CAST(r.Hold_Time_min AS DECIMAL(5,2)) AS tiempo_retencion_min,
    CAST(r.Duration_min AS DECIMAL(5,2)) AS duracion_total_min,
    CAST(r.ACW_min AS DECIMAL(5,2)) AS tiempo_post_llamada_min,

    -- KPIs
    CAST(r.CSAT AS UNSIGNED) AS csat,
    CAST(r.FCR AS UNSIGNED) AS fcr,
    CAST(r.NPS AS UNSIGNED) AS nps

FROM raw_call_center r

INNER JOIN dim_pais dp
    ON r.Country = dp.nombre_pais

INNER JOIN dim_category dc
    ON r.Category = dc.category

INNER JOIN dim_shift ds
    ON r.Shift = ds.acr_shift

INNER JOIN dim_agente da
    ON r.Agent_ID = da.Agent_ID;


-- Consulta de validación final del modelo estrella completo:
SELECT 
    f.id_llamada,
    f.fecha,
    p.nombre_pais,
    c.category AS nombre_categoria,
    s.nombre_shift,
    a.Agent_ID AS id_agente,
    f.duracion_total_min,
    f.csat,
    f.nps
FROM fact_call_center f
INNER JOIN dim_pais p 
    ON f.id_pais = p.id_pais
INNER JOIN dim_category c 
    ON f.id_categoria = c.id_categoria
INNER JOIN dim_shift s 
    ON f.id_shift = s.id_shift
INNER JOIN dim_agente a 
    ON f.id_agente = a.Agent_ID
LIMIT 15;

select * from fact_call_center;

-- =========================== Taller Práctico #11 Construcción de un Modelo Estrella mediante Consultas SQL
/*  Preparación del Entorno
Para este ejercicio vamos a usar solo los datos del 01 enero 2026
Trabajo autónomo
1.	Identificación de "Agentes Estrella"
La gerencia quiere reconocer a los agentes que están dando un servicio excepcional y que además 
tengan un volumen de llamadas representativo. 

Pregunta a Resolver: ¿Qué agentes tienen un promedio de satisfacción (CSAT) mayor a 4?5 y 
han atendido más de 10 llamadas? Se requiere el nombre del agente, su promedio de CSAT y el total de llamadas atendidas. 
Usa en esta consulta: JOIN entre 2 tablas (fact_call_center y dim_agentes), GROUP BY, HAVING y funciones de agregación*/

select da.nombre_agente, count(fc.id_llamada) total_llamadas, avg(fc.csat) promedio_satisfaccion
from fact_call_center fc
inner join dim_agentes da						-- trae una consulta vacia ya que no hay agentes que cumplan con este criterio
on fc.id_agente = da.id_agente
group by da.nombre_agente
having promedio_satisfaccion > 4.5 and total_llamadas > 10 ;

select * from fact_call_center;

/*2.	Eficiencia Regional por Turno
El área de operaciones necesita monitorear los tiempos de espera en las regiones con mayor carga laboral durante los turnos más críticos.

Pregunta a Resolver: Crear una vista que muestre el tiempo promedio de espera en segundos (tiempo_espera_seg) 
agrupado por la región del país (region_pais) y el nombre del turno (nombre_shift). 
El filtro debe incluir solo los turnos de Tarde (T2) y Noche (T3) en países que estén activos.
Usa en esta consulta: CREATE VIEW, JOIN entre 3 tablas, operadores lógicos (AND, IN), AVG()*/

create view Eficiencia_Regional_por_Turno as
select dp.region_pais, (ds.nombre_shift) nombre_turno, dp.pais_activo, avg(fc.tiempo_espera_seg) promedio_espera_segundos
from dim_pais dp
join fact_call_center fc
on dp.id_pais = fc.id_pais
join dim_shift ds
on fc.id_shift = ds.id_shift
where ds.nombre_shift not in ('Mañana') and dp.pais_activo = 'SI'
group by dp.region_pais, ds.nombre_shift;

USE callcenter;
SELECT * FROM dim_pais;

select * from Eficiencia_Regional_por_Turno;

/*							3.	Detección de Llamadas Atípicas
Se quiere identificar llamadas que se salieron de control y duraron mucho más de lo normal para su tipo de problema, 
con el fin de analizar qué pasó.

Pregunta a Resolver: Listar el ID de la llamada, el nombre de la categoría y la duración total de 
aquellas llamadas cuya duracion_total_min sea estrictamente mayor al promedio de duración de su misma categoría.

Usa en esta consulta: Subconsulta (correlacionada o en el FROM), JOIN, operadores de comparación (>).*/

select fc.id_llamada, (dc.category) nombre_categoria, fc.duracion_total_min	
from fact_call_center fc 
join dim_category dc
on fc.id_categoria = dc.id_categoria
where fc.duracion_total_min	 > (select avg(fc2.duracion_total_min) promedio_duracion
								from fact_call_center fc2
                                where fc2.id_categoria = fc.id_categoria);
                                                      
                               
/*4.							Clasificación de Desempeño por Supervisor

Los supervisores necesitan un reporte que los clasifique según el Net Promoter Score (NPS) 
promedio de sus equipos para asignar bonos de desempeño.

Pregunta a Resolver: Calcular el NPS promedio y la tasa de resolución (promedio de FCR) por supervisor. 
Usar un CASE para clasificarlos en 'Bajo' (NPS <= 5), 'Medio' (NPS entre 5.1 y 7) y 'Alto' (NPS > 7). 
Mostrar solo los supervisores con desempeño 'Alto' y que hayan supervisado más de 50 llamadas.

Usa en esta consulta: JOIN entre 3 tablas (fact, dim_agentes, dim_supervisores), CASE, GROUP BY, HAVING.*/

use callcenter;

select  ds.id_supervisor, 
		ds.nombre_supervisor, 
        avg(fc.nps) indicador_satisfaccion, 
        avg(fc.fcr) tasa_resolución, 
        count(fc.id_llamada)cantidad_llamadas,
	case 
		when avg(fc.nps) <= 5 then 'Bajo'
        when avg(fc.nps) between 5.1 and 7 then 'Medio'
        when avg(fc.nps) > 7 then 'Alto'
	end as clasificacion
from fact_call_center fc
join dim_agentes da
	on fc.id_agente = da.id_agente
join dim_supervisor ds
	on da.id_sup = ds.id_supervisor
group by ds.id_supervisor, ds.nombre_supervisor
HAVING AVG(fc.nps) > 7
AND COUNT(fc.id_llamada) > 50;			-- ESTA CONSULTA TRAE DATOS VACIOS PORQUE NINGUN SUPERVISOR CUMPLE LA CONDICION

select * from fact_call_center;

/*				5.	Tendencia Diaria vs. Histórico
La dirección quiere un dashboard rápido para ver si el servicio de hoy estuvo mejor o peor que el histórico general de la empresa.

Pregunta a Resolver: Crear una vista que muestre la fecha, el total de llamadas del día, el CSAT promedio del día y 
una columna calculada que indique si el CSAT del día estuvo 'Por encima' o 'Por debajo' del CSAT promedio 
histórico de toda la base de datos.

Usa en esta consulta (CREATE VIEW, GROUP BY, Subconsulta para el promedio global, CASE, operadores de comparación.)*/




















-- ================================================== MODELO ESTRELLA PARTE 2: =========================================================

create database if not exists estrella_ventas;

use estrella_ventas;

CREATE TABLE dim_cliente (
    cliente_id INT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(90) NOT NULL
);

CREATE TABLE dim_producto (
    producto_id INT PRIMARY KEY,
    producto VARCHAR(80) NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE dim_vendedor (
    vendedor_id INT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    cargo VARCHAR(50) NOT NULL
);

CREATE TABLE dim_tienda (
    tienda_id INT PRIMARY KEY,
    tienda VARCHAR(90) NOT NULL,
    ciudad VARCHAR(60) NOT NULL
);

-- TABLA DE ECHOS:

CREATE TABLE fact_ventas (
    venta_id INT PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    tienda_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total_venta DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES dim_cliente(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES dim_producto(producto_id),
    FOREIGN KEY (vendedor_id) REFERENCES dim_vendedor(vendedor_id),
    FOREIGN KEY (tienda_id) REFERENCES dim_tienda(tienda_id)
);

-- POBLACION DE TABLAS DIM:
INSERT INTO dim_cliente VALUES
(1,'Ana','Medellín'),
(2,'Carlos','Bogotá'),
(3,'Laura','Cali'),
(4,'Juan','Medellín'),
(5,'Sofía','Rionegro');

INSERT INTO dim_producto VALUES
(1,'Café','Bebidas'),
(2,'Sandwich','Comidas'),
(3,'Torta','Postres'),
(4,'Jugo','Bebidas'),
(5,'Ensalada','Comidas');

INSERT INTO dim_vendedor VALUES
(1,'Laura','Asesora'),
(2,'Pedro','Asesor'),
(3,'Camila','Asesora'),
(4,'Andrés','Asesor');

INSERT INTO dim_tienda VALUES
(1,'Laureles','Medellín'),
(2,'El Poblado','Medellín'),
(3,'Centro','Bogotá');

-- POBLACION TABLA DE ECHOS (FACT):
INSERT INTO fact_ventas (
    venta_id,
    fecha_venta,
    cliente_id,
    producto_id,
    vendedor_id,
    tienda_id,
    cantidad,
    precio_unitario,
    total_venta
)
VALUES
(1, '2026-08-01', 1, 1, 1, 1, 2, 9000, 18000),
(2, '2026-08-01', 2, 2, 2, 1, 1, 18000, 18000),
(3, '2026-08-02', 3, 3, 3, 1, 2, 12000, 24000),
(4, '2026-08-02', 1, 4, 1, 1, 3, 7000, 21000),
(5, '2026-08-03', 4, 1, 4, 2, 1, 9000, 9000),
(6, '2026-08-03', 5, 2, 3, 2, 2, 16000, 32000),
(7, '2026-08-04', 2, 3, 3, 2, 1, 12000, 12000),
(8, '2026-08-04', 3, 2, 1, 2, 2, 18000, 36000),
(9, '2026-08-05', 1, 4, 4, 3, 4, 7000, 28000),
(10, '2026-08-05', 4, 1, 2, 1, 3, 9000, 27000),
(11, '2026-08-05', 5, 3, 3, 2, 1, 12000, 12000),
(12, '2026-08-06', 2, 5, 4, 3, 2, 16000, 32000),
(13, '2026-08-07', 1, 2, 1, 1, 2, 18000, 36000),
(14, '2026-08-07', 3, 1, 2, 2, 5, 9000, 45000),
(15, '2026-08-06', 5, 4, 3, 2, 2, 7000, 14000);

SELECT *
FROM fact_ventas f
INNER JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id
INNER JOIN dim_producto p
    ON f.producto_id = p.producto_id
INNER JOIN dim_tienda t
    ON f.tienda_id = t.tienda_id
INNER JOIN dim_vendedor v
    ON f.vendedor_id = v.vendedor_id;

SELECT * FROM fact_ventas;














