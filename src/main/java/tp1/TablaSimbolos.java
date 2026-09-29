package tp1;

import java.util.LinkedHashMap;
import java.util.Map;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class TablaSimbolos {

    private Map<String, Simbolo> tabla = new LinkedHashMap<>();

    public void agregar(String nombre, String token, String valor, Integer longitud) {

        if (!tabla.containsKey(nombre)) {
            tabla.put(nombre, new Simbolo(nombre, token, valor, longitud));
        }
    }

    public void guardarEnArchivo(String ruta) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ruta))) {
            bw.write(String.format("%-20s | %-15s | %-15s | %-5s\n", "NOMBRE", "TOKEN", "VALOR", "LONG"));
            bw.write("-".repeat(65) + "\n");

            for (Simbolo s : tabla.values()) {
                bw.write(s.toString() + "\n");
            }
        }
    }
}