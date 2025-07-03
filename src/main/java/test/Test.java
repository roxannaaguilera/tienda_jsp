package test;

import java.util.ArrayList;
import controlador.VentaDAO;
import controlador.ProductoDAO;
import modelo.Producto;
import modelo.Venta;

public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		
		
		VentaDAO ventaDAO = new VentaDAO();
		ArrayList<Venta> ventas = ventaDAO.listarTodas();
		
		for (  Venta ven : ventas) {
			System.out.println(ven);
		}

	}
	

}
