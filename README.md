# 2026 - TEOI1 - TP1 (Primera Entrega: Analizador Léxico)
## UNLu - Licenciatura en Sistemas de Información
## Materia: 11412 – Teoría de la Computación I, Plan de estudios: 1713
#### Docente responsable: Capuya Mara Alejandra – Profesor Adjunto
#### Equipo Docente
##### Silvia Cuagliarelli – Jefe de Trabajos Prácticos
##### Eugenia Céspedes – Ayudante de Primera

### Alumnos (Grupo 6):
- Daddario Agustín 196658
- Coyra Federico 182939
- Cavallero Jorge Hernán 95807
- Kubisen Joaquín 171779
- Cazeneuve Mario G.L. 168551

---

## Descripción del Proyecto
Este repositorio contiene la **Primera Entrega** del Trabajo Práctico Integrador (Compilador). Consiste en un analizador léxico desarrollado con **JFlex** e integrado en una interfaz gráfica (IDE) construida con Java Swing.

El analizador reconoce los tokens del lenguaje definido por la cátedra e incluye la implementación de nuestro tema especial asignado: **SETSWITCH**.

---

#### Construir el proyecto
Este comando le indica a Maven que genere la clase `Lexico.java` utilizando JFlex y luego empaquete todo el proyecto.
```bash
mvn clean package

java -jar ./target/tp1-0.0.1-SNAPSHOT.jar
```
###  Instrucciones de Uso
Ejecutar la aplicación con el comando mencionado arriba.

Ir al menú superior Archivo > Abrir archivo... y seleccionar el archivo prueba.txt suministrado en la raíz de este repositorio.

Presionar el botón Compilar (Análisis Léxico) ubicado en la parte inferior derecha.

Los tokens reconocidos (y posibles errores) se listarán en la Consola de Salida.

Al finalizar, la Tabla de Símbolos se exportará automáticamente actualizando el archivo ts.txt en el directorio del proyecto.
