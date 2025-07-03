<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="modelo.Producto"%>
<%@ page import="controlador.ProductoDAO"%>
<%@ page import="modelo.Cliente"%>
<%@ page import="controlador.ClienteDAO"%>
<%@ page import="modelo.LVenta"%>
<%@ page import="controlador.LVentaDAO"%>
<%@ page import="modelo.Venta"%>
<%@ page import="controlador.VentaDAO"%>

<%
// Lógica de datos
ProductoDAO productoDAO = new ProductoDAO();
ArrayList<Producto> productos = productoDAO.listarTodos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>GÖT Sportwear - Elevate Your Athletic Style</title>
    
    <!-- Favicons -->
    <link rel="apple-touch-icon" href="assets/img/apple-icon.png">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico?v=3">
    <link rel="icon" type="image/png" href="assets/img/favicon.png?v=2026">
    
    <!-- CSS Framework -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/templatemo.css">
    <link rel="stylesheet" href="assets/css/custom.css">
    
    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="assets/css/fontawesome.min.css">
    
    <!-- Styles -->
    <link rel="stylesheet" href="assets/css/main-styles.css">
</head>

<body>
    <!-- Header/Navigation -->
    <%@ include file="includes/header.jsp" %>
    
    <!-- Hero Carousel -->
    <%@ include file="includes/hero-carousel.jsp" %>
    
    <!-- Categories Section -->
    <%@ include file="includes/categories.jsp" %>
    
    <!-- Featured Products -->
    <%@ include file="includes/featured-products.jsp" %>
    
    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>
    
    <!-- Modals -->
    <%@ include file="includes/modals.jsp" %>
    
    <!-- Scripts -->
    <script src="assets/js/jquery-1.11.0.min.js"></script>
    <script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/templatemo.js"></script>
    <script src="assets/js/custom.js"></script>
    <script src="assets/js/main-functionality.js"></script>
</body>
</html>