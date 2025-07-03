package modelo;

import java.time.LocalDateTime;
import java.util.Objects;

public class LVenta {
    
    // Campos básicos de la línea de venta
    private int idLventa;
    private int idVenta;
    private int idProducto;
    private int unidades;
    private double precioUnidad;
    
    // Campos adicionales para información del producto
    private String nombreProducto;
    private double precioProducto;
    
    // Campos adicionales para información de la venta
    private LocalDateTime fechaVenta;
    private int idClienteVenta;
    private int idEmpleadoVenta;
    private double precioVentaCompleta;
    
    // Campos adicionales para estadísticas agregadas
    private int totalTransacciones;
    private double totalIngresos;

    // Constructor vacío
    public LVenta() {
        super();
    }

    // Constructor básico
    public LVenta(int idLventa, int idVenta, int idProducto, int unidades, double precioUnidad) {
        super();
        this.idLventa = idLventa;
        this.idVenta = idVenta;
        this.idProducto = idProducto;
        this.unidades = unidades;
        this.precioUnidad = precioUnidad;
    }

    // Constructor completo
    public LVenta(int idLventa, int idVenta, int idProducto, int unidades, double precioUnidad,
                  String nombreProducto, double precioProducto, LocalDateTime fechaVenta,
                  int idClienteVenta, int idEmpleadoVenta, double precioVentaCompleta) {
        this(idLventa, idVenta, idProducto, unidades, precioUnidad);
        this.nombreProducto = nombreProducto;
        this.precioProducto = precioProducto;
        this.fechaVenta = fechaVenta;
        this.idClienteVenta = idClienteVenta;
        this.idEmpleadoVenta = idEmpleadoVenta;
        this.precioVentaCompleta = precioVentaCompleta;
    }

    // ========================================
    // GETTERS Y SETTERS BÁSICOS
    // ========================================

    public int getIdLventa() {
        return idLventa;
    }

    public void setIdLventa(int idLventa) {
        this.idLventa = idLventa;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public int getUnidades() {
        return unidades;
    }

    public void setUnidades(int unidades) {
        if (unidades < 0) {
            throw new IllegalArgumentException("Las unidades no pueden ser negativas");
        }
        this.unidades = unidades;
    }

    public double getPrecioUnidad() {
        return precioUnidad;
    }

    public void setPrecioUnidad(double precioUnidad) {
        if (precioUnidad < 0) {
            throw new IllegalArgumentException("El precio por unidad no puede ser negativo");
        }
        this.precioUnidad = precioUnidad;
    }

    // ========================================
    // GETTERS Y SETTERS PARA INFORMACIÓN DEL PRODUCTO
    // ========================================

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public double getPrecioProducto() {
        return precioProducto;
    }

    public void setPrecioProducto(double precioProducto) {
        this.precioProducto = precioProducto;
    }

    // ========================================
    // GETTERS Y SETTERS PARA INFORMACIÓN DE LA VENTA
    // ========================================

    public LocalDateTime getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(LocalDateTime fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public int getIdClienteVenta() {
        return idClienteVenta;
    }

    public void setIdClienteVenta(int idClienteVenta) {
        this.idClienteVenta = idClienteVenta;
    }

    public int getIdEmpleadoVenta() {
        return idEmpleadoVenta;
    }

    public void setIdEmpleadoVenta(int idEmpleadoVenta) {
        this.idEmpleadoVenta = idEmpleadoVenta;
    }

    public double getPrecioVentaCompleta() {
        return precioVentaCompleta;
    }

    public void setPrecioVentaCompleta(double precioVentaCompleta) {
        this.precioVentaCompleta = precioVentaCompleta;
    }

    // ========================================
    // GETTERS Y SETTERS PARA ESTADÍSTICAS AGREGADAS
    // ========================================

    public int getTotalTransacciones() {
        return totalTransacciones;
    }

    public void setTotalTransacciones(int totalTransacciones) {
        this.totalTransacciones = Math.max(0, totalTransacciones);
    }

    public double getTotalIngresos() {
        return totalIngresos;
    }

    public void setTotalIngresos(double totalIngresos) {
        this.totalIngresos = Math.max(0.0, totalIngresos);
    }

    // ========================================
    // MÉTODOS DE CÁLCULO
    // ========================================

    public double calcularSubtotal() {
        return this.unidades * this.precioUnidad;
    }

    public double calcularDiferenciaPrecio() {
        if (precioProducto == 0) return 0.0;
        return this.precioUnidad - this.precioProducto;
    }

    public double calcularPorcentajeDiferenciaPrecio() {
        if (precioProducto == 0) return 0.0;
        return ((this.precioUnidad - this.precioProducto) / this.precioProducto) * 100;
    }

    public boolean seVendioConDescuento() {
        return this.precioUnidad < this.precioProducto;
    }

    public boolean seVendioConSobreprecio() {
        return this.precioUnidad > this.precioProducto;
    }

    // ========================================
    // MÉTODOS DE VALIDACIÓN Y ESTADO
    // ========================================

    public boolean esVentaValida() {
        return this.unidades > 0 && this.precioUnidad > 0;
    }

    public boolean tieneInformacionCompleta() {
        return this.nombreProducto != null && 
               this.fechaVenta != null && 
               this.idClienteVenta > 0 && 
               this.idEmpleadoVenta > 0;
    }

    public String getEstadoVenta() {
        if (!esVentaValida()) return "INVÁLIDA";
        if (tieneInformacionCompleta()) return "COMPLETA";
        return "BÁSICA";
    }

    // ========================================
    // MÉTODOS DE UTILIDAD
    // ========================================

    public LVenta copia() {
        LVenta copia = new LVenta(this.idLventa, this.idVenta, this.idProducto, 
                                  this.unidades, this.precioUnidad,
                                  this.nombreProducto, this.precioProducto, 
                                  this.fechaVenta, this.idClienteVenta, 
                                  this.idEmpleadoVenta, this.precioVentaCompleta);
        copia.setTotalTransacciones(this.totalTransacciones);
        copia.setTotalIngresos(this.totalIngresos);
        return copia;
    }

    public void limpiarInformacionAdicional() {
        this.nombreProducto = null;
        this.precioProducto = 0.0;
        this.fechaVenta = null;
        this.idClienteVenta = 0;
        this.idEmpleadoVenta = 0;
        this.precioVentaCompleta = 0.0;
        this.totalTransacciones = 0;
        this.totalIngresos = 0.0;
    }

    // ========================================
    // MÉTODOS ESTÁNDAR
    // ========================================

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        LVenta lVenta = (LVenta) obj;
        return idLventa == lVenta.idLventa;
    }

    @Override
    public int hashCode() {
        return Objects.hash(idLventa);
    }

    @Override
    public String toString() {
        return "LVenta [idLventa=" + idLventa + 
               ", idVenta=" + idVenta + 
               ", idProducto=" + idProducto + 
               ", nombreProducto=" + nombreProducto +
               ", unidades=" + unidades + 
               ", precioUnidad=" + precioUnidad + 
               ", subtotal=" + calcularSubtotal() +
               ", fechaVenta=" + fechaVenta + "]";
    }

    // Método toString básico para mostrar solo información esencial
    public String toStringBasico() {
        return "Línea [" + idLventa + "] Producto: " + 
               (nombreProducto != null ? nombreProducto : "ID:" + idProducto) +
               " - Cantidad: " + unidades + 
               " - Precio: $" + precioUnidad + 
               " - Subtotal: $" + calcularSubtotal();
    }

    // Método toString completo para reportes detallados
    public String toStringCompleto() {
        StringBuilder sb = new StringBuilder();
        sb.append("=== LÍNEA DE VENTA ===\n");
        sb.append("ID Línea: ").append(idLventa).append("\n");
        sb.append("ID Venta: ").append(idVenta).append("\n");
        sb.append("Producto: ").append(nombreProducto != null ? nombreProducto : "ID:" + idProducto).append("\n");
        sb.append("Unidades: ").append(unidades).append("\n");
        sb.append("Precio unitario: $").append(precioUnidad).append("\n");
        sb.append("Subtotal: $").append(calcularSubtotal()).append("\n");
        
        if (precioProducto > 0) {
            sb.append("Precio actual del producto: $").append(precioProducto).append("\n");
            sb.append("Diferencia de precio: $").append(calcularDiferenciaPrecio()).append("\n");
            if (seVendioConDescuento()) {
                sb.append("*** VENDIDO CON DESCUENTO ***\n");
            } else if (seVendioConSobreprecio()) {
                sb.append("*** VENDIDO CON SOBREPRECIO ***\n");
            }
        }
        
        if (fechaVenta != null) {
            sb.append("Fecha de venta: ").append(fechaVenta).append("\n");
        }
        
        if (idClienteVenta > 0) {
            sb.append("ID Cliente: ").append(idClienteVenta).append("\n");
        }
        
        if (idEmpleadoVenta > 0) {
            sb.append("ID Empleado: ").append(idEmpleadoVenta).append("\n");
        }
        
        if (precioVentaCompleta > 0) {
            sb.append("Total de la venta completa: $").append(precioVentaCompleta).append("\n");
        }
        
        sb.append("Estado: ").append(getEstadoVenta());
        
        return sb.toString();
    }

    // Método específico para estadísticas agregadas
    public String toStringEstadisticas() {
        return "Producto ID:" + idProducto + 
               (nombreProducto != null ? " (" + nombreProducto + ")" : "") +
               " - Total unidades: " + unidades +
               " - Transacciones: " + totalTransacciones +
               " - Ingresos totales: $" + totalIngresos;
    }
}