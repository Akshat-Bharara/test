%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int line_num = 1;
%}

/* Regular expressions */
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+
WHITESPACE  [ \t]+

%%

"if"        { printf("Token: IF\n"); return IF; }
"else"      { printf("Token: ELSE\n"); return ELSE; }
"for"       { printf("Token: FOR\n"); return FOR; }

"=="        { printf("Token: EQ\n"); return EQ; }
"!="        { printf("Token: NE\n"); return NE; }
"<="        { printf("Token: LE\n"); return LE; }
">="        { printf("Token: GE\n"); return GE; }
"<"         { printf("Token: LT\n"); return LT; }
">"         { printf("Token: GT\n"); return GT; }

"+"         { printf("Token: PLUS\n"); return PLUS; }
"-"         { printf("Token: MINUS\n"); return MINUS; }
"*"         { printf("Token: MULT\n"); return MULT; }
"/"         { printf("Token: DIV\n"); return DIV; }
"="         { printf("Token: ASSIGN\n"); return ASSIGN; }

"++"        { printf("Token: INCREMENT\n"); return INCREMENT; }
"--"        { printf("Token: DECREMENT\n"); return DECREMENT; }

"("         { printf("Token: LPAREN\n"); return LPAREN; }
")"         { printf("Token: RPAREN\n"); return RPAREN; }
"{"         { printf("Token: LBRACE\n"); return LBRACE; }
"}"         { printf("Token: RBRACE\n"); return RBRACE; }
";"         { printf("Token: SEMICOLON\n"); return SEMICOLON; }

{IDENTIFIER} { 
    printf("Token: IDENTIFIER (%s)\n", yytext); 
    yylval.str = strdup(yytext);
    return IDENTIFIER; 
}

{NUMBER}    { 
    printf("Token: NUMBER (%s)\n", yytext); 
    yylval.num = atoi(yytext);
    return NUMBER; 
}

{WHITESPACE} {  }

\n          { line_num++; }

.           { 
    printf("Unexpected character: %c\n", yytext[0]); 
    return yytext[0]; 
}

%%

int yywrap() {
    return 1;
}