CREATE SCHEMA IF NOT EXISTS ventascific17 ;
USE ventascific17;

CREATE TABLE IF NOT EXISTS Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary Key for Usuarios table
    mail VARCHAR(255) NOT NULL UNIQUE,  -- Mail must be unique
    password VARCHAR(255) NOT NULL,     -- Password field (store hashed passwords)
    nombre VARCHAR(100),
    direccion VARCHAR(255),
    numTarjeta VARCHAR(50),  -- Assuming this field stores credit card numbers
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Track when the user is created
);

INSERT INTO Usuarios (mail, password, nombre, direccion, numTarjeta)
VALUES (
    'juana@mail.com', 
    '94289908a16a748e4ff0d375ddd8789de354f8e597e58a2c5852c7434e58374b', 
    'Juana', 
    'SiempreViva 321', 
    '1234123412341234'
);

CREATE TABLE IF NOT EXISTS Productos (
    codigoProducto INT PRIMARY KEY,   -- Primary key for Productos
    nombre VARCHAR(100) NOT NULL,
    categoria ENUM('TECNOLOGIA', 'INDUMENTARIA', 'CALZADO', 'DEPORTE', 'HOGAR', 'MUEBLES', 'ELECTRODOMESTICOS') NOT NULL,  -- Add actual categories
    subcategoria ENUM('CELULARES', 'TABLETS', 'INFORMATICA') NOT NULL,     -- Add actual subcategories
    precio DECIMAL(10, 2) NOT NULL,  -- Price with two decimal precision
    descuento DECIMAL(10, 2),        -- Discount with two decimal precision
    precioFinal DECIMAL(10, 2),      -- Final price after discount
    stock INT NOT NULL,              -- Stock level
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Automatically track creation time
);

-- Basic products
INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (1234, 'Zapatillas', 'CALZADO', 50.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (5678, 'Televisor', 'ELECTRODOMESTICOS', 800.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (9012, 'Mesa', 'HOGAR', 120.00, 100);

-- Technological products with subcategories
INSERT INTO Productos (codigoProducto, nombre, categoria, subcategoria, precio, stock) 
VALUES (1470, 'Computadora', 'TECNOLOGIA', 'INFORMATICA', 1200.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, subcategoria, precio, stock) 
VALUES (5885, 'Mouse', 'TECNOLOGIA', 'INFORMATICA', 35.30, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, subcategoria, precio, stock) 
VALUES (9632, 'Teclado', 'TECNOLOGIA', 'INFORMATICA', 21.10, 100);

-- Extra products
INSERT INTO Productos (codigoProducto, nombre, categoria, subcategoria, precio, stock) 
VALUES (1111, 'Smartphone', 'TECNOLOGIA', 'CELULARES', 600.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (2222, 'Remera', 'INDUMENTARIA', 30.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (3333, 'Pantalones', 'INDUMENTARIA', 45.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (4444, 'Raqueta', 'DEPORTE', 150.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (5555, 'Bicicleta', 'DEPORTE', 800.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (6666, 'Silla', 'MUEBLES', 450.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (7777, 'Estante', 'HOGAR', 20.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (8888, 'Aspiradora', 'ELECTRODOMESTICOS', 180.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, subcategoria, precio, stock) 
VALUES (9999, 'Tablet', 'TECNOLOGIA', 'TABLETS', 250.00, 100);

INSERT INTO Productos (codigoProducto, nombre, categoria, precio, stock) 
VALUES (1010, 'Campera', 'INDUMENTARIA', 120.00, 100);

CREATE TABLE IF NOT EXISTS Pedidos (
    numPedido BIGINT PRIMARY KEY AUTO_INCREMENT,  -- Auto-incrementing primary key for each order
    usuario_mail VARCHAR(255),  -- Foreign key linking to the Usuarios table
    precioFinal DECIMAL(10, 2),  -- Final price after discounts
    costoEnvio DECIMAL(10, 2),  -- Shipping cost
    descuento DECIMAL(10, 2),  -- Discount on the order
    fechaPedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Time when the order was placed
    entregado BOOLEAN DEFAULT FALSE,  -- Whether the order has been delivered or not
    fechaEntregado TIMESTAMP NULL,  -- Time when the order was delivered (can be NULL if not delivered)
    FOREIGN KEY (usuario_mail) REFERENCES Usuarios(mail)  -- Foreign key constraint linking to Usuarios
);

CREATE TABLE IF NOT EXISTS Pedidos_Productos (
    numPedido BIGINT,   -- Foreign key to Pedidos
    codigoProducto INT, -- Foreign key to Productos
    cantidad INT NOT NULL,  -- Quantity of each product in the order
    PRIMARY KEY (numPedido, codigoProducto),  -- Composite primary key
    FOREIGN KEY (numPedido) REFERENCES Pedidos(numPedido),  -- Foreign key constraint to Pedidos
    FOREIGN KEY (codigoProducto) REFERENCES Productos(codigoProducto)  -- Foreign key constraint to Productos
);

