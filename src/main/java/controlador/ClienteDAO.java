package controlador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import modelo.Cliente;
import modelo.Venta;

public class ClienteDAO {
	
    private Connection conexion;

    public ClienteDAO() {
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

    // Listar todos los clientes
    public ArrayList<Cliente> listarTodos() {
        ArrayList<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT * FROM Clientes";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setDni(rs.getString("dni"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellidos(rs.getString("apellidos"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setCp(rs.getString("cp"));
                cliente.setProvincia(rs.getString("provincia"));
                clientes.add(cliente);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return clientes;
    }

    // Obtener cliente por ID
    public Cliente obtenerPorId(int id) {
        String sql = "SELECT * FROM Clientes WHERE idCliente = ?";
        Cliente cliente = null;

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setDni(rs.getString("dni"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellidos(rs.getString("apellidos"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setCp(rs.getString("cp"));
                cliente.setProvincia(rs.getString("provincia"));
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cliente;
    }

    // Guardar nuevo cliente
    public boolean guardar(Cliente cliente) {
        String sql = "INSERT INTO Clientes (dni, nombre, apellidos, direccion, cp, provincia) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, cliente.getDni());
            stmt.setString(2, cliente.getNombre());
            stmt.setString(3, cliente.getApellidos());
            stmt.setString(4, cliente.getDireccion());
            stmt.setString(5, cliente.getCp());
            stmt.setString(6, cliente.getProvincia());

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // Actualizar cliente existente
    public boolean actualizar(Cliente cliente) {
        boolean actualizado = false;
        String sql = "UPDATE Clientes SET dni = ?, nombre = ?, apellidos = ?, direccion = ?, cp = ?, provincia = ? WHERE idCliente = ?";

        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, cliente.getDni());
            ps.setString(2, cliente.getNombre());
            ps.setString(3, cliente.getApellidos());
            ps.setString(4, cliente.getDireccion());
            ps.setString(5, cliente.getCp());
            ps.setString(6, cliente.getProvincia());
            ps.setInt(7, cliente.getIdCliente());

            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return actualizado;
    }


    // Eliminar cliente por ID
    public boolean eliminar(int id) {
        String sql = "DELETE FROM clientes WHERE idCliente = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // Obtener ventas de un cliente
    public ArrayList<Venta> obtenerVentasCliente(int idCliente) {
        ArrayList<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM Ventas WHERE idCliente = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("idVenta"));
                venta.setFechaHora(rs.getTimestamp("fechaHora").toLocalDateTime());
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
   
}
