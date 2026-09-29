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
%}

// --- EXPRESIONES REGULARES ---

// Caracteres básicos
LETRA = [a-zA-Z]
DIGITO = [0-9]
CARACTERSTRING = [^\n\"\\]
ESPACIO_BLANCO = [ \t\r\n]+

// Comentarios multilínea o de una línea delimitados por //* y *//
// JFlex utiliza ~ para indicar "todo hasta encontrar la siguiente cadena"
COMENTARIO = "//*" ~"*//"

// Identificadores y Constantes
ID = {LETRA}({LETRA}|{DIGITO})*
CONST_INT = (0 | [1-9]{DIGITO}*)
CONST_REAL = {CONST_INT}\.{DIGITO}+
CONST_STRING = \"({CARACTERSTRING}|\\.)*\"

%%
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
"%"                                         { return "TOKEN: OP_RESTO"; }

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
                        ts.agregar(yytext(), "CTE_E", yytext(), 0);
                        return "TOKEN: CONST_INT, VALOR: " + yytext();
                     }

{CONST_REAL}         {
                        ts.agregar(yytext(), "CTE_F", yytext(), 0);
                        return "TOKEN: CONST_REAL, VALOR: " + yytext();
                     }

{CONST_STRING}       {
                        // Calculamos el valor y la longitud sin incluir las comillas para la Tabla de Símbolos
                        String valorReal = yytext().replace("\"", "");
                        ts.agregar(yytext(), "CTE_STR", valorReal, valorReal.length());
                        return "TOKEN: CONST_STRING, VALOR: " + yytext();
                     }

// --- REGLAS DE EXCLUSIÓN ---

{ESPACIO_BLANCO}     { /* Ignorar espacios y saltos de línea, no generan token */ }
{COMENTARIO}         { /* Ignorar bloques de comentarios, no generan token */ }

// Manejo de Errores: Cualquier caracter que no coincida con nada de lo anterior
[^]                  { return "ERROR LÉXICO en línea " + (yyline+1) + " columna " + yycolumn + ": Caracter no reconocido '" + yytext() + "'"; }