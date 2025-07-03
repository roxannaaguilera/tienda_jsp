<%@ page import="modelo.Cliente, controlador.ClienteDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String mensaje = "";
    String tipoMensaje = "error";

    try {
        if ("modificar".equals(request.getParameter("accion"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            String dni = request.getParameter("dni");
            String nombre = request.getParameter("nombre");
            String apellidos = request.getParameter("apellidos");
            String direccion = request.getParameter("direccion");
            String cp = request.getParameter("cp");
            String provincia = request.getParameter("provincia");

            // Validaciones
            if (dni == null || dni.trim().isEmpty()) {
                mensaje = "El DNI es obligatorio";
            } else if (nombre == null || nombre.trim().isEmpty()) {
                mensaje = "El nombre es obligatorio";
            } else if (apellidos == null || apellidos.trim().isEmpty()) {
                mensaje = "Los apellidos son obligatorios";
            }

            if (mensaje.isEmpty()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(id);
                cliente.setDni(dni.trim());
                cliente.setNombre(nombre.trim());
                cliente.setApellidos(apellidos.trim());
                cliente.setDireccion(direccion != null ? direccion.trim() : "");
                cliente.setCp(cp != null ? cp.trim() : "");
                cliente.setProvincia(provincia != null ? provincia.trim() : "");

                ClienteDAO dao = new ClienteDAO();
                boolean exito = dao.actualizar(cliente);

                if (exito) {
                    mensaje = "Cliente modificado exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al modificar el cliente";
                }
            }
        }
    } catch (NumberFormatException e) {
        mensaje = "ID de cliente inválido.";
    } catch (Exception e) {
        e.printStackTrace();
        mensaje = "Error inesperado: " + e.getMessage();
    }

    // Redireccionar a listado con mensaje
    response.sendRedirect("clientes_listado.jsp?mensaje=" +
        java.net.URLEncoder.encode(mensaje, "UTF-8") +
        "&tipo=" + java.net.URLEncoder.encode(tipoMensaje, "UTF-8"));
%>
