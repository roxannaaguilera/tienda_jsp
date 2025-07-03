package modelo;
import java.time.LocalDateTime;

public class Venta {
	
	private int idVenta;
    private LocalDateTime fechaHora;
    private int idCliente;
    private int idEmpleado;
    private double precioVenta;
	
    public Venta() {
		super();
	}

	public Venta(int idVenta, LocalDateTime fechaHora, int idCliente, int idEmpleado, double precioVenta) {
		super();
		this.idVenta = idVenta;
		this.fechaHora = fechaHora;
		this.idCliente = idCliente;
		this.idEmpleado = idEmpleado;
		this.precioVenta = precioVenta;
	}

	public int getIdVenta() {
		return idVenta;
	}

	public void setIdVenta(int idVenta) {
		this.idVenta = idVenta;
	}

	public LocalDateTime getFechaHora() {
		return fechaHora;
	}

	public void setFechaHora(LocalDateTime fechaHora) {
		this.fechaHora = fechaHora;
	}

	public int getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(int idCliente) {
		this.idCliente = idCliente;
	}

	public int getIdEmpleado() {
		return idEmpleado;
	}

	public void setIdEmpleado(int idEmpleado) {
		this.idEmpleado = idEmpleado;
	}

	public double getPrecioVenta() {
		return precioVenta;
	}

	public void setPrecioVenta(double precioVenta) {
		this.precioVenta = precioVenta;
	}

	@Override
	public String toString() {
		return "Venta [idVenta=" + idVenta + ", fechaHora=" + fechaHora + ", idCliente=" + idCliente + ", idEmpleado="
				+ idEmpleado + ", precioVenta=" + precioVenta + "]";
	}
    
}
