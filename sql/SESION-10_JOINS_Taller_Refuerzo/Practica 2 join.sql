use sakila;

-- DDL:
CREATE TABLE customer_demo (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date DATE
);
 
CREATE TABLE payment_demo (
    payment_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL
);
 
-- DML:
INSERT INTO customer_demo (customer_id, first_name, last_name, registration_date) VALUES
(1, 'Elena', 'Rios', '2026-01-15'),     -- Multiple payments
(2, 'Mario', 'Velez', '2026-02-10'),    -- ZERO payments (LEFT JOIN target)
(3, 'Sofia', 'Castro', '2026-03-22'),   -- Multiple payments
(4, 'Diego', 'Ortiz', '2026-04-05'),    -- Single payment
(5, 'Ana', 'Gomez', '2026-04-18'),      -- Multiple payments
(6, 'Lucas', 'Molina', '2026-05-01'),   -- ZERO payments (LEFT JOIN target)
(7, 'Maria', 'Paz', '2026-05-20'),      -- Single payment
(8, 'Jorge', 'Ruiz', '2026-06-11'),     -- ZERO payments (LEFT JOIN target)
(9, 'Camila', 'Soto', '2026-07-02'),    -- Multiple payments
(10, 'David', 'Lopera', '2026-07-15');  -- ZERO payments (LEFT JOIN target)
 
INSERT INTO payment_demo (payment_id, customer_id, amount, payment_date) VALUES
-- Valid transactions (INNER JOIN matches)
(1001, 1, 55.00, '2026-01-20'),
(1002, 1, 120.00, '2026-02-15'),
(1003, 1, 35.50, '2026-03-10'),
(1004, 3, 200.00, '2026-03-25'),
(1005, 3, 150.00, '2026-04-02'),
(1006, 4, 85.50, '2026-04-10'),
(1007, 5, 45.00, '2026-04-20'),
(1008, 5, 60.00, '2026-05-05'),
(1009, 7, 110.00, '2026-05-25'),
(1010, 9, 90.00, '2026-07-05'),
(1011, 9, 12.50, '2026-07-10'),
 
-- Orphaned transactions (RIGHT JOIN targets)
(1012, 99, 40.00, '2026-07-22'),        -- Non-existent customer_id
(1013, 150, 75.00, '2026-07-23'),       -- Non-existent customer_id
(1014, NULL, 15.00, '2026-07-25'),      -- NULL customer_id (System error simulation)
(1015, NULL, 30.00, '2026-07-26');      -- NULL customer_id (System error simulation)

select * from customer_demo;
select * from payment_demo;

/*¿Cuál es el listado de todos los ingresos (pagos) recibidos, 
cruzados con la información del cliente si existe, para auditar pagos de origen desconocido?*/

SELECT * 
FROM payment_demo p  -- Tabla izquierda
LEFT JOIN customer_demo c 
ON p.customer_id = c.customer_id;

SELECT * 
FROM payment_demo p  -- Tabla izquierda
RIGHT JOIN customer_demo c 
ON p.customer_id = c.customer_id;

-- CUANTO HA PAGADO CADA CLIENTE 
-- Y CUANTAS TRANSACCIONES HA REALIZADO
 
SELECT c.customer_id, sum(p.amount), count(p.payment_id) 
FROM customer_demo c   -- Tabla izquierda
INNER JOIN payment_demo p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;




