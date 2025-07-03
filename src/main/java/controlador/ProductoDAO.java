package controlador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import modelo.Producto;

public class ProductoDAO {

	private Connection conexion;

    public ProductoDAO() {
		super();
		
		
		try {
		           Class.forName("com.mysql.jdbc.Driver");
		       } catch (ClassNotFoundException e1) {
		           // TODO Auto-generated catch block
		           e1.printStackTrace();
		       }
		
		try {
			this.conexion=DriverManager.getConnection("jdbc:mysql://localhost:3306/proyecto_tienda","root","");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public Connection getConexion() {
		return conexion;
	}

	public void setConexion(Connection conexion) {
		this.conexion = conexion;
	}

	// 1. Método listarTodos() - Mantener como está, funciona bien
    public ArrayList<Producto> listarTodos() {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM productos ORDER BY idProducto";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));           
                producto.setDescripcion(rs.getString("descripcion")); 
                producto.setPrecio(rs.getDouble("precio"));          
                producto.setStock(rs.getInt("stock"));               
                producto.setCategoria(rs.getString("categoria"));
                productos.add(producto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // 2. Método obtenerPorId() - Mantener como está, funciona bien
    public Producto obtenerPorId(int id) {
        String sql = "SELECT * FROM productos WHERE idProducto = ?";
        Producto producto = null;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));           
                producto.setDescripcion(rs.getString("descripcion")); 
                producto.setPrecio(rs.getDouble("precio"));          
                producto.setStock(rs.getInt("stock"));              
                producto.setCategoria(rs.getString("categoria"));
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return producto;
    }

    // 3. Método guardar() - Mantener como está
    public boolean guardar(Producto producto) {
        String sql = "INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, producto.getNombre());
            stmt.setString(2, producto.getDescripcion());
            stmt.setDouble(3, producto.getPrecio());
            stmt.setInt(4, producto.getStock());
            stmt.setString(5, producto.getCategoria());

            int filasInsertadas = stmt.executeUpdate();
            return filasInsertadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. Método actualizar() - Mantener como está  
    public boolean actualizar(Producto producto) {
        String sql = "UPDATE productos SET nombre=?, descripcion=?, precio=?, stock=?, categoria=? WHERE idProducto=?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, producto.getNombre());
            stmt.setString(2, producto.getDescripcion());
            stmt.setDouble(3, producto.getPrecio());
            stmt.setInt(4, producto.getStock());
            stmt.setString(5, producto.getCategoria());
            stmt.setInt(6, producto.getIdProducto());

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. Método eliminar() - Mantener como está
    public boolean eliminar(int id) {
        String sql = "DELETE FROM productos WHERE idProducto = ?";
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. Método obtenerMasVendidos() - Mantener como está
    public ArrayList<Producto> obtenerMasVendidos(int cantidad) {
        ArrayList<Producto> productos = new ArrayList<>();

        String sql = 
            "SELECT p.*, SUM(lv.unidades) AS total_vendidos " +
            "FROM productos p " +
            "JOIN lventas lv ON p.idProducto = lv.idProducto " +
            "GROUP BY p.idProducto " +
            "ORDER BY total_vendidos DESC " +
            "LIMIT ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, cantidad);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));          
                producto.setDescripcion(rs.getString("descripcion")); 
                producto.setPrecio(rs.getDouble("precio"));          
                producto.setStock(rs.getInt("stock"));               
                producto.setCategoria(rs.getString("categoria"));
                productos.add(producto);
            }

            rs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener productos más vendidos: " + e.getMessage());
            e.printStackTrace();
        }

        return productos;
    }

    // 7. Método obtenerPorCategoria() - Mantener como está
    public ArrayList<Producto> obtenerPorCategoria(String categoria) {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE categoria = ? OR categoria LIKE ?";
        
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, categoria);
            stmt.setString(2, "%" + categoria + "%");
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));     
                producto.setNombre(rs.getString("nombre"));           
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setPrecio(rs.getDouble("precio"));          
                producto.setCategoria(rs.getString("categoria"));     
                producto.setStock(rs.getInt("stock"));               
                
                productos.add(producto);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return productos;
    }

    // ========================================
    // MÉTODOS ADICIONALES PARA ANÁLISIS DE VENTAS
    // ========================================

    // 8. Obtener productos con estadísticas de ventas
    public ArrayList<Producto> obtenerProductosConEstadisticas() {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = 
            "SELECT p.*, " +
            "COALESCE(SUM(lv.unidades), 0) as total_vendidos, " +
            "COALESCE(COUNT(DISTINCT lv.idVenta), 0) as num_transacciones, " +
            "COALESCE(SUM(lv.unidades * lv.precioUnidad), 0) as ingresos_generados " +
            "FROM productos p " +
            "LEFT JOIN lventas lv ON p.idProducto = lv.idProducto " +
            "GROUP BY p.idProducto " +
            "ORDER BY total_vendidos DESC";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setCategoria(rs.getString("categoria"));
                
                // Estadísticas adicionales (necesitarás agregar estos campos a tu modelo Producto)
                producto.setTotalVendidos(rs.getInt("total_vendidos"));
                producto.setNumTransacciones(rs.getInt("num_transacciones"));
                producto.setIngresosGenerados(rs.getDouble("ingresos_generados"));
                
                productos.add(producto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // 9. Obtener productos sin ventas
    public ArrayList<Producto> obtenerProductosSinVentas() {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = 
            "SELECT p.* FROM productos p " +
            "LEFT JOIN lventas lv ON p.idProducto = lv.idProducto " +
            "WHERE lv.idProducto IS NULL " +
            "ORDER BY p.nombre";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setCategoria(rs.getString("categoria"));
                productos.add(producto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // 10. Obtener productos con bajo stock
    public ArrayList<Producto> obtenerProductosBajoStock(int limite) {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE stock <= ? ORDER BY stock ASC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setCategoria(rs.getString("categoria"));
                productos.add(producto);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // 11. Buscar productos por nombre
    public ArrayList<Producto> buscarPorNombre(String termino) {
        ArrayList<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE nombre LIKE ? ORDER BY nombre";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, "%" + termino + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setCategoria(rs.getString("categoria"));
                productos.add(producto);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // 12. Actualizar stock después de una venta
    public boolean actualizarStock(int idProducto, int cantidadVendida) {
        String sql = "UPDATE productos SET stock = stock - ? WHERE idProducto = ? AND stock >= ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, cantidadVendida);
            stmt.setInt(2, idProducto);
            stmt.setInt(3, cantidadVendida); // Verificar que hay suficiente stock

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 13. Verificar disponibilidad de stock
    public boolean verificarStock(int idProducto, int cantidadRequerida) {
        String sql = "SELECT stock FROM productos WHERE idProducto = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int stockActual = rs.getInt("stock");
                rs.close();
                return stockActual >= cantidadRequerida;
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // 14. Obtener todas las categorías disponibles
    public ArrayList<String> obtenerCategorias() {
        ArrayList<String> categorias = new ArrayList<>();
        String sql = "SELECT DISTINCT categoria FROM productos WHERE categoria IS NOT NULL ORDER BY categoria";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                String categoria = rs.getString("categoria");
                if (categoria != null && !categoria.trim().isEmpty()) {
                    categorias.add(categoria);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categorias;
    }

    // 15. Contar total de productos
    public int contarTotalProductos() {
        String sql = "SELECT COUNT(*) as total FROM productos";
        int total = 0;

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // 16. Obtener valor total del inventario
    public double obtenerValorInventario() {
        String sql = "SELECT SUM(precio * stock) as valor_total FROM productos";
        double valorTotal = 0.0;

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                valorTotal = rs.getDouble("valor_total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return valorTotal;
    }

    // Cerrar conexión
    public void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}