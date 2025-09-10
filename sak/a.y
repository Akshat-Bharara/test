%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char* c);
int yylex();

%}

%union
{
char* punc;
char* id;
char* op;
}

%token <punc> L_BRAC R_BRAC
%token <id> ID;
%token <op> RELAT_OP

%%
E: E RELAT_OP E
 | L_BRAC E R_BRAC
 | ID
%%

void yyerror(const char* c)
{
	printf("%s",c);
}

int main()
{
	if(yyparse()==0)
		printf("Correct");
}
