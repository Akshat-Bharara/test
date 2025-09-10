%{
#include <stdio.h>
#include "y.tab.h"

int yywrap();
%}

%%
"("	{yylval.punc=strdup(yytext); return L_BRAC;}
")"	{yylval.punc=strdup(yytext); return R_BRAC;}

[a-zA-Z_][a-zA-Z0-9_]*	{yylval.id=strdup(yytext); return ID;}

"<"|">"|">="|"<="|"!="|"=="	{yylval.op=strdup(yytext); return RELAT_OP;}
%%

int yywrap()
{
	return 1;
}
