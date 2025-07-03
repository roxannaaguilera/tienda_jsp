</html><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
// ====================================
// LÓGICA DE DATOS Y PROCESAMIENTO
// ====================================

// Obtener datos del cliente y ventas
ClienteDAO clienteListaDAO = new ClienteDAO();
ArrayList<Cliente> clientes = clienteListaDAO.listarTodos();

// Variables para el modal de ventas
String clienteIdVentas = request.getParameter("clienteId");
ArrayList<Venta> ventasCliente = new ArrayList<>();
ArrayList<LVenta> todasLasLineas = new ArrayList<>();
ProductoDAO productoDAO = new ProductoDAO();
double montoTotal = 0.0;

// Si se solicita ver ventas de un cliente específico
if (clienteIdVentas != null && !clienteIdVentas.trim().isEmpty()) {
    try {
        VentaDAO ventaDAO = new VentaDAO();
        LVentaDAO lventaDAO = new LVentaDAO();
        
        // Obtener todas las ventas del cliente
        ventasCliente = ventaDAO.obtenerVentasPorCliente(Integer.parseInt(clienteIdVentas));
        
        // Para cada venta, obtener sus líneas de venta
        for (Venta venta : ventasCliente) {
            ArrayList<LVenta> lineasVenta = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
            todasLasLineas.addAll(lineasVenta);
            montoTotal += venta.getPrecioVenta();
        }
    } catch (Exception e) {
        // Error al cargar ventas - continuar sin ventas
        e.printStackTrace();
    }
}

// ====================================
// LÓGICA PARA CLIENTE DESTACADO DESDE PRODUCTOS
// ====================================

// Variable para cliente seleccionado desde productos
String clienteIdDesdeProductos = request.getParameter("clienteId");
Cliente clienteDestacado = null;
boolean mostrarClienteDestacado = false;

// Si viene un clienteId, buscar y mostrar ese cliente
if (clienteIdDesdeProductos != null && !clienteIdDesdeProductos.trim().isEmpty()) {
    try {
        ClienteDAO clienteDAODestacado = new ClienteDAO();
        clienteDestacado = clienteDAODestacado.obtenerPorId(Integer.parseInt(clienteIdDesdeProductos));
        if (clienteDestacado != null) {
            mostrarClienteDestacado = true;
        }
    } catch (Exception e) {
        // Error al buscar cliente, continuar normal
    }
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Clientes - Got Admin</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        /* ====================================
           VARIABLES CSS
           ==================================== */
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

        /* ====================================
           RESET Y BASE
           ==================================== */
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
           LISTA DE CLIENTES
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
            border-radius: 50%;
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
           CLIENTE DESTACADO
           ==================================== */
        .cliente-destacado-container {
            margin-bottom: 2rem;
        }

        .cliente-destacado {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #f59e0b;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.15);
            position: relative;
            overflow: hidden;
        }

        .cliente-destacado::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #f59e0b, #d97706, #f59e0b);
            animation: shimmer 2s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .cliente-destacado-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(245, 158, 11, 0.3);
        }

        .destacado-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #f59e0b, #d97706);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .destacado-info {
            flex: 1;
        }

        .destacado-info h4 {
            margin: 0 0 0.25rem 0;
            color: #92400e;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .destacado-info p {
            margin: 0;
            color: #a16207;
            font-size: 0.9rem;
        }

        .btn-cerrar-destacado {
            width: 40px;
            height: 40px;
            background: rgba(245, 158, 11, 0.2);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #92400e;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-cerrar-destacado:hover {
            background: rgba(245, 158, 11, 0.3);
            border-color: rgba(245, 158, 11, 0.5);
            transform: scale(1.05);
            color: #92400e;
            text-decoration: none;
        }

        .cliente-destacado-card {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .client-avatar-circle-large {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.5rem;
            text-transform: uppercase;
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.3);
        }

        .client-info-destacado {
            flex: 1;
        }

        .client-name-destacado h3 {
            margin: 0 0 0.5rem 0;
            color: #1f2937;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .client-dni-destacado {
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 500;
            background: #f3f4f6;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            display: inline-block;
        }

        .client-details-destacado {
            margin-top: 1rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.75rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #374151;
            font-size: 0.9rem;
        }

        .detail-item i {
            width: 16px;
            color: #6b7280;
        }

        .client-actions-destacado {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .btn-edit-destacado,
        .btn-ventas-destacado {
            padding: 0.75rem 1.25rem;
            border-radius: 8px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 0.9rem;
            min-width: 140px;
        }

        .btn-edit-destacado {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: 1px solid #059669;
        }

        .btn-edit-destacado:hover {
            background: linear-gradient(135deg, #059669, #047857);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
        }

        .btn-ventas-destacado {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: 1px solid #1d4ed8;
        }

        .btn-ventas-destacado:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
            color: white;
            text-decoration: none;
        }

        /* ====================================
           VENTAS STYLES
           ==================================== */

        .ventas-summary {
            margin-bottom: 2rem;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
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

        /* Lista de ventas */
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

        .venta-item.expanded {
            border-color: #3b82f6;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);
        }

        .venta-header {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            user-select: none;
            transition: background-color 0.2s ease;
        }

        .venta-header:hover {
            background: #f0f9ff;
        }

        .venta-item.expanded .venta-header {
            background: #eff6ff;
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
            transition: all 0.3s ease;
            margin-left: 1rem;
        }

        .venta-item.expanded .toggle-icon {
            color: #3b82f6;
            transform: rotate(180deg);
        }

        /* Detalle de líneas de venta */
        .venta-detalle {
            display: none;
            padding: 1.5rem;
            background: #ffffff;
            border-top: 1px solid #f3f4f6;
        }

        .detalle-header {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1rem;
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
            transition: all 0.2s ease;
        }

        .linea-venta:hover {
            background: #f0f9ff;
            transform: translateX(4px);
        }

        .producto-info {
            flex: 1;
        }

        .producto-nombre {
            font-weight: 500;
            color: var(--dark-color);
            margin-bottom: 2px;
            line-height: 1.3;
        }

        .producto-precio {
            font-size: 0.85rem;
            color: #6c757d;
            line-height: 1.2;
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

        /* Client Info Header específico para modal */
        .client-info-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .client-avatar-circle {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            font-weight: bold;
            flex-shrink: 0;
        }

        .client-info-header .client-details {
            flex: 1;
        }

        .client-info-header .client-details h5 {
            margin: 0 0 4px 0;
            color: var(--dark-color);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .client-info-header .client-details p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Productos con problemas */
        .linea-venta.producto-eliminado {
            border-left: 4px solid #f59e0b;
            background-color: #fffbeb;
        }

        .linea-venta.producto-eliminado .producto-nombre {
            color: #d97706;
            font-weight: 500;
        }

        .linea-venta.producto-error {
            border-left: 4px solid #ef4444;
            background-color: #fef2f2;
        }

        .linea-venta.producto-error .producto-nombre {
            color: #dc2626;
            font-weight: 500;
        }

        .linea-venta.producto-sin-id {
            border-left: 4px solid #6b7280;
            background-color: #f9fafb;
        }

        .linea-venta.producto-sin-id .producto-nombre {
            color: #6b7280;
            font-weight: 500;
        }

        /* Enlaces de productos */
        .producto-link {
            color: #059669;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            background: rgba(5, 150, 105, 0.05);
            border: 1px solid transparent;
        }

        .producto-link:hover {
            color: #047857;
            background: rgba(5, 150, 105, 0.1);
            border-color: rgba(5, 150, 105, 0.2);
            transform: translateX(2px);
            text-decoration: none;
        }

        .producto-link i:first-child {
            font-size: 0.9em;
            color: #6b7280;
        }

        .producto-link i:last-child {
            font-size: 0.75em;
            opacity: 0.7;
            transition: opacity 0.2s ease;
        }

        .producto-link:hover i:last-child {
            opacity: 1;
        }

        .producto-no-disponible {
            color: #6b7280;
            font-weight: 500;
        }

        /* FORM STYLES */
        .form-section {
            margin-bottom: 2rem;
        }

        .form-section:last-child {
            margin-bottom: 0;
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

        .form-group:last-child {
            margin-bottom: 0;
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
            max-width: 100%;
            box-sizing: border-box;
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

        .form-row-thirds {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1rem;
            width: 100%;
        }

        .form-help {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        /* BUTTON STYLES */
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
            text-decoration: none;
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

        .btn-modern:active {
            transform: translateY(1px);
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

        /* ANIMATIONS */
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

        /* RESPONSIVE */
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
            
            .sidebar.show {
                transform: translateX(0);
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
            
            .modal-header,
            .modal-body,
            .modal-footer {
                padding: 1.5rem;
            }
            
            .form-row,
            .form-row-thirds {
                grid-template-columns: 1fr;
                gap: 1rem;
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

            .cliente-destacado-card {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
            
            .client-details-destacado {
                grid-template-columns: 1fr;
            }
            
            .client-actions-destacado {
                flex-direction: row;
                justify-content: center;
            }
            
            .cliente-destacado-header {
                flex-direction: column;
                text-align: center;
                gap: 0.75rem;
            }
        }
    </style>
</head>
<body>

    <!-- Header Principal -->
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

    <!-- Sidebar -->
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="clientes_listado.jsp" class="active"><i class="fas fa-users"></i> Clientes</a></li>
            <li><a href="productos_listado.jsp"><i class="fas fa-box"></i> Productos</a></li>
            <li><a href="ventas_listado.jsp"><i class="fas fa-shopping-cart"></i> Ventas</a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i> Reportes</a></li>
        </ul>
    </aside>

    <!-- Container Principal -->
    <div class="container">
        <!-- Header Interno -->
        <header class="header">
            <h1>Lista de Clientes</h1>
            <div class="stats">
                <span class="total-clients" onclick="openClientModal()">
                    <i class="fas fa-plus"></i> Agregar Cliente
                </span>
            </div>
        </header>

        <!-- Cliente Destacado (si viene de productos) -->
        <% if (mostrarClienteDestacado && clienteDestacado != null) { %>
        <div class="cliente-destacado-container">
            <div class="cliente-destacado">
                <div class="cliente-destacado-header">
                    <div class="destacado-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="destacado-info">
                        <h4>Cliente seleccionado desde ventas</h4>
                        <p>Este cliente fue seleccionado desde el modal de ventas de productos</p>
                    </div>
                    <a href="clientes_listado.jsp" class="btn-cerrar-destacado" title="Cerrar">
                        <i class="fas fa-times"></i>
                    </a>
                </div>
                
                <div class="cliente-destacado-card">
                    <div class="client-avatar">
                        <div class="client-avatar-circle-large">
                            <%= clienteDestacado.getNombre().charAt(0) %><%
                                if (clienteDestacado.getApellidos() != null && !clienteDestacado.getApellidos().isEmpty()) {
                                    out.print(clienteDestacado.getApellidos().charAt(0));
                                }
                            %>
                        </div>
                    </div>
                    
                    <div class="client-info-destacado">
                        <div class="client-name-destacado">
                            <h3><%= clienteDestacado.getNombre() %> <%= clienteDestacado.getApellidos() != null ? clienteDestacado.getApellidos() : "" %></h3>
                            <span class="client-dni-destacado">DNI: <%= clienteDestacado.getDni() %></span>
                        </div>
                        
                        <div class="client-details-destacado">
                            <div class="detail-item">
                                <i class="fas fa-id-card"></i>
                                <span><strong>ID:</strong> <%= clienteDestacado.getIdCliente() %></span>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-user"></i>
                                <span><strong>Nombre completo:</strong> <%= clienteDestacado.getNombre() %> <%= clienteDestacado.getApellidos() != null ? clienteDestacado.getApellidos() : "" %></span>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-fingerprint"></i>
                                <span><strong>DNI:</strong> <%= clienteDestacado.getDni() %></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="client-actions-destacado">
                        <button class="btn-edit-destacado" 
                                title="Editar cliente" 
                                onclick="openEditClientModal(this)"
                                data-id="<%= clienteDestacado.getIdCliente() %>"
                                data-nombre="<%= clienteDestacado.getNombre() %>"
                                data-apellidos="<%= clienteDestacado.getApellidos() != null ? clienteDestacado.getApellidos() : "" %>"
                                data-dni="<%= clienteDestacado.getDni() %>">
                            <i class="fas fa-edit"></i>
                            Editar
                        </button>

                        <form method="get" action="clientes_listado.jsp" style="margin: 0;">
                            <input type="hidden" name="clienteId" value="<%= clienteDestacado.getIdCliente() %>"/>
                            <button type="submit" class="btn-ventas-destacado">
                                <i class="fas fa-shopping-cart"></i>
                                Ver Ventas
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Lista de Clientes -->
        <div class="client-list">
            <% for (Cliente cli : clientes) { 
                   String gender = "women";
                   int photoId = cli.getIdCliente() % 99;
            %>
                <div class="client-card">
                    <div class="client-avatar">
                        <img src="https://randomuser.me/api/portraits/<%= gender %>/<%= photoId %>.jpg" 
                             onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=<%= cli.getNombre() %>&background=6366f1&color=fff&size=60';"
                             alt="Foto de <%= cli.getNombre() %>">
                    </div>
                    <div class="client-info">
                        <div class="client-name">
                            <h3><%= cli.getNombre() %> <%= cli.getApellidos() != null ? cli.getApellidos() : "" %></h3>
                            <span class="client-dni">DNI: <%= cli.getDni() %></span>
                        </div>
                        <div class="client-details">
                            <p class="address"><%= cli.getDireccion() != null ? cli.getDireccion() : "Sin dirección" %></p>
                            <div class="location">
                                <span class="postal-code">CP: <%= cli.getCp() != null ? cli.getCp() : "N/A" %></span>
                                <span class="province"><%= cli.getProvincia() != null ? cli.getProvincia() : "N/A" %></span>
                            </div>
                        </div>
                    </div>
                    <div class="client-actions">
                        <button class="btn-edit" 
                                title="Editar cliente" 
                                onclick="openEditClientModal(this)"
                                data-id="<%= cli.getIdCliente() %>"
                                data-dni="<%= cli.getDni() %>"
                                data-nombre="<%= cli.getNombre() %>"
                                data-apellidos="<%= cli.getApellidos() %>"
                                data-direccion="<%= cli.getDireccion() != null ? cli.getDireccion() : "" %>"
                                data-cp="<%= cli.getCp() != null ? cli.getCp() : "" %>"
                                data-provincia="<%= cli.getProvincia() != null ? cli.getProvincia() : "" %>">
                            <i class="fas fa-edit"></i>
                        </button>

                        <button class="btn-delete" 
                                title="Eliminar cliente" 
                                onclick="openDeleteClientModal(this)"
                                data-id="<%= cli.getIdCliente() %>"
                                data-dni="<%= cli.getDni() %>"
                                data-nombre="<%= cli.getNombre() %>"
                                data-apellidos="<%= cli.getApellidos() %>">
                            <i class="fas fa-trash"></i>
                        </button>

                        <!-- BOTÓN VER VENTAS -->
                        <form method="get" action="clientes_listado.jsp" style="margin: 0;">
                            <input type="hidden" name="clienteId" value="<%= cli.getIdCliente() %>"/>
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

    <!-- MODAL DE VENTAS - CORREGIDO -->
    <% if (clienteIdVentas != null && !clienteIdVentas.trim().isEmpty()) { 
        // Buscar información del cliente
        Cliente clienteSeleccionado = null;
        for (Cliente c : clientes) {
            if (String.valueOf(c.getIdCliente()).equals(clienteIdVentas)) {
                clienteSeleccionado = c;
                break;
            }
        }
    %>
    <div class="modal-overlay show" id="ventasClientModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    Ventas del Cliente
                </div>
                <a href="clientes_listado.jsp" class="modal-close" title="Cerrar">
                    <i class="fas fa-times"></i>
                </a>
            </div>
            
            <div class="modal-body">
                <% if (clienteSeleccionado != null) { %>
                    <!-- Información del Cliente Header -->
                    <div class="client-info-header">
                        <div class="client-avatar-circle">
                            <%= clienteSeleccionado.getNombre().charAt(0) %><%
                                if (clienteSeleccionado.getApellidos() != null && !clienteSeleccionado.getApellidos().isEmpty()) {
                                    out.print(clienteSeleccionado.getApellidos().charAt(0));
                                }
                            %>
                        </div>
                        <div class="client-details">
                            <h5><%= clienteSeleccionado.getNombre() %> <%= clienteSeleccionado.getApellidos() != null ? clienteSeleccionado.getApellidos() : "" %></h5>
                            <p>DNI: <%= clienteSeleccionado.getDni() %></p>
                        </div>
                    </div>
                <% } %>

                <!-- Resumen de ventas -->
                <div class="ventas-summary">
                    <div class="summary-cards">
                        <div class="summary-card">
                            <div class="summary-icon">
                                <i class="fas fa-receipt"></i>
                            </div>
                            <div class="summary-content">
                                <h4><%= ventasCliente.size() %></h4>
                                <p>Total de Ventas</p>
                            </div>
                        </div>
                        <div class="summary-card">
                            <div class="summary-icon">
                                <i class="fas fa-euro-sign"></i>
                            </div>
                            <div class="summary-content">
                                <h4><%= String.format("%.2f", montoTotal) %> €</h4>
                                <p>Monto Total</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lista de ventas -->
                <% if (ventasCliente.isEmpty()) { %>
                    <div class="no-data">
                        <i class="fas fa-shopping-cart"></i>
                        <h5>Sin ventas registradas</h5>
                        <p>Este cliente no tiene ventas en el sistema.</p>
                    </div>
                <% } else { %>
                    <div class="ventas-list">
                        <% 
                        LVentaDAO lventaDAO = new LVentaDAO();
                        for (int i = 0; i < ventasCliente.size(); i++) { 
                            Venta venta = ventasCliente.get(i);
                            ArrayList<LVenta> lineasVenta = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                        %>
                        <div class="venta-item" id="venta-<%= i %>">
                            <div class="venta-header" onclick="toggleVentaDetalle(<%= i %>)">
                                <div class="venta-info">
                                    <h5>Venta #<%= venta.getIdVenta() %></h5>
                                    <p><%= venta.getFechaHora() != null ? venta.getFechaHora().toString() : "Sin fecha" %></p>
                                </div>
                                <div class="venta-monto">
                                    <div class="precio"><%= String.format("%.2f", venta.getPrecioVenta()) %> €</div>
                                    <span class="estado">Completada</span>
                                </div>
                                <i class="fas fa-chevron-down toggle-icon"></i>
                            </div>
                            
                            <div class="venta-detalle" id="detalle-<%= i %>">
                                <div class="detalle-header">Productos comprados:</div>
                                <% if (lineasVenta.isEmpty()) { %>
                                    <p style="text-align: center; color: #6c757d;">No hay productos en esta venta</p>
                                <% } else { %>
                                    <% 
                                    double totalCalculadoVenta = 0.0;
                                    for (LVenta linea : lineasVenta) { 
                                        // ===== LÓGICA CORREGIDA PARA PRODUCTOS =====
                                        Producto producto = null;
                                        String nombreProducto = "Producto no disponible";
                                        double precioHistorico = 0.0;
                                        double precioActual = 0.0;
                                        double subtotal = 0.0;
                                        String estadoProducto = "";
                                        String detalleError = "";
                                        
                                        try {
                                            // Verificar si idProducto es válido (int primitivo, no puede ser null)
                                            if (linea.getIdProducto() > 0) {
                                                producto = productoDAO.obtenerPorId(linea.getIdProducto());
                                                
                                                if (producto != null) {
                                                    // Producto encontrado
                                                    nombreProducto = producto.getNombre();
                                                    precioActual = producto.getPrecio();
                                                    precioHistorico = linea.getPrecioUnidad(); // PRECIO DE LA VENTA
                                                    subtotal = linea.getUnidades() * precioHistorico; // USAR PRECIO HISTÓRICO
                                                    estadoProducto = "disponible";
                                                } else {
                                                    // Producto con ID válido pero no existe
                                                    nombreProducto = "⚠️ Producto eliminado";
                                                    precioHistorico = linea.getPrecioUnidad();
                                                    subtotal = linea.getUnidades() * precioHistorico;
                                                    estadoProducto = "eliminado";
                                                    detalleError = "ID: " + linea.getIdProducto();
                                                }
                                            } else {
                                                // idProducto es 0 o negativo
                                                nombreProducto = "❌ Producto sin identificar";
                                                precioHistorico = linea.getPrecioUnidad();
                                                subtotal = linea.getUnidades() * precioHistorico;
                                                estadoProducto = "sin-id";
                                                detalleError = "Línea: " + linea.getIdLventa();
                                            }
                                            
                                            totalCalculadoVenta += subtotal;
                                            
                                        } catch (Exception e) {
                                            nombreProducto = "❌ Error al procesar producto";
                                            precioHistorico = linea.getPrecioUnidad();
                                            subtotal = linea.getUnidades() * precioHistorico;
                                            estadoProducto = "error";
                                            detalleError = "Error de sistema";
                                            totalCalculadoVenta += subtotal;
                                        }
                                    %>
                                    
                                    <div class="linea-venta <%= estadoProducto.equals("eliminado") ? "producto-eliminado" : 
                                                                 estadoProducto.equals("sin-id") ? "producto-sin-id" :
                                                                 estadoProducto.equals("error") ? "producto-error" : "" %>">
                                        <div class="producto-info">
                                            <div class="producto-nombre">
                                                <% if (estadoProducto.equals("disponible") && producto != null) { %>
                                                    <!-- Producto disponible - crear enlace a productos -->
                                                    <span class="producto-link" title="Ver detalles del producto" style="cursor: default;">
													    <i class="fas fa-box"></i>
													    <%= nombreProducto %>
													    
													</span>

                                                <% } else { %>
                                                    <!-- Producto no disponible - sin enlace -->
                                                    <span class="producto-no-disponible">
                                                        <%= nombreProducto %>
                                                    </span>
                                                <% } %>
                                                
                                                <% if (!detalleError.isEmpty()) { %>
                                                    <small style="color: #dc2626; display: block; font-size: 0.8em;">
                                                        <%= detalleError %>
                                                    </small>
                                                <% } %>
                                            </div>
                                            
                                            <div class="producto-precio">
                                                <%= String.format("%.2f", precioHistorico) %> € c/u
                                                <% if (estadoProducto.equals("sin-id") || estadoProducto.equals("eliminado")) { %>
                                                    <small style="color: #6b7280;">(precio de venta original)</small>
                                                <% } else if (estadoProducto.equals("disponible") && Math.abs(precioHistorico - precioActual) > 0.01) { %>
                                                    <small style="color: #6b7280;">
                                                        (actual: <%= String.format("%.2f", precioActual) %> €)
                                                    </small>
                                                <% } %>
                                            </div>
                                        </div>
                                        <div class="cantidad">x<%= linea.getUnidades() %></div>
                                        <div class="subtotal"><%= String.format("%.2f", subtotal) %> €</div>
                                    </div>
                                    <% } %>
                                    
                                    <!-- Comparación de totales al final de cada venta -->
                                    <%
                                    // Verificar diferencia en totales
                                    double diferenciaTotales = Math.abs(totalCalculadoVenta - venta.getPrecioVenta());
                                    if (diferenciaTotales > 0.01) {
                                    %>
                                    <div style="margin-top: 1rem; padding: 0.75rem; background: #fef3c7; border: 1px solid #f59e0b; border-radius: 6px;">
                                        <div style="display: flex; justify-content: space-between; align-items: center;">
                                            <small style="color: #92400e;">
                                                <i class="fas fa-calculator"></i>
                                                <strong>Verificación de totales:</strong>
                                            </small>
                                        </div>
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 0.5rem; font-size: 0.85rem;">
                                            <div>
                                                <span style="color: #6b7280;">Suma de productos:</span><br>
                                                <strong style="color: #374151;"><%= String.format("%.2f", totalCalculadoVenta) %> €</strong>
                                            </div>
                                            <div>
                                                <span style="color: #6b7280;">Total registrado:</span><br>
                                                <strong style="color: #374151;"><%= String.format("%.2f", venta.getPrecioVenta()) %> €</strong>
                                            </div>
                                        </div>
                                        <%
                                        double diferencia = venta.getPrecioVenta() - totalCalculadoVenta;
                                        String colorDif = (diferencia > 0) ? "#059669" : "#dc2626";
                                        String iconoDif = (diferencia > 0) ? "fa-plus" : "fa-minus";
                                        %>
                                        <div style="margin-top: 0.5rem; padding: 0.5rem; background: white; border-radius: 4px; border-left: 3px solid <%= colorDif %>;">
                                            <small style="color: <%= colorDif %>; font-weight: 500;">
                                                <i class="fas <%= iconoDif %>"></i>
                                                Diferencia: <%= String.format("%.2f", Math.abs(diferencia)) %> €
                                                <% if (Math.abs(diferencia) > 0.01) { %>
                                                    (posible descuento, impuesto o error de datos)
                                                <% } %>
                                            </small>
                                        </div>
                                    </div>
                                    <% } %>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <div class="modal-footer">
                <a href="clientes_listado.jsp" class="btn-outline-modern">
                    <i class="fas fa-arrow-left"></i>
                    Volver a Clientes
                </a>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Modal Eliminar Cliente -->
    <div class="modal-overlay" id="deleteClientModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <i class="fas fa-user-times"></i>
                    </div>
                    Eliminar Cliente
                </div>
                <button class="modal-close" onclick="closeDeleteClientModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información del Cliente Header -->
                <div class="client-info-header">
                    <div class="client-avatar-circle" id="deleteClientAvatar">JC</div>
                    <div class="client-details">
                        <h5 id="deleteClientName">Juan Carlos Pérez López</h5>
                        <p id="deleteClientDni">DNI: 12345678A</p>
                    </div>
                </div>

                <div style="background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); border: 1px solid #fecaca; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem; display: flex; gap: 1rem; align-items: flex-start;">
                    <div style="width: 50px; height: 50px; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; flex-shrink: 0;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div style="flex: 1;">
                        <h4 style="color: #991b1b; font-size: 1.1rem; font-weight: 600; margin: 0 0 0.75rem 0;">¿Está seguro que desea eliminar este cliente?</h4>
                        <p style="color: #7f1d1d; margin: 0 0 0.75rem 0; line-height: 1.5;">Esta acción <strong>no se puede deshacer</strong>. Se eliminará permanentemente:</p>
                        <ul style="color: #7f1d1d; margin: 0 0 0.75rem 1.25rem; padding: 0;">
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Toda la información personal del cliente</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Historial de compras asociado</li>
                            <li style="margin-bottom: 0.25rem; line-height: 1.4;">Cualquier dato relacionado en el sistema</li>
                        </ul>
                    </div>
                </div>

                <!-- Formulario oculto para eliminación -->
                <form id="deleteClientForm" method="POST" action="cliente_eliminar.jsp" style="display: none;">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" id="deleteClientIdHidden" name="id" value="">
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeDeleteClientModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="button" class="btn-modern btn-danger-modern" onclick="confirmDeleteClient()">
                    <i class="fas fa-trash"></i>
                    Eliminar Cliente
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Modificar Cliente -->
    <div class="modal-overlay" id="editClientModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-user-edit"></i>
                    </div>
                    Modificar Cliente
                </div>
                <button class="modal-close" onclick="closeEditClientModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Información del Cliente Header -->
                <div class="client-info-header" id="clientInfoHeader" style="display: none;">
                    <div class="client-avatar-circle" id="clientAvatar">JC</div>
                    <div class="client-details">
                        <h5 id="clientName">Juan Carlos Pérez López</h5>
                        <p id="clientDni">DNI: 12345678A</p>
                    </div>
                </div>

                <!-- Formulario de Modificación -->
                <form id="editClientForm" method="POST" action="cliente_modificar.jsp">
                    <input type="hidden" name="accion" value="modificar">
                    <input type="hidden" id="editClientIdHidden" name="id" value="">
                    
                    <!-- Sección: Información Personal -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-id-card section-icon"></i>
                            Información Personal
                        </h4>
                        
                        <div class="form-group">
                            <label for="editDni" class="form-label">
                                DNI / Documento de Identidad <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editDni" 
                                   name="dni" 
                                   placeholder="DNI del cliente"
                                   required 
                                   maxlength="20">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="editNombre" class="form-label">
                                    Nombre <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="editNombre" 
                                       name="nombre" 
                                       placeholder="Nombre del cliente"
                                       required 
                                       maxlength="100">
                            </div>
                            
                            <div class="form-group">
                                <label for="editApellidos" class="form-label">
                                    Apellidos <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="editApellidos" 
                                       name="apellidos" 
                                       placeholder="Apellidos del cliente"
                                       required 
                                       maxlength="100">
                            </div>
                        </div>
                    </div>

                    <!-- Sección: Información de Contacto -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-map-marker-alt section-icon"></i>
                            Información de Contacto
                        </h4>
                        
                        <div class="form-group">
                            <label for="editDireccion" class="form-label">Dirección</label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="editDireccion" 
                                   name="direccion" 
                                   placeholder="Dirección completa"
                                   maxlength="255">
                        </div>
                        
                        <div class="form-row-thirds">
                            <div class="form-group">
                                <label for="editProvincia" class="form-label">Provincia</label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="editProvincia" 
                                       name="provincia" 
                                       placeholder="Provincia"
                                       maxlength="100">
                            </div>
                            
                            <div class="form-group">
                                <label for="editCp" class="form-label">Código Postal</label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="editCp" 
                                       name="cp" 
                                       placeholder="CP"
                                       maxlength="10">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeEditClientModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                
                <button type="submit" form="editClientForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Guardar Cambios
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Agregar Cliente -->
    <div class="modal-overlay" id="clientModal">
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title">
                    <div class="modal-title-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    Agregar Nuevo Cliente
                </div>
                <button class="modal-close" onclick="closeClientModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Formulario simple que se envía directamente -->
                <form id="clienteForm" method="POST" action="cliente_guardar.jsp">
                    <input type="hidden" name="action" value="agregarCliente">
                    
                    <!-- Sección: Información Personal -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-id-card section-icon"></i>
                            Información Personal
                        </h4>
                        
                        <div class="form-group">
                            <label for="dni" class="form-label">
                                DNI / Documento de Identidad <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="dni" 
                                   name="dni" 
                                   placeholder="Ingrese el DNI"
                                   required 
                                   maxlength="20">
                            <div class="form-help">Campo obligatorio - Debe ser único en el sistema</div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="nombre" class="form-label">
                                    Nombre <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="nombre" 
                                       name="nombre" 
                                       placeholder="Nombre del cliente"
                                       required 
                                       maxlength="100">
                            </div>
                            
                            <div class="form-group">
                                <label for="apellidos" class="form-label">
                                    Apellidos <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="apellidos" 
                                       name="apellidos" 
                                       placeholder="Apellidos del cliente"
                                       required 
                                       maxlength="100">
                            </div>
                        </div>
                    </div>

                    <!-- Sección: Información de Contacto -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-map-marker-alt section-icon"></i>
                            Información de Contacto
                        </h4>
                        
                        <div class="form-group">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" 
                                   class="form-control-modern" 
                                   id="direccion" 
                                   name="direccion" 
                                   placeholder="Dirección completa"
                                   maxlength="255">
                            <div class="form-help">Campo opcional</div>
                        </div>
                        
                        <div class="form-row-thirds">
                            <div class="form-group">
                                <label for="provincia" class="form-label">Provincia</label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="provincia" 
                                       name="provincia" 
                                       placeholder="Provincia"
                                       maxlength="100">
                            </div>
                            
                            <div class="form-group">
                                <label for="cp" class="form-label">Código Postal</label>
                                <input type="text" 
                                       class="form-control-modern" 
                                       id="cp" 
                                       name="cp" 
                                       placeholder="CP"
                                       maxlength="10">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-outline-modern" onclick="closeClientModal()">
                    <i class="fas fa-times"></i>
                    Cancelar
                </button>
                <button type="submit" form="clienteForm" class="btn-modern btn-primary-modern">
                    <i class="fas fa-save"></i>
                    Guardar Cliente
                </button>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // =============================================
        // FUNCIONES PARA MODALES BÁSICOS
        // =============================================
        
        function openClientModal() {
            document.getElementById('clientModal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }
        
        function closeClientModal() {
            document.getElementById('clientModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('clienteForm').reset();
        }

        function openEditClientModal(button) {
            const id = button.getAttribute('data-id');
            const dni = button.getAttribute('data-dni');
            const nombre = button.getAttribute('data-nombre');
            const apellidos = button.getAttribute('data-apellidos') || '';
            const direccion = button.getAttribute('data-direccion') || '';
            const cp = button.getAttribute('data-cp') || '';
            const provincia = button.getAttribute('data-provincia') || '';

            // Mostrar y llenar la información del header del cliente
            const iniciales = nombre.charAt(0) + (apellidos.split(' ')[0]?.charAt(0) || '');
            document.getElementById('clientAvatar').textContent = iniciales;
            document.getElementById('clientName').textContent = (nombre + ' ' + apellidos).trim();
            document.getElementById('clientDni').textContent = 'DNI: ' + dni;
            document.getElementById('clientInfoHeader').style.display = 'flex';

            // Cargar datos en el formulario
            document.getElementById('editClientIdHidden').value = id;
            document.getElementById('editDni').value = dni;
            document.getElementById('editNombre').value = nombre;
            document.getElementById('editApellidos').value = apellidos;
            document.getElementById('editDireccion').value = direccion;
            document.getElementById('editCp').value = cp;
            document.getElementById('editProvincia').value = provincia;

            // Mostrar el modal
            document.getElementById('editClientModal').classList.add('show');
            document.body.style.overflow = 'hidden';
            
            setTimeout(() => {
                document.getElementById('editNombre').focus();
            }, 300);
        }

        function closeEditClientModal() {
            document.getElementById('editClientModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            document.getElementById('clientInfoHeader').style.display = 'none';
            document.getElementById('editClientForm').reset();
        }

        function openDeleteClientModal(button) {
            const id = button.getAttribute("data-id");
            const dni = button.getAttribute("data-dni");
            const nombre = button.getAttribute("data-nombre");
            const apellidos = button.getAttribute("data-apellidos") || '';

            document.getElementById("deleteClientIdHidden").value = id;
            document.getElementById("deleteClientName").textContent = (nombre + ' ' + apellidos).trim();
            document.getElementById("deleteClientDni").textContent = "DNI: " + dni;

            const initials = (nombre[0] || "") + (apellidos[0] || "");
            document.getElementById("deleteClientAvatar").textContent = initials.toUpperCase();

            document.getElementById("deleteClientModal").classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteClientModal() {
            document.getElementById("deleteClientModal").classList.remove('show');
            document.body.style.overflow = 'auto';
        }

        function confirmDeleteClient() {
            document.getElementById("deleteClientForm").submit();
        }

     // =============================================
     // CORRECCIÓN ESPECÍFICA PARA venta-item.expanded
     // REEMPLAZA SOLO LA FUNCIÓN toggleVentaDetalle EN TU SCRIPT
     // =============================================

     // Función para toggle del desplegable de ventas - CORREGIDA PARA MÚLTIPLES PRODUCTOS
     function toggleVentaDetalle(index) {
         console.log('Toggling venta detalle:', index); // Debug
         
         const detalleDiv = document.getElementById('detalle-' + index);
         const ventaItem = document.getElementById('venta-' + index);
         const toggleIcon = ventaItem ? ventaItem.querySelector('.toggle-icon') : null;
         
         if (!detalleDiv) {
             console.error('No se encontró detalle-' + index);
             return;
         }
         
         if (!toggleIcon) {
             console.error('No se encontró toggle icon para venta-' + index);
             return;
         }
         
         if (!ventaItem) {
             console.error('No se encontró venta-' + index);
             return;
         }
         
         console.log('Estado inicial:', {
             display: detalleDiv.style.display,
             hasExpanded: ventaItem.classList.contains('expanded'),
             iconClasses: toggleIcon.classList.toString()
         });
         
         // CORRECCIÓN: Verificar el estado actual de forma más robusta
         const isCurrentlyVisible = detalleDiv.style.display === 'block' || 
                                   ventaItem.classList.contains('expanded');
         
         if (!isCurrentlyVisible) {
             // MOSTRAR DETALLE
             console.log('Mostrando detalle para venta', index);
             
             // 1. Primero mostrar el elemento
             detalleDiv.style.display = 'block';
             
             // 2. Añadir clase expanded al contenedor
             ventaItem.classList.add('expanded');
             
             // 3. Cambiar el icono
             toggleIcon.classList.remove('fa-chevron-down');
             toggleIcon.classList.add('fa-chevron-up');
             
             // 4. Aplicar animación
             detalleDiv.style.opacity = '0';
             detalleDiv.style.transform = 'translateY(-10px)';
             detalleDiv.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
             
             // 5. Forzar reflow y aplicar animación
             detalleDiv.offsetHeight;
             
             setTimeout(() => {
                 detalleDiv.style.opacity = '1';
                 detalleDiv.style.transform = 'translateY(0)';
             }, 10);
             
             console.log('Estado después de mostrar:', {
                 display: detalleDiv.style.display,
                 hasExpanded: ventaItem.classList.contains('expanded'),
                 iconClasses: toggleIcon.classList.toString()
             });
             
         } else {
             // OCULTAR DETALLE
             console.log('Ocultando detalle para venta', index);
             
             // 1. Aplicar animación de salida
             detalleDiv.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
             detalleDiv.style.opacity = '0';
             detalleDiv.style.transform = 'translateY(-10px)';
             
             // 2. Después de la animación, ocultar completamente
             setTimeout(() => {
                 detalleDiv.style.display = 'none';
                 ventaItem.classList.remove('expanded');
                 toggleIcon.classList.remove('fa-chevron-up');
                 toggleIcon.classList.add('fa-chevron-down');
                 detalleDiv.style.transition = '';
                 
                 console.log('Estado después de ocultar:', {
                     display: detalleDiv.style.display,
                     hasExpanded: ventaItem.classList.contains('expanded'),
                     iconClasses: toggleIcon.classList.toString()
                 });
             }, 300);
         }
     }

     // FUNCIÓN ADICIONAL PARA DEBUGGING - AÑADIR AL FINAL DE TU SCRIPT
     function debugVentasState() {
         console.log('=== DEBUG ESTADO VENTAS ===');
         
         const ventaItems = document.querySelectorAll('.venta-item');
         console.log('Total venta-items encontrados:', ventaItems.length);
         
         ventaItems.forEach((item, index) => {
             const detalle = document.getElementById('detalle-' + index);
             const icon = item.querySelector('.toggle-icon');
             
             console.log(`Venta ${index}:`, {
                 ventaItem: !!item,
                 hasExpanded: item.classList.contains('expanded'),
                 detalle: !!detalle,
                 detalleDisplay: detalle ? detalle.style.display : 'N/A',
                 icon: !!icon,
                 iconClasses: icon ? icon.classList.toString() : 'N/A'
             });
         });
     }

     // FUNCIÓN PARA RESETEAR ESTADO INICIAL - AÑADIR AL FINAL DE TU SCRIPT
     function resetVentasState() {
         console.log('Reseteando estado de ventas...');
         
         // Resetear todos los detalles
         const detallesDivs = document.querySelectorAll('[id^="detalle-"]');
         detallesDivs.forEach((detalle, index) => {
             detalle.style.display = 'none';
             detalle.style.opacity = '';
             detalle.style.transform = '';
             detalle.style.transition = '';
         });
         
         // Resetear todos los items
         const ventaItems = document.querySelectorAll('.venta-item');
         ventaItems.forEach(item => {
             item.classList.remove('expanded');
         });
         
         // Resetear todos los iconos
         const toggleIcons = document.querySelectorAll('.toggle-icon');
         toggleIcons.forEach(icon => {
             icon.classList.remove('fa-chevron-up');
             icon.classList.add('fa-chevron-down');
         });
         
         console.log('Estado reseteado');
     }

     // MODIFICAR LA FUNCIÓN DE INICIALIZACIÓN - REEMPLAZAR EN TU SCRIPT
     function initVentasToggle() {
         console.log('Inicializando toggle de ventas (versión corregida)...');
         
         // Primero resetear todo
         resetVentasState();
         
         // Verificar que tenemos los elementos necesarios
         const ventaItems = document.querySelectorAll('.venta-item');
         const detallesDivs = document.querySelectorAll('[id^="detalle-"]');
         const toggleIcons = document.querySelectorAll('.toggle-icon');
         
         console.log('Elementos encontrados:', {
             ventaItems: ventaItems.length,
             detalles: detallesDivs.length,
             toggleIcons: toggleIcons.length
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
                     
                     // Actualizar aria-expanded
                     const ventaItem = document.getElementById('venta-' + index);
                     const isExpanded = ventaItem ? ventaItem.classList.contains('expanded') : false;
                     this.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
                 }
             });
         });
         
         console.log('Toggle de ventas inicializado correctamente');
         
         // Debug automático después de 2 segundos
         setTimeout(() => {
             debugVentasState();
         }, 2000);
     }

     // FUNCIÓN PARA PROBAR MANUALMENTE - AÑADIR AL FINAL DE TU SCRIPT
     function testToggleMultiple() {
         console.log('=== TEST TOGGLE MÚLTIPLE ===');
         
         const ventaItems = document.querySelectorAll('.venta-item');
         console.log('Probando toggle en', ventaItems.length, 'ventas...');
         
         // Probar abrir todas las ventas una por una
         ventaItems.forEach((item, index) => {
             setTimeout(() => {
                 console.log(`Abriendo venta ${index}...`);
                 toggleVentaDetalle(index);
             }, index * 1000);
         });
         
         // Después de abrir todas, cerrarlas
         setTimeout(() => {
             console.log('Cerrando todas las ventas...');
             ventaItems.forEach((item, index) => {
                 setTimeout(() => {
                     console.log(`Cerrando venta ${index}...`);
                     toggleVentaDetalle(index);
                 }, index * 500);
             });
         }, ventaItems.length * 1000 + 2000);
     }

        // =============================================
        // INICIALIZACIÓN Y EVENT LISTENERS
        // =============================================

        document.addEventListener('DOMContentLoaded', function() {
            initVentasToggle();
            addToggleAllButtons();
            
            // Cerrar modales al hacer clic fuera
            ['clientModal', 'editClientModal', 'deleteClientModal', 'ventasClientModal'].forEach(modalId => {
                const modal = document.getElementById(modalId);
                if (modal) {
                    modal.addEventListener('click', function(e) {
                        if (e.target === this) {
                            if (modalId === 'clientModal') closeClientModal();
                            else if (modalId === 'editClientModal') closeEditClientModal();
                            else if (modalId === 'deleteClientModal') closeDeleteClientModal();
                            else if (modalId === 'ventasClientModal') window.location.href = 'clientes_listado.jsp';
                        }
                    });
                }
            });
            
            // Cerrar modales con Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    if (document.getElementById('clientModal')?.classList.contains('show')) {
                        closeClientModal();
                    }
                    if (document.getElementById('editClientModal')?.classList.contains('show')) {
                        closeEditClientModal();
                    }
                    if (document.getElementById('deleteClientModal')?.classList.contains('show')) {
                        closeDeleteClientModal();
                    }
                    if (document.getElementById('ventasClientModal')?.classList.contains('show')) {
                        window.location.href = 'clientes_listado.jsp';
                    }
                }
            });
        });

        // Click en el logo para ir a index.jsp
        document.querySelector('.logo').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = '../Index.jsp';
        });

</body>
</html>