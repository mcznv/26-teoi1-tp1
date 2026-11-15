package tp1;

public class Simbolo {
    String nombre;
    String token;
    String tipo;
    String valor;
    Integer longitud;

    public Simbolo(String nombre, String token, String tipo, String valor, Integer longitud) {
        this.nombre = nombre;
        this.token = token;
        this.tipo = tipo;
        this.valor = valor;
        this.longitud = longitud;
    }

    @Override
    public String toString() {
        String tip = (tipo != null && !tipo.isEmpty()) ? tipo : "";
        String val = (valor != null && !valor.isEmpty()) ? valor : "";
        String lon = (longitud != null && longitud > 0) ? longitud.toString() : "";

        return String.format("%-20s | %-12s | %-10s | %-15s | %-5s", nombre, token, tip, val, lon);
    }
}