<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="modelo.*" %>
<%@ page import="controlador.*" %>

<%
    int idCliente = 0;
    try {
        idCliente = Integer.parseInt(request.getParameter("idCliente"));
    } catch (Exception e) {
        out.println("<p>ID de cliente inválido.</p>");
        return;
    }

    ClienteDAO clienteDAO = new ClienteDAO();
    VentaDAO ventaDAO = new VentaDAO();
    LVentaDAO lventaDAO = new LVentaDAO();

    Cliente cliente = clienteDAO.obtenerPorId(idCliente);
    if (cliente == null) {
        out.println("<p>No se encontró el cliente.</p>");
        return;
    }

    ArrayList<Venta> ventas = ventaDAO.obtenerVentasPorCliente(idCliente);
%>

<h1>Ventas del cliente: <%= cliente.getNombre() + " " + cliente.getApellidos() %></h1>

<%
    if (ventas != null && !ventas.isEmpty()) {
        for (Venta venta : ventas) {
            ArrayList<LVenta> lineas = lventaDAO.obtenerLineasPorVenta(venta.getIdVenta());
%>
    <h2>Venta #<%= venta.getIdVenta() %> | Fecha: <%= venta.getFechaHora() %> | Total: €<%= String.format("%.2f", venta.getPrecioVenta()) %></h2>
    
    <table border="1" cellpadding="5" cellspacing="0" width="80%" style="margin-bottom: 20px;">
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio Unitario (€)</th>
                <th>Subtotal (€)</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (lineas != null && !lineas.isEmpty()) {
                    for (LVenta linea : lineas) {
                        String nombreProducto = linea.getNombreProducto();
                        if (nombreProducto == null || nombreProducto.trim().isEmpty()) {
                            nombreProducto = "Producto ID: " + linea.getIdProducto();
                        }
                        double subtotal = linea.getUnidades() * linea.getPrecioUnidad();
            %>
            <tr>
                <td><%= nombreProducto %></td>
                <td><%= linea.getUnidades() %></td>
                <td><%= String.format("%.2f", linea.getPrecioUnidad()) %></td>
                <td><%= String.format("%.2f", subtotal) %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr><td colspan="4">No hay productos en esta venta.</td></tr>
            <%
                }
            %>
        </tbody>
    </table>
<%
        }
    } else {
%>
    <p>Este cliente no tiene ventas registradas.</p>
<%
    }
%>

<p><a href="clientes_listado.jsp">Volver al listado de clientes</a></p>
