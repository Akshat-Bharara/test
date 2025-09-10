%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    char valid_emails[100][100];
    char valid_mobiles[100][100];

    int email_count = 0;
    int mobile_count = 0;
%}

%%
[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6} {
    strcpy(valid_emails[email_count], yytext);
    email_count++;
}

(\+91|91)?[1-9][0-9]{9} {
    strcpy(valid_mobiles[mobile_count], yytext);
    mobile_count++;
}

[ \t\n]+ ;  

. { }  

%%

int main() {

    yyin = stdin;

    yylex();  

    printf("Valid Emails:\n");
    for (int i = 0; i < email_count; i++) {
        printf("%s\n", valid_emails[i]);
    }

    printf("\nValid Mobile Numbers:\n");
    for (int i = 0; i < mobile_count; i++) {
        printf("%s\n", valid_mobiles[i]);
    }

    return 0;
}
