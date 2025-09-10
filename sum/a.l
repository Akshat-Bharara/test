%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int digit_sum(char* str) {
    int sum = 0;
    for (int i = 0; i < strlen(str); i++) {
        sum += str[i] - '0';
    }
    return sum;
}
%}

%%

[1-9][0-9][0-9]       { 
                        int sum = digit_sum(yytext);
                        if (sum == 9) {
                            printf("ACCEPTED: %s (sum = %d)\n", yytext, sum);
                        } else {
                            printf("REJECTED: %s (sum = %d, expected 9)\n", yytext, sum);
                        }
                      }

[0-9]+                { 
                        printf("REJECTED: %s (not a three-digit number)\n", yytext); 
                      }

[ \t\n]               { /* ignore whitespace */ }

.                     { 
                        printf("REJECTED: Invalid character '%c'\n", yytext[0]); 
                      }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter three-digit numbers (Ctrl+D to end):\n");
    printf("Valid numbers have digits that sum to 9\n");
    printf("Examples: 108, 117, 126, 135, 144, 207, 216, etc.\n\n");
    
    yylex();
    return 0;
}
