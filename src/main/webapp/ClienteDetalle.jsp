<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="modelo.Cliente" %>
<%@ page import="controlador.ClienteDAO" %>
<%@ page import="modelo.Venta" %>
<%@ page import="controlador.VentaDAO" %>
<%@ page import="modelo.LVenta" %>
<%@ page import="controlador.LVentaDAO" %>
<%@ page import="modelo.Producto" %>
<%@ page import="controlador.ProductoDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <title>Detalle Cliente - Göt Shop</title>
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
        --success-color: #10b981;
        --warning-color: #f59e0b;
        --danger-color: #ef4444;
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
        background: #f8f9fa;
    }
    
    /* ===== HEADER ===== */
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

    .nav-icons-container {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }

    .nav-icon {
        font-size: 1.2rem;
        color: #3a3a3a;
        transition: color 0.3s ease;
        text-decoration: none;
        position: relative;
    }

    .nav-icon:hover {
        color: var(--accent-pink);
        text-decoration: none;
    }

    .badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background: var(--danger-color);
        color: white;
        border-radius: 50%;
        width: 18px;
        height: 18px;
        font-size: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
    }

    /* ===== SHIPPING BANNER ===== */
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

    /* ===== BREADCRUMB ===== */
    .breadcrumb-row {
        font-size: 14px;
        color: #7f8c8d;
        margin-bottom: 1rem;
        padding: 1rem 4rem;
        background: white;
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

    /* ===== MAIN CONTAINER ===== */
    .main-container {
        padding: 2rem 4rem 4rem;
        background: white;
        min-height: 100vh;
    }

    /* ===== CLIENTE HEADER ===== */
    .cliente-header {
        background: linear-gradient(145deg, #ffffff 0%, #fdf2f8 100%);
        border-radius: 25px;
        padding: 2.5rem;
        margin-bottom: 2rem;
        box-shadow: 0 12px 40px rgba(236, 72, 153, 0.08);
        border: 1px solid rgba(236, 72, 153, 0.1);
        position: relative;
        overflow: hidden;
    }

    .cliente-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #ec4899, #be185d, #f97316);
        background-size: 300% 100%;
        animation: gradientFlow 3s ease infinite;
    }

    .cliente-header-content {
        display: flex;
        align-items: center;
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .cliente-avatar-large {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 2.5rem;
        font-weight: 700;
        flex-shrink: 0;
        box-shadow: 0 8px 32px rgba(236, 72, 153, 0.25);
        position: relative;
        overflow: hidden;
    }

    .cliente-avatar-large::before {
        content: '';
        position: absolute;
        inset: -3px;
        border-radius: 50%;
        background: linear-gradient(45deg, #ec4899, #be185d, #8b5cf6);
        background-size: 300% 300%;
        animation: borderGradient 3s ease infinite;
        z-index: -1;
    }

    .cliente-avatar-large img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        transition: transform 0.3s ease;
    }

    .cliente-header:hover .cliente-avatar-large {
        transform: scale(1.05);
    }

    .cliente-header:hover .cliente-avatar-large img {
        transform: scale(1.05);
    }

    .cliente-info-large {
        flex: 1;
    }

    .cliente-nombre-large {
        font-size: 2.5rem;
        font-weight: 700;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 0.5rem;
        line-height: 1.2;
    }

    .cliente-email-large {
        font-size: 1.2rem;
        color: var(--text-secondary);
        margin-bottom: 1rem;
    }

    .cliente-estado-badge {
        display: inline-block;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.9rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .estado-activo {
        background: rgba(16, 185, 129, 0.1);
        color: var(--success-color);
        border: 2px solid rgba(16, 185, 129, 0.2);
    }

    .estado-premium {
        background: rgba(245, 158, 11, 0.1);
        color: var(--warning-color);
        border: 2px solid rgba(245, 158, 11, 0.2);
    }

    .estado-inactivo {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
        border: 2px solid rgba(239, 68, 68, 0.2);
    }

    .cliente-actions {
        display: flex;
        gap: 1rem;
        margin-left: auto;
    }

    .action-btn-large {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 12px;
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.9), rgba(139, 92, 246, 0.9));
        color: white;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 600;
        text-decoration: none;
        position: relative;
        overflow: hidden;
    }

    .action-btn-large::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: left 0.5s ease;
    }

    .action-btn-large:hover::before {
        left: 100%;
    }

    .action-btn-large:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(236, 72, 153, 0.4);
        color: white;
        text-decoration: none;
    }

    /* ===== DETALLES DEL CLIENTE ===== */
    .cliente-details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .detail-card {
        background: rgba(255, 255, 255, 0.6);
        border-radius: 12px;
        padding: 1.5rem;
        border: 1px solid rgba(236, 72, 153, 0.1);
        transition: all 0.3s ease;
    }

    .detail-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.05), rgba(139, 92, 246, 0.05));
        border-color: rgba(236, 72, 153, 0.2);
    }

    .detail-title {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 0.8px;
        margin-bottom: 0.75rem;
        font-weight: 700;
    }

    .detail-content {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-primary);
    }

    /* ===== ESTADÍSTICAS ===== */
    .stats-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 3rem;
    }

    .stat-card {
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.8), rgba(252, 231, 243, 0.8));
        border-radius: 16px;
        padding: 1.5rem;
        text-align: center;
        box-shadow: 0 4px 15px rgba(236, 72, 153, 0.1);
        border: 1px solid rgba(236, 72, 153, 0.1);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(236, 72, 153, 0.05), transparent);
        transition: left 0.6s ease;
    }

    .stat-card:hover::before {
        left: 100%;
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
    }

    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        margin: 0 auto 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.8rem;
        color: white;
    }

    .stat-icon.compras {
        background: linear-gradient(135deg, var(--success-color), #059669);
    }

    .stat-icon.total {
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
    }

    .stat-icon.promedio {
        background: linear-gradient(135deg, var(--warning-color), #d97706);
    }

    .stat-icon.productos {
        background: linear-gradient(135deg, #6366f1, var(--accent-purple));
    }

    .stat-value {
        font-size: 2rem;
        font-weight: 800;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 0.5rem;
    }

    .stat-label {
        font-size: 0.9rem;
        color: var(--text-secondary);
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    /* ===== HISTORIAL DE COMPRAS ===== */
    .compras-section {
        background: linear-gradient(145deg, #ffffff 0%, #fdf2f8 100%);
        border-radius: 25px;
        padding: 2.5rem;
        box-shadow: 0 12px 40px rgba(236, 72, 153, 0.08);
        border: 1px solid rgba(236, 72, 153, 0.1);
        position: relative;
        overflow: hidden;
    }

    .compras-section::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #ec4899, #be185d, #f97316);
        background-size: 300% 100%;
        animation: gradientFlow 3s ease infinite;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid rgba(236, 72, 153, 0.1);
    }

    .section-title {
        font-size: 1.8rem;
        font-weight: 700;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .section-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.5rem;
    }

    .compras-filter {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .filter-select {
        padding: 0.5rem 1rem;
        border: 2px solid rgba(236, 72, 153, 0.2);
        border-radius: 8px;
        font-size: 14px;
        background: white;
        color: var(--text-primary);
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .filter-select:focus {
        outline: none;
        border-color: var(--accent-pink);
        box-shadow: 0 0 0 3px rgba(255, 107, 157, 0.1);
    }

    /* ===== LISTA DE COMPRAS ===== */
    .compras-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .compra-item {
        background: rgba(255, 255, 255, 0.8);
        border-radius: 12px;
        padding: 1.5rem;
        border: 1px solid rgba(236, 72, 153, 0.1);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .compra-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: linear-gradient(180deg, #ec4899, #8b5cf6);
    }

    .compra-item:hover {
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.05), rgba(139, 92, 246, 0.05));
        transform: translateX(5px);
        border-color: rgba(236, 72, 153, 0.2);
    }

    .compra-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
    }

    .compra-info h4 {
        font-size: 1.2rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 0.25rem;
    }

    .compra-fecha {
        font-size: 0.9rem;
        color: var(--text-secondary);
    }

    .compra-total {
        font-size: 1.3rem;
        font-weight: 700;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .productos-compra {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 1rem;
        margin-top: 1rem;
    }

    .producto-item {
        background: white;
        border-radius: 8px;
        padding: 1rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        box-shadow: 0 2px 8px rgba(236, 72, 153, 0.1);
        border: 1px solid rgba(236, 72, 153, 0.1);
        transition: all 0.3s ease;
    }

    .producto-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(236, 72, 153, 0.15);
        border-color: rgba(236, 72, 153, 0.2);
    }

    .producto-imagen {
        width: 60px;
        height: 60px;
        border-radius: 8px;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        flex-shrink: 0;
    }

    .producto-info {
        flex: 1;
    }

    .producto-nombre {
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 0.25rem;
    }

    .producto-detalles {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 0.9rem;
        color: var(--text-secondary);
    }

    .producto-cantidad {
        background: var(--accent-pink);
        color: white;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    .producto-precio {
        font-weight: 600;
        color: var(--text-primary);
    }

    /* ===== NO COMPRAS MESSAGE ===== */
    .no-compras-message {
        text-align: center;
        padding: 3rem 2rem;
        color: #7f8c8d;
        background: rgba(255, 255, 255, 0.6);
        border-radius: 12px;
        margin: 2rem 0;
        border: 1px solid rgba(236, 72, 153, 0.1);
    }

    .no-compras-message i {
        font-size: 4rem;
        color: #bdc3c7;
        margin-bottom: 1rem;
    }

    .no-compras-message h3 {
        color: #2c3e50;
        margin-bottom: 1rem;
    }

    /* ===== FOOTER ===== */
    .modern-footer {
        background: linear-gradient(135deg, var(--text-primary) 0%, #34495e 25%, #2c3e50 50%, #1a252f 75%, #0f1419 100%);
        background-image: 
            radial-gradient(circle at 20% 80%, rgba(118, 75, 162, 0.3) 0%, transparent 50%),
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

    .social-icons {
        display: flex !important;
        flex-direction: row !important;
        justify-content: flex-start !important;
        align-items: center !important;
        gap: 1.5rem !important;
        margin-top: 1rem !important;
        flex-wrap: wrap;
    }

    .social-icon {
        width: 45px !important;
        height: 45px !important;
        border-radius: 12px;
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        display: inline-flex !important;
        align-items: center;
        justify-content: center;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        transition: all 0.4s ease;
        position: relative;
        overflow: hidden;
        flex-shrink: 0;
        margin: 0 !important;
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

    /* ===== ANIMATIONS ===== */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(40px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    @keyframes gradientFlow {
        0%, 100% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
    }

    @keyframes borderGradient {
        0%, 100% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
    }

    @keyframes footerFloat {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        33% { transform: translateY(-10px) rotate(1deg); }
        66% { transform: translateY(5px) rotate(-1deg); }
    }

    /* ===== RESPONSIVE DESIGN ===== */
    @media (max-width: 1200px) {
        .main-container,
        .footer-container {
            padding-left: 3rem;
            padding-right: 3rem;
        }
        
        .breadcrumb-row {
            padding: 1rem 3rem;
        }
    }

    @media (max-width: 768px) {
        .breadcrumb-row,
        .main-container,
        .footer-container {
            padding-left: 2rem;
            padding-right: 2rem;
        }
        
        .cliente-header-content {
            flex-direction: column;
            text-align: center;
            gap: 1rem;
        }
        
        .cliente-actions {
            margin-left: 0;
            justify-content: center;
        }
        
        .cliente-nombre-large {
            font-size: 2rem;
        }
        
        .cliente-details-grid {
            grid-template-columns: 1fr;
        }
        
        .stats-container {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .section-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }
        
        .productos-compra {
            grid-template-columns: 1fr;
        }

        .nav-icons-container {
            gap: 1rem;
        }

        .social-icons {
            justify-content: center;
            flex-wrap: wrap;
        }
    }

    @media (max-width: 480px) {
        .breadcrumb-row,
        .main-container,
        .footer-container {
            padding-left: 1rem;
            padding-right: 1rem;
        }
        
        .stats-container {
            grid-template-columns: 1fr;
        }
        
        .cliente-avatar-large {
            width: 80px;
            height: 80px;
            font-size: 2rem;
        }
        
        .cliente-nombre-large {
            font-size: 1.8rem;
        }
        
        .compra-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }

        .social-icons {
            gap: 0.5rem;
        }

        .social-icon {
            width: 40px;
            height: 40px;
        }
    }
</style>

</head>

<body>

<%
// ====================================
// OBTENER PARÁMETROS Y DATOS
// ====================================

String clienteIdStr = request.getParameter("id");
if (clienteIdStr == null || clienteIdStr.trim().isEmpty()) {
    response.sendRedirect("Clientes.jsp");
    return;
}

int clienteId = 0;
try {
    clienteId = Integer.parseInt(clienteIdStr);
} catch (NumberFormatException e) {
    response.sendRedirect("Clientes.jsp");
    return;
}

ClienteDAO clienteDAO = new ClienteDAO();
VentaDAO ventaDAO = new VentaDAO();
LVentaDAO lventaDAO = new LVentaDAO();
ProductoDAO productoDAO = new ProductoDAO();

// Obtener cliente
Cliente cliente = clienteDAO.obtenerPorId(clienteId);
if (cliente == null) {
    response.sendRedirect("Clientes.jsp");
    return;
}

// Obtener ventas del cliente
ArrayList<Venta> ventasCliente = new ArrayList<Venta>();
ArrayList<Venta> todasVentas = ventaDAO.listarTodas();

if (todasVentas != null) {
    for (Venta venta : todasVentas) {
        if (venta.getIdCliente() == clienteId) {
            ventasCliente.add(venta);
        }
    }
}

// Ordenar ventas por fecha (más reciente primero)
Collections.sort(ventasCliente, new Comparator<Venta>() {
    public int compare(Venta v1, Venta v2) {
        if (v1.getFechaHora() == null && v2.getFechaHora() == null) return 0;
        if (v1.getFechaHora() == null) return 1;
        if (v2.getFechaHora() == null) return -1;
        return v2.getFechaHora().compareTo(v1.getFechaHora());
    }
});

// Calcular estadísticas
double totalGastado = 0.0;
int totalProductosComprados = 0;
Set<Integer> productosUnicos = new HashSet<Integer>();
String ultimaCompraFecha = "";

DecimalFormat df = new DecimalFormat("#,##0.00");
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

for (Venta venta : ventasCliente) {
    try {
        ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
        if (lineas != null) {
            for (LVenta linea : lineas) {
                totalGastado += (linea.getPrecioUnidad() * linea.getUnidades());
                totalProductosComprados += linea.getUnidades();
                productosUnicos.add(linea.getIdProducto());
            }
        }
    } catch (Exception e) {
        if (venta.getPrecioVenta() > 0) {
            totalGastado += venta.getPrecioVenta();
        }
    }
    
    // Obtener fecha más reciente
    if (venta.getFechaHora() != null && ultimaCompraFecha.isEmpty()) {
        try {
            ultimaCompraFecha = venta.getFechaHora().format(dateFormatter);
        } catch (Exception e) {
            ultimaCompraFecha = venta.getFechaHora().toString();
        }
    }
}

// Calcular iniciales para avatar
String iniciales = "";
if (cliente.getNombre() != null && cliente.getNombre().length() > 0) {
    iniciales += cliente.getNombre().charAt(0);
}
if (cliente.getApellidos() != null && cliente.getApellidos().length() > 0) {
    iniciales += cliente.getApellidos().charAt(0);
}
if (iniciales.isEmpty()) {
    iniciales = "CL";
}
iniciales = iniciales.toUpperCase();

// Determinar estado del cliente
String estadoCliente = "activo";
String estadoTexto = "Cliente Activo";
if (ventasCliente.size() == 0) {
    estadoCliente = "inactivo";
    estadoTexto = "Sin Compras";
} else if (totalGastado > 500) {
    estadoCliente = "premium";
    estadoTexto = "Cliente Premium";
}
%>

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
                        <a class="nav-link" href="Clientes.jsp">Clientes</a>
                    </li>
                    <li class="nav-item mx-4">
                        <a class="nav-link" href="./admin/dashboard.jsp">Admin</a>
                    </li>
                </ul>

                <div class="nav-icons-container">
                    <a class="nav-icon" href="#" data-bs-toggle="modal" data-bs-target="#searchModal">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="nav-icon" href="#">
                        <i class="fa fa-shopping-bag"></i>
                        <span class="badge">3</span>
                    </a>
                    <a class="nav-icon" href="#">
                        <i class="fa fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Cintillo -->
    <div class="shipping-banner">
        <div class="shipping-message">
            👤 FICHA DE CLIENTE - Información Completa y Historial de Compras
        </div>
    </div>

    <!-- Breadcrumb -->
    <div class="breadcrumb-row">
        <a href="index.jsp">inicio</a>
        <span class="breadcrumb-separator">></span>
        <a href="Clientes.jsp">clientes</a>
        <span class="breadcrumb-separator">></span>
        <span><%= cliente.getNombre().toLowerCase() %></span>
    </div>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Header del Cliente -->
        <div class="cliente-header">
            <div class="cliente-header-content">
                <div class="cliente-avatar-large">
                    <img src="https://ui-avatars.com/api/?name=<%= cliente.getNombre().replace(" ", "+") %>&size=100&background=ec4899&color=fff&font-size=0.6&bold=true" 
                         alt="<%= cliente.getNombre() %>" 
                         onerror="this.style.display='none'; this.parentNode.innerHTML='<%= iniciales %>';">
                </div>
                <div class="cliente-info-large">
                    <h1 class="cliente-nombre-large">
                        <%= cliente.getNombre() %> <%= cliente.getApellidos() != null ? cliente.getApellidos() : "" %>
                    </h1>
                    <div class="cliente-email-large">
                        ID: <%= cliente.getIdCliente() %>
                    </div>
                    <div class="cliente-estado-badge estado-<%= estadoCliente %>">
                        <%= estadoTexto %>
                    </div>
                </div>
                <div class="cliente-actions">
                    <a href="Clientes.jsp" class="action-btn-large">
                        <i class="fas fa-arrow-left"></i>
                        Volver a Clientes
                    </a>
                </div>
            </div>

            <!-- Detalles del Cliente -->
            <div class="cliente-details-grid">
                <div class="detail-card">
                    <div class="detail-title">DNI / Identificación</div>
                    <div class="detail-content"><%= cliente.getDni() != null ? cliente.getDni() : "No especificado" %></div>
                </div>
                <div class="detail-card">
                    <div class="detail-title">Teléfono</div>
                    <div class="detail-content">No especificado</div>
                </div>
                <div class="detail-card">
                    <div class="detail-title">Dirección</div>
                    <div class="detail-content"><%= cliente.getDireccion() != null ? cliente.getDireccion() : "No especificada" %></div>
                </div>
                <div class="detail-card">
                    <div class="detail-title">Última Compra</div>
                    <div class="detail-content"><%= ultimaCompraFecha.isEmpty() ? "Sin compras" : ultimaCompraFecha %></div>
                </div>
            </div>
        </div>

        <!-- Estadísticas del Cliente -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon compras">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-value"><%= ventasCliente.size() %></div>
                <div class="stat-label">Compras Realizadas</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon total">
                    <i class="fas fa-euro-sign"></i>
                </div>
                <div class="stat-value"><%= df.format(totalGastado) %>€</div>
                <div class="stat-label">Total Gastado</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon promedio">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-value">
                    <%= ventasCliente.size() > 0 ? df.format(totalGastado / ventasCliente.size()) : "0.00" %>€
                </div>
                <div class="stat-label">Promedio por Compra</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon productos">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-value"><%= productosUnicos.size() %></div>
                <div class="stat-label">Productos Únicos</div>
            </div>
        </div>

        <!-- Historial de Compras -->
        <div class="compras-section">
            <div class="section-header">
                <div class="section-title">
                    <div class="section-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    Historial de Compras
                </div>
                <div class="compras-filter">
                    <select class="filter-select" onchange="filtrarCompras(this.value)">
                        <option value="todas">Todas las compras</option>
                        <option value="ultimo-mes">Último mes</option>
                        <option value="ultimo-trimestre">Último trimestre</option>
                        <option value="ultimo-año">Último año</option>
                    </select>
                </div>
            </div>

            <!-- Lista de Compras -->
            <% if (ventasCliente.isEmpty()) { %>
                <div class="no-compras-message">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Sin historial de compras</h3>
                    <p>Este cliente aún no ha realizado ninguna compra.</p>
                    <a href="Shop.jsp" class="action-btn-large" style="margin-top: 1rem; text-decoration: none;">
                        <i class="fas fa-shopping-bag"></i>
                        Ver Productos
                    </a>
                </div>
            <% } else { %>
                <div class="compras-list">
                    <%
                    for (Venta venta : ventasCliente) {
                        // Obtener líneas de venta
                        ArrayList<LVenta> lineasVenta = new ArrayList<LVenta>();
                        double totalVenta = 0.0;
                        
                        try {
                            lineasVenta = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                            if (lineasVenta != null) {
                                for (LVenta linea : lineasVenta) {
                                    totalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
                                }
                            }
                        } catch (Exception e) {
                            totalVenta = venta.getPrecioVenta();
                        }
                        
                        // Formatear fecha
                        String fechaVenta = "Sin fecha";
                        if (venta.getFechaHora() != null) {
                            try {
                                fechaVenta = venta.getFechaHora().format(dateFormatter);
                            } catch (Exception e) {
                                fechaVenta = venta.getFechaHora().toString();
                            }
                        }
                    %>
                        <div class="compra-item">
                            <div class="compra-header">
                                <div class="compra-info">
                                    <h4>Venta #<%= venta.getIdVenta() %></h4>
                                    <div class="compra-fecha"><%= fechaVenta %></div>
                                </div>
                                <div class="compra-total"><%= df.format(totalVenta) %>€</div>
                            </div>
                            
                            <!-- Productos de la compra -->
                            <% if (lineasVenta != null && !lineasVenta.isEmpty()) { %>
                                <div class="productos-compra">
                                    <%
                                    for (LVenta linea : lineasVenta) {
                                        // Obtener información del producto
                                        Producto producto = null;
                                        String nombreProducto = "Producto no disponible";
                                        
                                        try {
                                            producto = productoDAO.obtenerPorId(linea.getIdProducto());
                                            if (producto != null) {
                                                nombreProducto = producto.getNombre();
                                            } else {
                                                nombreProducto = "Producto eliminado";
                                            }
                                        } catch (Exception e) {
                                            nombreProducto = "Error al cargar producto";
                                        }
                                        
                                        double subtotal = linea.getPrecioUnidad() * linea.getUnidades();
                                        
                                        // Calcular iniciales del producto
                                        String inicialesProducto = "PR";
                                        if (nombreProducto.length() >= 2) {
                                            inicialesProducto = nombreProducto.substring(0, 2).toUpperCase();
                                        }
                                    %>
                                        <div class="producto-item">
                                            <div class="producto-imagen">
                                                <%= inicialesProducto %>
                                            </div>
                                            <div class="producto-info">
                                                <div class="producto-nombre"><%= nombreProducto %></div>
                                                <div class="producto-detalles">
                                                    <span class="producto-cantidad">x<%= linea.getUnidades() %></span>
                                                    <span><%= df.format(linea.getPrecioUnidad()) %>€ c/u</span>
                                                    <span class="producto-precio"><%= df.format(subtotal) %>€</span>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <div style="text-align: center; padding: 1rem; color: #7f8c8d;">
                                    <i class="fas fa-info-circle"></i>
                                    No se encontraron detalles de productos para esta venta.
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
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
                    <div class="social-icons">
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

    <!-- JavaScript -->
    <script src="assets/js/jquery-1.11.0.min.js"></script>
    <script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/templatemo.js"></script>
    <script src="assets/js/custom.js"></script>

    <script>
    function filtrarCompras(filtro) {
        showNotification('Filtro aplicado: ' + filtro, 'info');
    }
    
    function showNotification(message, type) {
        type = type || 'info';
        
        const notification = document.createElement('div');
        notification.style.cssText = 
            'position: fixed; top: 100px; right: 20px; padding: 1rem 1.5rem; ' +
            'border-radius: 12px; color: white; font-weight: 600; z-index: 10000; ' +
            'max-width: 400px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); ' +
            'animation: slideInRight 0.3s ease-out;';
        
        if (type === 'success') {
            notification.style.background = 'linear-gradient(135deg, #10b981, #059669)';
        } else if (type === 'error') {
            notification.style.background = 'linear-gradient(135deg, #ef4444, #dc2626)';
        } else if (type === 'warning') {
            notification.style.background = 'linear-gradient(135deg, #f59e0b, #d97706)';
        } else {
            notification.style.background = 'linear-gradient(135deg, #6366f1, #8b5cf6)';
        }
        
        const iconClass = (type === 'success') ? 'check-circle' : 
                         (type === 'error') ? 'exclamation-circle' : 
                         (type === 'warning') ? 'exclamation-triangle' : 'info-circle';
        
        notification.innerHTML = '<i class="fas fa-' + iconClass + '" style="margin-right: 0.5rem;"></i>' + message;
        
        document.body.appendChild(notification);
        
        setTimeout(function() {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%)';
            setTimeout(function() {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            showNotification('Ficha de cliente cargada correctamente', 'success');
        }, 500);
        
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.boxShadow = '0 12px 35px rgba(236, 72, 153, 0.2)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-3px)';
                this.style.boxShadow = '0 8px 25px rgba(236, 72, 153, 0.15)';
            });
        });
        
        const statValues = document.querySelectorAll('.stat-value');
        statValues.forEach((stat, index) => {
            setTimeout(() => {
                stat.style.opacity = '0';
                stat.style.transform = 'translateY(20px)';
                stat.style.transition = 'all 0.5s ease';
                
                setTimeout(() => {
                    stat.style.opacity = '1';
                    stat.style.transform = 'translateY(0)';
                }, 100);
            }, index * 200);
        });

        const detailCards = document.querySelectorAll('.detail-card');
        detailCards.forEach((card, index) => {
            card.style.animationDelay = (index * 0.1) + 's';
            card.style.animation = 'fadeInUp 0.6s ease-out both';
        });

        const compraItems = document.querySelectorAll('.compra-item');
        compraItems.forEach((item, index) => {
            item.style.animationDelay = (index * 0.1) + 's';
            item.style.animation = 'fadeInUp 0.6s ease-out both';
        });
    });
    
    const style = document.createElement('style');
    style.textContent = 
        '@keyframes slideInRight {' +
            'from { opacity: 0; transform: translateX(100%); }' +
            'to { opacity: 1; transform: translateX(0); }' +
        '}' +
        '@keyframes fadeInUp {' +
            'from { opacity: 0; transform: translateY(30px); }' +
            'to { opacity: 1; transform: translateY(0); }' +
        '}';
    document.head.appendChild(style);
    </script>

</body>
</html>