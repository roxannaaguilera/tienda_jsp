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

<!DOCTYPE html>
<html lang="es">

<head>
    <title>GÖT Sportwear - <%= request.getParameter("id") != null ? "Producto" : "ShopSingle" %></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="assets/css/fontawesome.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --text-primary: #2c3e50;
            --text-secondary: #7f8c8d;
            --accent-pink: #ff6b9d;
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

        /* ===== NAVBAR ===== */
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

        .nav-icon {
            margin-left: 1.25rem;
            font-size: 1.2rem;
            color: #3a3a3a;
            transition: color 0.3s ease;
            text-decoration: none;
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

        /* ===== PRODUCT DETAIL SECTION ===== */
        .product-detail-section {
            margin-top: 80px;
            padding: 2rem 0;
            background: #ffffff;
        }

        .product-images-section {
            position: sticky;
            top: 100px;
            height: fit-content;
        }

        .main-product-image {
            width: 100%;
            aspect-ratio: 0.75;
            object-fit: cover;
            border-radius: 0;
            margin-bottom: 0;
            cursor: zoom-in;
        }

        .secondary-images {
            max-height: 600px;
            overflow-y: auto;
            scrollbar-width: thin;
        }

        .secondary-images::-webkit-scrollbar {
            width: 4px;
        }

        .secondary-images::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .secondary-images::-webkit-scrollbar-thumb {
            background: var(--accent-pink);
            border-radius: 2px;
        }

        .secondary-image {
            width: 100%;
            aspect-ratio: 0.75;
            object-fit: cover;
            border-radius: 0;
            margin-bottom: 0;
            cursor: pointer;
            transition: opacity 0.3s ease;
        }

        .secondary-image:hover {
            opacity: 0.8;
        }

        /* ===== PRODUCT INFO SECTION ===== */
        .product-info-section {
            padding-left: 2rem;
        }

        .product-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            text-align: left;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 2rem;
        }

        .color-selection {
            margin-bottom: 2rem;
        }

        .color-circles {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .color-circle {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .color-circle:hover,
        .color-circle.active {
            border-color: var(--text-primary);
            transform: scale(1.1);
        }

        .color-circle.black { background-color: #2c3e50; }
        .color-circle.gray { background-color: #95a5a6; }
        .color-circle.white { background-color: #ffffff; border: 2px solid #ddd; }
        .color-circle.blue { background-color: #3498db; }

        .size-selection {
            margin-bottom: 2rem;
        }

        .size-label {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: block;
        }

        .size-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .size-btn {
            padding: 0.75rem 1.25rem;
            border: 2px solid #ddd;
            background: white;
            color: var(--text-primary);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 0;
        }

        .size-btn:hover,
        .size-btn.active {
            border-color: var(--text-primary);
            background: var(--text-primary);
            color: white;
        }

        .product-description {
            margin-bottom: 2rem;
            line-height: 1.6;
            color: var(--text-secondary);
        }

        .add-to-cart-btn {
            width: 100%;
            padding: 1rem 2rem;
            background: var(--secondary-gradient);
            color: white;
            border: none;
            font-weight: 600;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border-radius: 0;
        }

        .add-to-cart-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s ease;
        }

        .add-to-cart-btn:hover::before {
            left: 100%;
        }

        .add-to-cart-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(245, 87, 108, 0.4);
        }

        /* ===== RELATED PRODUCTS SECTION ===== */
        .related-products-section {
            padding: 4rem 0;
            background: #f8f9fa;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 3rem;
            color: var(--text-primary);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 2rem;
        }

        .product-card {
            background: white;
            border-radius: 0;
            overflow: hidden;
            transition: transform 0.3s ease;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .product-card:hover {
            transform: translateY(-5px);
        }

        .product-card-image {
            width: 100%;
            aspect-ratio: 0.75;
            object-fit: cover;
        }

        .product-card-content {
            padding: 1.5rem;
        }

        .product-card-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .product-card-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--accent-pink);
        }

        /* ===== VIDEO SECTION ===== */
        .video-section {
            width: 100%;
            height: 100vh;
            position: relative;
            overflow: hidden;
        }

        .video-background {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .video-content {
            text-align: center;
            color: white;
        }

        .video-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .video-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
        }

       
/* ===== FOOTER ===== */
/* Títulos del footer */
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

/* Enlaces del footer */
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
}

/* Efecto de hover para enlaces */
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

/* Iconos sociales modernos */
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
}

/* Newsletter moderno */
.newsletter-input {
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: white;
    padding: 0.9rem 1.3rem;
    border-radius: 12px;
    transition: all 0.3s ease;
    font-size: 0.95rem;
}

.newsletter-input:focus {
    outline: none;
    border-color: var(--accent-pink);
    box-shadow: 0 0 0 3px rgba(255, 107, 157, 0.2);
    background: rgba(255, 255, 255, 0.12);
}

.newsletter-input::placeholder {
    color: rgba(255, 255, 255, 0.6);
}

.newsletter-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%,
        transparent 50%, rgba(255, 255, 255, 0.2) 100%);
    transform: translateX(-100%);
    transition: transform 0.6s ease;
}

.newsletter-btn:hover::before {
    transform: translateX(100%);
}

.newsletter-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(245, 87, 108, 0.4);
}

/* Información de contacto */
.modern-footer .fas, .modern-footer .fa {
    color: var(--accent-pink);
    margin-right: 0.7rem;
    font-size: 1.1rem;
}

/* Línea divisoria */
.border-top {
    border-color: rgba(255, 255, 255, 0.15) !important;
    margin-top: 3rem !important;
    padding-top: 2rem !important;
}

/* Texto de copyright */
.modern-footer .text-light {
    color: rgba(255, 255, 255, 0.8) !important;
}

.modern-footer .opacity-75 {
    opacity: 0.85 !important;
}

/* Modern Footer con Gradiente */
.modern-footer {
    background: var(--dark-gradient);
    background: linear-gradient(135deg, var(--text-primary) 0%, #34495e 25%,
        #2c3e50 50%, #1a252f 75%, #0f1419 100%);
    background-image: radial-gradient(circle at 20% 80%, rgba(118, 75, 162, 0.3)
        0%, transparent 50%),
        radial-gradient(circle at 80% 20%, rgba(240, 147, 251, 0.25) 0%,
        transparent 50%),
        radial-gradient(circle at 40% 40%, rgba(255, 107, 157, 0.2) 0%,
        transparent 50%);
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

.footer-title {
    color: #ffffff !important;
    font-weight: 600;
    font-size: 1.25rem;
    margin-bottom: 1.5rem;
    text-transform: none;
    background: none !important;
    -webkit-background-clip: initial !important;
    -webkit-text-fill-color: initial !important;
    background-clip: initial !important;
}

/* Newsletter */
.d-flex.mb-4 {
    flex-direction: column !important;
    gap: 10px;
}

.newsletter-input {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    padding: 12px 16px;
    border-radius: 8px;
    outline: none;
    transition: all 0.3s ease;
}

.newsletter-btn {
    background: linear-gradient(45deg, #8e44ad, #7d3c98);
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    white-space: nowrap;
}


@keyframes footerFloat {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    33% { transform: translateY(-10px) rotate(1deg); }
    66% { transform: translateY(5px) rotate(-1deg); }
}

/* ===== UTILITIES ===== */
.fade-in-up {
    animation: fadeInUp 0.8s ease forwards;
}

@keyframes fadeInUp {
    from { 
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}


        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
            
            .product-title {
                font-size: 1.5rem;
            }
        }
        
/* ===== SECCIÓN DE VENTAS DE PRODUCTOS ===== */
.ventas-producto-section {
    background: linear-gradient(145deg, #ffffff 0%, #fdf2f8 100%);
    border-radius: 25px;
    padding: 2.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 12px 40px rgba(236, 72, 153, 0.08);
    border: 1px solid rgba(236, 72, 153, 0.1);
    position: relative;
    overflow: hidden;
}

.ventas-producto-section::before {
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

@keyframes gradientFlow {
    0%, 100% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
}

/* ===== HEADER DEL PRODUCTO ===== */
.product-info-header {
    display: flex;
    align-items: center;
    gap: 1.5rem;
    margin-bottom: 2rem;
    padding: 1.5rem;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 16px;
    border: 1px solid rgba(236, 72, 153, 0.1);
    transition: all 0.3s ease;
}

.product-info-header:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
    background: rgba(255, 255, 255, 0.9);
}

.product-avatar-circle {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.8rem;
    font-weight: 700;
    flex-shrink: 0;
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
    position: relative;
    overflow: hidden;
}

.product-avatar-circle::before {
    content: '';
    position: absolute;
    inset: -2px;
    border-radius: 50%;
    background: linear-gradient(45deg, #667eea, #764ba2, #4facfe);
    background-size: 300% 300%;
    animation: borderGradient 3s ease infinite;
    z-index: -1;
}

@keyframes borderGradient {
    0%, 100% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
}

.product-details h3 {
    font-size: 1.8rem;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 0.5rem;
    line-height: 1.2;
}

.product-details p {
    font-size: 1.1rem;
    color: var(--text-secondary);
    font-weight: 500;
}

/* ===== RESUMEN DE VENTAS ===== */
.ventas-summary {
    margin-bottom: 2rem;
}

.summary-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
}

.summary-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.9), rgba(248, 250, 252, 0.9));
    border-radius: 16px;
    padding: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    border: 1px solid rgba(236, 72, 153, 0.1);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.summary-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(236, 72, 153, 0.05), transparent);
    transition: left 0.6s ease;
}

.summary-card:hover::before {
    left: 100%;
}

.summary-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
}

.summary-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.4rem;
    color: white;
    flex-shrink: 0;
}

.summary-card:nth-child(1) .summary-icon {
    background: linear-gradient(135deg, var(--success-color), #059669);
}

.summary-card:nth-child(2) .summary-icon {
    background: linear-gradient(135deg, #667eea, #764ba2);
}

.summary-card:nth-child(3) .summary-icon {
    background: linear-gradient(135deg, var(--warning-color), #d97706);
}

.summary-card div h4 {
    font-size: 1.8rem;
    font-weight: 800;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 0.25rem;
    line-height: 1;
}

.summary-card div p {
    font-size: 0.85rem;
    color: var(--text-secondary);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin: 0;
}

/* ===== SIN DATOS ===== */
.no-data {
    text-align: center;
    padding: 3rem 2rem;
    background: rgba(255, 255, 255, 0.6);
    border-radius: 16px;
    border: 2px dashed rgba(236, 72, 153, 0.2);
    margin: 2rem 0;
}

.no-data i {
    font-size: 3rem;
    color: rgba(236, 72, 153, 0.4);
    margin-bottom: 1rem;
    display: block;
}

.no-data h5 {
    font-size: 1.4rem;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 0.5rem;
}

.no-data p {
    color: var(--text-secondary);
    font-size: 1rem;
}

/* ===== LISTA DE VENTAS ===== */
.ventas-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.venta-item {
    background: rgba(255, 255, 255, 0.8);
    border-radius: 12px;
    border: 1px solid rgba(236, 72, 153, 0.1);
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.venta-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(236, 72, 153, 0.12);
    border-color: rgba(236, 72, 153, 0.2);
}

.venta-header {
    padding: 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
}

.venta-header::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    transform: scaleY(0);
    transition: transform 0.3s ease;
}

.venta-item:hover .venta-header::before {
    transform: scaleY(1);
}

.venta-header:hover {
    background: rgba(236, 72, 153, 0.03);
}

.venta-header h5 {
    font-size: 1.1rem;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 0.25rem;
}

.venta-header p {
    font-size: 0.9rem;
    color: var(--text-secondary);
    margin: 0;
}

.venta-header > div:nth-child(2) {
    text-align: right;
}

.venta-header strong {
    font-size: 1.2rem;
    font-weight: 700;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    display: block;
    margin-bottom: 0.25rem;
}

.venta-header span {
    font-size: 0.85rem;
    color: var(--text-secondary);
    font-weight: 500;
}

.toggle-icon {
    color: var(--text-secondary);
    transition: transform 0.3s ease;
    font-size: 0.9rem;
}

.venta-item.active .toggle-icon {
    transform: rotate(180deg);
}

/* ===== DETALLE DE VENTA ===== */
.venta-detalle {
    padding: 0 1.5rem 1.5rem;
    background: rgba(248, 250, 252, 0.5);
    border-top: 1px solid rgba(236, 72, 153, 0.1);
    animation: slideDown 0.3s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.venta-detalle p {
    margin-bottom: 0.75rem;
    font-size: 0.95rem;
    color: var(--text-primary);
}

.venta-detalle strong {
    color: var(--text-primary);
    font-weight: 600;
    margin-right: 0.5rem;
}

.venta-detalle a {
    color: var(--accent-pink);
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.venta-detalle a:hover {
    color: var(--accent-purple);
    text-decoration: none;
    transform: translateX(2px);
}

.venta-detalle a i {
    font-size: 0.75rem;
    opacity: 0.7;
}

.cliente-no-disponible {
    color: var(--text-secondary);
    font-style: italic;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
    .ventas-producto-section {
        padding: 1.5rem;
        margin: 1rem;
    }
    
    .product-info-header {
        flex-direction: column;
        text-align: center;
        gap: 1rem;
    }
    
    .product-avatar-circle {
        width: 60px;
        height: 60px;
        font-size: 1.4rem;
    }
    
    .product-details h3 {
        font-size: 1.4rem;
    }
    
    .summary-cards {
        grid-template-columns: 1fr;
    }
    
    .venta-header {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    
    .venta-header > div:nth-child(2) {
        text-align: center;
    }
}

/* ===== ANIMACIONES ADICIONALES ===== */
.venta-item {
    animation: fadeInUp 0.5s ease forwards;
    opacity: 0;
    transform: translateY(20px);
}

.venta-item:nth-child(1) { animation-delay: 0.1s; }
.venta-item:nth-child(2) { animation-delay: 0.2s; }
.venta-item:nth-child(3) { animation-delay: 0.3s; }
.venta-item:nth-child(4) { animation-delay: 0.4s; }
.venta-item:nth-child(5) { animation-delay: 0.5s; }

@keyframes fadeInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ===== ESTILOS PARA TOGGLE DE VENTAS (VERSIÓN CORREGIDA) ===== */

/* Estilos base para items de venta */
.venta-item {
    background: rgba(255, 255, 255, 0.8);
    border-radius: 12px;
    border: 1px solid rgba(236, 72, 153, 0.1);
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    margin-bottom: 1rem;
    opacity: 0;
    transform: translateY(20px);
}

.venta-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(236, 72, 153, 0.12);
    border-color: rgba(236, 72, 153, 0.2);
}

/* Header de la venta */
.venta-header {
    padding: 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    background: transparent;
}

.venta-header::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    transform: scaleY(0);
    transition: transform 0.3s ease;
}

.venta-item:hover .venta-header::before,
.venta-item.active .venta-header::before {
    transform: scaleY(1);
}

.venta-header:hover {
    background: rgba(236, 72, 153, 0.03);
}

/* Contenido del header */
.venta-header h5 {
    font-size: 1.1rem;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 0.25rem;
    margin: 0;
}

.venta-header p {
    font-size: 0.9rem;
    color: var(--text-secondary);
    margin: 0;
}

.venta-header > div:nth-child(2) {
    text-align: right;
}

.venta-header strong {
    font-size: 1.2rem;
    font-weight: 700;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    display: block;
    margin-bottom: 0.25rem;
}

.venta-header span {
    font-size: 0.85rem;
    color: var(--text-secondary);
    font-weight: 500;
}

/* Icono de toggle */
.toggle-icon {
    color: var(--text-secondary);
    transition: transform 0.3s ease;
    font-size: 0.9rem;
    margin-left: 1rem;
}

.venta-item.active .toggle-icon {
    transform: rotate(180deg);
}

/* Detalle de venta */
.venta-detalle {
    padding: 0 1.5rem 1.5rem;
    background: rgba(248, 250, 252, 0.5);
    border-top: 1px solid rgba(236, 72, 153, 0.1);
    display: none;
    opacity: 0;
    transform: translateY(-10px);
    transition: all 0.3s ease;
}

.venta-detalle.show {
    display: block;
    opacity: 1;
    transform: translateY(0);
}

.venta-detalle p {
    margin-bottom: 0.75rem;
    font-size: 0.95rem;
    color: var(--text-primary);
}

.venta-detalle p:last-child {
    margin-bottom: 0;
}

.venta-detalle strong {
    color: var(--text-primary);
    font-weight: 600;
    margin-right: 0.5rem;
}

/* Enlaces de cliente */
.venta-detalle a {
    color: var(--accent-pink);
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.venta-detalle a:hover {
    color: var(--accent-purple);
    text-decoration: none;
    transform: translateX(2px);
}

.venta-detalle a i {
    font-size: 0.75rem;
    opacity: 0.7;
}

.cliente-no-disponible {
    color: var(--text-secondary);
    font-style: italic;
}

/* Clase para búsqueda resaltada */
.highlight-search {
    background: linear-gradient(135deg, rgba(255, 235, 59, 0.1), rgba(255, 193, 7, 0.1));
    border-color: rgba(255, 193, 7, 0.3);
    box-shadow: 0 4px 15px rgba(255, 193, 7, 0.2);
}

.highlight-search .venta-header::before {
    background: linear-gradient(135deg, #ffc107, #ff9800);
    transform: scaleY(1);
}

/* Estilos para cards de estadísticas */
.summary-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.9), rgba(248, 250, 252, 0.9));
    border-radius: 16px;
    padding: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    border: 1px solid rgba(236, 72, 153, 0.1);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    opacity: 0;
    transform: translateY(20px);
}

.summary-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(236, 72, 153, 0.05), transparent);
    transition: left 0.6s ease;
}

.summary-card:hover::before {
    left: 100%;
}

.summary-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(236, 72, 153, 0.15);
}

/* Iconos de estadísticas */
.summary-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.4rem;
    color: white;
    flex-shrink: 0;
}

/* Valores de estadísticas */
.summary-card div h4 {
    font-size: 1.8rem;
    font-weight: 800;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 0.25rem;
    line-height: 1;
    margin: 0 0 0.25rem 0;
}

.summary-card div p {
    font-size: 0.85rem;
    color: var(--text-secondary);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin: 0;
}

/* Responsive */
@media (max-width: 768px) {
    .venta-header {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    
    .venta-header > div:nth-child(2) {
        text-align: center;
    }
    
    .toggle-icon {
        margin-left: 0;
        margin-top: 0.5rem;
    }
    
    .summary-card {
        flex-direction: column;
        text-align: center;
        gap: 1rem;
    }
}

/* Animación de entrada personalizada */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Utilidad para forzar animación */
.animate-in {
    animation: fadeInUp 0.5s ease forwards;
}

/* Estados de carga */
.loading-skeleton {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
}

@keyframes loading {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}        
    </style>
</head>

<%
    int idProducto = Integer.parseInt(request.getParameter("id"));

    ProductoDAO productoDAO = new ProductoDAO();
    Producto productoSeleccionado = productoDAO.obtenerPorId(idProducto);

    // Obtener productos relacionados
    ArrayList<Producto> productosRelacionados = productoDAO.obtenerMasVendidos(5);

    // Variables para resumen de ventas
    ArrayList<Venta> ventasConProducto = new ArrayList<>();
    ArrayList<LVenta> lineasVentaProducto = new ArrayList<>();
    ClienteDAO clienteDAO = new ClienteDAO();
    double montoTotalProducto = 0.0;
    int cantidadTotalVendida = 0;

    if (productoSeleccionado != null) {
        try {
            LVentaDAO lventaDAO = new LVentaDAO();
            VentaDAO ventaDAO = new VentaDAO();
            lineasVentaProducto = lventaDAO.obtenerLineasPorProducto(idProducto);

            Set<Integer> ventasIds = new HashSet<>();
            for (LVenta linea : lineasVentaProducto) {
                cantidadTotalVendida += linea.getUnidades();
                if (!ventasIds.contains(linea.getIdVenta())) {
                    Venta venta = ventaDAO.obtenerPorId(linea.getIdVenta());
                    if (venta != null) {
                        ventasConProducto.add(venta);
                        ventasIds.add(linea.getIdVenta());
                        montoTotalProducto += productoSeleccionado.getPrecio() * linea.getUnidades();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<body>
    <!-- NAVBAR -->
    <!-- ... navbar sin cambios ... -->

    <!-- PRODUCT DETAIL SECTION -->
    <section class="product-detail-section">
        <div class="container-fluid">
            <div class="row">
                <!-- Imagen Principal -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-images-section">
                        <img id="mainProductImage"
                             class="main-product-image"
                             src="assets/img/producto_<%= productoSeleccionado.getIdProducto() %>.jpg"
                             alt="<%= productoSeleccionado.getNombre() %>"
                             onerror="this.src='assets/img/default_product.jpg'">
                    </div>
                </div>

                <!-- Imágenes Secundarias -->
                <div class="col-lg-4 col-md-6">
                    <div class="secondary-images">
                        <% for (int i = 2; i <= 4; i++) { %>
                            <img class="secondary-image"
                                 src="assets/img/producto_<%= productoSeleccionado.getIdProducto() %>.<%= i %>.jpg"
                                 alt="<%= productoSeleccionado.getNombre() %> - Vista <%= i %>"
                                 onclick="changeMainImage(this.src)"
                                 onerror="this.style.display='none'">
                        <% } %>
                    </div>
                </div>

                <!-- Información del Producto -->
                <div class="col-lg-4">
                    <div class="product-info-section">
                        <h1 class="product-title"><%= productoSeleccionado.getNombre() %></h1>
                        <div class="product-price"><%= String.format("%.2f", productoSeleccionado.getPrecio()) %>€</div>

                        <!-- Colores -->
                        <div class="color-selection">
                            <label class="size-label">Color:</label>
                            <div class="color-circles">
                                <div class="color-circle black active" data-color="negro" title="Negro"></div>
                                <div class="color-circle gray" data-color="gris" title="Gris"></div>
                                <div class="color-circle white" data-color="blanco" title="Blanco"></div>
                                <div class="color-circle blue" data-color="azul" title="Azul"></div>
                            </div>
                        </div>

                        <!-- Tallas -->
                        <div class="size-selection">
                            <label class="size-label">Talla:</label>
                            <div class="size-buttons">
                                <% String[] tallas = {"XS", "S", "M", "L", "XL"}; 
                                   for (String t : tallas) { %>
                                    <button class="size-btn <%= "M".equals(t) ? "active" : "" %>" data-size="<%= t %>"><%= t %></button>
                                <% } %>
                            </div>
                        </div>

                        <!-- Descripción -->
                        <div class="product-description">
                            <p><%= productoSeleccionado.getDescripcion() %></p>
                        </div>

                       

                        <!-- Botón Agregar al Carrito -->
                        <form action="AddCarrito" method="POST">
                            <input type="hidden" name="id" value="<%= productoSeleccionado.getIdProducto() %>">
                            <input type="hidden" name="color" id="selectedColor" value="negro">
                            <input type="hidden" name="size" id="selectedSize" value="M">
                            <button type="submit" class="add-to-cart-btn">
                                Agregar al Carrito
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>

 <!-- RESUMEN DE VENTAS -->
                        <% if (productoSeleccionado != null) { %>
                            <section class="ventas-producto-section">
                                <div class="product-info-header">
                                    <div class="product-avatar-circle">
                                        <%= productoSeleccionado.getNombre().substring(0, Math.min(2, productoSeleccionado.getNombre().length())).toUpperCase() %>
                                    </div>
                                    <div class="product-details">
                                        <h3><%= productoSeleccionado.getNombre() %></h3>
                                        <p><%= productoSeleccionado.getDescripcion() %> - <%= String.format("%.2f", productoSeleccionado.getPrecio()) %> EUR</p>
                                    </div>
                                </div>

                                <div class="ventas-summary">
                                    <div class="summary-cards">
                                        <div class="summary-card">
                                            <i class="fas fa-shopping-cart summary-icon"></i>
                                            <div><h4><%= ventasConProducto.size() %></h4><p>Ventas realizadas</p></div>
                                        </div>
                                        <div class="summary-card">
                                            <i class="fas fa-boxes summary-icon"></i>
                                            <div><h4><%= cantidadTotalVendida %></h4><p>Unidades vendidas</p></div>
                                        </div>
                                        <div class="summary-card">
                                            <i class="fas fa-euro-sign summary-icon"></i>
                                            <div><h4><%= String.format("%.2f", montoTotalProducto) %> €</h4><p>Ingresos totales</p></div>
                                        </div>
                                    </div>
                                </div>

                                <% if (ventasConProducto.isEmpty()) { %>
                                    <div class="no-data">
                                        <i class="fas fa-chart-line"></i>
                                        <h5>Sin ventas registradas</h5>
                                        <p>Este producto no se ha vendido aún.</p>
                                    </div>
                                <% } else { %>
                                    <div class="ventas-list">
                                        <% for (int i = 0; i < ventasConProducto.size(); i++) {
                                            Venta venta = ventasConProducto.get(i);
                                            Cliente cliente = null;
                                            String nombreCliente = "Cliente no disponible";
                                            String dniCliente = "N/A";
                                            String estadoCliente = "";

                                            try {
                                                if (venta.getIdCliente() > 0) {
                                                    cliente = clienteDAO.obtenerPorId(venta.getIdCliente());
                                                    if (cliente != null) {
                                                        nombreCliente = cliente.getNombre();
                                                        if (cliente.getApellidos() != null) {
                                                            nombreCliente += " " + cliente.getApellidos();
                                                        }
                                                        dniCliente = cliente.getDni();
                                                        estadoCliente = "disponible";
                                                    } else {
                                                        nombreCliente = "⚠️ Cliente eliminado";
                                                        dniCliente = "ID: " + venta.getIdCliente();
                                                        estadoCliente = "eliminado";
                                                    }
                                                } else {
                                                    nombreCliente = "⚠️ Sin cliente asignado";
                                                    dniCliente = "Sin asignar";
                                                    estadoCliente = "sin-asignar";
                                                }
                                            } catch (Exception e) {
                                                nombreCliente = "❌ Error al cargar cliente";
                                                dniCliente = "Error";
                                                estadoCliente = "error";
                                            }

                                            LVenta lineaProducto = null;
                                            for (LVenta linea : lineasVentaProducto) {
                                                if (linea.getIdVenta() == venta.getIdVenta()) {
                                                    lineaProducto = linea;
                                                    break;
                                                }
                                            }

                                            if (lineaProducto != null) {
                                                double subtotalProducto = productoSeleccionado.getPrecio() * lineaProducto.getUnidades();
                                        %>
                                            <div class="venta-item" id="venta-<%= i %>">
                                                <div class="venta-header" onclick="toggleVentaDetalle(<%= i %>)">
                                                    <div>
                                                        <h5>Venta #<%= venta.getIdVenta() %></h5>
                                                        <p><%= venta.getFechaHora() != null ? venta.getFechaHora().toString() : "Sin fecha" %></p>
                                                    </div>
                                                    <div>
                                                        <strong><%= String.format("%.2f", subtotalProducto) %> €</strong>
                                                        <span>(<%= lineaProducto.getUnidades() %> uds)</span>
                                                    </div>
                                                    <i class="fas fa-chevron-down toggle-icon"></i>
                                                </div>
                                                <div class="venta-detalle" id="detalle-<%= i %>" style="display: none;">
                                                    <p><strong>Cliente:</strong>
                                                        <% if ("disponible".equals(estadoCliente) && cliente != null) { %>
                                                            <a href="clientes_listado.jsp?clienteId=<%= cliente.getIdCliente() %>">
                                                                <%= nombreCliente %> <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        <% } else { %>
                                                            <span class="cliente-no-disponible"><%= nombreCliente %></span>
                                                        <% } %>
                                                    </p>
                                                    <p><strong>DNI:</strong> <%= dniCliente %></p>
                                                </div>
                                            </div>
                                        <% } } %>
                                    </div>
                                <% } %>
                            </section>
                        <% } %>


    <!-- ===== RELATED PRODUCTS SECTION ===== -->
    <section class="related-products-section">
        <div class="container">
            <h2 class="section-title">Quizás También Te Guste</h2>
            <div class="products-grid">
                <%
                if (productosRelacionados != null && !productosRelacionados.isEmpty()) {
                    for (Producto prod : productosRelacionados) {
                %>
                    <div class="product-card">
                        <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>">
                            <img class="product-card-image" 
                                 src="assets/img/producto_<%= prod.getIdProducto() %>.jpg" 
                                 alt="<%= prod.getNombre() %>"
                                 onerror="this.src='assets/img/default_product.jpg'">
                        </a>
                        <div class="product-card-content">
                            <a href="ShopSingle.jsp?id=<%= prod.getIdProducto() %>" class="product-card-title">
                                <%= prod.getNombre() %>
                            </a>
                            <div class="product-card-price">
                                <%= String.format("%.2f", prod.getPrecio()) %>€
                            </div>
                        </div>
                    </div>
                <%
                    }
                }
                %>
            </div>
        </div>
    </section>

    <!-- ===== VIDEO SECTION ===== -->
    <section class="video-section">
        <video class="video-background" autoplay muted loop>
            <source src="./videos/productos-deportivos.mp4" type="video/mp4">
            <source src="./videos/lifestyle-brand.webm" type="video/webm">
        </video>
        <div class="video-overlay">
            <div class="video-content">
                <h2 class="video-title">Vive el Deporte</h2>
                <p class="video-subtitle">
                    Descubre tu potencial con nuestra colección premium de ropa deportiva diseñada para superar tus límites
                </p>
            </div>
        </div>
    </section>

    <!-- ===== FOOTER ===== -->
    <footer class="modern-footer">
        <div class="container">
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
                    <h4 class="footer-title">Newsletter</h4>
                    <p class="text-light opacity-75 mb-3">Suscríbete para recibir las últimas novedades y ofertas exclusivas.</p>
                </div>
            </div>

            <div class="border-top border-secondary mt-4 pt-4">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="text-light opacity-75 mb-0">
                            &copy; 2025 GÖT Sportwear. Todos los derechos reservados.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="assets/js/jquery-1.11.0.min.js"></script>
    <script src="assets/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/templatemo.js"></script>
    <script src="assets/js/custom.js"></script>
    


    <script>
        // Cambiar imagen principal
        function changeMainImage(src) {
            document.getElementById('mainProductImage').src = src;
        }

        // Selección de colores
        document.querySelectorAll('.color-circle').forEach(circle => {
            circle.addEventListener('click', function() {
                document.querySelectorAll('.color-circle').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                document.getElementById('selectedColor').value = this.dataset.color;
            });
        });

        // Selección de tallas
        document.querySelectorAll('.size-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                document.getElementById('selectedSize').value = this.dataset.size;
            });
        });
        
        function toggleVentaDetalle(index) {
        	  const detalle = document.getElementById(`detalle-${index}`);
        	  const ventaItem = document.getElementById(`venta-${index}`);
        	  const toggleIcon = ventaItem.querySelector('.toggle-icon');

        	  if (detalle.style.display === 'none' || detalle.style.display === '') {
        	    detalle.style.display = 'block';
        	    toggleIcon.style.transform = 'rotate(180deg)';
        	  } else {
        	    detalle.style.display = 'none';
        	    toggleIcon.style.transform = 'rotate(0deg)';
        	  }
        	}


        // ===== INICIALIZACIÓN AL CARGAR LA PÁGINA =====
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Inicializando funcionalidades de ventas...');
            
            // Verificar que existen los elementos
            const ventaItems = document.querySelectorAll('.venta-item');
            console.log('Items de venta encontrados:', ventaItems.length);
            
            // Configurar estado inicial de todos los detalles
            ventaItems.forEach((item, index) => {
                const detalle = document.getElementById(`detalle-${index}`);
                if (detalle) {
                    detalle.style.display = 'none';
                    detalle.style.transition = 'all 0.3s ease';
                }
            });
            
            // Animar entrada de cards de resumen si existen
            const summaryCards = document.querySelectorAll('.summary-card');
            if (summaryCards.length > 0) {
                summaryCards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        card.style.transition = 'all 0.5s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            }
            
            // Animar entrada de items de venta
            if (ventaItems.length > 0) {
                ventaItems.forEach((item, index) => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        item.style.transition = 'all 0.5s ease';
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }, (index * 100) + 200);
                });
            }
            
            // Efecto hover para product-info-header
            const productHeader = document.querySelector('.product-info-header');
            if (productHeader) {
                const avatar = productHeader.querySelector('.product-avatar-circle');
                if (avatar) {
                    avatar.style.transition = 'transform 0.3s ease';
                    
                    productHeader.addEventListener('mouseenter', function() {
                        avatar.style.transform = 'scale(1.05) rotate(5deg)';
                    });
                    
                    productHeader.addEventListener('mouseleave', function() {
                        avatar.style.transform = 'scale(1) rotate(0deg)';
                    });
                }
            }
            
            // Inicializar animación de estadísticas si existen
            setTimeout(animateStats, 500);
        });

        // ===== FUNCIÓN PARA ANIMAR ESTADÍSTICAS =====
        function animateStats() {
            const statValues = document.querySelectorAll('.summary-card h4');
            statValues.forEach(stat => {
                const finalText = stat.textContent;
                const numericMatch = finalText.match(/[\d.]+/);
                
                if (numericMatch) {
                    const finalValue = parseFloat(numericMatch[0]);
                    const hasEuro = finalText.includes('€');
                    let currentValue = 0;
                    const increment = finalValue / 30;
                    const duration = 1000; // 1 segundo
                    const intervalTime = duration / 30;
                    
                    const timer = setInterval(() => {
                        currentValue += increment;
                        if (currentValue >= finalValue) {
                            stat.textContent = finalText;
                            clearInterval(timer);
                        } else {
                            if (hasEuro) {
                                stat.textContent = currentValue.toFixed(2) + ' €';
                            } else {
                                stat.textContent = Math.floor(currentValue).toString();
                            }
                        }
                    }, intervalTime);
                }
            });
        }

        
        // Función para toggle del desplegable de ventas
           function toggleVentaDetalle(index) {
               const detalleDiv = document.getElementById('detalle-' + index);
               const toggleIcon = document.querySelector('#venta-' + index + ' .toggle-icon');
               const ventaItem = document.getElementById('venta-' + index);
               
               if (detalleDiv && toggleIcon) {
                   // Toggle de la visibilidad
                   if (detalleDiv.style.display === 'none' || detalleDiv.style.display === '') {
                       // Mostrar detalle
                       detalleDiv.style.display = 'block';
                       toggleIcon.classList.remove('fa-chevron-down');
                       toggleIcon.classList.add('fa-chevron-up');
                       ventaItem.classList.add('expanded');
                       
                       // Animación suave de aparición
                       detalleDiv.style.opacity = '0';
                       detalleDiv.style.transform = 'translateY(-10px)';
                       
                       setTimeout(() => {
                           detalleDiv.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                           detalleDiv.style.opacity = '1';
                           detalleDiv.style.transform = 'translateY(0)';
                       }, 10);
                       
                   } else {
                       // Ocultar detalle
                       detalleDiv.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                       detalleDiv.style.opacity = '0';
                       detalleDiv.style.transform = 'translateY(-10px)';
                       
                       setTimeout(() => {
                           detalleDiv.style.display = 'none';
                           toggleIcon.classList.remove('fa-chevron-up');
                           toggleIcon.classList.add('fa-chevron-down');
                           ventaItem.classList.remove('expanded');
                           detalleDiv.style.transition = '';
                       }, 300);
                   }
               }
           }

           // Función para expandir/contraer todas las ventas
           function toggleAllVentas(expandir = null) {
               const ventaItems = document.querySelectorAll('.venta-item');
               
               ventaItems.forEach((item, index) => {
                   const detalleDiv = document.getElementById('detalle-' + index);
                   const isVisible = detalleDiv && detalleDiv.style.display === 'block';
                   
                   if (expandir === true && !isVisible) {
                       toggleVentaDetalle(index);
                   } else if (expandir === false && isVisible) {
                       toggleVentaDetalle(index);
                   } else if (expandir === null) {
                       toggleVentaDetalle(index);
                   }
               });
           }

           // Función para inicializar el estado de los desplegables
           function initVentasToggle() {
               // Asegurar que todos los detalles estén ocultos al cargar
               const detallesDivs = document.querySelectorAll('[id^="detalle-"]');
               detallesDivs.forEach(detalle => {
                   detalle.style.display = 'none';
               });
               
               // Asegurar que todos los iconos estén en estado inicial
               const toggleIcons = document.querySelectorAll('.toggle-icon');
               toggleIcons.forEach(icon => {
                   icon.classList.remove('fa-chevron-up');
                   icon.classList.add('fa-chevron-down');
               });
               
               // Agregar eventos de teclado para accesibilidad
               const ventaHeaders = document.querySelectorAll('.venta-header');
               ventaHeaders.forEach((header, index) => {
                   header.setAttribute('tabindex', '0');
                   header.setAttribute('role', 'button');
                   header.setAttribute('aria-expanded', 'false');
                   header.setAttribute('aria-controls', 'detalle-' + index);
                   
                   header.addEventListener('keydown', function(e) {
                       if (e.key === 'Enter' || e.key === ' ') {
                           e.preventDefault();
                           toggleVentaDetalle(index);
                           this.setAttribute('aria-expanded', 
                               document.getElementById('detalle-' + index).style.display === 'block' ? 'true' : 'false'
                           );
                       }
                   });
               });
           }

           // Inicializar cuando el DOM esté listo
           document.addEventListener('DOMContentLoaded', function() {
               initVentasToggle();
               
               // Opcional: agregar botones para expandir/contraer todo
               addToggleAllButtons();
           });

           // Función opcional para agregar botones de expandir/contraer todo
           function addToggleAllButtons() {
               const ventasList = document.querySelector('.ventas-list');
               if (ventasList && document.querySelectorAll('.venta-item').length > 1) {
                   
                   // Crear contenedor de botones
                   const buttonsContainer = document.createElement('div');
                   buttonsContainer.className = 'ventas-toggle-buttons';
                   buttonsContainer.style.cssText = `
                       margin-bottom: 1rem;
                       text-align: right;
                       padding-bottom: 0.5rem;
                       border-bottom: 1px solid #e5e7eb;
                   `;
                   
                   // Botón expandir todo
                   const expandAllBtn = document.createElement('button');
                   expandAllBtn.innerHTML = '<i class="fas fa-expand-alt"></i> Expandir Todo';
                   expandAllBtn.className = 'btn-sm btn-outline';
                   expandAllBtn.style.cssText = `
                       margin-right: 0.5rem;
                       padding: 0.25rem 0.75rem;
                       font-size: 0.85rem;
                       border: 1px solid #d1d5db;
                       background: white;
                       color: #374151;
                       border-radius: 0.375rem;
                       cursor: pointer;
                       transition: all 0.2s;
                   `;
                   expandAllBtn.onclick = () => toggleAllVentas(true);
                   
                   // Botón contraer todo
                   const collapseAllBtn = document.createElement('button');
                   collapseAllBtn.innerHTML = '<i class="fas fa-compress-alt"></i> Contraer Todo';
                   collapseAllBtn.className = 'btn-sm btn-outline';
                   collapseAllBtn.style.cssText = expandAllBtn.style.cssText;
                   collapseAllBtn.onclick = () => toggleAllVentas(false);
                   
                   // Agregar efectos hover
                   [expandAllBtn, collapseAllBtn].forEach(btn => {
                       btn.addEventListener('mouseenter', function() {
                           this.style.backgroundColor = '#f9fafb';
                           this.style.borderColor = '#9ca3af';
                       });
                       btn.addEventListener('mouseleave', function() {
                           this.style.backgroundColor = 'white';
                           this.style.borderColor = '#d1d5db';
                       });
                   });
                   
                   buttonsContainer.appendChild(expandAllBtn);
                   buttonsContainer.appendChild(collapseAllBtn);
                   
                   // Insertar antes de la lista de ventas
                   ventasList.parentNode.insertBefore(buttonsContainer, ventasList);
               }
           }
        // Función mejorada para filtrar ventas por fecha
        function filtrarVentasPorFecha(fechaInicio, fechaFin) {
            const ventaItems = document.querySelectorAll('.venta-item');
            let visibleCount = 0;
            
            ventaItems.forEach((item, index) => {
                const fechaElement = item.querySelector('.venta-header p');
                if (!fechaElement) return;
                
                const fechaText = fechaElement.textContent.trim();
                const fecha = new Date(fechaText);
                
                if (!isNaN(fecha.getTime()) && 
                    fecha >= new Date(fechaInicio) && 
                    fecha <= new Date(fechaFin)) {
                    
                    item.style.display = 'block';
                    setTimeout(() => {
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }, visibleCount * 50);
                    visibleCount++;
                } else {
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        item.style.display = 'none';
                    }, 300);
                }
            });
            
            console.log(`Mostrando ${visibleCount} ventas en el rango de fechas`);
        }

        // Función para buscar ventas por cliente
        function buscarVentaPorCliente(nombreCliente) {
            const ventaItems = document.querySelectorAll('.venta-item');
            const searchTerm = nombreCliente.toLowerCase().trim();
            let foundCount = 0;
            
            if (searchTerm === '') {
                // Si no hay término de búsqueda, mostrar todos
                ventaItems.forEach(item => {
                    item.style.display = 'block';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                    item.classList.remove('highlight-search');
                });
                return;
            }
            
            ventaItems.forEach((item, index) => {
                const clienteElement = item.querySelector('.venta-detalle p');
                if (!clienteElement) return;
                
                const clienteText = clienteElement.textContent.toLowerCase();
                
                if (clienteText.includes(searchTerm)) {
                    item.style.display = 'block';
                    item.classList.add('highlight-search');
                    setTimeout(() => {
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }, foundCount * 50);
                    foundCount++;
                } else {
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(-10px)';
                    item.classList.remove('highlight-search');
                    setTimeout(() => {
                        item.style.display = 'none';
                    }, 300);
                }
            });
            
            console.log(`Encontradas ${foundCount} ventas para: "${nombreCliente}"`);
        }

        // Función para resetear filtros
        function resetearFiltros() {
            const ventaItems = document.querySelectorAll('.venta-item');
            ventaItems.forEach((item, index) => {
                item.style.display = 'block';
                item.classList.remove('highlight-search');
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 50);
            });
        }

        // Función de debugging
        function debugVentas() {
            console.group('Debug Ventas');
            console.log('Items de venta:', document.querySelectorAll('.venta-item').length);
            console.log('Cards de resumen:', document.querySelectorAll('.summary-card').length);
            console.log('Product header:', document.querySelector('.product-info-header') ? 'Encontrado' : 'No encontrado');
            
            const ventaItems = document.querySelectorAll('.venta-item');
            ventaItems.forEach((item, index) => {
                const detalle = document.getElementById(`detalle-${index}`);
                console.log(`Venta ${index}:`, {
                    item: item ? 'OK' : 'Missing',
                    detalle: detalle ? 'OK' : 'Missing',
                    display: detalle ? window.getComputedStyle(detalle).display : 'N/A'
                });
            });
            console.groupEnd();
        }
    </script>
    
    

</body>
</html>