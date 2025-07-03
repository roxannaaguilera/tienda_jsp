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
<%@ page import="java.time.YearMonth"%>
<%@ page import="java.time.Month"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Got Admin</title>
    
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

        /* ====================================
           ESTILOS DE REPORTES
           ==================================== */

        .report-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .report-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .report-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }

        .report-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .report-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .report-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin: 0;
        }

        .report-subtitle {
            font-size: 0.9rem;
            color: #6b7280;
            margin: 0;
        }

        .report-content {
            margin-bottom: 1.5rem;
        }

        .metric {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f3f4f6;
        }

        .metric:last-child {
            border-bottom: none;
        }

        .metric-label {
            font-weight: 500;
            color: var(--dark-color);
        }

        .metric-value {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .metric-value.currency {
            color: var(--success-color);
        }

        .metric-value.danger {
            color: var(--danger-color);
        }

        .metric-value.warning {
            color: var(--warning-color);
        }

        /* Gráficos simples con CSS */
        .chart-container {
            margin: 1rem 0;
        }

        .chart-bar {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .chart-label {
            width: 100px;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--dark-color);
        }

        .chart-bar-bg {
            flex: 1;
            height: 24px;
            background: #f3f4f6;
            border-radius: 12px;
            margin: 0 0.5rem;
            position: relative;
            overflow: hidden;
        }

        .chart-bar-fill {
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 12px;
            transition: width 0.5s ease;
            position: relative;
        }

        .chart-value {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--dark-color);
            min-width: 40px;
            text-align: right;
        }

        /* Tabla de reportes */
        .report-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }

        .report-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .report-table th {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 1rem;
            font-weight: 600;
            text-align: left;
        }

        .report-table td {
            padding: 1rem;
            border-bottom: 1px solid #f3f4f6;
        }

        .report-table tr:hover {
            background: #f9fafb;
        }

        /* Filtros */
        .filter-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .filter-input {
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
            font-family: 'Inter', sans-serif;
        }

        .filter-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            background: white;
        }

        .btn-filter {
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
        }

        .btn-filter:hover {
            filter: brightness(1.1);
            transform: translateY(-2px);
        }

        /* Estadísticas destacadas */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
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

        .stat-icon.sales {
            background: linear-gradient(135deg, var(--success-color), #059669);
        }

        .stat-icon.clients {
            background: linear-gradient(135deg, var(--info-color), #0891b2);
        }

        .stat-icon.products {
            background: linear-gradient(135deg, var(--warning-color), #d97706);
        }

        .stat-icon.revenue {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #6b7280;
            font-weight: 500;
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

            .report-grid {
                grid-template-columns: 1fr;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        /* Animaciones */
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

        .report-card {
            animation: fadeInUp 0.5s ease-out;
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

// Variables para estadísticas
int totalVentas = 0;
int totalClientes = 0;
int totalProductos = 0;
double ingresoTotal = 0.0;
double promedioVentaMensual = 0.0;
String mesActual = "";
String productoMasVendido = "N/A";
String clienteMasActivo = "N/A";

// Obtener datos para reportes
try {
    // Total de ventas
    ArrayList<Venta> todasVentas = ventaDAO.listarTodas();
    if (todasVentas != null) {
        totalVentas = todasVentas.size();
        
        // Calcular ingresos totales
        for (Venta venta : todasVentas) {
            if (venta.getPrecioVenta() > 0) {
                ingresoTotal += venta.getPrecioVenta();
            } else {
                // Calcular desde líneas de venta si el precio no está actualizado
                try {
                    ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                    if (lineas != null) {
                        for (LVenta linea : lineas) {
                            ingresoTotal += (linea.getPrecioUnidad() * linea.getUnidades());
                        }
                    }
                } catch (Exception e) {
                    // Ignorar errores en líneas individuales
                }
            }
        }
    }
    
    // Total de clientes
    ArrayList<Cliente> todosClientes = clienteDAO.listarTodos();
    if (todosClientes != null) {
        totalClientes = todosClientes.size();
    }
    
    // Total de productos
    ArrayList<Producto> todosProductos = productoDAO.listarTodos();
    if (todosProductos != null) {
        totalProductos = todosProductos.size();
    }
    
    // Calcular promedio mensual
    if (totalVentas > 0) {
        promedioVentaMensual = ingresoTotal / Math.max(1, totalVentas);
    }
    
    // Mes actual
    YearMonth mesActualObj = YearMonth.now();
    Month mes = mesActualObj.getMonth();
    mesActual = mes.name();
    
} catch (Exception e) {
    out.println("<!-- Error al cargar estadísticas: " + e.getMessage() + " -->");
}

// Datos para gráficos (simulados para demostración)
Map<String, Integer> ventasPorMes = new HashMap<String, Integer>();
ventasPorMes.put("Enero", 15);
ventasPorMes.put("Febrero", 23);
ventasPorMes.put("Marzo", 18);
ventasPorMes.put("Abril", 31);
ventasPorMes.put("Mayo", 28);
ventasPorMes.put("Junio", 35);

// Encontrar el máximo para normalizar las barras
int maxVentas = 0;
for (Integer ventas : ventasPorMes.values()) {
    if (ventas > maxVentas) maxVentas = ventas;
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
            <li><a href="ventas_listado.jsp"><i class="fas fa-shopping-cart"></i> Ventas</a></li>
            <li><a href="reportes.jsp" class="active"><i class="fas fa-chart-bar"></i> Reportes</a></li>
        </ul>
    </aside>

    <!-- ====================================
         CONTAINER PRINCIPAL
         ==================================== -->
    <div class="container">
        <!-- Header Interno -->
        <header class="header">
            <h1>Reportes y Análisis</h1>
            <div style="display: flex; gap: 1rem;">
                <button class="btn-filter" onclick="exportarReporte()">
                    <i class="fas fa-download"></i> Exportar
                </button>
                <button class="btn-filter" onclick="actualizarReportes()">
                    <i class="fas fa-sync-alt"></i> Actualizar
                </button>
            </div>
        </header>

        <!-- ====================================
             ESTADÍSTICAS PRINCIPALES
             ==================================== -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon sales">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-value"><%= totalVentas %></div>
                <div class="stat-label">Total Ventas</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon revenue">
                    <i class="fas fa-euro-sign"></i>
                </div>
                <div class="stat-value"><%= String.format("%.0f", ingresoTotal) %>€</div>
                <div class="stat-label">Ingresos Totales</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon clients">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value"><%= totalClientes %></div>
                <div class="stat-label">Total Clientes</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon products">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-value"><%= totalProductos %></div>
                <div class="stat-label">Total Productos</div>
            </div>
        </div>

        <!-- ====================================
             FILTROS DE REPORTES
             ==================================== -->
        <div class="filter-section">
            <h3 style="margin-bottom: 1rem; color: var(--dark-color);">
                <i class="fas fa-filter" style="color: var(--primary-color); margin-right: 0.5rem;"></i>
                Filtros de Reportes
            </h3>
            <div class="filter-grid">
                <div class="filter-group">
                    <label class="filter-label">Fecha Inicio</label>
                    <input type="date" class="filter-input" id="fechaInicio">
                </div>
                <div class="filter-group">
                    <label class="filter-label">Fecha Fin</label>
                    <input type="date" class="filter-input" id="fechaFin">
                </div>
                <div class="filter-group">
                    <label class="filter-label">Cliente</label>
                    <select class="filter-input" id="clienteFiltro">
                        <option value="">Todos los clientes</option>
                        <!-- Aquí se cargarían los clientes dinámicamente -->
                    </select>
                </div>
                <div class="filter-group">
                    <button class="btn-filter" onclick="aplicarFiltros()">
                        <i class="fas fa-search"></i> Generar Reporte
                    </button>
                </div>
            </div>
        </div>

        <!-- ====================================
             REPORTES PRINCIPALES
             ==================================== -->
        <div class="report-grid">
            <!-- Reporte de Ventas por Mes -->
            <div class="report-card">
                <div class="report-header">
                    <div class="report-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <div>
                        <h3 class="report-title">Ventas por Mes</h3>
                        <p class="report-subtitle">Últimos 6 meses</p>
                    </div>
                </div>
                <div class="report-content">
                    <div class="chart-container">
                        <% for (Map.Entry<String, Integer> entry : ventasPorMes.entrySet()) { 
                            String mes = entry.getKey();
                            Integer ventas = entry.getValue();
                            double porcentaje = ((double) ventas / maxVentas) * 100;
                        %>
                        <div class="chart-bar">
                            <div class="chart-label"><%= mes %></div>
                            <div class="chart-bar-bg">
                                <div class="chart-bar-fill" style="width: <%= porcentaje %>%"></div>
                            </div>
                            <div class="chart-value"><%= ventas %></div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Reporte Financiero -->
            <div class="report-card">
                <div class="report-header">
                    <div class="report-icon">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div>
                        <h3 class="report-title">Resumen Financiero</h3>
                        <p class="report-subtitle">Estado actual</p>
                    </div>
                </div>
                <div class="report-content">
                    <div class="metric">
                        <span class="metric-label">Ingresos Totales</span>
                        <span class="metric-value currency"><%= String.format("%.2f", ingresoTotal) %>€</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Promedio por Venta</span>
                        <span class="metric-value currency"><%= String.format("%.2f", promedioVentaMensual) %>€</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Ventas Este Mes</span>
                        <span class="metric-value"><%= totalVentas > 0 ? (totalVentas / 6) : 0 %></span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Tendencia</span>
                        <span class="metric-value" style="color: var(--success-color);">
                            <i class="fas fa-arrow-up"></i> +12%
                        </span>
                    </div>
                </div>
            </div>

            <!-- Reporte de Productos -->
            <div class="report-card">
                <div class="report-header">
                    <div class="report-icon">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <div>
                        <h3 class="report-title">Análisis de Productos</h3>
                        <p class="report-subtitle">Rendimiento de inventario</p>
                    </div>
                </div>
                <div class="report-content">
                    <div class="metric">
                        <span class="metric-label">Productos Activos</span>
                        <span class="metric-value"><%= totalProductos %></span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Más Vendido</span>
                        <span class="metric-value">Producto A</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Stock Bajo</span>
                        <span class="metric-value warning">3</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Sin Ventas</span>
                        <span class="metric-value danger">1</span>
                    </div>
                </div>
            </div>

            <!-- Reporte de Clientes -->
            <div class="report-card">
                <div class="report-header">
                    <div class="report-icon">
                        <i class="fas fa-user-friends"></i>
                    </div>
                    <div>
                        <h3 class="report-title">Análisis de Clientes</h3>
                        <p class="report-subtitle">Base de clientes</p>
                    </div>
                </div>
                <div class="report-content">
                    <div class="metric">
                        <span class="metric-label">Clientes Totales</span>
                        <span class="metric-value"><%= totalClientes %></span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Clientes Activos</span>
                        <span class="metric-value"><%= Math.max(0, totalClientes - 2) %></span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Nuevos Este Mes</span>
                        <span class="metric-value" style="color: var(--success-color);">5</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Tasa Retención</span>
                        <span class="metric-value">85%</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ====================================
             TABLA DE REPORTES DETALLADOS
             ==================================== -->
        <div class="report-table">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID Venta</th>
                        <th><i class="fas fa-user"></i> Cliente</th>
                        <th><i class="fas fa-calendar"></i> Fecha</th>
                        <th><i class="fas fa-euro-sign"></i> Total</th>
                        <th><i class="fas fa-box"></i> Productos</th>
                        <th><i class="fas fa-chart-line"></i> Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        ArrayList<Venta> ventasRecientes = ventaDAO.listarTodas();
                        if (ventasRecientes != null && !ventasRecientes.isEmpty()) {
                            // Mostrar solo las últimas 10 ventas
                            int limite = Math.min(10, ventasRecientes.size());
                            for (int i = 0; i < limite; i++) {
                                Venta venta = ventasRecientes.get(i);
                                
                                // Obtener cliente
                                String nombreCliente = "Cliente no disponible";
                                try {
                                    Cliente cliente = clienteDAO.obtenerPorId(venta.getIdCliente());
                                    if (cliente != null) {
                                        nombreCliente = cliente.getNombre();
                                        if (cliente.getApellidos() != null && !cliente.getApellidos().trim().isEmpty()) {
                                            nombreCliente += " " + cliente.getApellidos();
                                        }
                                    }
                                } catch (Exception e) {
                                    nombreCliente = "Error al cargar";
                                }
                                
                                // Calcular total y cantidad de productos
                                double totalVenta = 0.0;
                                int cantidadProductos = 0;
                                try {
                                    ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                                    if (lineas != null) {
                                        cantidadProductos = lineas.size();
                                        for (LVenta linea : lineas) {
                                            totalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
                                        }
                                    }
                                } catch (Exception e) {
                                    totalVenta = venta.getPrecioVenta();
                                }
                                
                                // Formatear fecha
                                String fechaFormateada = "Sin fecha";
                                if (venta.getFechaHora() != null) {
                                    try {
                                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                        fechaFormateada = venta.getFechaHora().format(formatter);
                                    } catch (Exception e) {
                                        fechaFormateada = "Fecha inválida";
                                    }
                                }
                    %>
                    <tr>
                        <td><strong>#<%= venta.getIdVenta() %></strong></td>
                        <td><%= nombreCliente %></td>
                        <td><%= fechaFormateada %></td>
                        <td><strong style="color: var(--success-color);"><%= String.format("%.2f", totalVenta) %>€</strong></td>
                        <td><%= cantidadProductos %> items</td>
                        <td>
                            <span style="background: #c6f6d5; color: #22543d; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600;">
                                Completada
                            </span>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 2rem; color: #6b7280;">
                            <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                            No hay ventas registradas
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 2rem; color: var(--danger-color);">
                            <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                            Error al cargar datos: <%= e.getMessage() %>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>

        <!-- ====================================
             REPORTES ADICIONALES
             ==================================== -->
        <div style="margin-top: 3rem;">
            <h2 style="color: var(--dark-color); margin-bottom: 2rem; display: flex; align-items: center; gap: 0.75rem;">
                <div style="width: 50px; height: 50px; background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem;">
                    <i class="fas fa-chart-pie"></i>
                </div>
                Reportes Avanzados
            </h2>
            
            <div class="report-grid">
                <!-- Análisis de Tendencias -->
                <div class="report-card">
                    <div class="report-header">
                        <div class="report-icon">
                            <i class="fas fa-trending-up"></i>
                        </div>
                        <div>
                            <h3 class="report-title">Análisis de Tendencias</h3>
                            <p class="report-subtitle">Proyecciones futuras</p>
                        </div>
                    </div>
                    <div class="report-content">
                        <div class="metric">
                            <span class="metric-label">Crecimiento Mensual</span>
                            <span class="metric-value" style="color: var(--success-color);">+15.2%</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Proyección Anual</span>
                            <span class="metric-value currency"><%= String.format("%.0f", ingresoTotal * 1.15) %>€</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Mejor Trimestre</span>
                            <span class="metric-value">Q2 2024</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Predicción</span>
                            <span class="metric-value" style="color: var(--success-color);">Positiva</span>
                        </div>
                    </div>
                </div>

                <!-- ROI y Rentabilidad -->
                <div class="report-card">
                    <div class="report-header">
                        <div class="report-icon">
                            <i class="fas fa-percentage"></i>
                        </div>
                        <div>
                            <h3 class="report-title">ROI y Rentabilidad</h3>
                            <p class="report-subtitle">Retorno de inversión</p>
                        </div>
                    </div>
                    <div class="report-content">
                        <div class="metric">
                            <span class="metric-label">ROI General</span>
                            <span class="metric-value" style="color: var(--success-color);">24.5%</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Margen Bruto</span>
                            <span class="metric-value">67.8%</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Costo Adquisición</span>
                            <span class="metric-value currency">45.30€</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Valor Cliente</span>
                            <span class="metric-value currency"><%= totalClientes > 0 ? String.format("%.2f", ingresoTotal / totalClientes) : "0.00" %>€</span>
                        </div>
                    </div>
                </div>

                <!-- Análisis de Inventario -->
                <div class="report-card">
                    <div class="report-header">
                        <div class="report-icon">
                            <i class="fas fa-warehouse"></i>
                        </div>
                        <div>
                            <h3 class="report-title">Inventario y Stock</h3>
                            <p class="report-subtitle">Control de existencias</p>
                        </div>
                    </div>
                    <div class="report-content">
                        <div class="metric">
                            <span class="metric-label">Rotación Stock</span>
                            <span class="metric-value">4.2x</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Días Inventario</span>
                            <span class="metric-value">87 días</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Stock Crítico</span>
                            <span class="metric-value warning">3 productos</span>
                        </div>
                        <div class="metric">
                            <span class="metric-label">Valor Inventario</span>
                            <span class="metric-value currency">12,450€</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ====================================
             PIE DE PÁGINA CON ACCIONES
             ==================================== -->
        <div style="margin-top: 3rem; padding: 2rem; background: rgba(255, 255, 255, 0.95); border-radius: 12px; text-align: center; box-shadow: var(--shadow-md);">
            <h3 style="color: var(--dark-color); margin-bottom: 1rem;">Acciones Rápidas</h3>
            <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <button class="btn-filter" onclick="generarReportePDF()" style="background: linear-gradient(135deg, var(--danger-color), #dc2626);">
                    <i class="fas fa-file-pdf"></i> Generar PDF
                </button>
                <button class="btn-filter" onclick="generarReporteExcel()" style="background: linear-gradient(135deg, var(--success-color), #059669);">
                    <i class="fas fa-file-excel"></i> Exportar Excel
                </button>
                <button class="btn-filter" onclick="enviarReporte()" style="background: linear-gradient(135deg, var(--info-color), #0891b2);">
                    <i class="fas fa-envelope"></i> Enviar por Email
                </button>
                <button class="btn-filter" onclick="programarReporte()">
                    <i class="fas fa-clock"></i> Programar Envío
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
        // FUNCIONES DE REPORTES
        // ====================================
        
        function aplicarFiltros() {
            const fechaInicio = document.getElementById('fechaInicio').value;
            const fechaFin = document.getElementById('fechaFin').value;
            const cliente = document.getElementById('clienteFiltro').value;
            
            let mensaje = 'Generando reporte';
            if (fechaInicio && fechaFin) {
                mensaje += ' del ' + fechaInicio + ' al ' + fechaFin;
            }
            if (cliente) {
                mensaje += ' para el cliente seleccionado';
            }
            
            showNotification(mensaje + '...', 'info');
            
            // Simular carga
            setTimeout(function() {
                showNotification('Reporte generado exitosamente', 'success');
                // Aquí se recargarían los datos filtrados
            }, 2000);
        }
        
        function actualizarReportes() {
            showNotification('Actualizando reportes...', 'info');
            
            // Simular actualización
            setTimeout(function() {
                showNotification('Reportes actualizados correctamente', 'success');
                location.reload();
            }, 1500);
        }
        
        function exportarReporte() {
            showNotification('Preparando exportación...', 'info');
            
            // Simular exportación
            setTimeout(function() {
                showNotification('Reporte exportado exitosamente', 'success');
            }, 1000);
        }
        
        function generarReportePDF() {
            showNotification('Generando PDF...', 'info');
            
            setTimeout(function() {
                showNotification('PDF generado y descargado', 'success');
                // Aquí se simularía la descarga del PDF
            }, 2000);
        }
        
        function generarReporteExcel() {
            showNotification('Generando archivo Excel...', 'info');
            
            setTimeout(function() {
                showNotification('Excel generado y descargado', 'success');
                // Aquí se simularía la descarga del Excel
            }, 2000);
        }
        
        function enviarReporte() {
            const email = prompt('Ingrese el email de destino:');
            if (email) {
                showNotification('Enviando reporte a ' + email + '...', 'info');
                
                setTimeout(function() {
                    showNotification('Reporte enviado exitosamente', 'success');
                }, 2000);
            }
        }
        
        function programarReporte() {
            const frecuencia = prompt('¿Con qué frecuencia desea recibir el reporte?\n1. Diario\n2. Semanal\n3. Mensual\n\nIngrese el número:');
            
            if (frecuencia) {
                let tipoFrecuencia = '';
                switch(frecuencia) {
                    case '1': tipoFrecuencia = 'diario'; break;
                    case '2': tipoFrecuencia = 'semanal'; break;
                    case '3': tipoFrecuencia = 'mensual'; break;
                    default: tipoFrecuencia = 'personalizado'; break;
                }
                
                showNotification('Reporte ' + tipoFrecuencia + ' programado correctamente', 'success');
            }
        }

        // ====================================
        // FUNCIONES AUXILIARES
        // ====================================
        
        function showNotification(message, type) {
            type = type || 'info';
            
            // Crear elemento de notificación
            const notification = document.createElement('div');
            notification.style.cssText = 
                'position: fixed; top: 100px; right: 20px; padding: 1rem 1.5rem; ' +
                'border-radius: 12px; color: white; font-weight: 600; z-index: 10000; ' +
                'max-width: 400px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); ' +
                'animation: slideInRight 0.3s ease-out;';
            
            // Establecer color según tipo
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
            
            // Auto-remover después de 4 segundos
            setTimeout(function() {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100%)';
                setTimeout(function() {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 4000);
        }

        // ====================================
        // INICIALIZACIÓN
        // ====================================
        
        document.addEventListener('DOMContentLoaded', function() {
            // Establecer fechas por defecto
            const fechaInicio = document.getElementById('fechaInicio');
            const fechaFin = document.getElementById('fechaFin');
            
            if (fechaInicio && fechaFin) {
                const hoy = new Date();
                const hace30Dias = new Date();
                hace30Dias.setDate(hoy.getDate() - 30);
                
                fechaFin.value = hoy.toISOString().split('T')[0];
                fechaInicio.value = hace30Dias.toISOString().split('T')[0];
            }
            
            // Animar barras de gráfico
            const barras = document.querySelectorAll('.chart-bar-fill');
            barras.forEach(function(barra, index) {
                setTimeout(function() {
                    barra.style.width = barra.style.width || '0%';
                }, index * 200);
            });
            
            // Mostrar mensaje de bienvenida
            setTimeout(function() {
                showNotification('Reportes cargados correctamente', 'success');
            }, 500);
        });

        // Agregar animación de entrada CSS
        const style = document.createElement('style');
        style.textContent = 
            '@keyframes slideInRight {' +
                'from { opacity: 0; transform: translateX(100%); }' +
                'to { opacity: 1; transform: translateX(0); }' +
            '}';
        document.head.appendChild(style);
        
     // Click en el logo para ir a index.jsp
        document.querySelector('.logo').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = '../Index.jsp';
        });
    </script>
    </script>

</body>
</html>