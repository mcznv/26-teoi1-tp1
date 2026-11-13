package tp1;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java_cup.runtime.*;

%%
%public
%class Lexico
%cup
%line
%column

%{
    // Instancia pública de la Tabla de Símbolos para accederla desde la interfaz gráfica
    public TablaSimbolos ts = new TablaSimbolos();

    // Lista de errores léxicos
    public List<String> erroresLexicos = new ArrayList<>();

     // Contador para controlar la profundidad de anidamiento
    private int nivelComentario = 0;

    //Formatea errores léxicos de manera uniforme
    private void registrarErrorLexico(String mensaje) {
        String error = "ERROR LÉXICO en línea " + (yyline + 1) + ", columna " + (yycolumn + 1) + ": " + mensaje;
        erroresLexicos.add(error);
        System.err.println(error);
    }

    // Helper para construir los objetos Symbol de CUP
    private Symbol token(int tipo) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1);
    }

    private Symbol token(int tipo, Object valor) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1, valor);
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
        registrarErrorLexico("Cierre de comentario '*//' inesperado.");
        return token(sym.error);
    }

    // --- REGLAS LÉXICAS ---

    // Secciones del programa (Permite mayúsculas o minúsculas sin combinarlas)
    "DECLARE.SECTION" | "declare.section"       { return token(sym.DECLARE_SECTION); }
    "ENDDECLARE.SECTION" | "enddeclare.section" { return token(sym.ENDDECLARE_SECTION); }
    "PROGRAM.SECTION" | "program.section"       { return token(sym.PROGRAM_SECTION); }
    "ENDPROGRAM.SECTION" | "endprogram.section" { return token(sym.ENDPROGRAM_SECTION); }

    // Tipos de datos
    "FLOAT" | "float"                           { return token(sym.FLOAT); }
    "INT" | "int"                               { return token(sym.INT); }
    "STRING" | "string"                         { return token(sym.STRING); }

    // Ciclo y Decisiones
    "WHILE" | "while"                           { return token(sym.WHILE); }
    "ENDWHILE" | "endwhile"                     { return token(sym.ENDWHILE); }
    "IF" | "if"                                 { return token(sym.IF); }
    "ELSE" | "else"                             { return token(sym.ELSE); }
    "ENDIF" | "endif"                           { return token(sym.ENDIF); }

    // Funciones I/O
    "WRITE" | "write"                           { return token(sym.WRITE); }

    // Tema Especial Grupo 6: SETSWITCH
    "SETSWITCH" | "setswitch"                   { return token(sym.SETSWITCH); }
    "CASE" | "case"                             { return token(sym.CASE); }
    "ELSECASE" | "elsecase"                     { return token(sym.ELSECASE); }
    "ENDSETCASE" | "endsetcase"                 { return token(sym.ENDSETCASE); }

    // Operadores Lógicos
    "AND" | "and"                               { return token(sym.OP_AND); }
    "OR" | "or"                                 { return token(sym.OP_OR); }

    // Operadores Aritméticos y Asignación
    "::="                                       { return token(sym.ASIGNACION); }
    "+"                                         { return token(sym.OP_SUMA); }
    "-"                                         { return token(sym.OP_RESTA); }
    "*"                                         { return token(sym.OP_MULT); }
    "/"                                         { return token(sym.OP_DIV); }

    // Operadores de Comparación
    "<"                                         { return token(sym.OP_MENOR); }
    "<="                                        { return token(sym.OP_MENOR_IGUAL); }
    ">"                                         { return token(sym.OP_MAYOR); }
    ">="                                        { return token(sym.OP_MAYOR_IGUAL); }
    "=="                                        { return token(sym.OP_IGUAL); }
    "!="                                        { return token(sym.OP_DISTINTO); }

    // Signos y Separadores
    "["                                         { return token(sym.COR_A); }
    "]"                                         { return token(sym.COR_C); }
    "("                                         { return token(sym.PAR_A); }
    ")"                                         { return token(sym.PAR_C); }
    ","                                         { return token(sym.COMA); }
    ":"                                         { return token(sym.DOS_PUNTOS); }

    // --- PATRONES COMPLEJOS Y TABLA DE SÍMBOLOS ---

    {ID} {
        // El ID se envía al Parser. Se agregará a la Tabla de Símbolos en DECLARE.SECTION
        return token(sym.ID, yytext());
    }

    {CONST_INT} {
        if (!esEntero16BitsValido(yytext())) {
            registrarErrorLexico("Constante entera fuera de rango (16 bits): " + yytext());
            return token(sym.error);
        }
        ts.agregar("_" + yytext(), "CTE_E", yytext(), 0);
        return token(sym.CONST_INT, yytext());
    }

    {CONST_REAL} {
        if (!esReal32BitsValido(yytext())) {
            registrarErrorLexico("Constante real fuera de rango (32 bits): " + yytext());
            return token(sym.error);
        }
        ts.agregar("_" + yytext(), "CTE_F", yytext(), 0);
        return token(sym.CONST_REAL, yytext());
    }

    {CONST_STRING} {
        String valorReal = yytext().substring(1, yytext().length() - 1);

        if (valorReal.length() > 30) {
            registrarErrorLexico("Constante string supera el máximo de 30 caracteres (" + valorReal.length() + " leídos)");
            return token(sym.error);
        }

        ts.agregar("_" + valorReal, "CTE_STR", valorReal, valorReal.length());
        return token(sym.CONST_STRING, valorReal);
    }

    // --- REGLAS DE EXCLUSIÓN ---

    {ESPACIO_BLANCO} { /* Ignorar espacios y saltos de línea */ }

    [^] {
        registrarErrorLexico("Caracter no reconocido '" + yytext() + "'");
        return token(sym.error);
    }
}

// --- ESTADO EXCLUSIVO PARA COMENTARIOS ---
<COMENTARIO> {

    // Apertura de comentario anidado
    "//*" {
        nivelComentario++;
        if (nivelComentario > 2) {
            yybegin(YYINITIAL);
            registrarErrorLexico("Se superó el límite máximo de 1 nivel de anidamiento en comentarios.");
            return token(sym.error);
        }
    }

    // Cierre de comentario
    "*//" {
        nivelComentario--;
        if (nivelComentario == 0) {
            yybegin(YYINITIAL);
        }
    }

    // Fin de archivo con comentario abierto
    <<EOF>> {
        yybegin(YYINITIAL);
        registrarErrorLexico("Comentario sin cerrar antes del fin de archivo.");
        return token(sym.error);
    }

    // Consume e ignora todo dentro del comentario
    [^] { }
}