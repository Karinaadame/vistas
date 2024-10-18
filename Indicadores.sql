CREATE DATABASE TareaIndicadores;

USE TareaIndicadores;

CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(255) NOT NULL,
    categoria VARCHAR(255) NOT NULL
);

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);

CREATE TABLE Empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empleado VARCHAR(255) NOT NULL
);

CREATE TABLE Transportistas (
    id_transportista INT AUTO_INCREMENT PRIMARY KEY,
    nombre_transportista VARCHAR(255) NOT NULL
);

CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_transportista INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_transportista) REFERENCES Transportistas(id_transportista)
);

CREATE TABLE Detalles_Pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

/*Ventas Totales por Período (Año y Mes)*/
CREATE VIEW Ventas_Totales_Por_Periodo AS
SELECT 
    YEAR(fecha_pedido) AS año, 
    MONTH(fecha_pedido) AS mes, 
    SUM(cantidad * precio) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido dp ON p.id_pedido = dp.id_pedido
GROUP BY 
    YEAR(fecha_pedido), MONTH(fecha_pedido);
    
/*Ventas por Categoría de Producto*/
CREATE VIEW Ventas_Por_Categoria_Producto AS
SELECT 
    p.categoria, 
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM 
    Detalles_Pedido dp
JOIN 
    Productos p ON dp.id_producto = p.id_producto
GROUP BY 
    p.categoria;

/*Total de Ventas por Categoría*/
CREATE VIEW Total_Ventas_Por_Categoria AS
SELECT 
    p.categoria, 
    COUNT(dp.id_detalle) AS total_ventas
FROM 
    Detalles_Pedido dp
JOIN 
    Productos p ON dp.id_producto = p.id_producto
GROUP BY 
    p.categoria;
    
/*Ventas por Región/País*/
CREATE VIEW Ventas_Por_Region_Pais AS
SELECT 
    c.region, 
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
GROUP BY 
    c.region;

/*Número de Pedidos Procesados por Empleado*/
CREATE VIEW Numero_Pedidos_Procesados_Por_Empleado AS
SELECT 
    e.nombre_empleado, 
    COUNT(p.id_pedido) AS total_pedidos
FROM 
    Pedidos p
JOIN 
    Empleados e ON p.id_empleado = e.id_empleado
GROUP BY 
    e.nombre_empleado;

/*Productividad de Empleados (Ventas por Empleado)*/
CREATE VIEW Productividad_Empleados AS
SELECT 
    e.nombre_empleado, 
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    Empleados e ON p.id_empleado = e.id_empleado
GROUP BY 
    e.nombre_empleado;

/*Clientes Atendidos por Empleado*/
CREATE VIEW Clientes_Atendidos_Por_Empleado AS
SELECT 
    e.nombre_empleado, 
    COUNT(DISTINCT p.id_cliente) AS total_clientes
FROM 
    Pedidos p
JOIN 
    Empleados e ON p.id_empleado = e.id_empleado
GROUP BY 
    e.nombre_empleado;
    
/*Productos Más Vendidos*/
CREATE VIEW Productos_Mas_Vendidos AS
SELECT 
    p.nombre_producto, 
    SUM(dp.cantidad) AS total_vendidos
FROM 
    Detalles_Pedido dp
JOIN 
    Productos p ON dp.id_producto = p.id_producto
GROUP BY 
    p.nombre_producto
ORDER BY 
    total_vendidos DESC
LIMIT 10;

/*Productos Más Vendidos por Categoría*/
CREATE VIEW Productos_Mas_Vendidos_Por_Categoria AS
SELECT 
    p.categoria, 
    p.nombre_producto, 
    SUM(dp.cantidad) AS total_vendidos
FROM 
    Detalles_Pedido dp
JOIN 
    Productos p ON dp.id_producto = p.id_producto
GROUP BY 
    p.categoria, p.nombre_producto
ORDER BY 
    p.categoria, total_vendidos DESC;

/*Total de Ventas por Transportista*/
CREATE VIEW Total_Ventas_Por_Transportista AS
SELECT 
    t.nombre_transportista, 
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    Transportistas t ON p.id_transportista = t.id_transportista
GROUP BY 
    t.nombre_transportista;

/*Número de Órdenes Enviadas por Transportista*/
CREATE VIEW Numero_Ordenes_Enviadas_Por_Transportista AS
SELECT 
    t.nombre_transportista, 
    COUNT(p.id_pedido) AS total_ordenes
FROM 
    Pedidos p
JOIN 
    Transportistas t ON p.id_transportista = t.id_transportista
GROUP BY 
    t.nombre_transportista;


/*Total de Ventas por Cliente*/
CREATE VIEW Total_Ventas_Por_Cliente AS
SELECT 
    c.nombre_cliente, 
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
GROUP BY 
    c.nombre_cliente;

/*Número de Órdenes por Cliente*/
CREATE VIEW Numero_Ordenes_Por_Cliente AS
SELECT 
    c.nombre_cliente, 
    COUNT(p.id_pedido) AS total_ordenes
FROM 
    Pedidos p
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
GROUP BY 
    c.nombre_cliente;



