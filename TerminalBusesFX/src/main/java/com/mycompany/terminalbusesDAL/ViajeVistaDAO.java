/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.terminalbusesDAL;

/**
 *
 * @author Jorge
 */

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ViajeVistaDAO {

    public List<ViajeVista> obtenerTodos(String ciudad) {
        List<ViajeVista> lista = new ArrayList<>();
        String sql = " ";
    
        switch (ciudad.toLowerCase()) {
        case "ibarra":
            sql = "SELECT * FROM Viaje_Ibarra_vista";
            break;
        case "quito":
            sql = "SELECT * FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[Viaje_Quito_vista]";
            break;
        default:
            System.err.println("Ciudad no reconocida: " + ciudad);
            return lista;
    }
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ViajeVista viaje = new ViajeVista(
                    rs.getInt("cod_viaje"),
                    rs.getInt("cod_conductor"),
                    rs.getInt("cod_vehiculo"),
                    rs.getInt("cod_terminal"),
                    rs.getDate("fecha_viaje").toLocalDate(),
                    rs.getTime("hora_viaje").toLocalTime(),
                    rs.getString("ciudad_destino"),
                    rs.getDouble("precio_viaje")
                );
                lista.add(viaje);
            }

        } catch (SQLException e) {
            System.err.println("Error al consultar la vista: " + e.getMessage());
        }

        return lista;
    }

public List<ViajeVista> obtenerViajesFiltrados(String ciudadUsuario, LocalDate desde, LocalDate hasta, String origen, String destino) {
    List<ViajeVista> lista = new ArrayList<>();
    String sqlBase = "";

    // Definir la consulta base según la ciudadUsuario (origen)
    switch (ciudadUsuario.toLowerCase()) {
        case "ibarra":
            sqlBase = "SELECT * FROM Viaje_Ibarra_vista WHERE fecha_viaje BETWEEN ? AND ?";
            break;
        case "quito":
            sqlBase = "SELECT * FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[Viaje_Quito_vista] WHERE fecha_viaje BETWEEN ? AND ?";
            break;
        default:
            System.err.println("Ciudad no reconocida: " + ciudadUsuario);
            return lista;
    }

    // Solo filtro por destino si está seleccionado
    if (destino != null && !destino.isEmpty()) {
        sqlBase += " AND ciudad_destino = ?";
    }

    try (Connection conn = ConexionBD.conectar();
         PreparedStatement ps = conn.prepareStatement(sqlBase)) {

        // Parámetros obligatorios: fechas
        ps.setDate(1, java.sql.Date.valueOf(desde));
        ps.setDate(2, java.sql.Date.valueOf(hasta));

        // Parámetro destino si aplica
        if (destino != null && !destino.isEmpty()) {
            ps.setString(3, destino);
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ViajeVista viaje = new ViajeVista(
                    rs.getInt("cod_viaje"),
                    rs.getInt("cod_conductor"),
                    rs.getInt("cod_vehiculo"),
                    rs.getInt("cod_terminal"),
                    rs.getDate("fecha_viaje").toLocalDate(),
                    rs.getTime("hora_viaje").toLocalTime(),
                    rs.getString("ciudad_destino"),
                    rs.getDouble("precio_viaje")
                );
                lista.add(viaje);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error al consultar la vista filtrada: " + e.getMessage());
    }

    return lista;
    }
}

