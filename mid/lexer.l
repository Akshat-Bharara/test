%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"  
extern int yylval;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
STRING      \"[^\"]*\"
CHAR        \'[^\']*\'

%%

"int"           { return INT; }
"float"         { return FLOAT_TYPE; }
"char"          { return CHAR_TYPE; }
"void"          { return VOID; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }
"return"        { return RETURN; }
"printf"        { return PRINTF; }
"scanf"         { return SCANF; }
"main"          { return MAIN; }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"="             { return ASSIGN; }
"=="            { return EQ; }
"!="            { return NE; }
"<"             { return LT; }
">"             { return GT; }
"<="            { return LE; }
">="            { return GE; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }

{INTEGER}       { yylval = atoi(yytext); return NUMBER; }
{FLOAT}         { return FLOAT_NUM; }
{STRING}        { return STRING_LITERAL; }
{CHAR}          { return CHAR_LITERAL; }
{IDENTIFIER}    { return IDENTIFIER; }

[ \t]+          { /* ignore whitespace */ }
\n              { /* ignore newlines */ }

"//".*          { /* ignore single-line comments */ }
"/*"([^*]|(\*+[^*/]))*\*+"/"  { /* ignore multi-line comments */ }

.               { printf("Lexical Error: Unrecognized character '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}