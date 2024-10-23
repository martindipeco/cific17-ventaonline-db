# Java MySQL Integration Guide

## 1. Create the MySQL Database

It's best to first create your database schema (tables, relationships, etc.) before writing the code. This allows you to structure your domain classes around the actual database.

### Steps:
- Install MySQL if you don’t have it installed.
- Create the database and tables in MySQL. For example, using the MySQL command-line interface or MySQL Workbench, run:

```sql
CREATE DATABASE my_app_db;
USE my_app_db;

CREATE TABLE Producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    stock INT
);

CREATE TABLE Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    total DECIMAL(10,2)
);

-- Create more tables as per your domain model```

## 2. Download the MySQL Connector for Java

You need the MySQL JDBC driver to connect your Java application to the MySQL database.

### Steps:

- Download the MySQL Connector/J from the official MySQL site.
- Unzip the file and add the mysql-connector-java-x.x.x.jar to your project’s classpath.
- Steps to add .jar to the classpath:
- In IntelliJ IDEA (since you’re using it):
- Go to File > Project Structure.
- Select Modules > Dependencies.
- Click the + icon, select JARs or directories, and add the mysql-connector-java.jar file.

## 3. Configure MySQL Connection in Your Java Code
You will manually manage the connection using DriverManager. Here's an example of how to set up a connection:

Create a DatabaseUtil class to manage connections:

```import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    private static final String URL = "jdbc:mysql://localhost:3306/my_app_db";
    private static final String USER = "root";  // Change it to your MySQL username
    private static final String PASSWORD = "yourpassword";  // Change it to your MySQL password

    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}```

## 4. Create DAO Classes for Each Domain Entity
For each domain class (e.g., Producto, Pedido), you’ll create a Data Access Object (DAO) to handle database interactions.

Example: ProductoDAO

```import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> getAllProductos() {
        List<Producto> productos = new ArrayList<>();
        String query = "SELECT * FROM Producto";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Producto producto = new Producto(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getBigDecimal("precio"),
                    rs.getInt("stock")
                );
                productos.add(producto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    public void saveProducto(Producto producto) {
        String query = "INSERT INTO Producto (nombre, precio, stock) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, producto.getNombre());
            pstmt.setBigDecimal(2, producto.getPrecio());
            pstmt.setInt(3, producto.getStock());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Add other CRUD methods like update, delete, etc.
}
```

## 5. Modify Your Service Layer
If you already have services (e.g., ProductoServicio) that were interacting with a mock repository, you’ll need to modify them to interact with the DAO instead.

Example: ProductoServicio

```public class ProductoServicio {

    private final ProductoDAO productoDAO = new ProductoDAO();

    public List<Producto> listarProductos() {
        return productoDAO.getAllProductos();
    }

    public void agregarProducto(Producto producto) {
        productoDAO.saveProducto(producto);
    }

    // Add more service methods as needed
}```

## 6. Test the Integration
Write a simple test to verify the database connection and CRUD operations.

Example Test:

```public class App {

    public static void main(String[] args) {
        ProductoServicio productoServicio = new ProductoServicio();

        // Create a new product
        Producto nuevoProducto = new Producto(0, "Laptop", new BigDecimal("1200.00"), 10);
        productoServicio.agregarProducto(nuevoProducto);

        // List all products
        productoServicio.listarProductos().forEach(producto -> 
            System.out.println(producto.getNombre() + " - " + producto.getPrecio())
        );
    }
}```

## 7. Handle Exceptions and Transactions
You may want to wrap critical operations in transactions, particularly when you perform multiple database operations that need to succeed or fail together. Here's an example:

```public void performTransactionExample() {
    Connection conn = null;

    try {
        conn = DatabaseUtil.getConnection();
        conn.setAutoCommit(false);  // Begin transaction

        // Perform operations

        conn.commit();  // Commit transaction if all succeeded
    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();  // Roll back if any failure occurs
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);  // Reset autocommit
                conn.close();
            } catch (SQLException closeEx) {
                closeEx.printStackTrace();
            }
        }
    }
}```

## 8. Next Steps: Improve Efficiency
Connection Pooling: Instead of creating a new connection for every request, consider adding a connection pool (like HikariCP) to improve performance.
Refactor: Once you’re comfortable, you may consider automating dependencies or ORM (like Hibernate) for complex models and queries.
