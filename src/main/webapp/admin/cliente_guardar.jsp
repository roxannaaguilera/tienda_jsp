<%@ page import="modelo.Cliente, controlador.ClienteDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String mensaje = "";
    String tipo = "error";

    try {
        String dni = request.getParameter("dni");
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String direccion = request.getParameter("direccion");
        String cp = request.getParameter("cp");
        String provincia = request.getParameter("provincia");

        if (dni != null && nombre != null && apellidos != null) {
            Cliente cliente = new Cliente();
            cliente.setDni(dni.trim().toUpperCase());
            cliente.setNombre(nombre.trim());
            cliente.setApellidos(apellidos.trim());
            cliente.setDireccion(direccion != null ? direccion.trim() : "");
            cliente.setCp(cp != null ? cp.trim() : "");
            cliente.setProvincia(provincia != null ? provincia.trim() : "");

            ClienteDAO dao = new ClienteDAO();
            boolean guardado = dao.guardar(cliente);

            if (guardado) {
                mensaje = "Cliente guardado correctamente.";
                tipo = "success";
            } else {
                mensaje = "Error: No se pudo guardar. El DNI puede estar duplicado.";
            }
        } else {
            mensaje = "Faltan campos requeridos (DNI, Nombre, Apellidos).";
        }
    } catch (Exception e) {
        mensaje = "Error del servidor: " + e.getMessage();
        e.printStackTrace();
    }

    response.sendRedirect("clientes_listado.jsp?mensaje=" + java.net.URLEncoder.encode(mensaje, "UTF-8") + "&tipo=" + tipo);
%>
