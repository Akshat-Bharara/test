%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);
%}

%token IDENTIFIER NUMBER
%token LE GE EQ NE LT GT
%token PLUS MINUS MULT DIV
%token LPAREN RPAREN
%token INVALID

%left LE GE EQ NE LT GT
%left PLUS MINUS
%left MULT DIV
%nonassoc LPAREN RPAREN

%%

program:
    expression { 
        printf("Valid relational expression\n"); 
        return 0; 
    }
    ;

expression:
    relational_expr
    ;

relational_expr:
    operand
    | relational_expr LT relational_expr
    | relational_expr GT relational_expr  
    | relational_expr LE relational_expr
    | relational_expr GE relational_expr
    | relational_expr EQ relational_expr
    | relational_expr NE relational_expr
    | LPAREN relational_expr RPAREN
    ;

operand:
    IDENTIFIER
    | NUMBER
    ;

%%

void yyerror(const char *s) {
    printf("Invalid relational expression: %s\n", s);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Enter a relational expression (Ctrl+D to end):\n");
    
    if (yyparse() == 0) {
        return 0;
    } else {
        return 1;
    }
}
