%{
#include "y.tab.h"
%}

%%

a       { return a; }
b       { return B; }  
[ \t\n] ;              
.       { printf("Invalid character: %s\n", yytext); exit(1); }

%%
