package tp1;

import java.util.LinkedHashMap;
import java.util.Map;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class TablaSimbolos {

    private Map<String, Simbolo> tabla = new LinkedHashMap<>();

    // Analizador Léxico para constantes (sin columna TIPO)
    public void agregar(String nombre, String token, String valor, Integer longitud) {
        agregar(nombre, token, "", valor, longitud);
    }

    // Analizador Sintáctico para variables declaradas (con columna TIPO)
    public void agregar(String nombre, String token, String tipo, String valor, Integer longitud) {
        if (!tabla.containsKey(nombre)) {
            tabla.put(nombre, new Simbolo(nombre, token, tipo, valor, longitud));
        } else {
            Simbolo existente = tabla.get(nombre);
            if ((existente.tipo == null || existente.tipo.isEmpty()) && tipo != null && !tipo.isEmpty()) {
                existente.tipo = tipo;
            }
        }
    }

    public boolean existe(String nombre) {
        return tabla.containsKey(nombre);
    }

    public String obtenerTipo(String nombre) {
        Simbolo s = tabla.get(nombre);
        return (s != null && s.tipo != null) ? s.tipo : "";
    }

    public void guardarEnArchivo(String ruta) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ruta))) {
            bw.write(String.format("%-20s | %-12s | %-10s | %-15s | %-5s\n",
                    "NOMBRE", "TOKEN", "TIPO", "VALOR", "LONG"));
            bw.write("-".repeat(75) + "\n");

            for (Simbolo s : tabla.values()) {
                bw.write(s.toString() + "\n");
            }
        }
    }
}