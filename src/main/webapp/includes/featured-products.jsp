<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="modelo.Producto" %>
<%@ page import="controlador.ProductoDAO" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>GÖT Sportwear - Productos Destacados</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="assets/css/fontawesome.min.css">
    <link rel="stylesheet" href="assets/css/styles.css"> <!-- Tu CSS principal -->

</head>
<body>

<%
    ProductoDAO featuredProducts = new ProductoDAO();
    ArrayList<Producto> topProductos = featuredProducts.obtenerMasVendidos(5);
%>

<!-- Featured Products Section -->
<section class="featured-section">
    <div class="container-fluid">   
        <h2 class="section-title fade-in-up">MÁS VENDIDOS</h2>

        <!-- Grid de Productos -->
        <div class="products-wrapper">
            <div class="modern-products-grid">
                <%
                if (topProductos != null && !topProductos.isEmpty()) {
                    for (Producto prod : topProductos) {
                %>
                    <div class="modern-product-card">
                        <!-- Imagen del producto CLICKEABLE -->
                        <div class="product-image-wrapper">
                            <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>">
                                <img class="product-main-image" 
                                     src="assets/img/producto_<%= prod.getIdProducto() %>.jpg" 
                                     alt="<%= prod.getNombre() %>" 
                                     onerror="this.src='assets/img/default_product.jpg'">
                                
                                <img class="product-hover-image" 
                                     src="assets/img/producto_<%= prod.getIdProducto() %>.2.jpg"  
                                     alt="<%= prod.getNombre() %> - Vista alternativa" 
                                     onerror="this.onerror=null; this.src='assets/img/producto_<%= prod.getIdProducto() %>.jpg';">
                            </a>
                        </div>
                        
                        <!-- Información del producto -->
                        <div class="product-info">
                            <!-- Fila de colores y bolsa -->
                            <div class="product-colors-row">
                                <div class="color-circle color-1" title="Negro"></div>
                                <div class="color-circle color-2" title="Gris"></div>
                                <div class="color-circle color-3" title="Azul marino"></div>
                                <span class="more-colors">+</span>
                                <a href="AddCarrito?id=<%= prod.getIdProducto() %>" class="shopping-bag-icon" title="Añadir al carrito">
                                    <i class="fas fa-shopping-bag"></i>
                                </a>
                            </div>
                            
                            <!-- Nombre del producto CLICKEABLE -->
                            <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>" class="product-title">
                                <%= prod.getNombre() %>
                            </a>
                            
                            <!-- Precio -->
                            <div class="product-price">
                                <%= String.format("%.2f", prod.getPrecio()) %> EUR
                            </div>
                        </div>
                    </div>
                <%
                    }
                } else {
                %>
                    <div class="col-12 text-center">
                        <p>No hay productos disponibles en este momento.</p>
                    </div>
                <%
                }
                %>
            </div>
        </div>
    </div>
</section>

<!-- Scripts -->
<script src="assets/js/jquery-1.11.0.min.js"></script>
<script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/templatemo.js"></script>
<script src="assets/js/custom.js"></script>

<!-- Tu nuevo archivo JavaScript para productos featured -->
<script src="assets/js/featured-products.js"></script>

</body>
</html>