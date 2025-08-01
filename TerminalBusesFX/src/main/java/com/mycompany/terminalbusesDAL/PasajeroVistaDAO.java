/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.terminalbusesDAL;

/**
 *
 * @author Jorge
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class PasajeroVistaDAO {
    
        public List<PasajeroVista> obtenerTodosLosPasajeros(String ciudad) {
        List<PasajeroVista> lista = new ArrayList<>();
        String sql = " ";
    
        switch (ciudad.toLowerCase()) {
        case "ibarra":
            sql = "SELECT * FROM Pasajero_Ibarra_vista";
            break;
        case "quito":
            sql = "SELECT * FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[Pasajero_Quito_vista]";
            break;
        default:
            System.err.println("Ciudad no reconocida: " + ciudad);
            return lista;
    }

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PasajeroVista pasajero = new PasajeroVista(
                    rs.getInt("cod_pasajero"),
                    rs.getInt("cod_viaje"),
                    rs.getString("nombre_pasajero"),
                    rs.getString("apellido_pasajero"),
                    rs.getString("telefono_pasajero"),
                    rs.getString("cedula_pasajero"),
                    rs.getString("correo_pasajero")
                );
                lista.add(pasajero);
            }

        } catch (SQLException e) {
            System.err.println("Error al consultar la vista: " + e.getMessage());
        }

        return lista;
    }
        
        
        
        /**
 * Devuelve los pasajeros de un viaje concreto, según la ciudad de origen
 */
public List<PasajeroVista> obtenerPasajerosPorViaje(String ciudad, int codViaje) {
    List<PasajeroVista> lista = new ArrayList<>();
    String sql;

    // Elige la vista correcta
    switch (ciudad.toLowerCase()) {
        case "ibarra":
            sql = "SELECT * FROM Pasajero_Ibarra_vista WHERE cod_viaje = ?";
            break;
        case "quito":
            sql = "SELECT * FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[Pasajero_Quito_vista] WHERE cod_viaje = ?";
            break;
        default:
            System.err.println("Ciudad no reconocida: " + ciudad);
            return lista;
    }

    try (Connection conn = ConexionBD.conectar();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        // Asigna el parámetro
        ps.setInt(1, codViaje);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new PasajeroVista(
                    rs.getInt("cod_pasajero"),
                    rs.getInt("cod_viaje"),
                    rs.getString("nombre_pasajero"),
                    rs.getString("apellido_pasajero"),
                    rs.getString("telefono_pasajero"),
                    rs.getString("cedula_pasajero"),
                    rs.getString("correo_pasajero")
                ));
            }
        }

    } catch (SQLException e) {
        System.err.println("Error al consultar pasajeros por viaje: " + e.getMessage());
    }

    return lista;
}

}
