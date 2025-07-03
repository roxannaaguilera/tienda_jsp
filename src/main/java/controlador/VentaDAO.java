package controlador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import modelo.Venta;

public class VentaDAO {
    private Connection conexion;

    public VentaDAO() {
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

    public ArrayList<Venta> listarTodas() {
        ArrayList<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas ORDER BY fechaHora";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));

                Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    venta.setFechaHora(timestamp.toLocalDateTime());
                }

                venta.setIdCliente(rs.getInt("idCliente"));
                venta.setIdEmpleado(rs.getInt("idEmpleado"));
                venta.setPrecioVenta(rs.getDouble("precioVenta"));

                ventas.add(venta);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ventas;
    }



    // Obtener venta por ID
    public Venta obtenerPorId(int id) {
        String sql = "SELECT * FROM ventas WHERE idVenta = ?";
        Venta venta = null;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));
                
                // Manejo seguro de timestamp
                Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    venta.setFechaHora(timestamp.toLocalDateTime());
                }
                
                venta.setIdCliente(rs.getInt("idCliente"));
                venta.setIdEmpleado(rs.getInt("idEmpleado"));
                venta.setPrecioVenta(rs.getDouble("precioVenta"));
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return venta;
    }

    // Guardar nueva venta
    public void guardar(Venta venta) {
        String sql = "INSERT INTO ventas (fechaHora, idCliente, idEmpleado, precioVenta) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            if (venta.getFechaHora() != null) {
                stmt.setTimestamp(1, Timestamp.valueOf(venta.getFechaHora()));
            } else {
                stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            }
            stmt.setInt(2, venta.getIdCliente());
            stmt.setInt(3, venta.getIdEmpleado());
            stmt.setDouble(4, venta.getPrecioVenta());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Guardar nueva venta y retornar el ID generado
    public int guardarYObtenerID(Venta venta) {
        String sql = "INSERT INTO ventas (fechaHora, idCliente, idEmpleado, precioVenta) VALUES (?, ?, ?, ?)";
        int idGenerado = -1;

        try (PreparedStatement stmt = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (venta.getFechaHora() != null) {
                stmt.setTimestamp(1, Timestamp.valueOf(venta.getFechaHora()));
            } else {
                stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            }
            stmt.setInt(2, venta.getIdCliente());
            stmt.setInt(3, venta.getIdEmpleado());
            stmt.setDouble(4, venta.getPrecioVenta());

            int filasAfectadas = stmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        idGenerado = generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return idGenerado;
    }

    // Actualizar venta existente
    public void actualizar(Venta venta) {
        String sql = "UPDATE ventas SET fechaHora = ?, idCliente = ?, idEmpleado = ?, precioVenta = ? WHERE idVenta = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            if (venta.getFechaHora() != null) {
                stmt.setTimestamp(1, Timestamp.valueOf(venta.getFechaHora()));
            } else {
                stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            }
            stmt.setInt(2, venta.getIdCliente());
            stmt.setInt(3, venta.getIdEmpleado());
            stmt.setDouble(4, venta.getPrecioVenta());
            stmt.setInt(5, venta.getIdVenta());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Eliminar venta por ID
    public void eliminar(int id) {
        String sql = "DELETE FROM ventas WHERE idVenta = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Obtener ventas de un cliente específico
    public ArrayList<Venta> obtenerVentasPorCliente(int idCliente) {
        ArrayList<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas WHERE idCliente = ? ORDER BY fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));
                
                // Manejo seguro de timestamp
                Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    venta.setFechaHora(timestamp.toLocalDateTime());
                }
                
                venta.setIdCliente(rs.getInt("idCliente"));
                venta.setIdEmpleado(rs.getInt("idEmpleado"));
                venta.setPrecioVenta(rs.getDouble("precioVenta"));

                ventas.add(venta);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ventas;
    }

    // Obtener ventas de un empleado específico
    public ArrayList<Venta> obtenerVentasPorEmpleado(int idEmpleado) {
        ArrayList<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas WHERE idEmpleado = ? ORDER BY fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idEmpleado);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));
                
                // Manejo seguro de timestamp
                Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    venta.setFechaHora(timestamp.toLocalDateTime());
                }
                
                venta.setIdCliente(rs.getInt("idCliente"));
                venta.setIdEmpleado(rs.getInt("idEmpleado"));
                venta.setPrecioVenta(rs.getDouble("precioVenta"));

                ventas.add(venta);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ventas;
    }

    // Obtener el total de ventas de un cliente
    public double obtenerTotalVentasCliente(int idCliente) {
        String sql = "SELECT SUM(precioVenta) as total FROM ventas WHERE idCliente = ?";
        double total = 0.0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
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

    // Contar número de ventas de un cliente
    public int contarVentasCliente(int idCliente) {
        String sql = "SELECT COUNT(*) as total FROM ventas WHERE idCliente = ?";
        int total = 0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
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

    // Obtener el total de ventas de un empleado
    public double obtenerTotalVentasEmpleado(int idEmpleado) {
        String sql = "SELECT SUM(precioVenta) as total FROM ventas WHERE idEmpleado = ?";
        double total = 0.0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idEmpleado);
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

    // Contar número de ventas de un empleado
    public int contarVentasEmpleado(int idEmpleado) {
        String sql = "SELECT COUNT(*) as total FROM ventas WHERE idEmpleado = ?";
        int total = 0;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idEmpleado);
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

    // Obtener ventas por rango de fechas
    public ArrayList<Venta> obtenerVentasPorFecha(java.time.LocalDateTime fechaInicio, java.time.LocalDateTime fechaFin) {
        ArrayList<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas WHERE fechaHora BETWEEN ? AND ? ORDER BY fechaHora DESC";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(fechaInicio));
            stmt.setTimestamp(2, Timestamp.valueOf(fechaFin));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));
                
                // Manejo seguro de timestamp
                Timestamp timestamp = rs.getTimestamp("fechaHora");
                if (timestamp != null) {
                    venta.setFechaHora(timestamp.toLocalDateTime());
                }
                
                venta.setIdCliente(rs.getInt("idCliente"));
                venta.setIdEmpleado(rs.getInt("idEmpleado"));
                venta.setPrecioVenta(rs.getDouble("precioVenta"));

                ventas.add(venta);
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ventas;
    }

    // Obtener estadísticas generales de ventas
    public double obtenerTotalVentasGeneral() {
        String sql = "SELECT SUM(precioVenta) as total FROM ventas";
        double total = 0.0;

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                total = rs.getDouble("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // Contar total de ventas
    public int contarTotalVentas() {
        String sql = "SELECT COUNT(*) as total FROM ventas";
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