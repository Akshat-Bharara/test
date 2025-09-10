%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylval;
%}

%%

[a-zA-Z][a-zA-Z0-9]*  { return IDENTIFIER; }
[0-9]+                { return NUMBER; }
"<="                  { return LE; }
">="                  { return GE; }
"=="                  { return EQ; }
"!="                  { return NE; }
"<"                   { return LT; }
">"                   { return GT; }
"("                   { return LPAREN; }
")"                   { return RPAREN; }
[ \t\n]               { /* ignore whitespace */ }
.                     { 
                        printf("Invalid token: %c\n", yytext[0]); 
                        return INVALID; 
                      }

%%

int yywrap() {
    return 1;
}
