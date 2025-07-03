<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="modelo.Cliente" %>
<%@ page import="controlador.ClienteDAO" %>
<%@ page import="modelo.Venta" %>
<%@ page import="controlador.VentaDAO" %>
<%@ page import="modelo.LVenta" %>
<%@ page import="controlador.LVentaDAO" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <title>Clientes - Göt Shop</title>
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

    /* Breadcrumb */
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

    /* Main container */
    .main-container {
        padding: 2rem 4rem 4rem;
        background: white;
        min-height: 100vh;
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #e9ecef;
    }

    .page-title {
        font-size: 2.5rem;
        font-weight: 700;
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin: 0;
    }

    .header-controls {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .search-box {
        position: relative;
        display: flex;
        align-items: center;
    }

    .search-input {
        padding: 0.75rem 1rem 0.75rem 3rem;
        border: 2px solid #e9ecef;
        border-radius: 50px;
        font-size: 14px;
        background: #f8f9fa;
        color: var(--text-primary);
        min-width: 300px;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        outline: none;
        border-color: var(--accent-pink);
        background: white;
        box-shadow: 0 0 0 3px rgba(255, 107, 157, 0.1);
    }

    .search-icon {
        position: absolute;
        left: 1rem;
        color: #7f8c8d;
        font-size: 16px;
    }

    .filter-dropdown {
        padding: 0.75rem 1rem;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        font-size: 14px;
        background: white;
        color: var(--text-primary);
        min-width: 200px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .filter-dropdown:focus {
        outline: none;
        border-color: var(--accent-pink);
        box-shadow: 0 0 0 3px rgba(255, 107, 157, 0.1);
    }

    /* Clientes Grid - Diseño más vistoso con gradiente rosado */
    .clientes-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
        gap: 2.5rem;
        margin-bottom: 3rem;
    }

    .cliente-card {
        background: linear-gradient(145deg, #ffffff 0%, #fdf2f8 100%);
        border-radius: 25px;
        padding: 2.5rem;
        box-shadow: 0 12px 40px rgba(236, 72, 153, 0.08);
        border: 1px solid rgba(236, 72, 153, 0.1);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
        cursor: pointer;
    }

    .cliente-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #ec4899, #be185d, #f97316);
        background-size: 300% 100%;
        animation: gradientFlow 3s ease infinite;
        transform: scaleX(0);
        transition: transform 0.4s ease;
        border-radius: 25px 25px 0 0;
    }

    @keyframes gradientFlow {
        0%, 100% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
    }

    .cliente-card:hover {
        transform: translateY(-8px) scale(1.02);
        box-shadow: 0 25px 60px rgba(236, 72, 153, 0.15);
        border-color: rgba(236, 72, 153, 0.3);
        background: linear-gradient(145deg, #ffffff 0%, #fce7f3 100%);
    }

    .cliente-card:hover::before {
        transform: scaleX(1);
    }

    .cliente-header {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1rem;
        margin-bottom: 2rem;
        padding-bottom: 1.5rem;
        border-bottom: 1px solid rgba(236, 72, 153, 0.1);
        text-align: center;
    }

    .cliente-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        position: relative;
        flex-shrink: 0;
        overflow: hidden;
        box-shadow: 0 8px 32px rgba(236, 72, 153, 0.25);
        transition: all 0.3s ease;
    }

    .cliente-avatar::before {
        content: '';
        position: absolute;
        inset: -3px;
        border-radius: 50%;
        background: linear-gradient(45deg, #ec4899, #be185d, #8b5cf6);
        background-size: 300% 300%;
        animation: borderGradient 3s ease infinite;
        z-index: -1;
    }

    @keyframes borderGradient {
        0%, 100% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
    }

    .cliente-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        transition: transform 0.3s ease;
    }

    .cliente-card:hover .cliente-avatar {
        transform: scale(1.05);
    }

    .cliente-card:hover .cliente-avatar img {
        transform: scale(1.05);
    }

    .cliente-info {
        width: 100%;
        overflow: hidden;
    }

    .cliente-info h3 {
        font-size: 1.3rem;
        font-weight: 700;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin: 0;
        line-height: 1.3;
        word-wrap: break-word;
        overflow-wrap: break-word;
        hyphens: auto;
        text-align: center;
    }

    .cliente-details {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.25rem;
        margin-bottom: 2.5rem;
    }

    .detail-item {
        display: flex;
        flex-direction: column;
        background: rgba(255, 255, 255, 0.6);
        padding: 1.25rem;
        border-radius: 12px;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
        border: 1px solid rgba(236, 72, 153, 0.1);
        min-height: 85px;
        justify-content: center;
    }

    .detail-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.05), rgba(139, 92, 246, 0.05));
        border-color: rgba(236, 72, 153, 0.2);
    }

    .detail-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 0.8px;
        margin-bottom: 0.75rem;
        font-weight: 700;
        line-height: 1.2;
    }

    .detail-value {
        font-weight: 600;
        color: var(--text-primary);
        font-size: 0.9rem;
        line-height: 1.4;
    }

    .cliente-stats {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 1.5rem;
        padding: 2rem 1.5rem;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.8), rgba(252, 231, 243, 0.8));
        border-radius: 15px;
        margin-top: 2rem;
        border: 1px solid rgba(236, 72, 153, 0.1);
        position: relative;
        overflow: hidden;
    }

    .cliente-stats::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(236, 72, 153, 0.05), transparent);
        transition: left 0.6s ease;
    }

    .cliente-card:hover .cliente-stats::before {
        left: 100%;
    }

    .stat-item {
        text-align: center;
        padding: 1rem 0.75rem;
        background: rgba(255, 255, 255, 0.7);
        border-radius: 12px;
        transition: all 0.3s ease;
        border: 1px solid rgba(236, 72, 153, 0.1);
        display: flex;
        flex-direction: column;
        justify-content: center;
        min-height: 80px;
    }

    .stat-item:hover {
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.08), rgba(139, 92, 246, 0.08));
        transform: translateY(-2px);
        border-color: rgba(236, 72, 153, 0.2);
    }

    .stat-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 700;
        margin-bottom: 0.75rem;
        display: block;
        line-height: 1.2;
    }

    .stat-value {
        font-size: 1.25rem;
        font-weight: 800;
        background: linear-gradient(135deg, #ec4899, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        display: block;
        line-height: 1.2;
    }

    .cliente-actions {
        position: absolute;
        top: 1.25rem;
        right: 1.25rem;
        display: flex;
        gap: 0.5rem;
        opacity: 0.8;
        transition: opacity 0.3s ease;
        z-index: 10;
    }

    .cliente-card:hover .cliente-actions {
        opacity: 1;
    }

    .action-btn {
        width: 38px;
        height: 38px;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        position: relative;
        overflow: hidden;
        backdrop-filter: blur(10px);
        background: linear-gradient(135deg, rgba(236, 72, 153, 0.9), rgba(139, 92, 246, 0.9));
        color: white;
        box-shadow: 0 4px 15px rgba(236, 72, 153, 0.3);
        flex-shrink: 0;
    }

    .action-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: left 0.5s ease;
    }

    .action-btn:hover::before {
        left: 100%;
    }

    .action-btn:hover {
        transform: translateY(-2px) scale(1.05);
        box-shadow: 0 8px 25px rgba(236, 72, 153, 0.4);
    }

    /* Animaciones de entrada mejoradas */
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

    .cliente-card {
        animation: fadeInUp 0.6s ease-out;
        animation-fill-mode: both;
    }

    .cliente-card:nth-child(1) { animation-delay: 0.1s; }
    .cliente-card:nth-child(2) { animation-delay: 0.2s; }
    .cliente-card:nth-child(3) { animation-delay: 0.3s; }
    .cliente-card:nth-child(4) { animation-delay: 0.4s; }
    .cliente-card:nth-child(5) { animation-delay: 0.5s; }
    .cliente-card:nth-child(6) { animation-delay: 0.6s; }
    .cliente-card:nth-child(7) { animation-delay: 0.7s; }
    .cliente-card:nth-child(8) { animation-delay: 0.8s; }

    /* Paginación */
    .pagination-container {
        padding: 3rem 0;
        display: flex;
        justify-content: center;
        background: white;
    }

    .pagination {
        display: flex;
        gap: 0.5rem;
        list-style: none;
        margin: 0;
        padding: 0;
        justify-content: center;
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
        cursor: pointer;
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

    /* Mensaje cuando no hay clientes */
    .no-clientes-message {
        text-align: center;
        padding: 4rem 2rem;
        color: #7f8c8d;
        background: #f8f9fa;
        border-radius: 20px;
        margin: 2rem 0;
    }

    .no-clientes-message i {
        font-size: 4rem;
        color: #bdc3c7;
        margin-bottom: 1rem;
    }

    .no-clientes-message h3 {
        color: #2c3e50;
        margin-bottom: 1rem;
    }

    /* Modern Footer */
    .modern-footer {
        background: var(--dark-gradient);
        color: white;
        padding: 4rem 0 2rem;
        position: relative;
        overflow: hidden;
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
        color: white !important;
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
        text-decoration: none;
    }

    /* Responsive */
    @media (max-width: 1200px) {
        .main-container {
            padding: 2rem 3rem 4rem;
        }
        
        .clientes-grid {
            grid-template-columns: repeat(auto-fill, minmax(330px, 1fr));
            gap: 2rem;
        }
    }

    @media (max-width: 768px) {
        .breadcrumb-row,
        .main-container,
        .footer-container {
            padding-left: 2rem;
            padding-right: 2rem;
        }
        
        .page-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }
        
        .header-controls {
            flex-direction: column;
            width: 100%;
            gap: 1rem;
        }
        
        .search-input {
            min-width: 100%;
        }
        
        .filter-dropdown {
            width: 100%;
        }
        
        .clientes-grid {
            grid-template-columns: 1fr;
        }
        
        .page-title {
            font-size: 2rem;
        }
        
        .cliente-details {
            grid-template-columns: 1fr;
        }

        .cliente-stats {
            flex-direction: column;
            gap: 1rem;
        }

        .stat-item:not(:last-child)::after {
            display: none;
        }
    }

    @media (max-width: 480px) {
        .breadcrumb-row,
        .main-container,
        .footer-container {
            padding-left: 1rem;
            padding-right: 1rem;
        }
        
        .cliente-card {
            padding: 2rem;
        }
        
        .cliente-avatar {
            width: 70px;
            height: 70px;
        }
        
        .cliente-info h3 {
            font-size: 1.2rem;
        }
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

<%!
// ====================================
// MÉTODOS HELPER (DECLARATIONS SECTION)
// ====================================

// Helper methods for missing fields - MOVED TO DECLARATIONS
public String getClienteEmail(Cliente cliente) {
    // Replace with actual method name if different
    try {
        // Try to use reflection to get email field
        java.lang.reflect.Method method = cliente.getClass().getMethod("getEmail");
        return (String) method.invoke(cliente);
    } catch (Exception e) {
        return "email@ejemplo.com"; // Placeholder
    }
}

public String getClienteTelefono(Cliente cliente) {
    // Replace with actual method name if different
    try {
        // Try to use reflection to get telefono field
        java.lang.reflect.Method method = cliente.getClass().getMethod("getTelefono");
        return (String) method.invoke(cliente);
    } catch (Exception e) {
        return "No especificado"; // Placeholder
    }
}

// FIXED: Método auxiliar para construir URLs de paginación con manejo de excepción
public String construirURLPaginacion(HttpServletRequest request, int pagina) {
    StringBuilder url = new StringBuilder("Clientes.jsp?pagina=" + pagina);
    
    String buscar = request.getParameter("buscar");
    if (buscar != null && !buscar.trim().isEmpty()) {
        try {
            url.append("&buscar=").append(java.net.URLEncoder.encode(buscar, "UTF-8"));
        } catch (java.io.UnsupportedEncodingException e) {
            // Fallback: append without encoding
            url.append("&buscar=").append(buscar);
        }
    }
    
    String ordenar = request.getParameter("ordenar");
    if (ordenar != null && !ordenar.trim().isEmpty()) {
        url.append("&ordenar=").append(ordenar);
    }
    
    String estado = request.getParameter("estado");
    if (estado != null && !estado.trim().isEmpty()) {
        url.append("&estado=").append(estado);
    }
    
    return url.toString();
}
%>

<%
// ====================================
// OBTENER PARÁMETROS Y FILTROS
// ====================================

ClienteDAO clienteDAO = new ClienteDAO();
VentaDAO ventaDAO = new VentaDAO();
LVentaDAO lventaDAO = new LVentaDAO();

// Parámetros de filtrado y paginación
String busqueda = request.getParameter("buscar");
String filtroEstado = request.getParameter("estado");
final String ordenarPor = request.getParameter("ordenar"); // FIXED: Made final
String paginaStr = request.getParameter("pagina");

// Configuración de paginación
int clientesPorPagina = 12;
int paginaActual = 1;

if (paginaStr != null && !paginaStr.trim().isEmpty()) {
    try {
        paginaActual = Integer.parseInt(paginaStr);
        if (paginaActual < 1) paginaActual = 1;
    } catch (NumberFormatException e) {
        paginaActual = 1;
    }
}

// Obtener todos los clientes
ArrayList<Cliente> todosClientes = clienteDAO.listarTodos();
if (todosClientes == null) {
    todosClientes = new ArrayList<Cliente>();
}

// Filtrar clientes según búsqueda
ArrayList<Cliente> clientesFiltrados = new ArrayList<Cliente>();
for (Cliente clienteItem : todosClientes) { // FIXED: Changed variable name to avoid conflicts
    boolean coincide = true;
    
    // FIXED: Removed direct getEmail() call
    // Filtro por búsqueda
    if (busqueda != null && !busqueda.trim().isEmpty()) {
        String busquedaLower = busqueda.toLowerCase();
        String nombreCompleto = (clienteItem.getNombre() + " " + 
            (clienteItem.getApellidos() != null ? clienteItem.getApellidos() : "")).toLowerCase();
        String email = getClienteEmail(clienteItem).toLowerCase(); // FIXED: Use helper method
        String dni = clienteItem.getDni() != null ? clienteItem.getDni().toLowerCase() : "";
        
        if (!nombreCompleto.contains(busquedaLower) && 
            !email.contains(busquedaLower) && 
            !dni.contains(busquedaLower)) {
            coincide = false;
        }
    }
    
    if (coincide) {
        clientesFiltrados.add(clienteItem);
    }
}

// Calcular estadísticas de ventas para cada cliente
final Map<Integer, Double> totalComprasCliente = new HashMap<Integer, Double>(); // FIXED: Made final
Map<Integer, Integer> numeroComprasCliente = new HashMap<Integer, Integer>();
Map<Integer, String> ultimaCompraCliente = new HashMap<Integer, String>();

DecimalFormat df = new DecimalFormat("#,##0.00");

for (Cliente clienteStats : clientesFiltrados) { // FIXED: Changed variable name to avoid conflicts
    try {
        // Obtener ventas del cliente
        ArrayList<Venta> ventasCliente = new ArrayList<Venta>();
        ArrayList<Venta> todasVentas = ventaDAO.listarTodas();
        
        if (todasVentas != null) {
            for (Venta venta : todasVentas) {
                if (venta.getIdCliente() == clienteStats.getIdCliente()) {
                    ventasCliente.add(venta);
                }
            }
        }
        
        double totalCompras = 0.0;
        String ultimaFecha = "";
        
        for (Venta venta : ventasCliente) {
            // Calcular total de la venta
            try {
                ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                if (lineas != null) {
                    for (LVenta linea : lineas) {
                        totalCompras += (linea.getPrecioUnidad() * linea.getUnidades());
                    }
                }
            } catch (Exception e) {
                if (venta.getPrecioVenta() > 0) {
                    totalCompras += venta.getPrecioVenta();
                }
            }
            
            // Obtener fecha más reciente
            if (venta.getFechaHora() != null) {
                String fechaStr = venta.getFechaHora().toString();
                if (ultimaFecha.isEmpty() || fechaStr.compareTo(ultimaFecha) > 0) {
                    ultimaFecha = fechaStr;
                }
            }
        }
        
        totalComprasCliente.put(clienteStats.getIdCliente(), totalCompras);
        numeroComprasCliente.put(clienteStats.getIdCliente(), ventasCliente.size());
        ultimaCompraCliente.put(clienteStats.getIdCliente(), ultimaFecha);
        
    } catch (Exception e) {
        totalComprasCliente.put(clienteStats.getIdCliente(), 0.0);
        numeroComprasCliente.put(clienteStats.getIdCliente(), 0);
        ultimaCompraCliente.put(clienteStats.getIdCliente(), "");
    }
}

// FIXED: Ordenar clientes - removed email sorting
if (ordenarPor != null && !ordenarPor.trim().isEmpty()) {
    Collections.sort(clientesFiltrados, new Comparator<Cliente>() {
        public int compare(Cliente c1, Cliente c2) {
            switch(ordenarPor) {
                case "nombre":
                    return c1.getNombre().compareToIgnoreCase(c2.getNombre());
                // REMOVED: email case since getEmail() method doesn't exist
                case "compras-desc":
                    Double total1 = totalComprasCliente.get(c1.getIdCliente());
                    Double total2 = totalComprasCliente.get(c2.getIdCliente());
                    if (total1 == null) total1 = 0.0;
                    if (total2 == null) total2 = 0.0;
                    return Double.compare(total2, total1);
                case "compras-asc":
                    Double total1_asc = totalComprasCliente.get(c1.getIdCliente());
                    Double total2_asc = totalComprasCliente.get(c2.getIdCliente());
                    if (total1_asc == null) total1_asc = 0.0;
                    if (total2_asc == null) total2_asc = 0.0;
                    return Double.compare(total1_asc, total2_asc);
                default:
                    return 0;
            }
        }
    });
}

// Calcular paginación
int totalClientes = clientesFiltrados.size();
int totalPaginas = (int) Math.ceil((double) totalClientes / clientesPorPagina);
if (paginaActual > totalPaginas && totalPaginas > 0) {
    paginaActual = totalPaginas;
}

// Obtener clientes para la página actual
int inicioIndice = (paginaActual - 1) * clientesPorPagina;
int finIndice = Math.min(inicioIndice + clientesPorPagina, totalClientes);

ArrayList<Cliente> clientesParaMostrar = new ArrayList<Cliente>();
for (int i = inicioIndice; i < finIndice; i++) {
    clientesParaMostrar.add(clientesFiltrados.get(i));
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

                <div class="d-flex align-items-center">
                    <a class="nav-icon" href="#" data-bs-toggle="modal" data-bs-target="#searchModal">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="nav-icon position-relative" href="#">
                        <i class="fa fa-shopping-bag"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge bg-danger">3</span>
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
            👥 DIRECTORIO DE CLIENTES - Gestión Completa de Usuarios
        </div>
    </div>

    <!-- Breadcrumb -->
    <div class="breadcrumb-row">
        <a href="index.jsp">inicio</a>
        <span class="breadcrumb-separator">></span>
        <span>clientes</span>
    </div>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Header de la página -->
        <div class="page-header">
            <h1 class="page-title">Nuestros Clientes</h1>
            
            <div class="header-controls">
                <!-- Buscador -->
                <form method="get" action="Clientes.jsp" class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" name="buscar" class="search-input" 
                           placeholder="Buscar por nombre, email o DNI..." 
                           value="<%= busqueda != null ? busqueda : "" %>">
                    <% if (ordenarPor != null && !ordenarPor.trim().isEmpty()) { %>
                        <input type="hidden" name="ordenar" value="<%= ordenarPor %>">
                    <% } %>
                </form>
                
                <!-- Filtro de ordenamiento -->
                <select class="filter-dropdown" onchange="cambiarOrden(this.value)">
                    <option value="">Ordenar por...</option>
                    <option value="nombre" <%= "nombre".equals(ordenarPor) ? "selected" : "" %>>Nombre A-Z</option>
                    <!-- REMOVED: email option since getEmail() doesn't exist -->
                    <option value="compras-desc" <%= "compras-desc".equals(ordenarPor) ? "selected" : "" %>>Más compras</option>
                    <option value="compras-asc" <%= "compras-asc".equals(ordenarPor) ? "selected" : "" %>>Menos compras</option>
                </select>
            </div>
        </div>

        <!-- Grid de Clientes -->
        <% if (clientesParaMostrar.isEmpty()) { %>
            <div class="no-clientes-message">
                <i class="fas fa-users"></i>
                <h3>No se encontraron clientes</h3>
                <p>No hay clientes que coincidan con los criterios de búsqueda.</p>
                <a href="Clientes.jsp" class="btn btn-primary mt-3">Ver todos los clientes</a>
            </div>
        <% } else { %>
            <div class="clientes-grid">
                <%
                for (Cliente clienteCard : clientesParaMostrar) { // FIXED: Changed variable name to avoid conflicts
                    // Obtener estadísticas
                    double totalCompras = totalComprasCliente.getOrDefault(clienteCard.getIdCliente(), 0.0);
                    int numeroCompras = numeroComprasCliente.getOrDefault(clienteCard.getIdCliente(), 0);
                    String ultimaCompra = ultimaCompraCliente.getOrDefault(clienteCard.getIdCliente(), "");
                    
                    // Formatear última compra
                    String ultimaCompraFormateada = "Sin compras";
                    if (!ultimaCompra.isEmpty()) {
                        try {
                            // Simplificar formato de fecha
                            ultimaCompraFormateada = ultimaCompra.substring(0, 10);
                        } catch (Exception e) {
                            ultimaCompraFormateada = "Fecha inválida";
                        }
                    }
                    
                    // Datos para la imagen aleatoria (como en clientes_listado.jsp)
                    String gender = "women";
                    int photoId = clienteCard.getIdCliente() % 99;
                %>
                    <div class="cliente-card" onclick="verCliente(<%= clienteCard.getIdCliente() %>)">
                        <!-- Acciones -->
                        <div class="cliente-actions">
                            <button class="action-btn" title="Ver perfil" onclick="event.stopPropagation(); verCliente(<%= clienteCard.getIdCliente() %>)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        
                        <!-- Header del cliente -->
                        <div class="cliente-header">
                            <div class="cliente-avatar">
                                <img src="https://randomuser.me/api/portraits/<%= gender %>/<%= photoId %>.jpg" 
                                     onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<%= clienteCard.getNombre() %>&background=6366f1&color=fff&size=80';"
                                     alt="Foto de <%= clienteCard.getNombre() %>">
                            </div>
                            <div class="cliente-info">
                                <h3><%= clienteCard.getNombre() %> <%= clienteCard.getApellidos() != null ? clienteCard.getApellidos() : "" %></h3>
                            </div>
                        </div>
                        
                        <!-- Detalles del cliente -->
                        <div class="cliente-details">
                            <div class="detail-item">
                                <span class="detail-label">DNI</span>
                                <span class="detail-value"><%= clienteCard.getDni() != null ? clienteCard.getDni() : "No especificado" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Teléfono</span>
                                <!-- FIXED: Using helper method instead of direct getTelefono() call -->
                                <span class="detail-value"><%= getClienteTelefono(clienteCard) %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Dirección</span>
                                <span class="detail-value">
                                    <%= clienteCard.getDireccion() != null ? clienteCard.getDireccion() : "No especificada" %>
                                    <% if (clienteCard.getDireccion() != null && !clienteCard.getDireccion().trim().isEmpty()) { %>
                                        <br><small style="color: var(--text-secondary); font-size: 0.8rem;">Madrid, España</small>
                                    <% } %>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Última Compra</span>
                                <span class="detail-value"><%= ultimaCompraFormateada %></span>
                            </div>
                        </div>
                        
                        <!-- Estadísticas del cliente -->
                        <div class="cliente-stats">
                            <div class="stat-item">
                                <span class="stat-value"><%= numeroCompras %></span>
                                <span class="stat-label">Compras</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value"><%= df.format(totalCompras) %>€</span>
                                <span class="stat-label">Total Gastado</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">
                                    <%= numeroCompras > 0 ? df.format(totalCompras / numeroCompras) : "0.00" %>€
                                </span>
                                <span class="stat-label">Promedio</span>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Información de resultados -->
        <% if (!clientesParaMostrar.isEmpty()) { %>
            <div class="text-center mb-4 text-muted">
                Mostrando <%= inicioIndice + 1 %> - <%= finIndice %> de <%= totalClientes %> clientes
                <% if (busqueda != null && !busqueda.trim().isEmpty()) { %>
                    para "<%= busqueda %>"
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Paginación -->
    <% if (totalPaginas > 1) { %>
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
    <% } %>

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
    // ====================================
    // FUNCIONES PRINCIPALES
    // ====================================
    
    // Función para ver detalles del cliente
    function verCliente(idCliente) {
        window.location.href = 'ClienteDetalle.jsp?id=' + idCliente;
    }
    
    // Función para editar cliente
    function editarCliente(idCliente) {
        // Aquí puedes implementar la lógica para editar
        showNotification('Funcionalidad de edición próximamente', 'info');
    }
    
    // Función para cambiar el orden
    function cambiarOrden(ordenValue) {
        const urlParams = new URLSearchParams(window.location.search);
        
        if (ordenValue) {
            urlParams.set('ordenar', ordenValue);
        } else {
            urlParams.delete('ordenar');
        }
        
        // Resetear a página 1 cuando se cambia el orden
        urlParams.delete('pagina');
        
        const newUrl = window.location.pathname + '?' + urlParams.toString();
        window.location.href = newUrl;
    }
    
    // ====================================
    // FUNCIONES DE NOTIFICACIÓN
    // ====================================
    
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
    
    // ====================================
    // INICIALIZACIÓN DEL DOM
    // ====================================
    
    document.addEventListener('DOMContentLoaded', function() {
        // Auto-submit del formulario de búsqueda al presionar Enter
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    this.closest('form').submit();
                }
            });
        }
        
        // Mostrar mensaje de bienvenida si hay clientes
        <% if (!clientesParaMostrar.isEmpty()) { %>
            setTimeout(function() {
                showNotification('Mostrando <%= clientesParaMostrar.size() %> clientes', 'success');
            }, 500);
        <% } %>
        
        // Efectos de hover mejorados para las cards
        const clienteCards = document.querySelectorAll('.cliente-card');
        clienteCards.forEach((card, index) => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-15px) scale(1.03)';
                this.style.boxShadow = '0 30px 70px rgba(102, 126, 234, 0.2)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-12px) scale(1.02)';
                this.style.boxShadow = '0 25px 60px rgba(102, 126, 234, 0.15)';
            });
        });
    });
    
    // Agregar animación CSS para notificaciones
    const style = document.createElement('style');
    style.textContent = 
        '@keyframes slideInRight {' +
            'from { opacity: 0; transform: translateX(100%); }' +
            'to { opacity: 1; transform: translateX(0); }' +
        '}';
    document.head.appendChild(style);
    </script>

</body>
</html>