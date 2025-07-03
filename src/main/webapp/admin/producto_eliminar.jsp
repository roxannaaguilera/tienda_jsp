<%@ page import="controlador.ProductoDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String accion = request.getParameter("accion");
    String idStr = request.getParameter("id");

    if ("eliminar".equals(accion) && idStr != null && !idStr.isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            ProductoDAO dao = new ProductoDAO();
            boolean exito = dao.eliminar(id);

            if (exito) {
                response.sendRedirect("productos_listado.jsp?mensaje=Producto eliminado exitosamente&tipo=success");
            } else {
                response.sendRedirect("productos_listado.jsp?mensaje=No se pudo eliminar el producto&tipo=error");
            }
        } catch (Exception e) {
            response.sendRedirect("productos_listado.jsp?mensaje=Error: " + e.getMessage() + "&tipo=error");
        }
    } else {
        response.sendRedirect("productos_listado.jsp?mensaje=Parámetros inválidos&tipo=error");
    }
%>
