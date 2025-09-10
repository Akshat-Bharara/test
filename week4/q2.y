%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
}

%token <num> NUMBER ID
%type <num> E T

%left '+' '-'
%left '*' '/'

%%

E : T { printf("Result = %d\n", $$); }

T : T '+' T { $$ = $1 + $3; }
  | T '-' T { $$ = $1 - $3; }
  | T '*' T { $$ = $1 * $3; }
  | T '/' T { 
                if ($3 == 0) {
                    yyerror("Division by zero");
                    YYABORT;
                }
                $$ = $1 / $3; 
            }
  | '-' T { $$ = -$2; }
  | '(' T ')' { $$ = $2; }
  | NUMBER { $$ = $1; }
  | ID { $$ = 0; }  
  ;

%%

void yyerror(const char *s) {
    printf("\nExpression is invalid: %s\n", s);
}

int main() {
    printf("Enter an expression:\n");
    yyparse();
    return 0;
}