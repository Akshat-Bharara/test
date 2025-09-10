%option yylineno
%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX_SYM 256
#define MAX_NAME 1024 
#define MAX_TABLE 256

typedef struct {
    char name[MAX_NAME];
    char token[MAX_SYM];
    int count;
    int lineNum;
} Symbol;

Symbol *symTable[MAX_TABLE];
int symInd = 0;



void add_symbol(char * lexeme, int tokenNumber, int lineNum)
{
    int found = 0;
    for(int i = 0; i < symInd; i++)
    {
        if(strcmp(lexeme, symTable[i]->name) == 0)
        {
            symTable[i]->count++;
            found = 1;
            break;
        }
    }
    if(found == 0)
    {
        Symbol *s = malloc(sizeof(Symbol));
        strcpy(s->name, lexeme);
        
        if (tokenNumber == IDENTIFIER)
            strcpy(s->token, "IDENTIFIER");
        else if (tokenNumber == IF || tokenNumber == ELSE || tokenNumber == FOR || 
                 tokenNumber == INT || tokenNumber == FLOAT || tokenNumber == CHAR ||
                 tokenNumber == VOID || tokenNumber == RETURN || tokenNumber == INCLUDE ||
                 tokenNumber == MAIN || tokenNumber == WHILE)
            strcpy(s->token, "KEYWORD");
        else
            strcpy(s->token, "FUNCTION");
        s->count = 1;
        s->lineNum = lineNum;
        symTable[symInd++] = s;
    }
}

%}

%%
"#[^\n]" {}
"#include"      { return INCLUDE; }
"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }
"void"          { return VOID; }
"return"        { return RETURN; }
"main"          { add_symbol(yytext, MAIN, yylineno); 
                  yylval.sval = strdup(yytext); return MAIN; }
"if"            { add_symbol(yytext, IF, yylineno); return IF; }
"else"          { add_symbol(yytext, ELSE, yylineno); return ELSE; }
"for"           { add_symbol(yytext, FOR, yylineno); return FOR; }
"while"         { add_symbol(yytext, WHILE, yylineno); return WHILE; }
"do"            { add_symbol(yytext, DO, yylineno); return DO; }
"printf"        { add_symbol(yytext, PRINTF, yylineno); 
                  yylval.sval = strdup(yytext); return PRINTF; }
"scanf"         { add_symbol(yytext, SCANF, yylineno); 
                  yylval.sval = strdup(yytext); return SCANF; }

"=="            { return EQ; }
"!="            { return NEQ; }
"<"             { return LT; }
">"             { return GT; }
"<="            { return LTE; }
">="            { return GTE; }
"="             { return ASSIGN; }
"++"            { return INCREMENT; }
"--"            { return DECREMENT; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
"%"             { return MOD; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["            { return LSQUARE; }
"]"            { return RSQUARE; }
";"             { return SEMI; }
","             { return COMMA; }
"#"             { return HASH; }

[0-9]+\.[0-9]+  { yylval.fval = atof(yytext);
                  return FLOAT_NUM; }

[0-9]+          { yylval.ival = atoi(yytext); 
                  return NUMBER; }

'[^']'          { yylval.cval = yytext[1];
                  return CHAR_CONST; }

\"[^\"]*\"      { yylval.sval = strdup(yytext);
                  return STRING_CONST; }


[a-zA-Z_][a-zA-Z0-9_]* {
                    add_symbol(yytext, IDENTIFIER, yylineno);
                    yylval.sval = strdup(yytext);
                    return IDENTIFIER;
                }

[ \t]+          { /* skip whitespace */ }
\n              { /* skip newlines */ }
\r              { /* skip carriage returns */ }

\/\*([^*]|\*+[^*/])*\*+\/ { /* skip multi-line comments */ }
\/\/.*$         { /* skip single-line comments */ }

.               { /* ignore unknown characters */ }

%%

int yywrap()
{
    // Print symbol table
    printf("\n===== SYMBOL TABLE =====\n");
    printf("%-20s %-15s %-10s %-10s\n", "Name", "Token", "Count", "Line#");
    printf("------------------------------------------------------------\n");
    for (int i = 0; i < symInd; i++) {
        printf("%-20s %-15s %-10d %-10d\n",
               symTable[i]->name,
               symTable[i]->token,
               symTable[i]->count,
               symTable[i]->lineNum);
    }    
    return 1;
}
