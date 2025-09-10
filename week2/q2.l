%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int identifier_count = 0;
    int operator_count = 0;
    int arithmetic_count = 0;
    int relational_count = 0;

    int identifier_freq[1000];
    char* identifiers[1000];
%}

%%
[a-zA-Z][a-zA-Z0-9]* {
    int found = 0;
    for (int i = 0; i < identifier_count; i++) {
        if (strcmp(identifiers[i], yytext) == 0) {
            found = 1;
            identifier_freq[i]++;
            break;
        }
    }
    if (!found) {
        identifiers[identifier_count] = strdup(yytext); 
        identifier_freq[identifier_count] = 1;
        identifier_count++;
    }
}

"+"|"-"|"*"|"/" {
    operator_count++;
    arithmetic_count++;
}

"=="|"<"|">"|"<="|">="|"!=" {
    operator_count++;
    relational_count++;
}

[ \t\n]+ ;  

. { }       

%%

int main() {

    yyin = stdin;

    yylex();  

    printf("Identifiers and their frequencies:\n");
    for (int i = 0; i < identifier_count; i++) {
        printf("%s: %d\n", identifiers[i], identifier_freq[i]);
    }

    printf("\nTotal count of arithmetic operators: %d\n", arithmetic_count);
    printf("Total count of relational operators: %d\n", relational_count);
    printf("Total count of all operators: %d\n", operator_count);

    return 0;
}
