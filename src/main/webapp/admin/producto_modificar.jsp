<%@ page import="modelo.Producto, controlador.ProductoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String mensaje = "";
    String tipoMensaje = "error";

    try {
        if ("modificar".equals(request.getParameter("accion"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String precioStr = request.getParameter("precio");
            String stockStr = request.getParameter("stock");
            String categoria = request.getParameter("categoria");

            // Validaciones
            if (nombre == null || nombre.trim().isEmpty()) {
                mensaje = "El nombre es obligatorio";
            } else if (descripcion == null || descripcion.trim().isEmpty()) {
                mensaje = "La descripción es obligatoria";
            }

            double precio = 0;
            int stock = 0;
            try {
                precio = Double.parseDouble(precioStr);
                stock = Integer.parseInt(stockStr);
            } catch (NumberFormatException e) {
                mensaje = "Precio o stock inválidos";
            }

            if (mensaje.isEmpty()) {
                Producto producto = new Producto();
                producto.setIdProducto(id);
                producto.setNombre(nombre.trim());
                producto.setDescripcion(descripcion.trim());
                producto.setPrecio(precio);
                producto.setStock(stock);
                producto.setCategoria(categoria != null ? categoria.trim() : "");

                ProductoDAO dao = new ProductoDAO();
                boolean exito = dao.actualizar(producto);

                if (exito) {
                    mensaje = "Producto modificado exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al modificar el producto";
                }
            }
        }
    } catch (NumberFormatException e) {
        mensaje = "ID de producto inválido.";
    } catch (Exception e) {
        e.printStackTrace();
        mensaje = "Error inesperado: " + e.getMessage();
    }

    // Redireccionar a listado con mensaje
    response.sendRedirect("productos_listado.jsp?mensaje=" +
        java.net.URLEncoder.encode(mensaje, "UTF-8") +
        "&tipo=" + java.net.URLEncoder.encode(tipoMensaje, "UTF-8"));
%>
