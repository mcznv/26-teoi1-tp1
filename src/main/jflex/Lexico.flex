package tp1;

import java.io.*;

%%
%public
%class Lexico
%type String
%line
%column

%{
    // Instancia pública de la Tabla de Símbolos para accederla desde la interfaz gráfica
    public TablaSimbolos ts = new TablaSimbolos();

     // Contador para controlar la profundidad de anidamiento
    private int nivelComentario = 0;

    //Formatea errores léxicos de manera uniforme
    private String errorLexico(String mensaje) {
        return "ERROR LÉXICO en línea " + (yyline + 1) + " columna " + yycolumn + ": " + mensaje;
    }

    // Validación de Enteros de 16 bits rango con signo: -32768 a 32767, equivalente a Integer en Java
    private boolean esEntero16BitsValido(String lexema) {
        try {
            int valor = Integer.parseInt(lexema);
            return valor >= -32768 && valor <= 32767;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Validación de Reales de 32 bits equivalente a Float en Java
    private boolean esReal32BitsValido(String lexema) {
        try {
            float valor = Float.parseFloat(lexema);
            // Verifica que no haya desbordado a Infinito por superar los 32 bits
            return !Float.isInfinite(valor);
        } catch (NumberFormatException e) {
            return false;
        }
    }


%}
// Declaramos un estado auxiliar para ingresar a el cuando comienza un comentario, para manejar el anidamiento

%state COMENTARIO

// --- EXPRESIONES REGULARES ---

// Caracteres básicos
LETRA = [a-zA-Z]
DIGITO = [0-9]
CARACTERSTRING = [^\n\"\\]
ESPACIO_BLANCO = [ \t\r\n]+

// Identificadores y Constantes
ID = {LETRA}({LETRA}|{DIGITO})*
CONST_INT = (0 | [1-9]{DIGITO}*)
CONST_REAL = ({CONST_INT}\.{DIGITO}*) | (\.{DIGITO}+)
CONST_STRING = \"({CARACTERSTRING}|\\.)*\"

%%

// --- ESTADO NORMAL DEL LENGUAJE ---
<YYINITIAL> {

    // Inicio de un bloque de comentario (Nivel 1)
    "//*" {
        nivelComentario = 1;
        yybegin(COMENTARIO);
    }

    // Si aparece un cierre de comentario suelto sin haberlo abierto
    "*//" {
        return errorLexico("Cierre de comentario '*//' inesperado.");
    }

    // --- REGLAS LÉXICAS ---

    // Secciones del programa (Permite mayúsculas o minúsculas sin combinarlas)
    "DECLARE.SECTION" | "declare.section"       { return "TOKEN: DECLARE.SECTION"; }
    "ENDDECLARE.SECTION" | "enddeclare.section" { return "TOKEN: ENDDECLARE.SECTION"; }
    "PROGRAM.SECTION" | "program.section"       { return "TOKEN: PROGRAM.SECTION"; }
    "ENDPROGRAM.SECTION" | "endprogram.section" { return "TOKEN: ENDPROGRAM.SECTION"; }

    // Tipos de datos
    "FLOAT" | "float"                           { return "TOKEN: FLOAT"; }
    "INT" | "int"                               { return "TOKEN: INT"; }
    "STRING" | "string"                         { return "TOKEN: STRING"; }

    // Ciclo y Decisiones
    "WHILE" | "while"                           { return "TOKEN: WHILE"; }
    "ENDWHILE" | "endwhile"                     { return "TOKEN: ENDWHILE"; }
    "IF" | "if"                                 { return "TOKEN: IF"; }
    "ELSE" | "else"                             { return "TOKEN: ELSE"; }
    "ENDIF" | "endif"                           { return "TOKEN: ENDIF"; }

    // Funciones I/O
    "WRITE" | "write"                           { return "TOKEN: WRITE"; }

    // Tema Especial Grupo 6: SETSWITCH
    "SETSWITCH" | "setswitch"                   { return "TOKEN: SETSWITCH"; }
    "CASE" | "case"                             { return "TOKEN: CASE"; }
    "ELSECASE" | "elsecase"                     { return "TOKEN: ELSECASE"; }
    "ENDSETCASE" | "endsetcase"                 { return "TOKEN: ENDSETCASE"; }

    // Operadores Lógicos
    "AND" | "and"                               { return "TOKEN: OP_AND"; }
    "OR" | "or"                                 { return "TOKEN: OP_OR"; }

    // Operadores Aritméticos y Asignación
    "::="                                       { return "TOKEN: ASIGNACION"; }
    "+"                                         { return "TOKEN: OP_SUMA"; }
    "-"                                         { return "TOKEN: OP_RESTA"; }
    "*"                                         { return "TOKEN: OP_MULT"; }
    "/"                                         { return "TOKEN: OP_DIV"; }
    // resto no va correccion profe

    // "%"                                         { return "TOKEN: OP_RESTO"; }

    // Operadores de Comparación
    "<"                                         { return "TOKEN: OP_MENOR"; }
    "<="                                        { return "TOKEN: OP_MENOR_IGUAL"; }
    ">"                                         { return "TOKEN: OP_MAYOR"; }
    ">="                                        { return "TOKEN: OP_MAYOR_IGUAL"; }
    "=="                                        { return "TOKEN: OP_IGUAL"; }
    "!="                                        { return "TOKEN: OP_DISTINTO"; }

    // Signos y Separadores
    "["                                         { return "TOKEN: COR_A"; }
    "]"                                         { return "TOKEN: COR_C"; }
    "("                                         { return "TOKEN: PAR_A"; }
    ")"                                         { return "TOKEN: PAR_C"; }
    ","                                         { return "TOKEN: COMA"; }
    ":"                                         { return "TOKEN: DOS_PUNTOS"; }

    // --- PATRONES COMPLEJOS Y TABLA DE SÍMBOLOS ---

    {ID}                 {
                            ts.agregar(yytext(), "ID", "", 0);
                            return "TOKEN: ID, LEXEMA: " + yytext();
                        }

    {CONST_INT}          {
                            if (!esEntero16BitsValido(yytext())) {
                                return errorLexico("Constante entera fuera de rango (16 bits): " + yytext());
                            }
                            ts.agregar("_" + yytext(), "CTE_E", yytext(), 0);
                            return "TOKEN: CONST_INT, VALOR: " + yytext();
                        }

    {CONST_REAL}         {
                            if (!esReal32BitsValido(yytext())) {
                                return errorLexico("Constante real fuera de rango (32 bits): " + yytext());
                            }
                            ts.agregar("_" + yytext(), "CTE_F", yytext(), 0);
                            return "TOKEN: CONST_REAL, VALOR: " + yytext();
                        }

    {CONST_STRING}       {
                            String valorReal = yytext().substring(1, yytext().length() - 1);

                            if (valorReal.length() > 30) {
                                return errorLexico("Constante string supera el máximo de 30 caracteres (" + valorReal.length() + " leídos)");
                            }

                            ts.agregar("_" + valorReal, "CTE_STR", valorReal, valorReal.length());
                            return "TOKEN: CONST_STRING, VALOR: " + yytext();
                        }

    // --- REGLAS DE EXCLUSIÓN ---

    {ESPACIO_BLANCO}     { /* Ignorar espacios y saltos de línea, no generan token */ }

    [^] {
        return errorLexico("Caracter no reconocido '" + yytext() + "'");
    }
}

// --- ESTADO EXCLUSIVO PARA COMENTARIOS ---
<COMENTARIO> {

    // Apertura de comentario anidado
    "//*" {
        nivelComentario++;
        // La consigna permite máximo 1 nivel de anidamiento (nivel 1 + 1 anidado = 2)
        if (nivelComentario > 2) {
            yybegin(YYINITIAL); // Reseteamos el estado para evitar bucles
            return errorLexico("Se superó el límite máximo de 1 nivel de anidamiento en comentarios.");
        }
    }

    // Cierre de comentario
    "*//" {
        nivelComentario--;
        // Volvemos al código normal cuando se cierra el comentario principal
        if (nivelComentario == 0) {
            yybegin(YYINITIAL);
        }
    }

    // Si llegamos a fin de archivo (EOF) con comentario sin cerrar, es error
    <<EOF>> {
        yybegin(YYINITIAL);
        return errorLexico("Comentario sin cerrar antes del fin de archivo.");
    }

    // Consume e ignora todo  dentro del comentario
    [^] {  }
}




