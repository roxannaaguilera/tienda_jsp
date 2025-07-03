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
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control - Got Admin</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
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

        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 2rem;
            min-height: calc(100vh - 80px);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            color: white;
        }

        .stat-icon.primary { background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); }
        .stat-icon.success { background: linear-gradient(135deg, var(--success-color), #059669); }
        .stat-icon.warning { background: linear-gradient(135deg, var(--warning-color), #d97706); }
        .stat-icon.info { background: linear-gradient(135deg, var(--info-color), #0891b2); }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: #6b7280;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.75rem;
            margin-top: 0.5rem;
        }

        .trend-up { color: var(--success-color); }
        .trend-down { color: var(--danger-color); }

        /* Cards */
        .card-modern {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: var(--shadow-md);
            margin-bottom: 2rem;
        }

        .card-header-modern {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-color);
            margin: 0;
        }

        .card-body-modern {
            padding: 1.5rem;
        }

        /* Tables */
        .table-modern {
            width: 100%;
            border-collapse: collapse;
            background: transparent;
        }

        .table-modern th {
            background: rgba(99, 102, 241, 0.1);
            color: var(--dark-color);
            font-weight: 600;
            padding: 1rem;
            text-align: left;
            border-bottom: 2px solid rgba(99, 102, 241, 0.2);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-modern td {
            padding: 1rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            vertical-align: middle;
        }

        .table-modern tr:hover {
            background: rgba(99, 102, 241, 0.05);
        }

        /* Badges */
        .badge-modern {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-primary { background: var(--primary-color); color: white; }
        .badge-success { background: var(--success-color); color: white; }
        .badge-warning { background: var(--warning-color); color: white; }
        .badge-info { background: var(--info-color); color: white; }
        .badge-danger { background: var(--danger-color); color: white; }
        .badge-secondary { background: #6b7280; color: white; }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Scrollbar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.1);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 3px;
        }

        /* Animations */
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

        .stat-card,
        .card-modern {
            animation: fadeInUp 0.6s ease-out;
        }

        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.2s; }
        .stat-card:nth-child(4) { animation-delay: 0.3s; }

        /* Utilities */
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .mb-0 { margin-bottom: 0; }
        .mt-2 { margin-top: 0.5rem; }
        .fw-bold { font-weight: 700; }
        .text-muted { color: #6b7280; }

        /* Button */
        .btn-filter {
            background: transparent;
            border: 1px solid rgba(99, 102, 241, 0.3);
            color: var(--primary-color);
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-filter:hover,
        .btn-filter.active {
            background: var(--primary-color);
            color: white;
        }

        /* Alerta cuando no hay datos */
        .no-data-alert {
            background: linear-gradient(135deg, #fef3cd, #fcf4db);
            border: 1px solid #ffeaa7;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            color: #856404;
            margin: 1rem 0;
        }

        .no-data-alert i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #f39c12;
        }

        /* Quick actions */
        .quick-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .quick-action-btn {
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
            text-decoration: none;
        }

        .quick-action-btn:hover {
            filter: brightness(1.1);
            transform: translateY(-2px);
            color: white;
        }
    </style>
</head>
<body>

<%
// ====================================
// INICIALIZACIÓN DE VARIABLES Y DAOS
// ====================================

request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

VentaDAO ventaDAO = new VentaDAO();
ClienteDAO clienteDAO = new ClienteDAO();
LVentaDAO lventaDAO = new LVentaDAO();
ProductoDAO productoDAO = new ProductoDAO();

// Variables para estadísticas
int totalVentas = 0;
int totalClientes = 0;
int totalProductos = 0;
double ingresoTotal = 0.0;
double ingresosDia = 0.0;
int ventasHoy = 0;
int clientesActivos = 0;
int productosVendidos = 0;

// Listas para datos
ArrayList<Venta> todasVentas = new ArrayList<Venta>();
ArrayList<Cliente> todosClientes = new ArrayList<Cliente>();
ArrayList<Producto> todosProductos = new ArrayList<Producto>();

// Fecha actual para filtros
LocalDate hoy = LocalDate.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
DecimalFormat df = new DecimalFormat("#,##0.00");

// Obtener datos de la base de datos
try {
    // Obtener todas las ventas
    todasVentas = ventaDAO.listarTodas();
    if (todasVentas != null) {
        totalVentas = todasVentas.size();
        
        // Calcular ingresos y ventas de hoy
        for (Venta venta : todasVentas) {
            try {
                // Calcular total de la venta desde las líneas
                double totalVenta = 0.0;
                ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                if (lineas != null) {
                    for (LVenta linea : lineas) {
                        totalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
                        productosVendidos += linea.getUnidades();
                    }
                }
                
                ingresoTotal += totalVenta;
                
                // Verificar si es venta de hoy
                if (venta.getFechaHora() != null) {
                    LocalDate fechaVenta = venta.getFechaHora().toLocalDate();
                    if (fechaVenta.equals(hoy)) {
                        ventasHoy++;
                        ingresosDia += totalVenta;
                    }
                }
            } catch (Exception e) {
                // Si hay error, usar el precio directo de la venta
                if (venta.getPrecioVenta() > 0) {
                    ingresoTotal += venta.getPrecioVenta();
                    if (venta.getFechaHora() != null && venta.getFechaHora().toLocalDate().equals(hoy)) {
                        ingresosDia += venta.getPrecioVenta();
                    }
                }
            }
        }
    }
    
    // Obtener todos los clientes
    todosClientes = clienteDAO.listarTodos();
    if (todosClientes != null) {
        totalClientes = todosClientes.size();
        clientesActivos = totalClientes; // Asumimos que todos están activos
    }
    
    // Obtener todos los productos
    todosProductos = productoDAO.listarTodos();
    if (todosProductos != null) {
        totalProductos = todosProductos.size();
    }
    
} catch (Exception e) {
    out.println("<!-- Error al cargar datos: " + e.getMessage() + " -->");
}

// Calcular top productos y clientes
Map<Integer, Double> ventasPorProducto = new HashMap<Integer, Double>();
Map<Integer, Integer> unidadesPorProducto = new HashMap<Integer, Integer>();
Map<Integer, Double> comprasPorCliente = new HashMap<Integer, Double>();
Map<Integer, Integer> numeroComprasCliente = new HashMap<Integer, Integer>();

// Analizar ventas para estadísticas detalladas
for (Venta venta : todasVentas) {
    try {
        ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
        if (lineas != null) {
            for (LVenta linea : lineas) {
                int idProducto = linea.getIdProducto();
                double subtotal = linea.getPrecioUnidad() * linea.getUnidades();
                
                // Acumular por producto
                ventasPorProducto.put(idProducto, ventasPorProducto.getOrDefault(idProducto, 0.0) + subtotal);
                unidadesPorProducto.put(idProducto, unidadesPorProducto.getOrDefault(idProducto, 0) + linea.getUnidades());
            }
        }
        
        // Acumular por cliente
        int idCliente = venta.getIdCliente();
        double totalVenta = 0.0;
        if (lineas != null) {
            for (LVenta linea : lineas) {
                totalVenta += (linea.getPrecioUnidad() * linea.getUnidades());
            }
        }
        comprasPorCliente.put(idCliente, comprasPorCliente.getOrDefault(idCliente, 0.0) + totalVenta);
        numeroComprasCliente.put(idCliente, numeroComprasCliente.getOrDefault(idCliente, 0) + 1);
        
    } catch (Exception e) {
        // Continuar con el siguiente
    }
}
%>

    <!-- Header -->
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
            <li><a href="dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="clientes_listado.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li><a href="productos_listado.jsp"><i class="fas fa-box"></i> Productos</a></li>
            <li><a href="ventas_listado.jsp"><i class="fas fa-shopping-cart"></i> Ventas</a></li>
            <li><a href="reportes.jsp"><i class="fas fa-chart-bar"></i> Reportes</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header del Dashboard -->
        <div style="margin-bottom: 2rem;">
            <h1 style="color: white; font-size: 2.5rem; font-weight: 800; margin-bottom: 0.5rem;">
                Panel de Control
            </h1>
            <p style="color: rgba(255, 255, 255, 0.8); font-size: 1.1rem;">
                Bienvenido al sistema de gestión - <%= hoy.format(formatter) %>
            </p>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon primary">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-value"><%= ventasHoy %></div>
                <div class="stat-label">Ventas Hoy</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i>
                    Día actual
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="fas fa-euro-sign"></i>
                </div>
                <div class="stat-value"><%= df.format(ingresosDia) %>€</div>
                <div class="stat-label">Ingresos Hoy</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i>
                    Día actual
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value"><%= totalClientes %></div>
                <div class="stat-label">Total Clientes</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i>
                    Base de datos
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-value"><%= productosVendidos %></div>
                <div class="stat-label">Unidades Vendidas</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-arrow-up"></i>
                    Total acumulado
                </div>
            </div>
        </div>

        <!-- Acciones rápidas -->
        <div class="card-modern">
            <div class="card-header-modern">
                <h3 class="card-title">Acciones Rápidas</h3>
            </div>
            <div class="card-body-modern">
                <div class="quick-actions">
                    <a href="ventas_listado.jsp" class="quick-action-btn">
                        <i class="fas fa-plus"></i> Nueva Venta
                    </a>
                    <a href="clientes_listado.jsp" class="quick-action-btn" style="background: linear-gradient(135deg, var(--success-color), #059669);">
                        <i class="fas fa-user-plus"></i> Nuevo Cliente
                    </a>
                    <a href="productos_listado.jsp" class="quick-action-btn" style="background: linear-gradient(135deg, var(--warning-color), #d97706);">
                        <i class="fas fa-box"></i> Nuevo Producto
                    </a>
                    <a href="reportes.jsp" class="quick-action-btn" style="background: linear-gradient(135deg, var(--info-color), #0891b2);">
                        <i class="fas fa-chart-bar"></i> Ver Reportes
                    </a>
                </div>
            </div>
        </div>

        <!-- Productos Más Vendidos -->
        <div class="card-modern">
            <div class="card-header-modern">
                <h3 class="card-title">Productos Más Vendidos</h3>
                <div>
                    <button class="btn-filter active" onclick="filterTable('productos', 'all')">Todos</button>
                    <button class="btn-filter" onclick="filterTable('productos', 'high')">Top 5</button>
                </div>
            </div>
            <div class="card-body-modern">
                <% if (todosProductos.isEmpty()) { %>
                    <div class="no-data-alert">
                        <i class="fas fa-box-open"></i>
                        <h5>No hay productos registrados</h5>
                        <p>Comience agregando productos al sistema para ver las estadísticas de ventas.</p>
                        <a href="productos_listado.jsp" class="quick-action-btn" style="margin-top: 1rem;">
                            <i class="fas fa-plus"></i> Agregar Producto
                        </a>
                    </div>
                <% } else { %>
                    <div style="overflow-x: auto;">
                        <table class="table-modern" id="productos-table">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th>Precio</th>
                                    <th>Unidades Vendidas</th>
                                    <th>Ingresos Generados</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int contadorProductos = 0;
                                for (Producto producto : todosProductos) {
                                    if (contadorProductos >= 10) break; // Mostrar máximo 10
                                    
                                    int unidadesVendidas = unidadesPorProducto.getOrDefault(producto.getIdProducto(), 0);
                                    double ingresosGenerados = ventasPorProducto.getOrDefault(producto.getIdProducto(), 0.0);
                                    contadorProductos++;
                                %>
                                <tr data-ventas="<%= unidadesVendidas %>">
                                    <td class="fw-bold"><%= producto.getNombre() %></td>
                                    <td><%= df.format(producto.getPrecio()) %>€</td>
                                    <td class="fw-bold text-info"><%= unidadesVendidas %></td>
                                    <td class="fw-bold text-success"><%= df.format(ingresosGenerados) %>€</td>
                                    <td>
                                        <% if (unidadesVendidas > 10) { %>
                                            <span class="badge-modern badge-success">Muy Popular</span>
                                        <% } else if (unidadesVendidas > 5) { %>
                                            <span class="badge-modern badge-warning">Popular</span>
                                        <% } else if (unidadesVendidas > 0) { %>
                                            <span class="badge-modern badge-info">Vendido</span>
                                        <% } else { %>
                                            <span class="badge-modern badge-secondary">Sin Ventas</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Clientes y Ventas Recientes -->
        <div class="row">
            <div class="col-md-6">
                <div class="card-modern">
                    <div class="card-header-modern">
                        <h3 class="card-title">Top Clientes</h3>
                    </div>
                    <div class="card-body-modern">
                        <% if (todosClientes.isEmpty()) { %>
                            <div class="no-data-alert">
                                <i class="fas fa-users"></i>
                                <h5>No hay clientes registrados</h5>
                                <p>Agregue clientes para ver las estadísticas.</p>
                                <a href="clientes_listado.jsp" class="quick-action-btn" style="margin-top: 1rem;">
                                    <i class="fas fa-user-plus"></i> Agregar Cliente
                                </a>
                            </div>
                        <% } else {
                            int contadorClientes = 0;
                            for (Cliente cliente : todosClientes) {
                                if (contadorClientes >= 5) break; // Solo top 5
                                
                                double totalCompras = comprasPorCliente.getOrDefault(cliente.getIdCliente(), 0.0);
                                int numeroCompras = numeroComprasCliente.getOrDefault(cliente.getIdCliente(), 0);
                                contadorClientes++;
                        %>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <div class="fw-bold"><%= cliente.getNombre() %> <%= cliente.getApellidos() != null ? cliente.getApellidos() : "" %></div>
                                    <div class="text-muted"><%= cliente.getDni() %></div>
                                </div>
                                <div class="text-right">
                                    <div class="fw-bold text-success"><%= df.format(totalCompras) %>€</div>
                                    <div class="text-muted"><%= numeroCompras %> compras</div>
                                </div>
                            </div>
                        <% } 
                        } %>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card-modern">
                    <div class="card-header-modern">
                        <h3 class="card-title">Ventas Recientes</h3>
                    </div>
                    <div class="card-body-modern">
                        <% if (todasVentas.isEmpty()) { %>
                            <div class="no-data-alert">
                                <i class="fas fa-shopping-cart"></i>
                                <h5>No hay ventas registradas</h5>
                                <p>Las ventas aparecerán aquí una vez que comience a registrarlas.</p>
                                <a href="ventas_listado.jsp" class="quick-action-btn" style="margin-top: 1rem;">
                                    <i class="fas fa-plus"></i> Nueva Venta
                                </a>
                            </div>
                        <% } else {
                            // Mostrar las últimas 5 ventas
                            int contadorVentas = 0;
                            for (int i = Math.max(0, todasVentas.size() - 5); i < todasVentas.size(); i++) {
                                Venta venta = todasVentas.get(i);
                                
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
                                
                                // Calcular total
                                double totalVenta = 0.0;
                                try {
                                    ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
                                    if (lineas != null) {
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
                                        DateTimeFormatter formatterVenta = DateTimeFormatter.ofPattern("dd/MM HH:mm");
                                        fechaFormateada = venta.getFechaHora().format(formatterVenta);
                                    } catch (Exception e) {
                                        fechaFormateada = "Fecha inválida";
                                    }
                                }
                        %>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <div class="fw-bold">Venta #<%= venta.getIdVenta() %></div>
                                    <div class="text-muted"><%= nombreCliente %></div>
                                </div>
                                <div class="text-right">
                                    <div class="fw-bold text-success"><%= df.format(totalVenta) %>€</div>
                                    <div class="text-muted"><%= fechaFormateada %></div>
                                </div>
                            </div>
                        <% } 
                        } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas Adicionales -->
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card-modern text-center">
                    <div class="card-body-modern">
                        <div class="stat-icon primary mx-auto">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stat-value"><%= totalVentas %></div>
                        <div class="stat-label">Total Ventas</div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-modern text-center">
                    <div class="card-body-modern">
                        <div class="stat-icon success mx-auto">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div class="stat-value"><%= df.format(ingresoTotal) %>€</div>
                        <div class="stat-label">Ingresos Totales</div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-modern text-center">
                    <div class="card-body-modern">
                        <div class="stat-icon warning mx-auto">
                            <i class="fas fa-user-friends"></i>
                        </div>
                        <div class="stat-value"><%= totalClientes %></div>
                        <div class="stat-label">Total Clientes</div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-modern text-center">
                    <div class="card-body-modern">
                        <div class="stat-icon info mx-auto">
                            <i class="fas fa-boxes"></i>
                        </div>
                        <div class="stat-value"><%= totalProductos %></div>
                        <div class="stat-label">Total Productos</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Resumen del Sistema -->
        <div class="card-modern mt-4">
            <div class="card-header-modern">
                <h3 class="card-title">Resumen del Sistema</h3>
                <span class="text-muted">Estado actual del negocio</span>
            </div>
            <div class="card-body-modern">
                <div class="row">
                    <div class="col-md-4">
                        <div class="text-center p-3">
                            <div class="stat-icon success mx-auto mb-3">
                                <i class="fas fa-trending-up"></i>
                            </div>
                            <h4 class="fw-bold text-success">
                                <%= totalVentas > 0 ? df.format(ingresoTotal / totalVentas) : "0.00" %>€
                            </h4>
                            <p class="text-muted mb-0">Promedio por Venta</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3">
                            <div class="stat-icon warning mx-auto mb-3">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <h4 class="fw-bold text-warning">
                                <%= totalClientes > 0 ? df.format(ingresoTotal / totalClientes) : "0.00" %>€
                            </h4>
                            <p class="text-muted mb-0">Valor por Cliente</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3">
                            <div class="stat-icon info mx-auto mb-3">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <h4 class="fw-bold text-info">
                                <%= totalProductos > 0 ? Math.round((productosVendidos * 100.0) / (totalProductos * 10)) : 0 %>%
                            </h4>
                            <p class="text-muted mb-0">Tasa de Rotación</p>
                        </div>
                    </div>
                </div>
                
                <hr style="margin: 1.5rem 0;">
                
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="fw-bold mb-3">Estado del Negocio</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Rendimiento de Ventas:</span>
                            <span class="badge-modern badge-success">Excelente</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Base de Clientes:</span>
                            <span class="badge-modern <%= totalClientes > 50 ? "badge-success" : totalClientes > 20 ? "badge-warning" : "badge-info" %>">
                                <%= totalClientes > 50 ? "Sólida" : totalClientes > 20 ? "En Crecimiento" : "Inicial" %>
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Catálogo de Productos:</span>
                            <span class="badge-modern <%= totalProductos > 20 ? "badge-success" : totalProductos > 10 ? "badge-warning" : "badge-info" %>">
                                <%= totalProductos > 20 ? "Amplio" : totalProductos > 10 ? "Moderado" : "Básico" %>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h5 class="fw-bold mb-3">Recomendaciones</h5>
                        <ul style="list-style: none; padding: 0;">
                            <% if (totalClientes < 20) { %>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning me-2"></i>
                                    Considere estrategias para aumentar la base de clientes
                                </li>
                            <% } %>
                            <% if (totalProductos < 10) { %>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning me-2"></i>
                                    Amplíe el catálogo de productos para más opciones
                                </li>
                            <% } %>
                            <% if (ventasHoy == 0) { %>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-info me-2"></i>
                                    Impulse las ventas diarias con promociones
                                </li>
                            <% } %>
                            <% if (totalVentas > 0) { %>
                                <li class="mb-2">
                                    <i class="fas fa-check text-success me-2"></i>
                                    ¡Excelente! El sistema está siendo utilizado activamente
                                </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para filtrar tablas
        function filterTable(tableType, filter) {
            let table, rows, buttons;
            
            if (tableType === 'productos') {
                table = document.getElementById('productos-table');
                if (!table) return;
                buttons = table.closest('.card-modern').querySelectorAll('.btn-filter');
                rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            }
            
            // Actualizar botones activos
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Aplicar filtros
            let contador = 0;
            for (let i = 0; i < rows.length; i++) {
                let row = rows[i];
                let showRow = true;
                
                if (tableType === 'productos') {
                    let ventas = parseInt(row.dataset.ventas) || 0;
                    if (filter === 'high') {
                        showRow = contador < 5; // Solo mostrar top 5
                        if (showRow) contador++;
                    }
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        // Función para actualizar datos en tiempo real (simulado)
        function actualizarDatos() {
            // Aquí podrías implementar AJAX para actualizar datos
            console.log('Actualizando datos del dashboard...');
        }
        
        // Responsive sidebar toggle
        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('show');
        }
        
        // Agregar botón de menú en móviles
        document.addEventListener('DOMContentLoaded', function() {
            if (window.innerWidth <= 768) {
                let header = document.querySelector('.header .container-fluid > div');
                let menuBtn = document.createElement('button');
                menuBtn.className = 'btn btn-outline-primary d-md-none me-3';
                menuBtn.innerHTML = '<i class="fas fa-bars"></i>';
                menuBtn.onclick = toggleSidebar;
                header.insertBefore(menuBtn, header.firstChild);
            }
            
            // Mostrar mensaje de bienvenida
            setTimeout(function() {
                if (typeof showNotification === 'function') {
                    showNotification('Dashboard cargado correctamente', 'success');
                }
            }, 1000);
        });
        
        // Funciones de notificación
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
            }, 4000);
        }
        
        // Auto-refresh cada 5 minutos (opcional)
        setInterval(function() {
            // Podrías implementar actualización automática aquí
            console.log('Auto-refresh del dashboard');
        }, 300000);
        
        // Animación CSS para notificaciones
        const style = document.createElement('style');
        style.textContent = 
            '@keyframes slideInRight {' +
                'from { opacity: 0; transform: translateX(100%); }' +
                'to { opacity: 1; transform: translateX(0); }' +
            '}';
        document.head.appendChild(style);
        
        // Efectos de hover mejorados
        document.querySelectorAll('.stat-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px)';
                this.style.boxShadow = '0 12px 25px rgba(0, 0, 0, 0.15)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.boxShadow = '0 4px 6px -1px rgba(0, 0, 0, 0.1)';
            });
        });
        
        // Click en el logo para ir a index.jsp
        document.querySelector('.logo').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = '../Index.jsp';
        });
    </script>
</body>
</html>