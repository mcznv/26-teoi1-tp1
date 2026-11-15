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

Este repositorio contiene el desarrollo del Trabajo Práctico Integrador (Compilador) de la asignatura Teoría de la Computación I. Consiste en un compilador con análisis léxico, sintáctico y validaciones semánticas desarrollado utilizando JFlex y Java CUP, integrado dentro de un entorno gráfico interactivo (IDE) construido en Java Swing.

El compilador reconoce todos los temas comunes definidos por la cátedra e implementa el tema especial asignado al Grupo 6: la estructura de selección múltiple SETSWITCH.

---

#### Construir el proyecto
Este comando le indica a Maven que genere la clase `Lexico.java` utilizando JFlex y luego empaquete todo el proyecto.
```bash
mvn clean package

java -jar ./target/tp1-0.0.2-SNAPSHOT.jar
```
###  Instrucciones de Uso
Ejecutar la aplicación con el comando mencionado arriba.

Ir al menú superior Archivo > Abrir archivo... y seleccionar el archivo prueba.txt suministrado en la raíz de este repositorio.

Presionar el botón Compilar (Análisis Léxico) ubicado en la parte inferior derecha.

En el panel Consola de Salida se listarán todas las reglas sintácticas reconocidas por el parser o, en caso de existir, el detalle de los errores léxicos, sintácticos y semánticos encontrados con su número de línea.

Al finalizar el análisis, la Tabla de Símbolos se exportará automáticamente en el archivo ts.txt en la raíz del proyecto.