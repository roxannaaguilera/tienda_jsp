package modelo;

import java.util.Objects;

public class Producto {

    // Campos básicos del producto
    private int idProducto;
    private String nombre;
    private String categoria;
    private String descripcion;
    private double precio;
    private int stock;
    
    // Campos adicionales para estadísticas de ventas
    private int totalVendidos;
    private int numTransacciones;
    private double ingresosGenerados;

    // Constructor vacío
    public Producto() {
        super();
    }

    // Constructor básico
    public Producto(int idProducto, String nombre, String categoria, String descripcion, double precio, int stock) {
        super();
        setIdProducto(idProducto);
        setNombre(nombre);
        setCategoria(categoria);
        setDescripcion(descripcion);
        setPrecio(precio);
        setStock(stock);
        this.totalVendidos = 0;
        this.numTransacciones = 0;
        this.ingresosGenerados = 0.0;
    }

    // Constructor completo con estadísticas
    public Producto(int idProducto, String nombre, String categoria, String descripcion, 
                   double precio, int stock, int totalVendidos, int numTransacciones, 
                   double ingresosGenerados) {
        this(idProducto, nombre, categoria, descripcion, precio, stock);
        this.totalVendidos = totalVendidos;
        this.numTransacciones = numTransacciones;
        this.ingresosGenerados = ingresosGenerados;
    }

    // ========================================
    // GETTERS Y SETTERS BÁSICOS
    // ========================================

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del producto no puede ser vacío");
        }
        this.nombre = nombre.trim();
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria != null ? categoria.trim() : null;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        if (precio < 0) {
            throw new IllegalArgumentException("El precio no puede ser negativo");
        }
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        if (stock < 0) {
            throw new IllegalArgumentException("El stock no puede ser negativo");
        }
        this.stock = stock;
    }

    // ========================================
    // GETTERS Y SETTERS PARA ESTADÍSTICAS
    // ========================================

    public int getTotalVendidos() {
        return totalVendidos;
    }

    public void setTotalVendidos(int totalVendidos) {
        this.totalVendidos = Math.max(0, totalVendidos);
    }

    public int getNumTransacciones() {
        return numTransacciones;
    }

    public void setNumTransacciones(int numTransacciones) {
        this.numTransacciones = Math.max(0, numTransacciones);
    }

    public double getIngresosGenerados() {
        return ingresosGenerados;
    }

    public void setIngresosGenerados(double ingresosGenerados) {
        this.ingresosGenerados = Math.max(0.0, ingresosGenerados);
    }

    // ========================================
    // MÉTODOS DE CONTROL DE INVENTARIO
    // ========================================

    public boolean hayStock() {
        return this.stock > 0;
    }

    public boolean hayStock(int cantidad) {
        return this.stock >= cantidad;
    }

    public void reducirStock(int cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad debe ser positiva");
        }
        if (cantidad > this.stock) {
            throw new IllegalArgumentException("Stock insuficiente. Stock actual: " + this.stock);
        }
        this.stock -= cantidad;
    }

    public void aumentarStock(int cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad debe ser positiva");
        }
        this.stock += cantidad;
    }

    // ========================================
    // MÉTODOS DE ESTADO DEL PRODUCTO
    // ========================================

    public boolean estaAgotado() {
        return this.stock == 0;
    }

    public boolean stockBajo(int umbral) {
        return this.stock <= umbral;
    }

    public String getEstadoStock() {
        if (estaAgotado()) return "AGOTADO";
        if (stockBajo(5)) return "STOCK BAJO";
        return "DISPONIBLE";
    }

    public boolean seHaVendido() {
        return this.totalVendidos > 0;
    }

    // ========================================
    // MÉTODOS DE CÁLCULO
    // ========================================

    public double calcularValorInventario() {
        return this.precio * this.stock;
    }

    public double calcularIngresoPorVenta(int unidades) {
        return this.precio * unidades;
    }

    public double getPromedioUnidadesPorTransaccion() {
        if (this.numTransacciones == 0) return 0.0;
        return (double) this.totalVendidos / this.numTransacciones;
    }

    public double getPrecioPromedioVenta() {
        if (this.totalVendidos == 0) return 0.0;
        return this.ingresosGenerados / this.totalVendidos;
    }

    public double getRotacionInventario() {
        if (this.stock == 0) return 0.0;
        return (double) this.totalVendidos / this.stock;
    }

    // ========================================
    // MÉTODOS DE ANÁLISIS DE RENTABILIDAD
    // ========================================

    public String getCategoriaPorVentas() {
        if (totalVendidos == 0) return "SIN VENTAS";
        if (totalVendidos >= 100) return "BEST SELLER";
        if (totalVendidos >= 50) return "POPULAR";
        if (totalVendidos >= 10) return "MODERADO";
        return "BAJO";
    }

    public boolean esProductoEstrella() {
        return totalVendidos >= 50 && ingresosGenerados >= 1000.0;
    }

    public boolean necesitaRestock(int umbralMinimo) {
        return this.stock <= umbralMinimo && this.totalVendidos > 0;
    }

    // ========================================
    // MÉTODOS DE UTILIDAD
    // ========================================

    public Producto copia() {
        return new Producto(this.idProducto, this.nombre, this.categoria, 
                           this.descripcion, this.precio, this.stock,
                           this.totalVendidos, this.numTransacciones, 
                           this.ingresosGenerados);
    }

    public void reiniciarEstadisticas() {
        this.totalVendidos = 0;
        this.numTransacciones = 0;
        this.ingresosGenerados = 0.0;
    }

    // ========================================
    // MÉTODOS ESTÁNDAR
    // ========================================

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Producto producto = (Producto) obj;
        return idProducto == producto.idProducto;
    }

    @Override
    public int hashCode() {
        return Objects.hash(idProducto);
    }

    @Override
    public String toString() {
        return "Producto [idProducto=" + idProducto + 
               ", nombre=" + nombre + 
               ", categoria=" + categoria +
               ", descripcion=" + descripcion + 
               ", precio=" + precio + 
               ", stock=" + stock + 
               ", totalVendidos=" + totalVendidos +
               ", numTransacciones=" + numTransacciones +
               ", ingresosGenerados=" + ingresosGenerados + "]";
    }

    // Método toString simplificado para mostrar solo información básica
    public String toStringBasico() {
        return "Producto [" + idProducto + "] " + nombre + 
               " - Precio: $" + precio + 
               " - Stock: " + stock + 
               " - Estado: " + getEstadoStock();
    }

    // Método toString para reportes con estadísticas
    public String toStringCompleto() {
        return "=== PRODUCTO ===" +
               "\nID: " + idProducto +
               "\nNombre: " + nombre +
               "\nCategoría: " + categoria +
               "\nPrecio: $" + precio +
               "\nStock actual: " + stock + " (" + getEstadoStock() + ")" +
               "\nValor inventario: $" + calcularValorInventario() +
               "\n--- ESTADÍSTICAS DE VENTAS ---" +
               "\nTotal vendido: " + totalVendidos + " unidades" +
               "\nNúmero de transacciones: " + numTransacciones +
               "\nIngresos generados: $" + ingresosGenerados +
               "\nPromedio por transacción: " + getPromedioUnidadesPorTransaccion() + " unidades" +
               "\nCategoría por ventas: " + getCategoriaPorVentas();
    }
}