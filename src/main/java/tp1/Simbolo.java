package tp1;

public class Simbolo {
    String nombre;
    String token;
    String valor;
    Integer longitud;

    public Simbolo(String nombre, String token, String valor, Integer longitud) {
        this.nombre = nombre;
        this.token = token;
        this.valor = valor;
        this.longitud = longitud;
    }

    @Override
    public String toString() {

        String val = (valor != null && !valor.isEmpty()) ? valor : "";
        String lon = (longitud != null && longitud > 0) ? longitud.toString() : "";

        // Alineación de columnas: 20 caracteres para nombre, 15 token, 15 valor, 5 long
        return String.format("%-20s | %-15s | %-15s | %-5s", nombre, token, val, lon);
    }
}