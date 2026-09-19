/*Generar un reporte detallado para identificar a los clientes con pagos registrados a partir del 1 de enero de 2026, 
filtrando aquellas transacciones individuales mayores a 10.00, y agrupando únicamente a quienes acumulen un total superior a 100.00
 con al menos dos transacciones procesadas. El resultado final debe presentar la identificación del cliente, 
 el nombre y el apellido en mayúsculas, el volumen total de pagos y el promedio por transacción ordenados de mayor a menor.
*/

SELECT c.customer_id, 
	UPPER(c.first_name),
    UPPER(c.last_name),
	SUM(p.amount),
    COUNT(p.payment_id),
    AVG(p.amount)
FROM customer_demo c
INNER JOIN payment_demo p
ON c.customer_id = p.customer_id   
WHERE p.payment_date > '2026-01-01' AND p.amount > 10 
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > 100 AND COUNT(p.payment_id)>=2 
ORDER BY  COUNT(p.payment_id) DESC, AVG(p.amount) DESC;

-- ===================================================================================================================================

/*													Taller de Refuerzo de SQL
Parte 1: Configuración de la Base de Datos
Instrucción: Copia y ejecuta el siguiente script en tu cliente de MySQL.
Escenario: Gestionaremos la información de una pequeña academia online: Cursos, Instructores y Inscripciones de estudiantes.*/

-- Borrar la base de datos si ya existe para empezar desde cero 
DROP DATABASE IF EXISTS AcademiaDB; 

-- Crear la base de datos 
CREATE DATABASE AcademiaDB; 

-- Usar la base de datos recién creada 
USE AcademiaDB;


-- Crear la tabla de Instructores 
CREATE TABLE Instructores ( 
InstructorID INT PRIMARY KEY AUTO_INCREMENT, 
Nombre VARCHAR(100) NOT NULL, 
Especialidad VARCHAR(100) );

-- Crear la tabla de Cursos 
CREATE TABLE Cursos ( 
CursoID INT PRIMARY KEY AUTO_INCREMENT, 
Titulo VARCHAR(150) NOT NULL, 
Nivel VARCHAR(50), Horas INT, 
InstructorID INT, 
FOREIGN KEY (InstructorID) REFERENCES Instructores(InstructorID) );

-- Crear la tabla de Inscripciones 
CREATE TABLE Inscripciones ( 
InscripcionID INT PRIMARY KEY AUTO_INCREMENT, 
CursoID INT, 
NombreEstudiante VARCHAR(100), 
FechaInscripcion DATE, 
CalificacionFinal DECIMAL(4, 2), 
FOREIGN KEY (CursoID) REFERENCES Cursos(CursoID) );

-- Insertar datos en la tabla de Instructores 
INSERT INTO Instructores (Nombre, Especialidad) 
VALUES ('Carlos Ruiz', 'Bases de Datos'), 
		('Ana Gomez', 'Desarrollo Web'), 
        ('Luis Peña', 'Ciencia de Datos'), 
        ('Sofia Luna', 'Bases de Datos');

-- Insertar datos en la tabla de Cursos 
INSERT INTO Cursos (Titulo, Nivel, Horas, InstructorID) 
VALUES ('SQL para Principiantes', 'Básico', 20, 1), 
		('Modelado de Datos Avanzado', 'Avanzado', 35, 1), 
        ('JavaScript Moderno', 'Intermedio', 40, 2), 
        ('Python para Ciencia de Datos', 'Básico', 50, 3), 
        ('Machine Learning Aplicado', 'Avanzado', 60, 3), 
        ('Introducción a MySQL', 'Básico', 25, 4);
        
-- Insertar datos en la tabla de Inscripciones 
INSERT INTO Inscripciones (CursoID, NombreEstudiante, FechaInscripcion, CalificacionFinal) 
VALUES (1, 'Elena Torres', '2023-01-10', 8.50), 
		(1, 'Juan Vargas', '2023-01-12', 9.10), 
        (2, 'Maria Solis', '2023-02-15', 9.50), 
        (3, 'Pedro Campos', '2023-03-01', 8.80), 
        (3, 'Laura Mendez', '2023-03-05', 7.90), 
        (4, 'Elena Torres', '2023-04-20', 9.80), 
        (5, 'Juan Vargas', '2023-05-10', 9.20), 
        (6, 'Ricardo Perez', '2023-06-01', 8.00);        

/*Parte 2: Consultas y Manipulación de Datos
Instrucción: Escribe y ejecuta una consulta SQL para resolver cada uno de los siguientes enunciados.

Consultas Básicas y Filtrado*/
-- 1. Muestra todos los cursos de nivel 'Básico'.

select * from cursos
where Nivel = 'Básico';

-- 2. Encuentra todos los instructores cuya especialidad sea 'Bases de Datos'.

select * from instructores
where especialidad = 'Bases de Datos';

-- 3. Lista los cursos que tengan más de 40 horas de duración.

select * from cursos
where Horas > 40;

-- 4. Muestra las inscripciones realizadas después del '2023-03-01'.

select * from inscripciones
where FechaInscripcion > '2023-03-01';

/*Funciones de Agregación y Agrupamiento
5. Calcula el número total de cursos ofrecidos.*/

select count(*) AS cursos_ofrecidos
from cursos;

-- 6. Encuentra la calificación final promedio de todos los estudiantes inscritos.

select avg(CalificacionFinal) AS promedio_calificacion_final 
from inscripciones;

-- 7. Muestra cuántos cursos imparte cada instructor. El resultado debe mostrar el nombre del instructor y la cantidad de cursos.

select i.instructorID, i.Nombre, count(*) AS cantidad_cursos
from cursos c
inner join instructores i
on c.instructorID = i.instructorID
group by i.Nombre, i.instructorID;

select * from cursos;
select * from instructores;


-- 8. Calcula la calificación promedio por curso. El resultado debe mostrar el título del curso y su calificación promedio.

select c.titulo, avg(i.CalificacionFinal) AS calificacion_promedio
from cursos c
inner join inscripciones i
on c.CursoID = i.CursoID
group by  c.CursoID, c.titulo;

-- 9. Encuentra los cursos que tienen más de 1 estudiante inscrito, mostrando el título del curso y el número de inscritos.

select c.CursoID, c.titulo, count(*) AS numero_de_inscritos
from cursos c
inner join inscripciones i
on c.CursoID = i.CursoID
group by c.CursoID, c.titulo
having count(*) > 1;

select * from inscripciones;
select * from cursos;

/*Uniones (Joins)
10. Lista todos los cursos junto con el nombre del instructor que los imparte.*/

select i.nombre AS nombre_instructor, c.titulo
from cursos c
inner join instructores i
on c.InstructorID = i.InstructorID;


-- 11. Muestra el nombre de los estudiantes y el título del curso al que están inscritos.

select i.NombreEstudiante, c.titulo
from cursos c
inner join inscripciones i
on c.CursoID = i.CursoID;

-- 12. Encuentra todos los instructores y los cursos que imparten. 
-- Incluye a los instructores que no imparten ningún curso (si los hubiera).

select i.nombre AS nombre_instructor, c.titulo AS curso
from instructores i
left join cursos c
on i.InstructorID = c.InstructorID;


/*Manipulación de Datos
13. Insertar: Agrega un nuevo instructor llamado 'Laura Paez' con especialidad en 'Ciberseguridad'.*/

insert into instructores (nombre, especialidad)
values ('Laura Paez', 'Ciberseguridad');

select * from instructores;


/*14. Insertar: Inscribe a un nuevo estudiante, 'Ana Juarez', en el curso 'Introducción a MySQL' 
con fecha de hoy y una calificación final nula.*/

INSERT INTO Inscripciones (CursoID, NombreEstudiante, FechaInscripcion, CalificacionFinal) 
VALUES (6, 'Ana Juarez', current_date(), null);

select * from inscripciones;
select * from cursos;					

/*15. Actualizar: Carlos Ruiz ha cambiado su especialidad a 
'Bases de Datos y Cloud'. Actualiza su registro.*/

update instructores 
set especialidad = 'Bases de Datos y Cloud'
where InstructorID = 1;

select * from inscripciones;


/*16. Eliminar: El estudiante 'Ricardo Perez' ha decidido darse de baja del curso 
'Introducción a MySQL'. Elimina su inscripción.*/

SET SQL_SAFE_UPDATES = 0;

delete from inscripciones
where NombreEstudiante = 'Ricardo Perez' ;

/*Parte 3: Subconsultas y Vistas
Instrucción: Utiliza subconsultas y vistas para resolver los siguientes problemas.
Subconsultas
17. Encuentra los cursos impartidos por instructores especializados en 'Bases de Datos'.*/

select i.InstructorID, c. titulo AS titulo_curso, i.Nombre, i.Especialidad
from cursos c				-- SOLUCION CON JOIN
inner join instructores i
on c.InstructorID = i.InstructorID
where i.Especialidad = 'Bases de Datos';

select i.InstructorID, c. titulo AS titulo_curso, i.Nombre, i.Especialidad
from cursos c				-- SOLUCION CON SUBCONSULTA
inner join instructores i
on c.InstructorID = i.InstructorID
where i.InstructorID in (select InstructorID
					  from instructores 
					  where Especialidad = 'Bases de Datos');

select * from inscripciones;

-- 18. Muestra los nombres de los estudiantes que han obtenido una calificación final superior al promedio de todas las calificaciones.

select NombreEstudiante, CalificacionFinal
from inscripciones
where CalificacionFinal > (SELECT AVG(CalificacionFinal) FROM inscripciones);

-- 19. Lista los cursos en los que 'Elena Torres' está inscrita.

SELECT i.CursoID,							-- SOLUCION CON JOIN
       c.titulo,
       i.NombreEstudiante
FROM inscripciones i
INNER JOIN cursos c
ON i.CursoID = c.CursoID
WHERE i.NombreEstudiante = 'Elena Torres';

select CursoID, titulo			-- SOLUCION CON SUBCONSULTA
from cursos
where CursoID in (select cursoID
				 from inscripciones 
				 where NombreEstudiante = 'Elena Torres');
                 
/*ESTA ES OTRA SOLUCION USANDO JOIN PARA MOSTRAR EL NOMBRE DEL ESTUDIANTE, YA QUE SE ENCUENTRA EN LA TABLA INSCRIPCIONES. Y  
DONDE AL FINAL PONGO UN AND PARA QUE NO ME SALGAN MAS ESTUDIANTES*/

SELECT
    i.NombreEstudiante,
    c.titulo
FROM inscripciones i
INNER JOIN cursos c
    ON i.CursoID = c.CursoID
WHERE i.CursoID IN (
    SELECT CursoID
    FROM inscripciones
    WHERE NombreEstudiante = 'Elena Torres'
)
AND i.NombreEstudiante = 'Elena Torres';


-- 20. (Reto) Encuentra al instructor que imparte el curso con la mayor cantidad de horas.

select c.CursoID, c.titulo, i.Nombre, c.Horas  -- la respuesta debe ser: '5', 'Machine Learning Aplicado', 'Luis Peña', '60'
from instructores i
inner join cursos c
on i.InstructorID = c.InstructorID
where Horas = (SELECT max(Horas) FROM cursos);


/*Vistas (Views)
21. Crear Vista: Crea una vista llamada Vista_Cursos_Instructores que muestre el CursoID, Titulo del curso, Nivel y el Nombre del instructor.*/

CREATE VIEW Vista_Cursos_Instructores AS
SELECT
	c.CursoID,
	c.Titulo,
	c.Nivel,
    i.Nombre
FROM instructores i
inner join cursos c
	on i.InstructorID = c.InstructorID;

select * from Vista_Cursos_Instructores;

-- 22. Consultar Vista: Realiza una consulta a la vista Vista_Cursos_Instructores para encontrar todos los cursos de nivel 'Avanzado'.

select * 
from Vista_Cursos_Instructores
where Nivel = 'Avanzado';

/*23. Crear Vista: Crea una vista llamada Vista_Rendimiento_Estudiantes que muestre el NombreEstudiante, 
el Titulo del curso y la CalificacionFinal.*/

CREATE VIEW Vista_Rendimiento_Estudiantes AS
SELECT
	i.NombreEstudiante,
	c.Titulo,
	i.CalificacionFinal
FROM inscripciones i
inner join cursos c
	on i.CursoID = c.CursoID;

select * from Vista_Rendimiento_Estudiantes;


-- 24. Consultar Vista: Usando la vista Vista_Rendimiento_Estudiantes, encuentra a los estudiantes con calificaciones superiores a 9.0.

select * 
from Vista_Rendimiento_Estudiantes
where CalificacionFinal > 9.0;

-- 25. Eliminar Vista: Borra la vista Vista_Cursos_Instructores.

drop VIEW Vista_Cursos_Instructores;

 