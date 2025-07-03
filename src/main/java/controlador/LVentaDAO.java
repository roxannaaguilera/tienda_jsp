package controlador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import modelo.LVenta;

public class LVentaDAO {
    private Connection conexion;

    public LVentaDAO() {
        super();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
        }
        
        try {
            this.conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/proyecto_tienda", "root", "");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Connection getConexion() {
        return conexion;
    }

    public void setConexion(Connection conexion) {
        this.conexion = conexion;
    }

    // Listar todas las líneas de venta
    public ArrayList<LVenta> listarTodas() {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT * FROM lventas";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));

                lineas.add(linea);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Guardar línea de venta
    public void guardar(LVenta linea) {
        String sql = "INSERT INTO lventas (idVenta, idProducto, unidades, precioUnidad) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, linea.getIdVenta());
            stmt.setInt(2, linea.getIdProducto());
            stmt.setInt(3, linea.getUnidades());
            stmt.setDouble(4, linea.getPrecioUnidad());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Guardar múltiples líneas de venta en una transacción
    public void guardarLineas(ArrayList<LVenta> lineas) {
        String sql = "INSERT INTO lventas (idVenta, idProducto, unidades, precioUnidad) VALUES (?, ?, ?, ?)";
        
        try {
            conexion.setAutoCommit(false); // Iniciar transacción
            
            try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
                for (LVenta linea : lineas) {
                    stmt.setInt(1, linea.getIdVenta());
                    stmt.setInt(2, linea.getIdProducto());
                    stmt.setInt(3, linea.getUnidades());
                    stmt.setDouble(4, linea.getPrecioUnidad());
                    stmt.addBatch();
                }
                
                stmt.executeBatch();
                conexion.commit(); // Confirmar transacción
            } catch (SQLException e) {
                conexion.rollback(); // Revertir en caso de error
                throw e;
            } finally {
                conexion.setAutoCommit(true); // Restaurar autocommit
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Actualizar línea de venta
    public void actualizar(LVenta linea) {
        String sql = "UPDATE lventas SET idVenta = ?, idProducto = ?, unidades = ?, precioUnidad = ? WHERE idLventa = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, linea.getIdVenta());
            stmt.setInt(2, linea.getIdProducto());
            stmt.setInt(3, linea.getUnidades());
            stmt.setDouble(4, linea.getPrecioUnidad());
            stmt.setInt(5, linea.getIdLventa());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Eliminar líneas por ID de venta
    public void eliminarPorIdVenta(int idVenta) {
        String sql = "DELETE FROM lventas WHERE idVenta = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idVenta);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Eliminar línea específica por ID de línea
    public void eliminarPorIdLinea(int idLinea) {
        String sql = "DELETE FROM lventas WHERE idLventa = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idLinea);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Obtener líneas de venta por producto (CORREGIDO)
    public ArrayList<LVenta> obtenerLineasPorProducto(int idProducto) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT * FROM lventas WHERE idProducto = ? ORDER BY idVenta DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                lineas.add(linea);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Obtener líneas de venta por ID de venta (CORREGIDO)
    public ArrayList<LVenta> obtenerLineasPorVenta(int idVenta) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT lv.*, p.nombre as nombreProducto, p.precio as precioProducto " +
                     "FROM lventas lv " +
                     "LEFT JOIN productos p ON lv.idProducto = p.idProducto " +
                     "WHERE lv.idVenta = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idVenta);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                
                // Información adicional del producto
                linea.setNombreProducto(rs.getString("nombreProducto"));
                linea.setPrecioProducto(rs.getDouble("precioProducto"));
                
                lineas.add(linea);
            }
            
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Obtener líneas de venta por producto CON información completa
    public ArrayList<LVenta> obtenerLineasProductoCompletas(int idProducto) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT lv.*, p.nombre as nombreProducto, p.precio as precioProducto, " +
                     "v.fechaHora as fechaVenta, v.idCliente, v.idEmpleado, v.precioVenta " +
                     "FROM lventas lv " +
                     "LEFT JOIN productos p ON lv.idProducto = p.idProducto " +
                     "LEFT JOIN ventas v ON lv.idVenta = v.idVenta " +
                     "WHERE lv.idProducto = ? " +
                     "ORDER BY v.fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                
                // Información del producto
                linea.setNombreProducto(rs.getString("nombreProducto"));
                linea.setPrecioProducto(rs.getDouble("precioProducto"));
                
                // Información de la venta
                Timestamp timestamp = rs.getTimestamp("fechaVenta");
                if (timestamp != null) {
                    linea.setFechaVenta(timestamp.toLocalDateTime());
                }
                linea.setIdClienteVenta(rs.getInt("idCliente"));
                linea.setIdEmpleadoVenta(rs.getInt("idEmpleado"));
                linea.setPrecioVentaCompleta(rs.getDouble("precioVenta"));
                
                lineas.add(linea);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Obtener todas las líneas de venta de un cliente específico
    public ArrayList<LVenta> obtenerLineasPorCliente(int idCliente) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT lv.*, p.nombre as nombreProducto, p.precio as precioProducto, " +
                     "v.fechaHora as fechaVenta " +
                     "FROM lventas lv " +
                     "JOIN productos p ON lv.idProducto = p.idProducto " +
                     "JOIN ventas v ON lv.idVenta = v.idVenta " +
                     "WHERE v.idCliente = ? " +
                     "ORDER BY v.fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                
                // Información adicional
                linea.setNombreProducto(rs.getString("nombreProducto"));
                linea.setPrecioProducto(rs.getDouble("precioProducto"));
                
                Timestamp timestamp = rs.getTimestamp("fechaVenta");
                if (timestamp != null) {
                    linea.setFechaVenta(timestamp.toLocalDateTime());
                }

                lineas.add(linea);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Obtener todas las líneas de venta de un empleado específico
    public ArrayList<LVenta> obtenerLineasPorEmpleado(int idEmpleado) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT lv.*, p.nombre as nombreProducto, p.precio as precioProducto, " +
                     "v.fechaHora as fechaVenta, v.idCliente " +
                     "FROM lventas lv " +
                     "JOIN productos p ON lv.idProducto = p.idProducto " +
                     "JOIN ventas v ON lv.idVenta = v.idVenta " +
                     "WHERE v.idEmpleado = ? " +
                     "ORDER BY v.fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idEmpleado);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                
                // Información adicional
                linea.setNombreProducto(rs.getString("nombreProducto"));
                linea.setPrecioProducto(rs.getDouble("precioProducto"));
                linea.setIdClienteVenta(rs.getInt("idCliente"));
                
                Timestamp timestamp = rs.getTimestamp("fechaVenta");
                if (timestamp != null) {
                    linea.setFechaVenta(timestamp.toLocalDateTime());
                }

                lineas.add(linea);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
    }

    // Obtener el total de unidades vendidas de un producto
    public int obtenerTotalUnidadesProducto(int idProducto) {
        String sql = "SELECT SUM(unidades) as total FROM lventas WHERE idProducto = ?";
        int total = 0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // Obtener el total de ingresos generados por un producto
    public double obtenerTotalIngresosProducto(int idProducto) {
        String sql = "SELECT SUM(unidades * precioUnidad) as total FROM lventas WHERE idProducto = ?";
        double total = 0.0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total");
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // Obtener número de transacciones de un producto
    public int obtenerNumeroTransaccionesProducto(int idProducto) {
        String sql = "SELECT COUNT(DISTINCT idVenta) as total FROM lventas WHERE idProducto = ?";
        int total = 0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // Obtener productos más vendidos (por unidades)
    public ArrayList<LVenta> obtenerProductosMasVendidos(int limite) {
        ArrayList<LVenta> productos = new ArrayList<>();
        String sql = "SELECT idProducto, SUM(unidades) as totalUnidades, COUNT(DISTINCT idVenta) as totalTransacciones, " +
                     "SUM(unidades * precioUnidad) as totalIngresos " +
                     "FROM lventas " +
                     "GROUP BY idProducto " +
                     "ORDER BY totalUnidades DESC " +
                     "LIMIT ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta producto = new LVenta();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setUnidades(rs.getInt("totalUnidades"));
                producto.setTotalTransacciones(rs.getInt("totalTransacciones"));
                producto.setTotalIngresos(rs.getDouble("totalIngresos"));
                productos.add(producto);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // Buscar líneas de venta por rango de fechas
    public ArrayList<LVenta> obtenerLineasPorFecha(java.time.LocalDateTime fechaInicio, java.time.LocalDateTime fechaFin) {
        ArrayList<LVenta> lineas = new ArrayList<>();
        String sql = "SELECT lv.*, p.nombre as nombreProducto, v.fechaHora " +
                     "FROM lventas lv " +
                     "JOIN productos p ON lv.idProducto = p.idProducto " +
                     "JOIN ventas v ON lv.idVenta = v.idVenta " +
                     "WHERE v.fechaHora BETWEEN ? AND ? " +
                     "ORDER BY v.fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setTimestamp(1, java.sql.Timestamp.valueOf(fechaInicio));
            stmt.setTimestamp(2, java.sql.Timestamp.valueOf(fechaFin));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LVenta linea = new LVenta();
                linea.setIdLventa(rs.getInt("idLventa"));
                linea.setIdVenta(rs.getInt("idVenta"));
                linea.setIdProducto(rs.getInt("idProducto"));
                linea.setUnidades(rs.getInt("unidades"));
                linea.setPrecioUnidad(rs.getDouble("precioUnidad"));
                linea.setNombreProducto(rs.getString("nombreProducto"));
                
                java.sql.Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    linea.setFechaVenta(timestamp.toLocalDateTime());
                }

                lineas.add(linea);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lineas;
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