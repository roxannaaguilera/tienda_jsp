<%@ page import="controlador.ClienteDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String accion = request.getParameter("accion");
    String idStr = request.getParameter("id");

    boolean esAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

    if ("eliminar".equals(accion) && idStr != null && !idStr.isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            ClienteDAO dao = new ClienteDAO();
            boolean exito = dao.eliminar(id);

            if (esAjax) {
                response.setContentType("text/plain");
                if (exito) {
                    out.print("Cliente eliminado exitosamente");
                } else {
                    out.print("No se pudo eliminar el cliente");
                }
            } else {
                if (exito) {
                    response.sendRedirect("clientes_listado.jsp?mensaje=Cliente eliminado exitosamente&tipo=success");
                } else {
                    response.sendRedirect("clientes_listado.jsp?mensaje=No se pudo eliminar el cliente&tipo=error");
                }
            }
        } catch (Exception e) {
            if (esAjax) {
                response.setContentType("text/plain");
                out.print("Error: " + e.getMessage());
            } else {
                response.sendRedirect("clientes_listado.jsp?mensaje=Error: " + e.getMessage() + "&tipo=error");
            }
        }
    } else {
        if (esAjax) {
            response.setContentType("text/plain");
            out.print("Parámetros inválidos");
        } else {
            response.sendRedirect("clientes_listado.jsp?mensaje=Parámetros inválidos&tipo=error");
        }
    }
%>
