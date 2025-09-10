%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
%}

%token a B

%%

S:
      a S
    | a B
    ;

%%

void yyerror(const char *s) {
    return;
}

int main() {
    char input[100];  
    printf("Enter a string consisting of one or more 'a' followed by a single 'b':\n");
    
    if (fgets(input, sizeof(input), stdin) != NULL) {
        yy_scan_string(input); 
        if (yyparse() == 0) {
            printf("String accepted.\n");
        } else {
            printf("String rejected.\n");
        }
    } else {
        printf("Error reading input.\n");
    }
    return 0;
}
