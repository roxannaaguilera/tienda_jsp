<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="modelo.Producto" %>
<%@ page import="controlador.ProductoDAO" %>
<%@ page import="modelo.Cliente" %>
<%@ page import="controlador.ClienteDAO" %>
<%@ page import="modelo.LVenta" %>
<%@ page import="controlador.LVentaDAO" %>
<%@ page import="modelo.Venta" %>
<%@ page import="controlador.VentaDAO" %>

<%!
// Método helper para construir URLs de paginación
public String construirURLPaginacion(HttpServletRequest request, int pagina) {
    StringBuilder url = new StringBuilder("Shop.jsp?page=" + pagina);
    
    String busqueda = request.getParameter("busqueda");
    
    
    String categoria = request.getParameter("categoria");
    
    
    String sort = request.getParameter("sort");
    if (sort != null && !sort.trim().isEmpty()) {
        url.append("&sort=").append(sort);
    }
    
    return url.toString();
}
%>

<%
// Configuración de paginación
int elementosPorPagina = 12;
int paginaActual = 1;

String pageParam = request.getParameter("page");
if (pageParam != null && !pageParam.trim().isEmpty()) {
    try {
        paginaActual = Integer.parseInt(pageParam);
        if (paginaActual < 1) paginaActual = 1;
    } catch (NumberFormatException e) {
        paginaActual = 1;
    }
}

// Parámetros de filtrado
String busqueda = request.getParameter("busqueda");
String categoria = request.getParameter("categoria");
String sort = request.getParameter("sort");

// Obtener productos
ProductoDAO productoDAO = new ProductoDAO();
ArrayList<Producto> todosLosProductos = productoDAO.listarTodos();

// Aplicar filtros
ArrayList<Producto> productosFiltrados = new ArrayList<>();

for (Producto prod : todosLosProductos) {
    boolean incluir = true;
    
    // Filtro por búsqueda
    if (busqueda != null && !busqueda.trim().isEmpty()) {
        String nombreLower = prod.getNombre().toLowerCase();
        String busquedaLower = busqueda.toLowerCase();
        if (!nombreLower.contains(busquedaLower)) {
            incluir = false;
        }
    }
    
    // Filtro por categoría (si tienes este campo)
    if (categoria != null && !categoria.trim().isEmpty() && incluir) {
        // Aquí puedes implementar el filtro por categoría si tienes ese campo
        // if (!prod.getCategoria().equals(categoria)) incluir = false;
    }
    
    if (incluir) {
        productosFiltrados.add(prod);
    }
}



// Calcular paginación
int totalProductos = productosFiltrados.size();
int totalPaginas = (int) Math.ceil((double) totalProductos / elementosPorPagina);

// Validar página actual
if (paginaActual > totalPaginas && totalPaginas > 0) {
    paginaActual = totalPaginas;
}

// Calcular índices
int inicioIndice = (paginaActual - 1) * elementosPorPagina;
int finIndice = Math.min(inicioIndice + elementosPorPagina, totalProductos);

// Obtener productos para la página actual
ArrayList<Producto> productosParaMostrar = new ArrayList<>();
for (int i = inicioIndice; i < finIndice; i++) {
    productosParaMostrar.add(productosFiltrados.get(i));
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Göt Shop</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="apple-touch-icon" href="assets/img/apple-icon.png">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico?v=3">

    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/templatemo.css">
    <link rel="stylesheet" href="assets/css/custom.css">

    <!-- Load fonts style after rendering the layout styles -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;200;300;400;500;700;900&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="assets/css/fontawesome.min.css">
    
<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        --tertiary-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
        --text-primary: #2c3e50;
        --text-secondary: #7f8c8d;
        --accent-pink: #ff6b9d;
        --accent-purple: #c44569;
    }
    
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Inter', sans-serif;
        line-height: 1.6;
        color: var(--text-primary);
        overflow-x: hidden;
    }
    
    /* Header Styles */
    .modern-navbar {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        transition: all 0.3s ease;
    }
    
    .logo {
        font-family: 'Playfair Display', serif;
        font-weight: 700;
        font-size: 2.5rem;
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-decoration: none !important;
    }
    
    .nav-link {
        font-weight: 500;
        color: var(--text-primary) !important;
        position: relative;
        transition: all 0.3s ease;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-size: 0.9rem;
    }
    
    .nav-link:hover {
        color: var(--accent-pink) !important;
        transform: translateY(-2px);
    }
    
    .nav-link::after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: -5px;
        left: 50%;
        background: var(--secondary-gradient);
        transition: all 0.3s ease;
        transform: translateX(-50%);
    }
    
    .nav-link:hover::after {
        width: 100%;
    }
    
    .nav-icon {
        margin-left: 1.25rem;
        font-size: 1.2rem;
        color: #3a3a3a;
        transition: color 0.3s ease;
    }
    
    .nav-icon:hover {
        color: var(--accent-pink);
    }
    
    .badge {
        background: var(--secondary-gradient) !important;
        font-size: 0.7rem;
        border-radius: 50px;
        padding: 0.2rem 0.4rem;
    }

    /* Cintillo de envío gratis */
    .shipping-banner {
        background: var(--primary-gradient);
        height: auto;
        width: 100%;
        position: relative;
        margin-top: 80px;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0.8rem 0;
        min-height: 40px;
    }

    .shipping-message {
        background: none;
        padding: 0;
        border-radius: 0;
        font-size: 14px;
        font-weight: 600;
        color: white;
        white-space: nowrap;
        box-shadow: none;
        position: static;
        transform: none;
    }

    /* Breadcrumb pegado a la izquierda */
    .breadcrumb-row {
        font-size: 14px;
        color: #7f8c8d;
        margin-bottom: 1rem;
        padding: 1rem 4rem;
    }

    .breadcrumb-row a {
        color: #7f8c8d;
        text-decoration: none;
        text-transform: capitalize;
    }

    .breadcrumb-row a:hover {
        color: #2c3e50;
    }

    .breadcrumb-separator {
        margin: 0 0.5rem;
    }

    /* Navigation section alineado con productos */
    .navigation-section {
        width: 100%;
        padding: 1rem 0 0.5rem;
        background: white;
    }

    .navigation-container {
        max-width: none;
        margin: 0;
        padding: 0 4rem;
    }

    .page-title-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .main-title {
        font-size: 2.5rem;
        font-weight: 700;
        color: #2c3e50;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin: 0;
    }

    .filter-sort-controls {
        display: flex;
        align-items: center;
        gap: 2rem;
    }

    .filter-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        background: none;
        border: none;
        color: #2c3e50;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        padding: 0.5rem 0;
    }

    .filter-btn:hover {
        color: #7f8c8d;
    }

    .sort-dropdown-container {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .sort-label {
        font-size: 14px;
        color: #2c3e50;
        font-weight: 500;
    }

    .sort-dropdown {
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 0.4rem 0.8rem;
        font-size: 14px;
        background: white;
        color: #2c3e50;
        min-width: 150px;
    }

    .sort-dropdown:focus {
        outline: none;
        border-color: #7f8c8d;
    }

    /* Info de resultados */
    .results-info {
        padding: 0 4rem;
        margin: 1rem 0;
        text-align: center;
        color: var(--text-secondary);
        font-size: 0.9rem;
    }

    /* Categories section alineado con productos */
    .categories-section {
        padding: 2rem 0;
        background: white;
        width: 100%;
    }

    .categories-wrapper {
        max-width: none;
        margin: 0;
        padding: 0 4rem;
    }

    .categories-grid {
        display: flex;
        justify-content: center;
        align-items: stretch;
        width: 100%;
        gap: 1rem;
        flex-wrap: nowrap;
        max-width: 100%;
    }

    .category-item {
        display: flex;
        flex-direction: row;
        align-items: stretch;
        gap: 0;
        text-decoration: none;
        color: #2c3e50;
        transition: all 0.2s ease;
        padding: 0;
        border-radius: 0;
        flex: 1;
        justify-content: flex-start;
        border-right: none;
    }

    .category-item:hover {
        color: #2c3e50;
        text-decoration: none;
    }

    .category-image-small {
        width: 80px;
        height: 80px;
        border-radius: 0;
        object-fit: cover;
        flex-shrink: 0;
        transition: transform 0.2s ease;
        display: block;
    }

    .category-item:hover .category-image-small {
        transform: scale(1.05);
    }

    .category-name {
        font-size: 16px;
        font-weight: 500;
        text-transform: capitalize;
        white-space: nowrap;
        background: #f8f9fa;
        padding: 0.5rem;
        border-radius: 0;
        transition: background-color 0.2s ease;
        border: none;
        flex-grow: 1;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 80px;
        margin: 0;
    }

    .category-item:hover .category-name {
        background: #e9ecef;
    }

    /* Grid de productos con mismos márgenes */
    .products-container {
        padding: 2rem 0 4rem;
        background: #ffffff;
        min-height: 50vh;
    }

    .products-wrapper {
        padding: 0 4rem;
    }

    .modern-products-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
        row-gap: 3rem;
        width: 100%;
        margin: 0;
        padding: 0;
    }

    .modern-product-card {
        background: transparent;
        position: relative;
        overflow: hidden;
        transition: none;
        display: flex;
        flex-direction: column;
        border: none;
        border-radius: 0;
    }

    .product-image-wrapper {
        position: relative;
        overflow: hidden;
        background: #ffffff;
        aspect-ratio: 0.65;
        margin-bottom: 1rem;
    }

    .product-main-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: opacity 0.3s ease;
    }

    .product-hover-image {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .modern-product-card:hover .product-main-image {
        opacity: 0;
    }

    .modern-product-card:hover .product-hover-image {
        opacity: 1;
    }

    /* Fila de colores y bolsa */
    .product-colors-row {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 0.5rem;
        margin-bottom: 0.8rem;
    }

    .color-circle {
        width: 12px;
        height: 12px;
        border-radius: 50%;
        border: 1px solid rgba(0, 0, 0, 0.1);
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .color-circle:hover {
        transform: scale(1.2);
    }

    .color-circle.color-1 {
        background-color: #2c3e50;
    }

    .color-circle.color-2 {
        background-color: #95a5a6;
    }

    .color-circle.color-3 {
        background-color: #34495e;
    }

    .more-colors {
        font-size: 12px;
        color: #7f8c8d;
        font-weight: 500;
        margin-left: 0.3rem;
        cursor: pointer;
    }

    .shopping-bag-icon {
        margin-left: auto;
        font-size: 16px;
        color: #2c3e50;
        cursor: pointer;
        transition: color 0.2s ease;
        text-decoration: none;
    }

    .shopping-bag-icon:hover {
        color: #7f8c8d;
        text-decoration: none;
    }

    /* Información del producto */
    .product-info {
        padding: 0;
        background: transparent;
        text-align: left;
        flex-shrink: 0;
        position: relative;
    }

    .product-title {
        font-size: 14px;
        font-weight: 400;
        color: #2c3e50;
        margin-bottom: 0.5rem;
        text-decoration: none;
        display: block;
        line-height: 1.3;
        transition: none;
    }

    .product-title:hover {
        color: #2c3e50;
        text-decoration: none;
    }

    .product-price {
        font-size: 14px;
        font-weight: 500;
        color: #2c3e50;
        margin-bottom: 0;
    }

    .color-circle.active {
        border: 2px solid #2c3e50;
        transform: scale(1.1);
    }

    /* Mensaje cuando no hay productos */
    .no-products-message {
        text-align: center;
        padding: 4rem 0;
        color: var(--text-secondary);
    }

    .no-products-message h3 {
        font-size: 1.5rem;
        margin-bottom: 1rem;
        color: var(--text-primary);
    }

    .no-products-message p {
        font-size: 1rem;
        margin-bottom: 2rem;
    }

    .clear-filters-btn {
        background: var(--primary-gradient);
        color: white;
        border: none;
        padding: 0.8rem 2rem;
        border-radius: 50px;
        font-weight: 500;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
    }

    .clear-filters-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        color: white;
        text-decoration: none;
    }

    /* Paginación moderna alineada */
    .modern-pagination {
        padding: 3rem 0;
        display: flex;
        justify-content: center;
        background: white;
    }

    .pagination-wrapper {
        max-width: none;
        margin: 0;
        padding: 0 4rem;
        width: 100%;
    }

    .pagination-container {
        display: flex;
        justify-content: center;
        width: 100%;
    }

    .pagination {
        display: flex;
        gap: 0.5rem;
        list-style: none;
        margin: 0;
        padding: 0;
        justify-content: center;
        flex-wrap: wrap;
    }

    .page-item .page-link {
        padding: 0.8rem 1.2rem;
        border: none;
        border-radius: 50px;
        background: #f8f9fa;
        color: #6c757d;
        text-decoration: none;
        transition: all 0.3s ease;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .page-item.active .page-link {
        background: var(--primary-gradient);
        color: white;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .page-item:not(.active) .page-link:hover {
        background: var(--accent-pink);
        color: white;
        transform: translateY(-2px);
    }

    .page-item.disabled .page-link {
        background: #e9ecef;
        color: #adb5bd;
        cursor: not-allowed;
    }

    .page-item.disabled .page-link:hover {
        background: #e9ecef;
        color: #adb5bd;
        transform: none;
    }

    /* Modern Footer alineado */
    .modern-footer {
        background: var(--dark-gradient);
        background: linear-gradient(135deg, var(--text-primary) 0%, #34495e 25%, #2c3e50 50%, #1a252f 75%, #0f1419 100%);
        background-image: radial-gradient(circle at 20% 80%, rgba(118, 75, 162, 0.3) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(240, 147, 251, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 40% 40%, rgba(255, 107, 157, 0.2) 0%, transparent 50%);
        color: white;
        padding: 4rem 0 2rem;
        position: relative;
        overflow: hidden;
    }

    .modern-footer::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, #1a0d2e 0%, #2d1b69 25%, #4a1a4a 50%, #6b2c5c 75%, #2a0845 100%);
        z-index: -1;
        pointer-events: none;
        animation: footerFloat 20s ease-in-out infinite;
    }

    @keyframes footerFloat {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        33% { transform: translateY(-10px) rotate(1deg); }
        66% { transform: translateY(5px) rotate(-1deg); }
    }

    .footer-container {
        max-width: none;
        margin: 0;
        padding: 0 4rem;
    }

    .footer-title {
        font-family: 'Playfair Display', serif;
        font-weight: 700;
        font-size: 1.4rem;
        margin-bottom: 1.5rem;
        position: relative;
        color: white !important;
        background: none !important;
        -webkit-background-clip: unset !important;
        -webkit-text-fill-color: unset !important;
        background-clip: unset !important;
    }

    .footer-link {
        color: rgba(255, 255, 255, 0.85);
        text-decoration: none;
        transition: all 0.3s ease;
        display: block;
        padding: 0.4rem 0;
        position: relative;
        font-weight: 400;
    }

    .footer-link:hover {
        color: white;
        transform: translateX(8px);
        text-shadow: 0 0 10px rgba(255, 107, 157, 0.5);
        text-decoration: none;
    }

    .footer-link::before {
        content: '';
        position: absolute;
        left: -10px;
        top: 50%;
        width: 0;
        height: 2px;
        background: var(--accent-pink);
        transition: width 0.3s ease;
        transform: translateY(-50%);
    }

    .footer-link:hover::before {
        width: 6px;
    }

    .social-icon {
        width: 45px;
        height: 45px;
        border-radius: 12px;
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        margin: 0 0.4rem;
        transition: all 0.4s ease;
        position: relative;
        overflow: hidden;
    }

    .social-icon::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: var(--secondary-gradient);
        transition: left 0.4s ease;
        z-index: -1;
    }

    .social-icon:hover::before {
        left: 0;
    }

    .social-icon:hover {
        color: white;
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 8px 25px rgba(255, 107, 157, 0.3);
        border-color: transparent;
        text-decoration: none;
    }

    /* Responsive UNIFICADO para todos los elementos */
    @media (max-width: 1200px) {
        .navigation-container,
        .categories-wrapper,
        .products-wrapper,
        .pagination-wrapper,
        .footer-container,
        .results-info {
            padding: 0 3rem;
        }

        .modern-products-grid {
            grid-template-columns: repeat(3, 1fr);
        }

        .categories-grid {
            gap: 0.8rem;
        }

        .category-image-small {
            width: 70px;
            height: 70px;
        }

        .category-name {
            font-size: 15px;
            height: 70px;
        }

        .filter-sort-controls {
            gap: 1.5rem;
        }
    }

    @media (max-width: 768px) {
        .breadcrumb-row {
            padding: 0 0.5rem;
        }

        .navigation-container,
        .categories-wrapper,
        .products-wrapper,
        .pagination-wrapper,
        .footer-container,
        .results-info {
            padding: 0 2rem;
        }

        .modern-products-grid {
            grid-template-columns: repeat(2, 1fr);
            row-gap: 2rem;
            gap: 10px;
        }

        .product-image-wrapper {
            aspect-ratio: 0.7;
        }

        .product-title {
            font-size: 13px;
        }

        .product-price {
            font-size: 13px;
        }

        .color-circle {
            width: 10px;
            height: 10px;
        }

        .shopping-bag-icon {
            font-size: 14px;
        }

        .page-title-section {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }

        .filter-sort-controls {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
            width: 100%;
        }

        .sort-dropdown-container {
            width: 100%;
        }

        .sort-dropdown {
            width: 100%;
        }

        .main-title {
            font-size: 2rem;
        }

        .categories-grid {
            gap: 0.5rem;
        }

        .category-item {
            flex-direction: column;
            gap: 0;
            padding: 0;
            text-align: center;
        }

        .category-image-small {
            width: 50px;
            height: 50px;
        }

        .category-name {
            font-size: 12px;
            height: 30px;
            text-align: center;
        }

        .shipping-message {
            font-size: 12px;
        }

        .modern-footer {
            padding: 3rem 0 1.5rem;
        }

        .footer-title {
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }

        .social-icon {
            width: 40px;
            height: 40px;
            margin: 0 0.3rem;
        }

        .pagination {
            gap: 0.3rem;
        }

        .page-item .page-link {
            padding: 0.6rem 1rem;
            font-size: 0.9rem;
        }
    }

    @media (max-width: 480px) {
        .breadcrumb-row {
            padding: 0 0.3rem;
        }

        .navigation-container,
        .categories-wrapper,
        .products-wrapper,
        .pagination-wrapper,
        .footer-container,
        .results-info {
            padding: 0 1rem;
        }

        .modern-products-grid {
            grid-template-columns: 1fr;
            gap: 8px;
            row-gap: 2rem;
        }

        .product-image-wrapper {
            aspect-ratio: 0.75;
        }

        .main-title {
            font-size: 1.8rem;
        }

        .products-container {
            padding: 2rem 0;
        }

        .navigation-section {
            padding: 1rem 0 0.5rem;
        }

        .categories-grid {
            flex-wrap: nowrap;
            overflow-x: auto;
            padding-bottom: 0.5rem;
            justify-content: flex-start;
            gap: 1rem;
        }

        .category-item {
            flex: 0 0 auto;
            min-width: 80px;
            flex-direction: column;
        }

        .category-image-small {
            width: 50px;
            height: 50px;
        }

        .category-name {
            font-size: 10px;
            height: 25px;
        }

        .filter-sort-controls {
            width: 100%;
        }

        .sort-dropdown-container {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.3rem;
        }

        .pagination {
            gap: 0.2rem;
        }

        .page-item .page-link {
            padding: 0.5rem 0.8rem;
            font-size: 0.8rem;
        }
    }
</style>

</head>

<body>

    <!-- Header -->
    <nav class="navbar navbar-expand-lg modern-navbar">
        <div class="container">
            <a class="logo" href="Index.jsp">GÖT</a>

            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item mx-4">
                        <a class="nav-link" href="Index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item mx-4">
                        <a class="nav-link" href="Shop.jsp">Tienda</a>
                    </li>
                    <li class="nav-item mx-4">
                        <a class="nav-link" href="./admin/dashboard.jsp">Admin</a>
                    </li>
                </ul>

                <div class="d-flex align-items-center">
                    <a class="nav-icon" href="#" data-bs-toggle="modal" data-bs-target="#searchModal">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="nav-icon position-relative" href="#">
                        <i class="fa fa-shopping-bag"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge">3</span>
                    </a>
                    <a class="nav-icon position-relative" href="#">
                        <i class="fa fa-heart"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge">5</span>
                    </a>
                    <a class="nav-icon" href="#">
                        <i class="fa fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>
    <!-- Close Header -->

    <!-- Cintillo de envío gratis -->
    <div class="shipping-banner">
        <div class="shipping-message">
            🚚 ENVÍO GRATIS en compras superiores a 50€
        </div>
    </div>

    <!-- Breadcrumb pegado a la izquierda -->
    <div class="breadcrumb-row">
        <a href="Index.jsp">categoria</a>
        <span class="breadcrumb-separator">></span>
        <span>mujer</span>
    </div>

    <!-- Navegación y títulos ALINEADOS -->
    <div class="navigation-section">
        <div class="navigation-container">
            <!-- Título principal y controles -->
            <div class="page-title-section">
                <h1 class="main-title">Ropa Mujer</h1>
                
                <div class="filter-sort-controls">
                    <button class="filter-btn">
                        <i class="fas fa-filter"></i>
                        Filtrar
                    </button>
                    
                    <div class="sort-dropdown-container">
                        <label class="sort-label">Ordenar por:</label>
                        <select class="sort-dropdown" onchange="updateSort(this.value)">
                            <option value="bestselling" <%= "bestselling".equals(sort) ? "selected" : "" %>>Más vendidos</option>
                            <option value="price-low" <%= "price-low".equals(sort) ? "selected" : "" %>>Precio: Menor a Mayor</option>
                            <option value="price-high" <%= "price-high".equals(sort) ? "selected" : "" %>>Precio: Mayor a Menor</option>
                            <option value="name-asc" <%= "name-asc".equals(sort) ? "selected" : "" %>>Nombre: A-Z</option>
                            <option value="name-desc" <%= "name-desc".equals(sort) ? "selected" : "" %>>Nombre: Z-A</option>
                            <option value="newest" <%= "newest".equals(sort) ? "selected" : "" %>>Más recientes</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Información de resultados -->
    <% if (!productosParaMostrar.isEmpty()) { %>
    <div class="results-info">
        Mostrando <%= inicioIndice + 1 %> - <%= finIndice %> de <%= totalProductos %> productos
        <% if (busqueda != null && !busqueda.trim().isEmpty()) { %>
        para "<%= busqueda %>"
        <% } %>
    </div>
    <% } %>

    <!-- Categorías ALINEADAS -->
    <div class="categories-section">
        <div class="categories-wrapper">
            <div class="categories-grid">
               <a href="ShopSingle.jsp?id=29" class="category-item">
                    <img src="assets/img/categories/accesorios.png" alt="Accesorios" class="category-image-small"
                         onerror="this.src='assets/img/default-category.jpg'">
                    <span class="category-name">Accesorios</span>
                </a>

                <a href="ShopSingle.jsp?id=26" class="category-item">
                    <img src="assets/img/categories/faldas.png" alt="Faldas" class="category-image-small"
                         onerror="this.src='assets/img/default-category.jpg'">
                    <span class="category-name">Faldas</span>
                </a>
                
                <a href="ShopSingle.jsp?id=6" class="category-item">
                    <img src="assets/img/categories/hoddie.jpg" alt="Hoddies" class="category-image-small"
                         onerror="this.src='assets/img/default-category.jpg'">
                    <span class="category-name">Hoddies</span>
                </a>
                
                <a href="ShopSingle.jsp?id=11" class="category-item">
                    <img src="assets/img/categories/mallas.png" alt="Mallas" class="category-image-small"
                         onerror="this.src='assets/img/default-category.jpg'">
                    <span class="category-name">Mallas</span>
                </a>
                
                <a href="ShopSingle.jsp?id=9" class="category-item">
                    <img src="assets/img/categories/ofertas.jpg" alt="Ofertas" class="category-image-small"
                         onerror="this.src='assets/img/default-category.jpg'">
                    <span class="category-name">Ofertas</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Modal de Búsqueda -->
    <div class="modal fade bg-white" id="searchModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="w-100 pt-1 mb-5 text-right">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="Shop.jsp" method="get" class="modal-content modal-body border-0 p-0">
                <div class="input-group mb-2">
                    <input type="text" class="form-control" id="inputModalSearch" name="busqueda" 
                           placeholder="Buscar productos..." value="<%= busqueda != null ? busqueda : "" %>">
                    <button type="submit" class="input-group-text bg-success text-light">
                        <i class="fa fa-fw fa-search text-white"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Grid de Productos PERFECTAMENTE ALINEADO -->
    <div class="products-container">
        <div class="products-wrapper">
            <% if (productosParaMostrar.isEmpty()) { %>
                <div class="no-products-message">
                    <h3>No se encontraron productos</h3>
                    <% if (busqueda != null && !busqueda.trim().isEmpty()) { %>
                        <p>No se encontraron productos para la búsqueda "<%= busqueda %>"</p>
                        <a href="Shop.jsp" class="clear-filters-btn">Limpiar búsqueda</a>
                    <% } else { %>
                        <p>No hay productos disponibles en este momento.</p>
                    <% } %>
                </div>
            <% } else { %>
                <div class="modern-products-grid">
                    <%
                    for (Producto prod : productosParaMostrar) {
                    %>
                        <div class="modern-product-card">
                            <!-- Imagen del producto -->
                            <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>" class="product-image-wrapper">
                                <img class="product-main-image" 
                                     src="assets/img/producto_<%= prod.getIdProducto() %>.jpg" 
                                     alt="<%= prod.getNombre() %>" 
                                     onerror="this.src='assets/img/default_product.jpg'">
                                
                                <!-- Imagen de hover con fallback por defecto -->
                                <img class="product-hover-image" 
                                     src="assets/img/producto_<%= prod.getIdProducto() %>.2.jpg" 
                                     alt="<%= prod.getNombre() %> - Vista alternativa" 
                                     onerror="this.onerror=null; this.src='assets/img/producto_<%= prod.getIdProducto() %>.jpg';">
                            </a>
                            
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
                                
                                <!-- Nombre del producto -->
                                <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>" class="product-title">
                                    <%= prod.getNombre() %>
                                </a>
                                
                                <!-- Precio -->
                                <div class="product-price">
                                    <%= String.format("%.2f", prod.getPrecio()) %> EUR
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Paginación Moderna ALINEADA -->
   <!-- Paginación Moderna ALINEADA -->
    <% if (totalPaginas > 1) { %>
    <div class="modern-pagination">
        <div class="pagination-wrapper">
            <div class="pagination-container">
                <ul class="pagination">
                    <!-- Botón Anterior -->
                    <% if (paginaActual > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%= construirURLPaginacion(request, paginaActual - 1) %>">
                            <i class="fas fa-chevron-left"></i> Anterior
                        </a>
                    </li>
                    <% } %>

                    <!-- Páginas numéricas -->
                    <%
                    int inicoPagina = Math.max(1, paginaActual - 2);
                    int finPagina = Math.min(totalPaginas, paginaActual + 2);

                    // Mostrar primera página si no está en el rango
                    if (inicoPagina > 1) {
                    %>
                    <li class="page-item">
                        <a class="page-link" href="<%= construirURLPaginacion(request, 1) %>">1</a>
                    </li>
                    <% if (inicoPagina > 2) { %>
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                    <% } %>
                    <% } %>

                    <!-- Páginas del rango actual -->
                    <% for (int i = inicoPagina; i <= finPagina; i++) { %>
                    <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                        <a class="page-link" href="<%= construirURLPaginacion(request, i) %>"><%= i %></a>
                    </li>
                    <% } %>

                    <!-- Mostrar última página si no está en el rango -->
                    <% if (finPagina < totalPaginas) { %>
                    <% if (finPagina < totalPaginas - 1) { %>
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                    <% } %>
                    <li class="page-item">
                        <a class="page-link" href="<%= construirURLPaginacion(request, totalPaginas) %>"><%= totalPaginas %></a>
                    </li>
                    <% } %>

                    <!-- Botón Siguiente -->
                    <% if (paginaActual < totalPaginas) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%= construirURLPaginacion(request, paginaActual + 1) %>">
                            Siguiente <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
    <% } %>


    <!-- Modern Footer ALINEADO -->
    <footer class="modern-footer">
        <div class="footer-container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <h3 class="footer-title">GÖT Sportwear</h3>
                    <p class="text-light opacity-75 mb-4">Empoderando a mujeres atletas con ropa deportiva de alta calidad que combina rendimiento y estilo.</p>
                    <div class="mb-3">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        <span>Peñagrande, Madrid</span>
                    </div>
                    <div>
                        <i class="fa fa-envelope me-2"></i>
                        <a href="mailto:info@gotsportwear.com" class="footer-link d-inline">info@gotsportwear.com</a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Categorías</h4>
                    <a href="#" class="footer-link">Tops Deportivos</a>
                    <a href="#" class="footer-link">Sujetadores</a>
                    <a href="#" class="footer-link">Mallas</a>
                    <a href="#" class="footer-link">Shorts</a>
                    <a href="#" class="footer-link">Calzado</a>
                </div>

                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Ayuda</h4>
                    <a href="#" class="footer-link">Guía de Tallas</a>
                    <a href="#" class="footer-link">Devoluciones</a>
                    <a href="#" class="footer-link">Envíos</a>
                    <a href="#" class="footer-link">FAQ</a>
                    <a href="#" class="footer-link">Contacto</a>
                </div>

                <div class="col-lg-4">
                    <h4 class="footer-title">Síguenos</h4>
                    <p class="text-light opacity-75 mb-3">Mantente conectada con las últimas tendencias y novedades.</p>
                    <div class="d-flex mb-4">
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-pinterest"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
            </div>

            <div class="border-top border-secondary mt-4 pt-4">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="text-light opacity-75 mb-0">
                            &copy; 2025 GÖT Sportwear. Todos los derechos reservados.
                        </p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <a href="#" class="footer-link d-inline me-3">Política de Privacidad</a>
                        <a href="#" class="footer-link d-inline me-3">Términos de Uso</a>
                        <a href="#" class="footer-link d-inline">Cookies</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- End Footer -->

    
    <!-- JavaScript -->
    <script src="assets/js/jquery-1.11.0.min.js"></script>
    <script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/templatemo.js"></script>
    <script src="assets/js/custom.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Lazy loading de imágenes
        const images = document.querySelectorAll('.product-main-image, .product-hover-image');
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.classList.add('loaded');
                    observer.unobserve(img);
                }
            });
        });
        
        images.forEach(img => imageObserver.observe(img));

        // Funcionalidad de colores
        const colorCircles = document.querySelectorAll('.color-circle');
        colorCircles.forEach(circle => {
            circle.addEventListener('click', function() {
                // Remover clase activa de otros círculos en el mismo producto
                const parentCard = this.closest('.modern-product-card');
                const siblingCircles = parentCard.querySelectorAll('.color-circle');
                siblingCircles.forEach(c => c.classList.remove('active'));
                
                // Añadir clase activa al círculo clickeado
                this.classList.add('active');
                
                // Aquí puedes añadir lógica para cambiar la imagen del producto según el color
                console.log('Color seleccionado:', this.getAttribute('title'));
            });
        });
    });

    // Función para actualizar el ordenamiento
    function updateSort(sortValue) {
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('sort', sortValue);
        currentUrl.searchParams.delete('page'); // Reset page to 1 when sorting
        window.location.href = currentUrl.toString();
    }

    // Funciones para el modal de filtros
    function selectCategory(categoria) {
        // Remover active de todos los botones de categoría
        document.querySelectorAll('.filter-category-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Agregar active al botón seleccionado
        if (categoria !== '') {
            event.target.classList.add('active');
        }
        
        // Actualizar input hidden
        document.getElementById('categoriaInput').value = categoria;
    }

    function selectSize(talla) {
        // Remover active de todos los botones de talla
        document.querySelectorAll('.size-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Alternar el botón clickeado
        const currentTalla = document.getElementById('tallaInput').value;
        if (currentTalla === talla) {
            // Si ya está seleccionado, deseleccionar
            document.getElementById('tallaInput').value = '';
        } else {
            // Seleccionar nuevo
            event.target.classList.add('active');
            document.getElementById('tallaInput').value = talla;
        }
    }

    function selectColor(colorName) {
        // Remover active de todos los colores
        document.querySelectorAll('.color-option').forEach(option => {
            option.classList.remove('active');
        });
        
        // Alternar el color clickeado
        const currentColor = document.getElementById('colorInput').value;
        if (currentColor === colorName) {
            // Si ya está seleccionado, deseleccionar
            document.getElementById('colorInput').value = '';
        } else {
            // Seleccionar nuevo
            event.target.classList.add('active');
            document.getElementById('colorInput').value = colorName;
        }
    }

    // Función para remover filtros individuales
    function removeFilter(filterType) {
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.delete(filterType);
        currentUrl.searchParams.delete('page'); // Reset page to 1
        window.location.href = currentUrl.toString();
    }

    // Scroll suave para navegación
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
      
    <!-- JavaScript -->
    <script src="assets/js/jquery-1.11.0.min.js"></script>
    <script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/templatemo.js"></script>
    <script src="assets/js/custom.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const images = document.querySelectorAll('.product-main-image, .product-hover-image');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.classList.add('loaded');
                observer.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));

    const colorCircles = document.querySelectorAll('.color-circle');
    colorCircles.forEach(circle => {
        circle.addEventListener('click', function() {
            const parentCard = this.closest('.modern-product-card');
            const siblingCircles = parentCard.querySelectorAll('.color-circle');
            siblingCircles.forEach(c => c.classList.remove('active'));
            
            this.classList.add('active');
        });
    });
});

function updateSort(sortValue) {
    const currentUrl = new URL(window.location.href);
    currentUrl.searchParams.set('sort', sortValue);
    currentUrl.searchParams.delete('page');
    window.location.href = currentUrl.toString();
}
</script>

</body>
</html>