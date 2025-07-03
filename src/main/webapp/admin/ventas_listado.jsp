<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="modelo.Venta"%>
<%@ page import="controlador.VentaDAO"%>
<%@ page import="modelo.Cliente"%>
<%@ page import="controlador.ClienteDAO"%>
<%@ page import="modelo.LVenta"%>
<%@ page import="controlador.LVentaDAO"%>
<%@ page import="modelo.Producto"%>
<%@ page import="controlador.ProductoDAO"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Ventas - Got Admin</title>
    
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
           LISTA DE VENTAS
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
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
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
        .btn-delete,
        .btn-view {
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

        .btn-view {
            background-color: #e6fffa;
            color: #2d3748;
        }

        .btn-view:hover {
            background-color: #4fd1c7;
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

        .status.completada {
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

        .venta-info-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .venta-avatar-circle {
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

        .venta-info-header .venta-details {
            flex: 1;
        }

        .venta-info-header .venta-details h5 {
            margin: 0 0 4px 0;
            color: var(--dark-color);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .venta-info-header .venta-details p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .ventas-summary,
        .lineas-summary {
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

        .lineas-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .linea-item {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-bottom: 1rem;
            padding: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s ease;
        }

        .linea-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-color);
        }

        .producto-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
            flex-shrink: 0;
        }

        .linea-info {
            flex: 1;
        }

        .producto-nombre {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }

        .producto-descripcion {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .linea-detalles {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .cantidad {
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .precio-unidad {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .subtotal {
            font-weight: 600;
            color: var(--dark-color);
            font-size: 1.1rem;
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

        /* Mensaje de notificación */
        .alert-message {
            position: fixed;
            top: 100px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            z-index: 10000;
            max-width: 400px;
            animation: slideInRight 0.3s ease-out;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .alert-success {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .alert-error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
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

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
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
        }
    </style>      
   
</head>

<body>

<%
// ====================================
// INICIALIZACIÓN DE VARIABLES Y DAOS
// ====================================

VentaDAO ventaDAO = new VentaDAO();
ClienteDAO clienteDAO = new ClienteDAO();
LVentaDAO lventaDAO = new LVentaDAO();
ProductoDAO productoDAO = new ProductoDAO();

// Obtener todas las ventas
ArrayList<Venta> ventas = null;
try {
    ventas = ventaDAO.listarTodas();
    if (ventas == null) {
        ventas = new ArrayList<Venta>();
    }
} catch (Exception e) {
    ventas = new ArrayList<Venta>();
    out.println("<!-- Error al cargar ventas: " + e.getMessage() + " -->");
}

// Obtener todos los clientes para el modal de agregar
ArrayList<Cliente> todosClientes = null;
try {
    todosClientes = clienteDAO.listarTodos();
    if (todosClientes == null) {
        todosClientes = new ArrayList<Cliente>();
    }
} catch (Exception e) {
    todosClientes = new ArrayList<Cliente>();
    out.println("<!-- Error al cargar clientes: " + e.getMessage() + " -->");
}

// Obtener líneas de venta si se especifica ventaId
String ventaIdLineas = request.getParameter("ventaId");
ArrayList<LVenta> lineasVenta = new ArrayList<LVenta>();
double montoTotalVenta = 0.0;
int cantidadTotalItems = 0;

if (ventaIdLineas != null && !ventaIdLineas.trim().isEmpty()) {
    try {
        int ventaId = Integer.parseInt(ventaIdLineas);
        lineasVenta = lventaDAO.obtenerLineasPorVenta(ventaId);
        if (lineasVenta == null) {
            lineasVenta = new ArrayList<LVenta>();
        }
        
        // Calcular totales
        for (LVenta linea : lineasVenta) {
            montoTotalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
            cantidadTotalItems += linea.getUnidades();
        }
    } catch (NumberFormatException e) {
        ventaIdLineas = null;
        out.println("<!-- Error: ID de venta inválido -->");
    } catch (Exception e) {
        out.println("<!-- Error al cargar líneas de venta: " + e.getMessage() + " -->");
    }
}

// ====================================
// PROCESAMIENTO DE ACCIONES
// ====================================

String accion = request.getParameter("accion");
String mensaje = null;
String tipo = null;

// Procesar modificación de venta
if ("modificar".equals(accion)) {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String clienteNombre = request.getParameter("clienteNombre");
        String fechaHoraStr = request.getParameter("fechaHora");
        String totalStr = request.getParameter("total");
        String estado = request.getParameter("estado");
        
        VentaDAO ventaDAOModificar = new VentaDAO();
        Venta venta = ventaDAOModificar.obtenerPorId(id);
        
        if (venta != null) {
            // Actualizar fecha y hora si se proporciona
            if (fechaHoraStr != null && !fechaHoraStr.trim().isEmpty()) {
                try {
                    LocalDateTime fechaHora = LocalDateTime.parse(fechaHoraStr);
                    venta.setFechaHora(fechaHora);
                } catch (Exception e) {
                    throw new Exception("Formato de fecha inválido");
                }
            }
            
            // Actualizar precio si se proporciona
            if (totalStr != null && !totalStr.trim().isEmpty()) {
                try {
                    double total = Double.parseDouble(totalStr);
                    if (total < 0) {
                        throw new Exception("El total no puede ser negativo");
                    }
                    venta.setPrecioVenta(total);
                } catch (NumberFormatException e) {
                    throw new Exception("Formato de precio inválido");
                }
            }
            
            // Actualizar la venta
            ventaDAOModificar.actualizar(venta);
            mensaje = "Venta modificada correctamente";
            tipo = "success";
            
        } else {
            mensaje = "Venta no encontrada";
            tipo = "error";
        }
        
    } catch (NumberFormatException e) {
        mensaje = "Error: ID de venta inválido";
        tipo = "error";
    } catch (Exception e) {
        mensaje = "Error al modificar: " + e.getMessage();
        tipo = "error";
    }
}

// Procesar eliminación de venta
if ("eliminar".equals(accion)) {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        
        VentaDAO ventaDAOEliminar = new VentaDAO();
        
        // Verificar que la venta existe antes de eliminar
        Venta ventaExiste = ventaDAOEliminar.obtenerPorId(id);
        if (ventaExiste != null) {
            // Primero eliminar las líneas de venta asociadas (si es necesario)
            try {
                LVentaDAO lventaDAOEliminar = new LVentaDAO();
                ArrayList<LVenta> lineasAsociadas = lventaDAOEliminar.obtenerLineasPorVenta(id);
                for (LVenta linea : lineasAsociadas) {
                    lventaDAOEliminar.eliminarPorIdLinea(linea.getIdVenta());
                }
            } catch (Exception e) {
                // Si no se pueden eliminar las líneas, continuamos
                out.println("<!-- Advertencia: No se pudieron eliminar todas las líneas de venta -->");
            }
            
            // Eliminar la venta
            ventaDAOEliminar.eliminar(id);
            mensaje = "Venta eliminada correctamente";
            tipo = "success";
        } else {
            mensaje = "La venta no existe";
            tipo = "error";
        }
        
    } catch (NumberFormatException e) {
        mensaje = "ID de venta inválido";
        tipo = "error";
    } catch (Exception e) {
        mensaje = "Error al eliminar: " + e.getMessage();
        tipo = "error";
    }
}

// Procesar agregar nueva venta
if ("agregar".equals(accion)) {
    try {
        String clienteIdStr = request.getParameter("clienteId");
        String fechaHoraStr = request.getParameter("fechaHora");
        
        if (clienteIdStr == null || clienteIdStr.trim().isEmpty()) {
            throw new Exception("Debe seleccionar un cliente");
        }
        
        if (fechaHoraStr == null || fechaHoraStr.trim().isEmpty()) {
            throw new Exception("Debe especificar fecha y hora");
        }
        
        int clienteId = Integer.parseInt(clienteIdStr);
        
        // Verificar que el cliente existe
        ClienteDAO clienteDAOVerificar = new ClienteDAO();
        Cliente clienteExiste = clienteDAOVerificar.obtenerPorId(clienteId);
        if (clienteExiste == null) {
            throw new Exception("El cliente seleccionado no existe");
        }
        
        // Crear nueva venta
        Venta nuevaVenta = new Venta();
        nuevaVenta.setIdCliente(clienteId);
        
        // Convertir fechaHora de String a LocalDateTime
        try {
            LocalDateTime fechaHora = LocalDateTime.parse(fechaHoraStr);
            nuevaVenta.setFechaHora(fechaHora);
        } catch (Exception e) {
            throw new Exception("Formato de fecha inválido");
        }
        
        // Valores por defecto
        nuevaVenta.setIdEmpleado(1); // O el ID del empleado logueado
        nuevaVenta.setPrecioVenta(0.0); // Inicialmente 0, se calculará después
        
        VentaDAO ventaDAOAgregar = new VentaDAO();
        
        // Usar guardarYObtenerID para saber si se guardó correctamente
        int idGenerado = ventaDAOAgregar.guardarYObtenerID(nuevaVenta);
        
        if (idGenerado > 0) {
            mensaje = "Venta creada correctamente con ID: " + idGenerado;
            tipo = "success";
        } else {
            mensaje = "No se pudo crear la venta";
            tipo = "error";
        }
        
    } catch (NumberFormatException e) {
        mensaje = "Error en los datos numéricos: " + e.getMessage();
        tipo = "error";
    } catch (Exception e) {
        mensaje = "Error al crear venta: " + e.getMessage();
        tipo = "error";
    }
}

// Recargar ventas después de modificaciones
if (mensaje != null) {
    try {
        ventas = ventaDAO.listarTodas();
        if (ventas == null) {
            ventas = new ArrayList<Venta>();
        }
    } catch (Exception e) {
        ventas = new ArrayList<Venta>();
    }
}
%>

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
            <li><a href="productos_listado.jsp"><i class="fas fa-box"></i> Productos</a></li>
            <li><a href="ventas_listado.jsp" class="active"><i class="fas fa-shopping-cart"></i> Ventas</a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i> Reportes</a></li>
        </ul>
    </aside>

    <!-- ====================================
         MENSAJE DE NOTIFICACIÓN
         ==================================== -->
    <% if (mensaje != null && tipo != null) { %>
        <div class="alert-message alert-<%= tipo %>" id="alertMessage">
            <i class="fas fa-<%= "success".equals(tipo) ? "check-circle" : "exclamation-circle" %>"></i>
            <%= mensaje %>
        </div>
    <% } %>

    <!-- ====================================
         CONTAINER PRINCIPAL
         ==================================== -->
    <div class="container">
        <!-- Header Interno -->
        <header class="header">
            <h1>Lista de Ventas</h1>
            <div class="stats">
                <span class="total-clients" onclick="openVentaModal()">
                    <i class="fas fa-plus"></i> Nueva Venta
                </span>
            </div>
        </header>

        <!-- ====================================
             LISTA DE VENTAS
             ==================================== -->
        <div class="client-list">
            <% if (ventas == null || ventas.isEmpty()) { %>
                <div style='padding: 2rem; text-align: center; color: #f59e0b; background: #fffbeb; border: 1px solid #fed7aa; border-radius: 12px;'>
                    <i class="fas fa-shopping-cart" style="font-size: 3rem; color: #f59e0b; margin-bottom: 1rem;"></i>
                    <h5 style="color: #92400e; margin-bottom: 0.5rem;">No hay ventas disponibles</h5>
                    <p style="color: #92400e; margin: 0;">Comience creando su primera venta.</p>
                </div>
            <% } else { 
                for (Venta venta : ventas) {
                    // Calcular total y items de forma segura
                    double totalVenta = 0.0;
                    int totalItems = 0;
                    try {
                        LVentaDAO lventaDAOTemp = new LVentaDAO();
                        ArrayList<LVenta> lineasVentaTemp = lventaDAOTemp.obtenerLineasPorVenta(venta.getIdVenta());
                        if (lineasVentaTemp != null) {
                            for (LVenta linea : lineasVentaTemp) {
                                if (linea != null) {
                                    totalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
                                    totalItems += linea.getUnidades();
                                }
                            }
                        }
                    } catch (Exception e) {
                        // Si hay error, usar precio de venta directo
                        totalVenta = venta.getPrecioVenta();
                    }

                    // Nombre cliente con manejo de errores
                    String nombreCliente = "Cliente no disponible";
                    try {
                        Cliente cliente = clienteDAO.obtenerPorId(venta.getIdCliente());
                        if (cliente != null) {
                            nombreCliente = cliente.getNombre();
                            if (cliente.getApellidos() != null && !cliente.getApellidos().trim().isEmpty()) {
                                nombreCliente += " " + cliente.getApellidos();
                            }
                        } else if (venta.getIdCliente() > 0) {
                            nombreCliente = "Cliente eliminado";
                        } else {
                            nombreCliente = "Sin cliente asignado";
                        }
                    } catch (Exception e) {
                        nombreCliente = "Error al cargar cliente";
                    }

                    // Fecha formateada con manejo de errores
                    String fechaFormateada = "Sin fecha";
                    if (venta.getFechaHora() != null) {
                        try {
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                            fechaFormateada = venta.getFechaHora().format(formatter);
                        } catch (Exception e) {
                            try {
                                fechaFormateada = venta.getFechaHora().toString();
                            } catch (Exception e2) {
                                fechaFormateada = "Fecha inválida";
                            }
                        }
                    }

                    // Fecha para datetime-local con manejo de errores
                    String fechaDateTime = "";
                    if (venta.getFechaHora() != null) {
                        try {
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                            fechaDateTime = venta.getFechaHora().format(formatter);
                        } catch (Exception e) {
                            fechaDateTime = "";
                        }
                    }
                    
                    // Escapar caracteres especiales para JavaScript
                    String nombreClienteEscapado = nombreCliente.replace("'", "\\'").replace("\"", "&quot;");
            %>

            <div class="client-card">
                <div class="client-avatar">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="client-info">
                    <div class="client-name">
                        <h3>Venta #<%= venta.getIdVenta() %></h3>
                        <span class="client-dni">Cliente: <%= nombreCliente %></span>
                    </div>
                    <div class="client-details">
                        <p class="address"><%= String.format("%.2f", totalVenta) %> EUR</p>
                        <div class="location">
                            <span class="postal-code">Items: <%= totalItems %></span>
                            <span class="province"><%= fechaFormateada %></span>
                        </div>
                    </div>
                </div>
                <div class="client-actions">
                    <button class="btn-edit" 
                            title="Editar venta" 
                            onclick="openEditVentaModal(this)"
                            data-id="<%= venta.getIdVenta() %>"
                            data-cliente-id="<%= venta.getIdCliente() %>"
                            data-cliente-nombre="<%= nombreClienteEscapado %>"
                            data-fecha="<%= fechaDateTime %>"
                            data-total="<%= String.format("%.2f", totalVenta) %>">
                        <i class="fas fa-edit"></i>
                    </button>

                    <button class="btn-delete" 
                            title="Eliminar venta" 
                            onclick="openDeleteVentaModal(this)"
                            data-id="<%= venta.getIdVenta() %>"
                            data-cliente="<%= nombreClienteEscapado %>"
                            data-total="<%= String.format("%.2f", totalVenta) %>">
                        <i class="fas fa-trash"></i>
                    </button>

                    <form method="get" action="ventas_listado.jsp" style="margin: 0;">
                        <input type="hidden" name="ventaId" value="<%= venta.getIdVenta() %>"/>
                        <button type="submit" class="btn-view" title="Ver líneas de venta">
                            <i class="fas fa-list"></i>
                        </button>
                    </form>
                </div>
                <div class="status completada">Completada</div>
            </div>

            <%  } // fin for 
            } %>
        </div>
    </div>

<%
// Variables para el modal de líneas de venta
String fechaVentaSeleccionada = "Sin fecha";
Venta ventaSeleccionada = null;
String nombreClienteVenta = "Cliente no disponible";

if (ventaIdLineas != null && !ventaIdLineas.trim().isEmpty()) {
    // Buscar información de la venta seleccionada
    for (Venta v : ventas) {
        if (String.valueOf(v.getIdVenta()).equals(ventaIdLineas)) {
            ventaSeleccionada = v;
            break;
        }
    }
    
    // Formatear fecha con manejo de errores
    if (ventaSeleccionada != null && ventaSeleccionada.getFechaHora() != null) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            fechaVentaSeleccionada = ventaSeleccionada.getFechaHora().format(formatter);
        } catch (Exception e) {
            try {
                fechaVentaSeleccionada = ventaSeleccionada.getFechaHora().toString();
            } catch (Exception e2) {
                fechaVentaSeleccionada = "Fecha inválida";
            }
        }
    }
    
    // Obtener información del cliente con manejo de errores
    try {
        if (ventaSeleccionada != null && ventaSeleccionada.getIdCliente() > 0) {
            Cliente clienteVenta = clienteDAO.obtenerPorId(ventaSeleccionada.getIdCliente());
            if (clienteVenta != null) {
                nombreClienteVenta = clienteVenta.getNombre();
                if (clienteVenta.getApellidos() != null && !clienteVenta.getApellidos().trim().isEmpty()) {
                    nombreClienteVenta += " " + clienteVenta.getApellidos();
                }
            } else {
                nombreClienteVenta = "Cliente eliminado";
            }
        } else {
            nombreClienteVenta = "Sin cliente asignado";
        }
    } catch (Exception e) {
        nombreClienteVenta = "Error al cargar cliente";
    }
}
%>

<!-- ====================================
     MODAL DE LÍNEAS DE VENTA
     ==================================== -->
<% if (ventaIdLineas != null && !ventaIdLineas.trim().isEmpty()) { %>
<div class="modal-overlay show" id="lineasVentaModal">
    <div class="modal-container">
        <div class="modal-header">
            <div class="modal-title">
                <div class="modal-title-icon">
                    <i class="fas fa-list-ul"></i>
                </div>
                Líneas de Venta
            </div>
            <a href="ventas_listado.jsp" class="modal-close" title="Cerrar">
                <i class="fas fa-times"></i>
            </a>
        </div>
        
        <div class="modal-body">
            <% if (ventaSeleccionada != null) { %>
                <!-- Información de la Venta Header -->
                <div class="venta-info-header">
                    <div class="venta-avatar-circle">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <div class="venta-details">
                        <h5>Venta #<%= ventaSeleccionada.getIdVenta() %></h5>
                        <p>Cliente: <%= nombreClienteVenta %> - Fecha: <%= fechaVentaSeleccionada %></p>
                    </div>
                </div>
            <% } %>

            <!-- Resumen de líneas de venta -->
            <div class="lineas-summary">
                <div class="summary-cards">
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= lineasVenta.size() %></h4>
                            <p>Productos Diferentes</p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-cubes"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= cantidadTotalItems %></h4>
                            <p>Unidades Totales</p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-icon">
                            <i class="fas fa-euro-sign"></i>
                        </div>
                        <div class="summary-content">
                            <h4><%= String.format("%.2f", montoTotalVenta) %> €</h4>
                            <p>Total de la Venta</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lista de líneas de venta -->
            <% if (lineasVenta.isEmpty()) { %>
                <div class="no-data">
                    <i class="fas fa-shopping-cart"></i>
                    <h5>Sin líneas de venta</h5>
                    <p>Esta venta no tiene productos registrados.</p>
                </div>
            <% } else { %>
                <div class="lineas-list">
                    <% for (LVenta linea : lineasVenta) { 
                        // Obtener información del producto con manejo de errores
                        Producto producto = null;
                        String nombreProducto = "Producto no disponible";
                        String descripcionProducto = "Sin descripción";
                        
                        try {
                            producto = productoDAO.obtenerPorId(linea.getIdProducto());
                            if (producto != null) {
                                nombreProducto = producto.getNombre() != null ? producto.getNombre() : "Sin nombre";
                                descripcionProducto = producto.getDescripcion() != null ? producto.getDescripcion() : "Sin descripción";
                            } else {
                                nombreProducto = "Producto eliminado";
                                descripcionProducto = "ID: " + linea.getIdProducto();
                            }
                        } catch (Exception e) {
                            nombreProducto = "Error al cargar producto";
                            descripcionProducto = "Error en la base de datos";
                        }
                        
                        double subtotalLinea = linea.getPrecioUnidad() * linea.getUnidades();
                        
                        // Calcular iniciales para avatar
                        String iniciales = "PR";
                        if (nombreProducto.length() >= 2) {
                            iniciales = nombreProducto.substring(0, 2).toUpperCase();
                        } else if (nombreProducto.length() == 1) {
                            iniciales = nombreProducto.toUpperCase() + "P";
                        }
                    %>
                    <div class="linea-item">
                        <div class="producto-avatar">
                            <%= iniciales %>
                        </div>
                        <div class="linea-info">
                            <div class="producto-nombre">
                                <% if (producto != null) { %>
                                    <!-- Producto disponible - crear enlace -->
                                    <a href="productos_listado.jsp?productoId=<%= producto.getIdProducto() %>" 
                                       style="color: var(--primary-color); text-decoration: none; 
                                              display: inline-flex; align-items: center; gap: 0.5rem;">
                                        <%= nombreProducto %>
                                        <i class="fas fa-external-link-alt" style="font-size: 0.8rem;"></i>
                                    </a>
                                <% } else { %>
                                    <!-- Producto no disponible - sin enlace -->
                                    <%= nombreProducto %>
                                <% } %>
                            </div>
                            <div class="producto-descripcion"><%= descripcionProducto %></div>
                            <div class="linea-detalles">
                                <div class="cantidad">x<%= linea.getUnidades() %></div>
                                <div class="precio-unidad">
                                    <%= String.format("%.2f", linea.getPrecioUnidad()) %> € / unidad
                                </div>
                            </div>
                        </div>
                        <div class="subtotal"><%= String.format("%.2f", subtotalLinea) %> €</div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>
        
        <div class="modal-footer">
            <a href="ventas_listado.jsp" class="btn-outline-modern">
                <i class="fas fa-arrow-left"></i>
                Volver a Ventas
            </a>
            <% if (ventaSeleccionada != null) { 
                String fechaDateTimeModal = "";
                if (ventaSeleccionada.getFechaHora() != null) {
                    try {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                        fechaDateTimeModal = ventaSeleccionada.getFechaHora().format(formatter);
                    } catch (Exception e) {
                        fechaDateTimeModal = "";
                    }
                }
                String nombreClienteEscapado = nombreClienteVenta.replace("'", "\\'").replace("\"", "&quot;");
            %>
                <button class="btn-modern" onclick="openEditVentaModal(this)" 
                        data-id="<%= ventaSeleccionada.getIdVenta() %>"
                        data-cliente-id="<%= ventaSeleccionada.getIdCliente() %>"
                        data-cliente-nombre="<%= nombreClienteEscapado %>"
                        data-fecha="<%= fechaDateTimeModal %>"
                        data-total="<%= String.format("%.2f", montoTotalVenta) %>">
                    <i class="fas fa-edit"></i>
                    Editar Venta
                </button>
            <% } %>
        </div>
    </div>
</div>
<% } %>

    <!-- ====================================
         MODAL MODIFICAR VENTA
         ==================================== -->
    <div class="modal-overlay" id="editVentaModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    Modificar Venta
                </div>
                <button class="modal-close" onclick="closeEditVentaModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información de la Venta Header -->
                <div class="venta-info-header" id="ventaInfoHeader" style="display: none;">
                    <div class="venta-avatar-circle" id="ventaAvatar">VT</div>
                    <div class="venta-details">
                        <h5 id="ventaName">Venta</h5>
                        <p id="ventaDescription">Información de la venta</p>
                    </div>
                </div>

                <!-- Formulario de Modificación -->
                <form id="editVentaForm" method="POST" action="ventas_listado.jsp">
                    <input type="hidden" name="accion" value="modificar">
                    <input type="hidden" id="editVentaIdHidden" name="id" value="">
                    
                    <!-- Sección: Información de la Venta -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-receipt section-icon"></i>
                            Información de la Venta
                        </h4>
                        
                        <div class="form-group">
                            <label for="editClienteNombre" class="form-label">
                                Cliente <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editClienteNombre" 
                                   name="clienteNombre" 
                                   placeholder="Nombre del cliente"
                                   readonly
                                   style="background-color: #f8f9fa; cursor: not-allowed;"
                                   maxlength="100">
                            <div class="form-help">El cliente no se puede modificar desde aquí</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="editFechaHora" class="form-label">
                                Fecha y Hora <span class="required">*</span>
                            </label>
                            <input type="datetime-local" 
                                   class="form-control-modern" 
                                   id="editFechaHora" 
                                   name="fechaHora" 
                                   required>
                        </div>
                    </div>

                    <!-- Sección: Total -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-euro-sign section-icon"></i>
                            Total de la Venta
                        </h4>
                        
                        <div class="form-group">
                            <label for="editTotal" class="form-label">
                                Total (EUR) <span class="required">*</span>
                            </label>
                            <input type="number" 
                                   class="form-control-modern" 
                                   id="editTotal" 
                                   name="total" 
                                   placeholder="0.00"
                                   step="0.01"
                                   min="0"
                                   required>
                            <div class="form-help">Monto total de la venta</div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeEditVentaModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="submit" form="editVentaForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Guardar Cambios
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         MODAL ELIMINAR VENTA
         ==================================== -->
    <div class="modal-overlay" id="deleteVentaModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <i class="fas fa-trash"></i>
                    </div>
                    Eliminar Venta
                </div>
                <button class="modal-close" onclick="closeDeleteVentaModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información de la Venta Header -->
                <div class="venta-info-header">
                    <div class="venta-avatar-circle" id="deleteVentaAvatar">VT</div>
                    <div class="venta-details">
                        <h5 id="deleteVentaClienteNombre">Cliente</h5>
                        <p id="deleteVentaTotal">Total: 0.00 EUR</p>
                    </div>
                </div>

                <!-- Advertencia de eliminación -->
                <div style="background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); border: 1px solid #fecaca; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem; display: flex; gap: 1rem; align-items: flex-start;">
                    <div style="width: 50px; height: 50px; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; flex-shrink: 0;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div style="flex: 1;">
                        <h4 style="color: #991b1b; font-size: 1.1rem; font-weight: 600; margin: 0 0 0.75rem 0;">¿Está seguro que desea eliminar esta venta?</h4>
                        <p style="color: #7f1d1d; margin: 0 0 0.75rem 0; line-height: 1.5;">Esta acción <strong>no se puede deshacer</strong>. Se eliminará permanentemente:</p>
                        <ul style="color: #7f1d1d; margin: 0 0 0.75rem 1.25rem; padding: 0;">
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Toda la información de la venta</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Todas las líneas de venta asociadas</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Cualquier dato relacionado en el sistema</li>
                        </ul>
                    </div>
                </div>

                <!-- Formulario oculto para eliminación -->
                <form id="deleteVentaForm" method="POST" action="ventas_listado.jsp" style="display: none;">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" id="deleteVentaIdHidden" name="id" value="">
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeDeleteVentaModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="button" class="btn-modern btn-danger-modern" onclick="confirmDeleteVenta()">
                    <i class="fas fa-trash"></i>
                    Eliminar Venta
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         MODAL AGREGAR VENTA
         ==================================== -->
    <div class="modal-overlay" id="ventaModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                    Nueva Venta
                </div>
                <button class="modal-close" onclick="closeVentaModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Formulario de agregar venta -->
                <form id="ventaForm" method="POST" action="ventas_listado.jsp">
                    <input type="hidden" name="accion" value="agregar">
                    
                    <!-- Sección: Información de la Venta -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-receipt section-icon"></i>
                            Información de la Venta
                        </h4>
                        
                        <div class="form-group">
                            <label for="clienteId" class="form-label">
                                Cliente <span class="required">*</span>
                            </label>
                            <select class="form-control-modern" 
                                    id="clienteId" 
                                    name="clienteId" 
                                    required>
                                <option value="">Seleccionar cliente...</option>
                                <% 
                                if (todosClientes != null) {
                                    for (Cliente cli : todosClientes) { 
                                        String nombreCompleto = cli.getNombre();
                                        if (cli.getApellidos() != null && !cli.getApellidos().trim().isEmpty()) {
                                            nombreCompleto += " " + cli.getApellidos();
                                        }
                                        String dni = cli.getDni() != null ? cli.getDni() : "Sin DNI";
                                %>
                                    <option value="<%= cli.getIdCliente() %>">
                                        <%= nombreCompleto %> - <%= dni %>
                                    </option>
                                <% 
                                    }
                                }
                                %>
                            </select>
                            <div class="form-help">Seleccione el cliente para esta venta</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="fechaHora" class="form-label">
                                Fecha y Hora <span class="required">*</span>
                            </label>
                            <input type="datetime-local" 
                                   class="form-control-modern" 
                                   id="fechaHora" 
                                   name="fechaHora" 
                                   required>
                            <div class="form-help">Fecha y hora de la venta</div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeVentaModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                <button type="submit" form="ventaForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Crear Venta
                </button>
            </div>
        </div>
    </div>

    <!-- ====================================
         SCRIPTS
         ==================================== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // ====================================
        // FUNCIONES DE MODAL
        // ====================================
        
        function openVentaModal() {
            document.getElementById('ventaModal').classList.add('show');
            document.body.style.overflow = 'hidden';
            
            // Establecer fecha y hora actual
            const now = new Date();
            const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
            document.getElementById('fechaHora').value = localDateTime.toISOString().slice(0, 16);
        }

        function closeVentaModal() {
            document.getElementById('ventaModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('ventaForm').reset();
        }

        function openEditVentaModal(button) {
            try {
                const id = button.getAttribute('data-id');
                const clienteId = button.getAttribute('data-cliente-id');
                const clienteNombre = button.getAttribute('data-cliente-nombre');
                const fechaHora = button.getAttribute('data-fecha');
                const total = button.getAttribute('data-total');

                // Validar datos requeridos
                if (!id || !clienteNombre) {
                    console.error('Datos incompletos para editar venta');
                    return;
                }

                // Header del modal
                const iniciales = clienteNombre.length >= 2 ? clienteNombre.substring(0, 2).toUpperCase() : 'VT';
                document.getElementById('ventaAvatar').textContent = iniciales;
                document.getElementById('ventaName').textContent = `Venta #${id}`;
                document.getElementById('ventaDescription').textContent = `Cliente: ${clienteNombre}`;
                document.getElementById('ventaInfoHeader').style.display = 'flex';

                // Formulario
                document.getElementById('editVentaIdHidden').value = id;
                document.getElementById('editClienteNombre').value = clienteNombre;
                document.getElementById('editFechaHora').value = fechaHora || '';
                document.getElementById('editTotal').value = total || '0';

                // Mostrar modal
                document.getElementById('editVentaModal').classList.add('show');
                document.body.style.overflow = 'hidden';
                
                // Focus en el primer campo editable
                setTimeout(() => {
                    document.getElementById('editFechaHora').focus();
                }, 300);
                
            } catch (error) {
                console.error('Error al abrir modal de edición:', error);
                alert('Error al cargar los datos de la venta');
            }
        }

        function closeEditVentaModal() {
            document.getElementById('editVentaModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('ventaInfoHeader').style.display = 'none';
            document.getElementById('editVentaForm').reset();
        }

        function openDeleteVentaModal(button) {
            try {
                const id = button.getAttribute('data-id');
                const clienteNombre = button.getAttribute('data-cliente');
                const total = button.getAttribute('data-total');

                // Validar datos requeridos
                if (!id) {
                    console.error('ID de venta no proporcionado');
                    return;
                }

                document.getElementById('deleteVentaIdHidden').value = id;
                document.getElementById('deleteVentaClienteNombre').textContent = clienteNombre || 'Cliente no disponible';
                document.getElementById('deleteVentaTotal').textContent = `Total: ${total || '0.00'} EUR`;

                const iniciales = clienteNombre && clienteNombre.length >= 2 ? 
                    clienteNombre.substring(0, 2).toUpperCase() : 'XX';
                document.getElementById('deleteVentaAvatar').textContent = iniciales;

                document.getElementById('deleteVentaModal').classList.add('show');
                document.body.style.overflow = 'hidden';
                
            } catch (error) {
                console.error('Error al abrir modal de eliminación:', error);
                alert('Error al cargar los datos de la venta');
            }
        }

        function closeDeleteVentaModal() {
            document.getElementById('deleteVentaModal').classList.remove('show');
            document.body.style.overflow = 'auto';
        }

        function confirmDeleteVenta() {
            const ventaId = document.getElementById('deleteVentaIdHidden').value;
            if (!ventaId) {
                alert('Error: No se puede eliminar la venta');
                return;
            }
            
            // Confirmar una vez más
            if (confirm('¿Está absolutamente seguro de que desea eliminar esta venta? Esta acción no se puede deshacer.')) {
                document.getElementById('deleteVentaForm').submit();
            }
        }

        // ====================================
        // VALIDACIÓN DE FORMULARIOS
        // ====================================
        
        function validateEditForm() {
            const fechaHora = document.getElementById('editFechaHora').value;
            const total = document.getElementById('editTotal').value;
            
            if (!fechaHora) {
                alert('Por favor, especifique la fecha y hora');
                return false;
            }
            
            if (!total || isNaN(total) || parseFloat(total) < 0) {
                alert('Por favor, especifique un total válido');
                return false;
            }
            
            return true;
        }
        
        function validateNewVentaForm() {
            const clienteId = document.getElementById('clienteId').value;
            const fechaHora = document.getElementById('fechaHora').value;
            
            if (!clienteId) {
                alert('Por favor, seleccione un cliente');
                return false;
            }
            
            if (!fechaHora) {
                alert('Por favor, especifique la fecha y hora');
                return false;
            }
            
            return true;
        }

        // ====================================
        // EVENT LISTENERS
        // ====================================
        
        document.addEventListener('DOMContentLoaded', function() {
            // Configurar event listeners para modales
            const modales = [
                { id: 'ventaModal', closeFunction: closeVentaModal },
                { id: 'editVentaModal', closeFunction: closeEditVentaModal },
                { id: 'deleteVentaModal', closeFunction: closeDeleteVentaModal }
            ];

            modales.forEach(({ id, closeFunction }) => {
                const modal = document.getElementById(id);
                if (modal) {
                    modal.addEventListener('click', function(e) {
                        if (e.target === this) {
                            closeFunction();
                        }
                    });
                }
            });

            // Cerrar modales con Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    modales.forEach(({ id, closeFunction }) => {
                        const modal = document.getElementById(id);
                        if (modal && modal.classList.contains('show')) {
                            closeFunction();
                        }
                    });
                }
            });
            
            // Validación de formularios
            const editForm = document.getElementById('editVentaForm');
            if (editForm) {
                editForm.addEventListener('submit', function(e) {
                    if (!validateEditForm()) {
                        e.preventDefault();
                    }
                });
            }
            
            const newVentaForm = document.getElementById('ventaForm');
            if (newVentaForm) {
                newVentaForm.addEventListener('submit', function(e) {
                    if (!validateNewVentaForm()) {
                        e.preventDefault();
                    }
                });
            }
            
            // Auto-cerrar mensaje de alerta
            const alertMessage = document.getElementById('alertMessage');
            if (alertMessage) {
                setTimeout(() => {
                    alertMessage.style.opacity = '0';
                    alertMessage.style.transform = 'translateX(100%)';
                    setTimeout(() => {
                        alertMessage.remove();
                    }, 300);
                }, 5000);
            }
            
            // Configurar fecha mínima para nuevas ventas (opcional)
            const fechaInput = document.getElementById('fechaHora');
            if (fechaInput) {
                // Permitir fechas hasta 1 año atrás
                const oneYearAgo = new Date();
                oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);
                fechaInput.min = oneYearAgo.toISOString().slice(0, 16);
            }
        });

        // ====================================
        // FUNCIONES AUXILIARES
        // ====================================
        
        function formatCurrency(amount) {
            return new Intl.NumberFormat('es-ES', {
                style: 'currency',
                currency: 'EUR'
            }).format(amount);
        }
        
        function showNotification(message, type) {
            type = type || 'info';
            const notification = document.createElement('div');
            notification.className = 'alert-message alert-' + type;
            
            const iconClass = (type === 'success') ? 'check-circle' : 'exclamation-circle';
            notification.innerHTML = 
                '<i class="fas fa-' + iconClass + '"></i>' +
                message;
            
            document.body.appendChild(notification);
            
            setTimeout(function() {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100%)';
                setTimeout(function() {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 5000);
        }

        // Función para recargar la página después de operaciones exitosas
        function reloadPageAfterDelay(delay) {
            delay = delay || 2000;
            setTimeout(function() {
                window.location.reload();
            }, delay);
        }
        // Click en el logo para ir a index.jsp
        document.querySelector('.logo').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = '../Index.jsp';
        });
    </script>

</body>
</html>