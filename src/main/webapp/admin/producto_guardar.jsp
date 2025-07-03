<%@ page import="modelo.Producto, controlador.ProductoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String mensaje = "";
    String tipo = "error";

    try {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");
        String categoria = request.getParameter("categoria");

        if (nombre != null && descripcion != null && precioStr != null && stockStr != null) {
            double precio = Double.parseDouble(precioStr);
            int stock = Integer.parseInt(stockStr);

            Producto producto = new Producto();
            producto.setNombre(nombre.trim());
            producto.setDescripcion(descripcion.trim());
            producto.setPrecio(precio);
            producto.setStock(stock);
            producto.setCategoria(categoria != null ? categoria.trim() : "");

            ProductoDAO dao = new ProductoDAO();
            boolean guardado = dao.guardar(producto);

            if (guardado) {
                mensaje = "Producto guardado correctamente.";
                tipo = "success";
            } else {
                mensaje = "Error: No se pudo guardar el producto.";
            }
        } else {
            mensaje = "Faltan campos requeridos (Nombre, Descripción, Precio, Stock).";
        }
    } catch (Exception e) {
        mensaje = "Error del servidor: " + e.getMessage();
        e.printStackTrace();
    }

    response.sendRedirect("productos_listado.jsp?mensaje=" + java.net.URLEncoder.encode(mensaje, "UTF-8") + "&tipo=" + tipo);
%>
