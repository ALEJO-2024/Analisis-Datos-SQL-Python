-- Crear base de datos
CREATE DATABASE TiendaElectronica;
USE TiendaElectronica;

-- Tabla Proveedores
CREATE TABLE Proveedores (
    ProveedorID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Pais VARCHAR(50),
    Telefono VARCHAR(20)
);

-- Tabla Productos
CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Categoria VARCHAR(50),
    Precio DECIMAL(10,2),
    ProveedorID INT,
    FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID)
);

-- Tabla Ventas
CREATE TABLE Ventas (
    VentaID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT,
    FechaVenta DATE,
    Cantidad INT,
    Cliente VARCHAR(100),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

-- Inserción de datos en Proveedores
INSERT INTO Proveedores (Nombre, Pais, Telefono)
VALUES
('Samsung', 'Corea del Sur', '+82-2-1234-5678'),
('Apple', 'Estados Unidos', '+1-800-123-4567'),
('Sony', 'Japón', '+81-3-1234-5678');

-- Inserción datos Productos
INSERT INTO Productos (ProductoID, Nombre, Categoria, Precio, ProveedorID)
VALUES
(1, 'Televisor Samsung 50"', 'Televisores', 500.00, 1),
(2, 'iPhone 13', 'Smartphones', 999.00, 2),
(3, 'PlayStation 5', 'Consolas', 499.00, 3);

-- Inserción datos Ventas
INSERT INTO Ventas (VentaID, ProductoID, FechaVenta, Cantidad, Cliente)
VALUES
(1, 1, '2024-07-01', 2, 'Juan Pérez'),
(2, 2, '2024-07-03', 1, 'Ana Gómez'),
(3, 3, '2024-07-05', 3, 'Luis Martínez');

show tables;

-- -------
-- TALLER Y solucion
-- -------

-- PARTE 3

-- 1. Listar todos los productos
select * from productos;

-- 2. Encontrar todas las ventas realizadas en julio de 2024
select * from ventas;

select * from ventas
where FechaVenta >= '2024-07-01'
and FechaVenta <= '2024-07-31';

-- 3. Actualizar el precio del producto "iPhone 13" a 899.00
UPDATE Productos
SET precio = 899.00
WHERE nombre = 'iPhone 13';

-- 4. Eliminar el producto "PlayStation 5"
DELETE FROM Productos
WHERE nombre = 'PlayStation 5';

-- PARTE 4
-- 1. Añadir columna Stock a la tabla Productos
ALTER TABLE Productos
ADD Stock INT;

-- 2. Cambiar nombre de la tabla Proveedores a Fabricantes
ALTER TABLE Proveedores
RENAME TO Fabricantes;

-- Parte 5
-- 1. Añadir nuevo proveedor "LG"
INSERT INTO Fabricantes (nombre, pais, telefono)
VALUES ('LG', 'Corea del Sur', '+82-2-8765-4321');

-- 2. Añadir producto "LG OLED TV 55"
INSERT INTO Productos (nombre, categoria, precio, id_fabricante)
VALUES (
    'LG OLED TV 55',
    'Televisores',
    1200.00,
    (SELECT id FROM Fabricantes WHERE nombre = 'LG')
);

-- 3. Registrar venta
INSERT INTO Ventas (producto_id, cliente, fecha, cantidad)
VALUES (
    (SELECT id FROM Productos WHERE nombre = 'LG OLED TV 55'),
    'Carlos Rodríguez',
    '2024-07-20',
    1
);

-- 4. Actualizar país del proveedor "Sony"
UPDATE Fabricantes
SET pais = 'Estados Unidos'
WHERE nombre = 'Sony';

-- 5. Eliminar ventas de "Ana Gómez"
DELETE FROM Ventas
WHERE cliente = 'Ana Gómez';
