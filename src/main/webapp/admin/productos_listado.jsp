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

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Productos - Got Admin</title>
    
    <!-- ====================================
         ARCHIVOS CSS EXTERNOS
         ==================================== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- ====================================
         ESTILOS CSS PERSONALIZADOS
         ==================================== -->
    <style>
        /* Variables CSS */
        :root {
            --primary-color: #6366f1;
            --secondary-color: #8b5cf6;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #06b6d4;
            --dark-color: #1f2937;
            --light-color: #f8fafc;
            --border-radius: 12px;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        /* Reset y Base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark-color);
        }

        /* ====================================
           LAYOUT PRINCIPAL
           ==================================== */

         /* Header */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: var(--shadow-md);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 0;
        }

        .logo {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--primary-color);
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logo:hover {
            color: var(--secondary-color);
            transform: scale(1.05);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            left: 0;
            top: 80px;
            width: 280px;
            height: calc(100vh - 80px);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: var(--shadow-lg);
            padding: 2rem 0;
            overflow-y: auto;
            z-index: 999;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 1rem;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 1rem;
            color: var(--dark-color);
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            transform: translateX(5px);
        }

        .sidebar-menu i {
            margin-right: 0.75rem;
            width: 20px;
        }

        /* Container principal */
        .container {
            margin-left: 280px;
            margin-top: 80px;
            padding: 2rem;
            width: calc(100% - 280px);
        }

        /* Header interno */
        .container .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 12px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            position: relative;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .container .header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin: 0;
        }

        /* Stats */
        .stats {
            background: var(--primary-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .stats:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .total-clients {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* ====================================
           LISTA DE PRODUCTOS
           ==================================== */

        .client-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .client-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            animation: fadeInUp 0.5s ease-out;
        }

        .client-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
            border-color: #667eea;
        }

        .client-avatar {
            flex-shrink: 0;
        }

        .client-avatar img {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            object-fit: cover;
            border: 3px solid #e2e8f0;
            transition: border-color 0.3s ease;
        }

        .client-card:hover .client-avatar img {
            border-color: #667eea;
        }

        .client-info {
            flex: 1;
            min-width: 0;
        }

        .client-name {
            margin-bottom: 8px;
        }

        .client-name h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 2px;
        }

        .client-dni {
            font-size: 13px;
            color: #718096;
            font-weight: 500;
        }

        .client-details {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .address {
            font-size: 14px;
            color: #4a5568;
            margin-bottom: 4px;
            font-weight: 600;
        }

        .location {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .postal-code,
        .province {
            font-size: 13px;
            color: #718096;
            background-color: #f7fafc;
            padding: 2px 8px;
            border-radius: 6px;
            font-weight: 500;
        }

        .province {
            background-color: #ebf8ff;
            color: #2b6cb0;
        }

        .client-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-shrink: 0;
        }

        .btn-edit,
        .btn-delete {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-edit {
            background-color: #edf2f7;
            color: #4a5568;
        }

        .btn-edit:hover {
            background-color: #667eea;
            color: white;
            transform: scale(1.1);
        }

        .btn-delete {
            background-color: #fed7d7;
            color: #e53e3e;
        }

        .btn-delete:hover {
            background-color: #e53e3e;
            color: white;
            transform: scale(1.1);
        }

        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status.active {
            background-color: #c6f6d5;
            color: #22543d;
        }

        /* ====================================
           MODAL STYLES
           ==================================== */

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            animation: fadeIn 0.3s ease-out;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-container {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
            animation: slideInUp 0.4s ease-out;
            position: relative;
            margin: 1rem;
            display: flex;
            flex-direction: column;
        }

        .modal-header {
            padding: 2rem 2rem 1rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .modal-title-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #6b7280;
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .modal-close:hover {
            background: #f3f4f6;
            color: var(--danger-color);
        }

        .modal-body {
            padding: 2rem;
            flex: 1;
            overflow-y: auto;
        }

        .modal-footer {
            padding: 1.5rem 2rem 2rem 2rem;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            flex-shrink: 0;
        }

        /* ====================================
           ESTILOS PARA VENTAS DE PRODUCTOS
           ==================================== */

        .product-info-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .product-avatar-circle {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            font-weight: bold;
            flex-shrink: 0;
        }

        .product-info-header .product-details {
            flex: 1;
        }

        .product-info-header .product-details h5 {
            margin: 0 0 4px 0;
            color: var(--dark-color);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .product-info-header .product-details p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .ventas-summary {
            margin-bottom: 2rem;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }

        .summary-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .summary-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .summary-content h4 {
            margin: 0;
            color: var(--dark-color);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .summary-content p {
            margin: 4px 0 0 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .no-data i {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }

        .no-data h5 {
            margin: 0 0 0.5rem 0;
            color: #6b7280;
        }

        .no-data p {
            margin: 0;
            font-size: 0.9rem;
        }

        .ventas-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .venta-item {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-bottom: 1rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .venta-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-color);
        }

        .venta-header {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }

        .venta-info h5 {
            margin: 0 0 4px 0;
            color: var(--dark-color);
            font-size: 1rem;
            font-weight: 600;
        }

        .venta-info p {
            margin: 0;
            color: #6c757d;
            font-size: 0.85rem;
        }

        .venta-monto {
            text-align: right;
        }

        .venta-monto .precio {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--success-color);
            margin: 0;
        }

        .venta-monto .estado {
            font-size: 0.75rem;
            background: var(--success-color);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            margin-top: 4px;
            display: inline-block;
        }

        .toggle-icon {
            color: #6c757d;
            font-size: 1rem;
            transition: transform 0.3s ease;
        }

        .venta-item.expanded .toggle-icon {
            transform: rotate(180deg);
        }

        .venta-detalle {
            display: none;
            padding: 1.5rem;
            background: #fafafa;
        }

        .venta-item.expanded .venta-detalle {
            display: block;
        }

        .detalle-header {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .linea-venta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .linea-venta:last-child {
            border-bottom: none;
        }

        .cliente-info {
            flex: 1;
        }

        .cliente-nombre {
            font-weight: 500;
            color: var(--dark-color);
            margin-bottom: 2px;
        }

        .cliente-dni {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .cantidad {
            background: var(--primary-color);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
            margin: 0 1rem;
        }

        .subtotal {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 80px;
            text-align: right;
        }

        /* ====================================
           FORM STYLES
           ==================================== */

        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .section-icon {
            color: var(--primary-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .required {
            color: var(--danger-color);
            margin-left: 3px;
        }

        .form-control-modern {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
            font-family: 'Inter', sans-serif;
        }

        .form-control-modern:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            background: white;
            transform: scale(1.02);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            width: 100%;
        }

        .form-help {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        /* ====================================
           BUTTON STYLES
           ==================================== */

        .btn-outline-modern {
            background: transparent;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            min-width: fit-content;
            text-decoration: none;
        }

        .btn-outline-modern:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-2px);
        }

        .btn-modern {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            min-width: fit-content;
        }

        .btn-modern:hover {
            filter: brightness(1.1);
            transform: translateY(-2px);
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }

        .btn-danger-modern {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .btn-danger-modern:hover {
            background: linear-gradient(135deg, #dc2626, #b91c1c);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        /* ====================================
           ANIMATIONS
           ==================================== */

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

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

        /* ====================================
           RESPONSIVE DESIGN
           ==================================== */

        @media (max-width: 768px) {
            .container {
                margin-left: 0;
                width: 100%;
                padding: 1rem;
            }
            
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .client-card {
                flex-direction: column;
                text-align: center;
                align-items: center;
                gap: 15px;
                padding: 15px;
            }
            
            .client-info {
                width: 100%;
                text-align: center;
            }
            
            .location {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .client-actions {
                justify-content: center;
                width: 100%;
            }

            .modal-container {
                width: 95%;
                margin: 0.5rem;
                max-width: none;
            }
            
            .summary-cards {
                grid-template-columns: 1fr;
            }
            
            .venta-header {
                flex-direction: column;
                text-align: center;
                gap: 0.5rem;
            }
            
            .linea-venta {
                flex-direction: column;
                text-align: center;
                gap: 0.5rem;
            }
            
            .cantidad {
                margin: 0;
            }
        }
        /* Estilos para el desplegable de ventas */
		.venta-item {
		    border: 1px solid #e5e7eb;
		    border-radius: 8px;
		    margin-bottom: 1rem;
		    background: white;
		    overflow: hidden;
		    transition: all 0.3s ease;
		}
		
		.venta-item:hover {
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		}
		
		.venta-item.expanded {
		    border-color: #3b82f6;
		    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);
		}
		
		.venta-header {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 1rem;
		    cursor: pointer;
		    background: #fafafa;
		    transition: background-color 0.2s ease;
		    user-select: none;
		}
		
		.venta-header:hover {
		    background: #f0f9ff;
		}
		
		.venta-header:focus {
		    outline: 2px solid #3b82f6;
		    outline-offset: -2px;
		}
		
		.venta-item.expanded .venta-header {
		    background: #eff6ff;
		}
		
		.venta-info h5 {
		    margin: 0 0 0.25rem 0;
		    font-size: 1.1rem;
		    font-weight: 600;
		    color: #1f2937;
		}
		
		.venta-info p {
		    margin: 0;
		    font-size: 0.9rem;
		    color: #6b7280;
		}
		
		.venta-monto {
		    text-align: right;
		}
		
		.venta-monto .precio {
		    font-size: 1.1rem;
		    font-weight: 600;
		    color: #059669;
		    margin-bottom: 0.25rem;
		}
		
		.venta-monto .estado {
		    font-size: 0.85rem;
		    color: #6b7280;
		    background: #f3f4f6;
		    padding: 0.25rem 0.5rem;
		    border-radius: 12px;
		}
		
		.toggle-icon {
		    margin-left: 1rem;
		    color: #6b7280;
		    transition: all 0.3s ease;
		    font-size: 0.9rem;
		}
		
		.venta-item.expanded .toggle-icon {
		    color: #3b82f6;
		    transform: rotate(180deg);
		}
		
		.venta-detalle {
		    display: none;
		    padding: 0 1rem 1rem 1rem;
		    background: #ffffff;
		    border-top: 1px solid #f3f4f6;
		}
		
		.detalle-header {
		    font-weight: 600;
		    color: #374151;
		    margin-bottom: 0.75rem;
		    font-size: 0.95rem;
		}
		
		.linea-venta {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 0.75rem;
		    background: #f9fafb;
		    border-radius: 6px;
		    margin-bottom: 0.5rem;
		}
		
		.cliente-info {
		    flex: 1;
		}
		
		.cliente-nombre {
		    font-weight: 500;
		    color: #1f2937;
		    margin-bottom: 0.25rem;
		}
		
		.cliente-dni {
		    font-size: 0.85rem;
		    color: #6b7280;
		}
		
		.cantidad {
		    font-weight: 600;
		    color: #374151;
		    margin: 0 1rem;
		    padding: 0.25rem 0.5rem;
		    background: #e5e7eb;
		    border-radius: 4px;
		    font-size: 0.9rem;
		}
		
		.subtotal {
		    font-weight: 600;
		    color: #059669;
		    font-size: 1rem;
		}
		
		/* Estilos para los botones de expandir/contraer todo */
		.ventas-toggle-buttons {
		    margin-bottom: 1rem;
		    text-align: right;
		    padding-bottom: 0.5rem;
		    border-bottom: 1px solid #e5e7eb;
		}
		
		.ventas-toggle-buttons button {
		    margin-left: 0.5rem;
		    padding: 0.4rem 0.8rem;
		    font-size: 0.85rem;
		    border: 1px solid #d1d5db;
		    background: white;
		    color: #374151;
		    border-radius: 0.375rem;
		    cursor: pointer;
		    transition: all 0.2s ease;
		}
		
		.ventas-toggle-buttons button:hover {
		    background: #f9fafb;
		    border-color: #9ca3af;
		}
		
		.ventas-toggle-buttons button:active {
		    background: #f3f4f6;
		}
		
		.ventas-toggle-buttons button i {
		    margin-right: 0.5rem;
		}
		
		/* Animaciones mejoradas */
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
		
		@keyframes slideUp {
		    from {
		        opacity: 1;
		        transform: translateY(0);
		    }
		    to {
		        opacity: 0;
		        transform: translateY(-10px);
		    }
		}
		
		.venta-detalle.show {
		    animation: slideDown 0.3s ease forwards;
		}
		
		.venta-detalle.hide {
		    animation: slideUp 0.3s ease forwards;
		}
		
		/* Responsive design */
		@media (max-width: 768px) {
		    .venta-header {
		        flex-direction: column;
		        align-items: flex-start;
		        gap: 0.5rem;
		    }
		    
		    .linea-venta {
		        flex-direction: column;
		        align-items: flex-start;
		        gap: 0.5rem;
		    }
		    
		    .cantidad, .subtotal {
		        align-self: flex-end;
		    }
		    
		    .ventas-toggle-buttons {
		        text-align: center;
		    }
		    
		    .ventas-toggle-buttons button {
		        display: block;
		        width: 100%;
		        margin: 0.25rem 0;
		    }
		}
		
			/* Estados de accesibilidad */
			.venta-header[tabindex]:focus {
			    outline: 2px solid #3b82f6;
			    outline-offset: 2px;
			}
			
			/* Mejoras visuales adicionales */
			.venta-item:first-child {
			    margin-top: 0;
			}
			
			.venta-item:last-child {
			    margin-bottom: 0;
			}
			
			.no-data {
			    text-align: center;
			    padding: 2rem;
			    color: #6b7280;
			}
			
			.no-data i {
			    font-size: 3rem;
			    margin-bottom: 1rem;
			    color: #d1d5db;
			}
			
			.no-data h5 {
			    margin-bottom: 0.5rem;
			    color: #374151;
			}
			
			.no-data p {
			    margin: 0;
			    font-size: 0.9rem;
			}
			/* =============================================
	   ESTILOS PARA CLIENTES CON PROBLEMAS
	   ============================================= */
	
		/* Cliente eliminado */
		.linea-venta.cliente-eliminado {
		    border-left: 4px solid #f59e0b;
		    background-color: #fffbeb;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-eliminado .cliente-nombre {
		    color: #d97706;
		    font-weight: 500;
		}
		
		/* Cliente con error */
		.linea-venta.cliente-error {
		    border-left: 4px solid #ef4444;
		    background-color: #fef2f2;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-error .cliente-nombre {
		    color: #dc2626;
		    font-weight: 500;
		}
		
		/* Cliente sin asignar */
		.linea-venta.cliente-sin-asignar {
		    border-left: 4px solid #6b7280;
		    background-color: #f9fafb;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-sin-asignar .cliente-nombre {
		    color: #6b7280;
		    font-weight: 500;
		}
		
		/* =============================================
		   MEJORAS VISUALES ADICIONALES
		   ============================================= */
		
		/* Header del producto */
		.product-info-header {
		    display: flex;
		    align-items: center;
		    gap: 1rem;
		    margin-bottom: 1.5rem;
		    padding: 1rem;
		    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
		    border-radius: 12px;
		    border: 1px solid #e2e8f0;
		}
		
		.product-avatar-circle {
		    width: 60px;
		    height: 60px;
		    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
		    border-radius: 50%;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    color: white;
		    font-weight: 600;
		    font-size: 1.2rem;
		    text-transform: uppercase;
		    flex-shrink: 0;
		    box-shadow: 0 4px 8px rgba(59, 130, 246, 0.25);
		}
		
		.product-details h5 {
		    margin: 0 0 0.25rem 0;
		    font-size: 1.25rem;
		    font-weight: 600;
		    color: #1f2937;
		}
		
		.product-details p {
		    margin: 0;
		    font-size: 0.9rem;
		    color: #6b7280;
		}
		
		/* Mejorar los iconos de información */
		.detalle-header {
		    position: relative;
		    padding-bottom: 0.5rem;
		    margin-bottom: 1rem;
		    font-weight: 600;
		    color: #374151;
		}
		
		.detalle-header::after {
		    content: '';
		    position: absolute;
		    bottom: 0;
		    left: 0;
		    width: 40px;
		    height: 2px;
		    background: linear-gradient(90deg, #3b82f6, #1d4ed8);
		    border-radius: 1px;
		}
		
		/* Efectos hover mejorados */
		.linea-venta:hover {
		    transform: translateX(4px);
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		    transition: all 0.2s ease;
		}
		
		/* Información adicional de precio histórico */
		.precio-historico-info {
		    margin-top: 0.75rem;
		    padding: 0.5rem;
		    background: #fef3c7;
		    border: 1px solid #f59e0b;
		    border-radius: 4px;
		    font-size: 0.85rem;
		    color: #92400e;
		}
		
		.precio-historico-info i {
		    margin-right: 0.5rem;
		}
		
		/* Estados del cliente en la información */
		.cliente-info .cliente-nombre {
		    font-weight: 500;
		    margin-bottom: 0.25rem;
		    line-height: 1.3;
		}
		
		.cliente-info .cliente-dni {
		    font-size: 0.85rem;
		    color: #6b7280;
		}
		
		/* Responsive improvements */
		@media (max-width: 768px) {
		    .product-info-header {
		        flex-direction: column;
		        text-align: center;
		        gap: 0.75rem;
		    }
		    
		    .linea-venta {
		        flex-direction: column;
		        align-items: flex-start;
		        gap: 0.5rem;
		        padding: 1rem;
		    }
		    
		    .cantidad, .subtotal {
		        align-self: flex-end;
		    }
		}
		
		/* Animaciones suaves */
		.linea-venta {
		    transition: all 0.2s ease;
		}
		
		.cliente-nombre small {
		    animation: fadeIn 0.3s ease;
		}
		
		@keyframes fadeIn {
		    from { opacity: 0; transform: translateY(-5px); }
		    to { opacity: 1; transform: translateY(0); }
		}
				/* =============================================
		   ESTILOS PARA ENLACES DE CLIENTE
		   ============================================= */
		
		/* Enlace del cliente */
		.cliente-link {
		    color: #3b82f6;
		    text-decoration: none;
		    font-weight: 500;
		    transition: all 0.2s ease;
		    display: inline-flex;
		    align-items: center;
		    gap: 0.5rem;
		    padding: 0.25rem 0.5rem;
		    border-radius: 6px;
		    background: rgba(59, 130, 246, 0.05);
		    border: 1px solid transparent;
		}
		
		.cliente-link:hover {
		    color: #1d4ed8;
		    background: rgba(59, 130, 246, 0.1);
		    border-color: rgba(59, 130, 246, 0.2);
		    transform: translateX(2px);
		    text-decoration: none;
		}
		
		.cliente-link:active {
		    transform: translateX(1px);
		    background: rgba(59, 130, 246, 0.15);
		}
		
		.cliente-link i:first-child {
		    font-size: 0.9em;
		    color: #6b7280;
		}
		
		.cliente-link i:last-child {
		    font-size: 0.75em;
		    opacity: 0.7;
		    transition: opacity 0.2s ease;
		}
		
		.cliente-link:hover i:last-child {
		    opacity: 1;
		}
		
		/* Cliente no disponible */
		.cliente-no-disponible {
		    color: #6b7280;
		    font-weight: 500;
		}
		
		/* Cliente eliminado */
		.linea-venta.cliente-eliminado {
		    border-left: 4px solid #f59e0b;
		    background-color: #fffbeb;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-eliminado .cliente-nombre {
		    color: #d97706;
		    font-weight: 500;
		}
		
		/* Cliente con error */
		.linea-venta.cliente-error {
		    border-left: 4px solid #ef4444;
		    background-color: #fef2f2;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-error .cliente-nombre {
		    color: #dc2626;
		    font-weight: 500;
		}
		
		/* Cliente sin asignar */
		.linea-venta.cliente-sin-asignar {
		    border-left: 4px solid #6b7280;
		    background-color: #f9fafb;
		    border-radius: 6px;
		}
		
		.linea-venta.cliente-sin-asignar .cliente-nombre {
		    color: #6b7280;
		    font-weight: 500;
		}
		
		/* =============================================
		   MEJORAS VISUALES ADICIONALES
		   ============================================= */
		
		/* Header del producto */
		.product-info-header {
		    display: flex;
		    align-items: center;
		    gap: 1rem;
		    margin-bottom: 1.5rem;
		    padding: 1rem;
		    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
		    border-radius: 12px;
		    border: 1px solid #e2e8f0;
		}
		
		.product-avatar-circle {
		    width: 60px;
		    height: 60px;
		    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
		    border-radius: 50%;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    color: white;
		    font-weight: 600;
		    font-size: 1.2rem;
		    text-transform: uppercase;
		    flex-shrink: 0;
		    box-shadow: 0 4px 8px rgba(59, 130, 246, 0.25);
		}
		
		.product-details h5 {
		    margin: 0 0 0.25rem 0;
		    font-size: 1.25rem;
		    font-weight: 600;
		    color: #1f2937;
		}
		
		.product-details p {
		    margin: 0;
		    font-size: 0.9rem;
		    color: #6b7280;
		}
		
		/* Mejorar los iconos de información */
		.detalle-header {
		    position: relative;
		    padding-bottom: 0.5rem;
		    margin-bottom: 1rem;
		    font-weight: 600;
		    color: #374151;
		}
		
		.detalle-header::after {
		    content: '';
		    position: absolute;
		    bottom: 0;
		    left: 0;
		    width: 40px;
		    height: 2px;
		    background: linear-gradient(90deg, #3b82f6, #1d4ed8);
		    border-radius: 1px;
		}
		
		/* Efectos hover mejorados */
		.linea-venta:hover {
		    transform: translateX(4px);
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		    transition: all 0.2s ease;
		}
		
		/* Información adicional de precio histórico */
		.precio-historico-info {
		    margin-top: 0.75rem;
		    padding: 0.5rem;
		    background: #fef3c7;
		    border: 1px solid #f59e0b;
		    border-radius: 4px;
		    font-size: 0.85rem;
		    color: #92400e;
		}
		
		.precio-historico-info i {
		    margin-right: 0.5rem;
		}
		
		/* Estados del cliente en la información */
		.cliente-info .cliente-nombre {
		    font-weight: 500;
		    margin-bottom: 0.25rem;
		    line-height: 1.3;
		}
		
		.cliente-info .cliente-dni {
		    font-size: 0.85rem;
		    color: #6b7280;
		}
		
		/* Responsive improvements */
		@media (max-width: 768px) {
		    .product-info-header {
		        flex-direction: column;
		        text-align: center;
		        gap: 0.75rem;
		    }
		    
		    .linea-venta {
		        flex-direction: column;
		        align-items: flex-start;
		        gap: 0.5rem;
		        padding: 1rem;
		    }
		    
		    .cantidad, .subtotal {
		        align-self: flex-end;
		    }
		}
		
		/* Animaciones suaves */
		.linea-venta {
		    transition: all 0.2s ease;
		}
		
		.cliente-nombre small {
		    animation: fadeIn 0.3s ease;
		}
		
		@keyframes fadeIn {
		    from { opacity: 0; transform: translateY(-5px); }
		    to { opacity: 1; transform: translateY(0); }
		}
    </style>
</head>

<body>


<%
// ====================================
// LÓGICA DE DATOS Y PROCESAMIENTO
// ====================================

// Variables de mensajes
String mensaje = request.getParameter("mensaje");
String tipo = request.getParameter("tipo");



// Obtener datos de productos
ProductoDAO productoListaDAO = new ProductoDAO();
ArrayList<Producto> productos = productoListaDAO.listarTodos();

// Variables para el modal de ventas de productos
String productoIdVentas = request.getParameter("productoId");
ArrayList<LVenta> lineasVentaProducto = new ArrayList<>();
ArrayList<Venta> ventasConProducto = new ArrayList<>(); 
ClienteDAO clienteDAO = new ClienteDAO();
VentaDAO ventaDAO = new VentaDAO();
double montoTotalProducto = 0.0;
int cantidadTotalVendida = 0;

// Procesamiento de ventas si se solicita ver ventas de un producto específico
if (productoIdVentas != null && !productoIdVentas.trim().isEmpty()) {
    try {
        LVentaDAO lventaDAO = new LVentaDAO();
        
        // Obtener todas las líneas de venta que contienen este producto
        lineasVentaProducto = lventaDAO.obtenerLineasPorProducto(Integer.parseInt(productoIdVentas));
        
        // Para cada línea de venta, obtener la información de la venta y calcular totales
        Set<Integer> ventasIds = new HashSet<>();
        for (LVenta linea : lineasVentaProducto) {
            cantidadTotalVendida += linea.getUnidades(); // Corregido: usar getUnidades() en lugar de getCantidad()
            
            // Evitar duplicados de ventas
            if (!ventasIds.contains(linea.getIdVenta())) {
                Venta venta = ventaDAO.obtenerPorId(linea.getIdVenta());
                if (venta != null) {
                    ventasConProducto.add(venta);
                    ventasIds.add(linea.getIdVenta());
                    
                    // Calcular solo el monto correspondiente a este producto en esta venta
                    Producto prod = productoListaDAO.obtenerPorId(Integer.parseInt(productoIdVentas));
                    if (prod != null) {
                        montoTotalProducto += (prod.getPrecio() * linea.getUnidades()); // Corregido: usar getUnidades()
                    }
                }
            }
        }
    } catch (Exception e) {
        // Error al cargar ventas - continuar sin ventas
        e.printStackTrace();
    }
}
%>
    <!-- ====================================
         MENSAJES DE ALERTA
         ==================================== -->
    <% if (mensaje != null) { %>
        <div class="alert <%= "success".equals(tipo) ? "alert-success" : "alert-danger" %>">
            <%= mensaje %>
        </div>
    <% } %>
    
    
    

    <!-- ====================================
         HEADER PRINCIPAL
         ==================================== -->
    <header class="header">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <a href="../Index.jsp" class="logo" title="Ir al inicio">Got Admin</a>
                <div class="user-info">
                    <span class="fw-bold">Admin User</span>
                    <div class="user-avatar">AU</div>
                </div>
            </div>
        </div>
    </header>
    <!-- ====================================
         SIDEBAR DE NAVEGACIÓN
         ==================================== -->
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="clientes_listado.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li><a href="productos_listado.jsp" class="active"><i class="fas fa-box"></i> Productos</a></li>
            <li><a href="ventas_listado.jsp"><i class="fas fa-shopping-cart"></i> Ventas</a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i> Reportes</a></li>
        </ul>
    </aside>

    <!-- ====================================
         CONTAINER PRINCIPAL
         ==================================== -->
    <div class="container">
        <!-- Header Interno -->
        <header class="header">
            <h1>Lista de Productos</h1>
            <div class="stats">
                <span class="total-clients" onclick="openProductModal()">
                    <i class="fas fa-plus"></i> Agregar Producto
                </span>
            </div>
        </header>

        <!-- ====================================
             LISTA DE PRODUCTOS
             ==================================== -->
             
        <div class="client-list">
            <% for (Producto prod : productos) { %>
                <div class="client-card">
                    <div class="client-avatar">
                        <img class="product-main-image" 
                             src="../assets/img/producto_<%= prod.getIdProducto() %>.jpg" 
                             alt="<%= prod.getNombre() %>" 
                             onerror="this.src='../assets/img/default_product.jpg'">
                    </div>
                    <div class="client-info">
                        <div class="client-name">
                            <h3><%= prod.getNombre() %></h3>
                            <span class="client-dni">Descripción: <%= prod.getDescripcion() %></span>
                        </div>
                        <div class="client-details">
                            <p class="address"><%= String.format("%.2f", prod.getPrecio()) %> EUR</p>
                            <div class="location">
                                <span class="postal-code">Stock: <%= prod.getStock()%></span>
                                <span class="province"><%= prod.getCategoria() != null ? prod.getCategoria() : "Sin categoría" %></span>
                            </div>
                        </div>
                    </div>
                    
                    
                    <div class="client-actions">
                        <button class="btn-edit" 
                                title="Editar producto" 
                                onclick="openEditProductModal(this)"
                                data-id="<%= prod.getIdProducto() %>"
                                data-nombre="<%= prod.getNombre() %>"
                                data-descripcion="<%= prod.getDescripcion() %>"
                                data-precio="<%= prod.getPrecio() %>"
                                data-stock="<%= prod.getStock() %>"
                                data-categoria="<%= prod.getCategoria() != null ? prod.getCategoria() : "" %>">
                            <i class="fas fa-edit"></i>
                        </button>

                        <button class="btn-delete" 
                                title="Eliminar producto" 
                                onclick="openDeleteProductModal(this)"
                                data-id="<%= prod.getIdProducto() %>"
                                data-nombre="<%= prod.getNombre() %>"
                                data-precio="<%= prod.getPrecio() %>">
                            <i class="fas fa-trash"></i>
                        </button>

                        <!-- BOTÓN VER VENTAS DEL PRODUCTO -->
                        <form method="get" action="productos_listado.jsp" style="margin: 0;">
                            <input type="hidden" name="productoId" value="<%= prod.getIdProducto() %>"/>
                            <button type="submit" class="status active" 
                                    style="border: none; cursor: pointer; transition: all 0.3s ease;">
                                Ver Ventas
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

<!-- ====================================
     MODAL DE VENTAS DEL PRODUCTO
     ==================================== -->
<% if (productoIdVentas != null && !productoIdVentas.trim().isEmpty()) { 
    // Buscar información del producto seleccionado
    Producto productoSeleccionado = null;
    for (Producto p : productos) {
        if (String.valueOf(p.getIdProducto()).equals(productoIdVentas)) {
            productoSeleccionado = p;
            break;
        }
    }
%>
<div class="modal-overlay show" id="ventasProductModal">
    <div class="modal-container">
        <div class="modal-header">
            <div class="modal-title">
                <div class="modal-title-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                Ventas del Producto
            </div>
            <a href="productos_listado.jsp" class="modal-close" title="Cerrar">
                <i class="fas fa-times"></i>
            </a>
        </div>
        
        <div class="modal-body">
            <% if (productoSeleccionado != null) { %>
                <!-- Información del Producto Header -->
                <div class="product-info-header">
                    <div class="product-avatar-circle">
                        <%= productoSeleccionado.getNombre().substring(0, Math.min(2, productoSeleccionado.getNombre().length())).toUpperCase() %>
                    </div>
                    <div class="product-details">
                        <h5><%= productoSeleccionado.getNombre() %></h5>
                        <p><%= productoSeleccionado.getDescripcion() %> - <%= String.format("%.2f", productoSeleccionado.getPrecio()) %> EUR</p>
                    </div>
                </div>
            <% } %>

            <!-- Resumen de ventas del producto -->
            <div class="ventas-summary">
                <div class="summary-cards">
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= ventasConProducto.size() %></h4>
                            <p>Ventas Realizadas</p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-boxes"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= cantidadTotalVendida %></h4>
                            <p>Unidades Vendidas</p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-euro-sign"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= String.format("%.2f", montoTotalProducto) %> €</h4>
                            <p>Ingresos Totales</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lista de ventas -->
            <% if (ventasConProducto.isEmpty()) { %>
                <div class="no-data">
                    <i class="fas fa-chart-line"></i>
                    <h5>Sin ventas registradas</h5>
                    <p>Este producto no se ha vendido aún.</p>
                </div>
            <% } else { %>
                <div class="ventas-list">
                    <% 
                    for (int i = 0; i < ventasConProducto.size(); i++) { 
                        Venta venta = ventasConProducto.get(i);
                        
                        // ===== LÓGICA MEJORADA PARA MANEJO DE CLIENTES =====
                        Cliente cliente = null;
                        String nombreCliente = "Cliente no disponible";
                        String dniCliente = "N/A";
                        String estadoCliente = "";
                        
                        try {
                            if (venta.getIdCliente() > 0) {
                                cliente = clienteDAO.obtenerPorId(venta.getIdCliente());
                                if (cliente != null) {
                                    nombreCliente = cliente.getNombre();
                                    if (cliente.getApellidos() != null && !cliente.getApellidos().trim().isEmpty()) {
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
                        
                        // Obtener la línea de venta específica de este producto en esta venta
                        LVenta lineaProducto = null;
                        for (LVenta linea : lineasVentaProducto) {
                            if (linea.getIdVenta() == venta.getIdVenta()) {
                                lineaProducto = linea;
                                break;
                            }
                        }
                        
                        if (lineaProducto != null) {
                            // ===== LÓGICA MEJORADA PARA CÁLCULO DE SUBTOTAL =====
                            double subtotalProducto = 0.0;
                            if (productoSeleccionado != null) {
                                subtotalProducto = productoSeleccionado.getPrecio() * lineaProducto.getUnidades();
                            } else {
                                // Fallback: usar precio de la línea de venta
                                subtotalProducto = lineaProducto.getPrecioUnidad() * lineaProducto.getUnidades();
                            }
                    %>
                    <div class="venta-item" id="venta-<%= i %>">
                        <div class="venta-header" onclick="toggleVentaDetalle(<%= i %>)">
                            <div class="venta-info">
                                <h5>Venta #<%= venta.getIdVenta() %></h5>
                                <p>Fecha :<%= venta.getFechaHora() != null ? venta.getFechaHora().toString() : "Sin fecha" %></p>
                            </div>
                            <div class="venta-monto">
                                <div class="precio"><%= String.format("%.2f", subtotalProducto) %> €</div>
                                <span class="estado"><%= lineaProducto.getUnidades() %> unidades</span>
                            </div>
                            <i class="fas fa-chevron-down toggle-icon"></i>
                        </div>
                        
                        <div class="venta-detalle" id="detalle-<%= i %>">
                            <div class="detalle-header">Información de la venta:</div>
                            <div class="linea-venta <%= estadoCliente.equals("eliminado") ? "cliente-eliminado" : 
                                                        estadoCliente.equals("error") ? "cliente-error" : 
                                                        estadoCliente.equals("sin-asignar") ? "cliente-sin-asignar" : "" %>">
                                <div class="cliente-info">
                                    <div class="cliente-nombre">
                                        <% if (estadoCliente.equals("disponible") && cliente != null) { %>
                                            <!-- Cliente disponible - crear enlace -->
                                            <a href="clientes_listado.jsp?clienteId=<%= cliente.getIdCliente() %>" 
                                               class="cliente-link"
                                               title="Ver detalles del cliente">
                                                <i class="fas fa-user"></i>
                                                <%= nombreCliente %>
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                        <% } else { %>
                                            <!-- Cliente no disponible - sin enlace -->
                                            <span class="cliente-no-disponible">
                                                <%= nombreCliente %>
                                            </span>
                                        <% } %>
                                        <% if (estadoCliente.equals("eliminado") || estadoCliente.equals("error")) { %>
                                            <small style="display: block; font-size: 0.8em; color: #dc2626; font-weight: normal;">
                                                <% if (estadoCliente.equals("eliminado")) { %>
                                                    Este cliente fue eliminado del sistema
                                                <% } else { %>
                                                    Error al acceder a los datos del cliente
                                                <% } %>
                                            </small>
                                        <% } %>
                                    </div>
                                    <div class="cliente-dni">DNI: <%= dniCliente %></div>
                                </div>
                                <div class="cantidad">x<%= lineaProducto.getUnidades() %></div>
                                <div class="subtotal"><%= String.format("%.2f", subtotalProducto) %> €</div>
                            </div>
                            </div>
                        </div>
                    </div>
                    <% 
                        }
                    } %>
                </div>
            <% } %>
        </div>
        
        <div class="modal-footer">
            <a href="productos_listado.jsp" class="btn-outline-modern">
                <i class="fas fa-arrow-left"></i>
                Volver a Productos
            </a>
        </div>
    </div>
</div>
<% } %>

    <!-- ====================================
         MODAL ELIMINAR PRODUCTO
         ==================================== -->
    <div class="modal-overlay" id="deleteProductModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <i class="fas fa-box-open"></i>
                    </div>
                    Eliminar Producto
                </div>
                <button class="modal-close" onclick="closeDeleteProductModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información del Producto Header -->
                <div class="product-info-header">
                    <div class="product-avatar-circle" id="deleteProductAvatar">PR</div>
                    <div class="product-details">
                        <h5 id="deleteProductName">Nombre del Producto</h5>
                        <p id="deleteProductPrice">Precio: 0.00 EUR</p>
                    </div>
                </div>

                <!-- Advertencia de eliminación -->
                <div style="background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); border: 1px solid #fecaca; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem; display: flex; gap: 1rem; align-items: flex-start;">
                    <div style="width: 50px; height: 50px; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; flex-shrink: 0;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div style="flex: 1;">
                        <h4 style="color: #991b1b; font-size: 1.1rem; font-weight: 600; margin: 0 0 0.75rem 0;">¿Está seguro que desea eliminar este producto?</h4>
                        <p style="color: #7f1d1d; margin: 0 0 0.75rem 0; line-height: 1.5;">Esta acción <strong>no se puede deshacer</strong>. Se eliminará permanentemente:</p>
                        <ul style="color: #7f1d1d; margin: 0 0 0.75rem 1.25rem; padding: 0;">
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Toda la información del producto</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Historial de ventas asociado</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Cualquier dato relacionado en el sistema</li>
                        </ul>
                    </div>
                </div>

                <!-- Formulario oculto para eliminación -->
                <form id="deleteProductForm" method="POST" action="producto_eliminar.jsp" style="display: none;">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" id="deleteProductIdHidden" name="id" value="">
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeDeleteProductModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="button" class="btn-modern btn-danger-modern" onclick="confirmDeleteProduct()">
                    <i class="fas fa-trash"></i>
                    Eliminar Producto
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         MODAL MODIFICAR PRODUCTO
         ==================================== -->
    <div class="modal-overlay" id="editProductModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    Modificar Producto
                </div>
                <button class="modal-close" onclick="closeEditProductModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información del Producto Header -->
                <div class="product-info-header" id="productInfoHeader" style="display: none;">
                    <div class="product-avatar-circle" id="productAvatar">PR</div>
                    <div class="product-details">
                        <h5 id="productName">Nombre del Producto</h5>
                        <p id="productDescription">Descripción del producto</p>
                    </div>
                </div>

                <!-- Formulario de Modificación -->
                <form id="editProductForm" method="POST" action="producto_modificar.jsp">
                    <input type="hidden" name="accion" value="modificar">
                    <input type="hidden" id="editProductIdHidden" name="id" value="">
                    
                    <!-- Sección: Información del Producto -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-box section-icon"></i>
                            Información del Producto
                        </h4>
                        
                        <div class="form-group">
                            <label for="editNombre" class="form-label">
                                Nombre del Producto <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editNombre" 
                                   name="nombre" 
                                   placeholder="Nombre del producto"
                                   required 
                                   maxlength="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="editDescripcion" class="form-label">
                                Descripción <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editDescripcion" 
                                   name="descripcion" 
                                   placeholder="Descripción del producto"
                                   required 
                                   maxlength="255">
                        </div>
                    </div>

                    <!-- Sección: Precio y Stock -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-euro-sign section-icon"></i>
                            Precio y Stock
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="editPrecio" class="form-label">
                                    Precio (EUR) <span class="required">*</span>
                                </label>
                                <input type="number" 
                                       class="form-control-modern" 
                                       id="editPrecio" 
                                       name="precio" 
                                       placeholder="0.00"
                                       step="0.01"
                                       min="0"
                                       required>
                            </div>
                            
                            <div class="form-group">
                                <label for="editStock" class="form-label">
                                    Stock <span class="required">*</span>
                                </label>
                                <input type="number" 
                                       class="form-control-modern" 
                                       id="editStock" 
                                       name="stock" 
                                       placeholder="0"
                                       min="0"
                                       required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="editCategoria" class="form-label">Categoría</label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editCategoria" 
                                   name="categoria" 
                                   placeholder="Categoría del producto"
                                   maxlength="100">
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeEditProductModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="submit" form="editProductForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Guardar Cambios
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         MODAL AGREGAR PRODUCTO
         ==================================== -->
    <div class="modal-overlay" id="productModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                    Agregar Nuevo Producto
                </div>
                <button class="modal-close" onclick="closeProductModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Formulario de agregar producto -->
                <form id="productoForm" method="POST" action="producto_guardar.jsp">
                    <input type="hidden" name="action" value="agregarProducto">
                    
                    <!-- Sección: Información del Producto -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-box section-icon"></i>
                            Información del Producto
                        </h4>
                        
                        <div class="form-group">
                            <label for="nombre" class="form-label">
                                Nombre del Producto <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="nombre" 
                                   name="nombre" 
                                   placeholder="Ingrese el nombre del producto"
                                   required 
                                   maxlength="100">
                            <div class="form-help">Campo obligatorio</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="descripcion" class="form-label">
                                Descripción <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="descripcion" 
                                   name="descripcion" 
                                   placeholder="Descripción del producto"
                                   required 
                                   maxlength="255">
                            <div class="form-help">Breve descripción del producto</div>
                        </div>
                    </div>

                    <!-- Sección: Precio y Stock -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-euro-sign section-icon"></i>
                            Precio y Stock
                        </h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="precio" class="form-label">
                                    Precio (EUR) <span class="required">*</span>
                                </label>
                                <input type="number" 
                                       class="form-control-modern" 
                                       id="precio" 
                                       name="precio" 
                                       placeholder="0.00"
                                       step="0.01"
                                       min="0"
                                       required>
                            </div>
                            
                            <div class="form-group">
                                <label for="stock" class="form-label">
                                    Stock <span class="required">*</span>
                                </label>
                                <input type="number" 
                                       class="form-control-modern" 
                                       id="stock" 
                                       name="stock" 
                                       placeholder="0"
                                       min="0"
                                       required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="categoria" class="form-label">Categoría</label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="categoria" 
                                   name="categoria" 
                                   placeholder="Categoría del producto"
                                   maxlength="100">
                            <div class="form-help">Campo opcional</div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeProductModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                <button type="submit" form="productoForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Guardar Producto
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         SCRIPTS JAVASCRIPT
         ==================================== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // ====================================
        // FUNCIONES MODAL AGREGAR PRODUCTO
        // ====================================
        function openProductModal() {
            document.getElementById('productModal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeProductModal() {
            document.getElementById('productModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('productoForm').reset();
        }

        // ====================================
        // FUNCIONES MODAL EDITAR PRODUCTO
        // ====================================
        function openEditProductModal(button) {
            const id = button.getAttribute('data-id');
            const nombre = button.getAttribute('data-nombre');
            const descripcion = button.getAttribute('data-descripcion');
            const precio = button.getAttribute('data-precio');
            const stock = button.getAttribute('data-stock');
            const categoria = button.getAttribute('data-categoria') || '';

            // Mostrar y llenar la información del header del producto
            const iniciales = nombre.substring(0, 2).toUpperCase();
            document.getElementById('productAvatar').textContent = iniciales;
            document.getElementById('productName').textContent = nombre;
            document.getElementById('productDescription').textContent = descripcion;
            document.getElementById('productInfoHeader').style.display = 'flex';

            // Cargar datos en el formulario
            document.getElementById('editProductIdHidden').value = id;
            document.getElementById('editNombre').value = nombre;
            document.getElementById('editDescripcion').value = descripcion;
            document.getElementById('editPrecio').value = precio;
            document.getElementById('editStock').value = stock;
            document.getElementById('editCategoria').value = categoria;

            // Mostrar el modal
            document.getElementById('editProductModal').classList.add('show');
            document.body.style.overflow = 'hidden';
            
            setTimeout(() => {
                document.getElementById('editNombre').focus();
            }, 300);
        }

        function closeEditProductModal() {
            document.getElementById('editProductModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('productInfoHeader').style.display = 'none';
            document.getElementById('editProductForm').reset();
        }

        // ====================================
        // FUNCIONES MODAL ELIMINAR PRODUCTO
        // ====================================
        function openDeleteProductModal(button) {
            const id = button.getAttribute('data-id');
            const nombre = button.getAttribute('data-nombre');
            const precio = button.getAttribute('data-precio');

            // Rellenar modal con los datos
            document.getElementById('deleteProductIdHidden').value = id;
            document.getElementById('deleteProductName').textContent = nombre;
            document.getElementById('deleteProductPrice').textContent = `Precio: ${precio} EUR`;

            // Avatar: iniciales (primeras dos letras)
            const iniciales = (nombre[0] || '') + (nombre[1] || '');
            document.getElementById('deleteProductAvatar').textContent = iniciales.toUpperCase();

            // Mostrar modal
            document.getElementById('deleteProductModal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteProductModal() {
            document.getElementById('deleteProductModal').classList.remove('show');
            document.body.style.overflow = 'auto';
        }

        function confirmDeleteProduct() {
            document.getElementById('deleteProductForm').submit();
        }

        // ====================================
        // FUNCIONES VENTAS
        // ====================================
        function toggleVentaDetalle(index) {
            const ventaItem = document.getElementById(`venta-${index}`);
            const detalle = document.getElementById(`detalle-${index}`);
            
            if (ventaItem.classList.contains('expanded')) {
                ventaItem.classList.remove('expanded');
                detalle.style.display = 'none';
            } else {
                ventaItem.classList.add('expanded');
                detalle.style.display = 'block';
            }
        }

        // ====================================
        // EVENT LISTENERS
        // ====================================
        document.addEventListener('DOMContentLoaded', function() {
            // Event listeners para cerrar modales al hacer clic fuera
            ['productModal', 'editProductModal', 'deleteProductModal'].forEach(modalId => {
                const modal = document.getElementById(modalId);
                if (modal) {
                    modal.addEventListener('click', function(e) {
                        if (e.target === this) {
                            if (modalId === 'productModal') closeProductModal();
                            else if (modalId === 'editProductModal') closeEditProductModal();
                            else if (modalId === 'deleteProductModal') closeDeleteProductModal();
                        }
                    });
                }
            });
            
            // Cerrar modales con tecla Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    if (document.getElementById('productModal')?.classList.contains('show')) {
                        closeProductModal();
                    }
                    if (document.getElementById('editProductModal')?.classList.contains('show')) {
                        closeEditProductModal();
                    }
                    if (document.getElementById('deleteProductModal')?.classList.contains('show')) {
                        closeDeleteProductModal();
                    }
                }
            });
        });
        
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
        // Click en el logo para ir a index.jsp
        document.querySelector('.logo').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = '../Index.jsp';
        });
    </script>

</body>
</html>