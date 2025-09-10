%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_num;

void yyerror(const char *s);
%}

%union {
    int num;
    char *str;
}

%token <str> IDENTIFIER
%token <num> NUMBER
%token IF ELSE FOR
%token EQ NE LT GT LE GE
%token PLUS MINUS MULT DIV ASSIGN
%token INCREMENT DECREMENT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON

%left PLUS MINUS
%left MULT DIV
%left EQ NE LT GT LE GE

%start program

%%

program:
    statement_list
    {
        printf("\n=== PARSING COMPLETED SUCCESSFULLY ===\n");
    }
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    if_statement
    | for_statement
    | assignment_statement SEMICOLON
    | expression_statement SEMICOLON
    | compound_statement
    ;

if_statement:
    IF LPAREN condition RPAREN statement
    {
        printf("Parsed: IF statement\n");
    }
    | IF LPAREN condition RPAREN statement ELSE statement
    {
        printf("Parsed: IF-ELSE statement\n");
    }
    ;

for_statement:
    FOR LPAREN for_init SEMICOLON condition SEMICOLON for_update RPAREN statement
    {
        printf("Parsed: FOR loop\n");
    }
    ;

for_init:
    | assignment_statement
    | IDENTIFIER ASSIGN expression
    {
        printf("For init: %s = expression\n", $1);
        free($1);
    }
    ;

for_update:
    | IDENTIFIER INCREMENT
    {
        printf("For update: %s++\n", $1);
        free($1);
    }
    | IDENTIFIER DECREMENT
    {
        printf("For update: %s--\n", $1);
        free($1);
    }
    | assignment_statement
    ;

condition:
    expression relational_op expression
    {
        printf("Parsed: Condition (expression relational operator expression)\n");
    }
    | expression
    {
        printf("Parsed: Condition (expression)\n");
    }
    ;

relational_op:
    EQ { printf("Relational operator: ==\n"); }
    | NE { printf("Relational operator: !=\n"); }
    | LT { printf("Relational operator: <\n"); }
    | GT { printf("Relational operator: >\n"); }
    | LE { printf("Relational operator: <=\n"); }
    | GE { printf("Relational operator: >=\n"); }
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression
    {
        printf("Parsed: Assignment (%s = expression)\n", $1);
        free($1);
    }
    ;

expression_statement:
    expression
    ;

expression:
    term
    | expression PLUS term
    {
        printf("Parsed: Addition\n");
    }
    | expression MINUS term
    {
        printf("Parsed: Subtraction\n");
    }
    ;

term:
    factor
    | term MULT factor
    {
        printf("Parsed: Multiplication\n");
    }
    | term DIV factor
    {
        printf("Parsed: Division\n");
    }
    ;

factor:
    IDENTIFIER
    {
        printf("Parsed: Identifier (%s)\n", $1);
        free($1);
    }
    | NUMBER
    {
        printf("Parsed: Number (%d)\n", $1);
    }
    | LPAREN expression RPAREN
    {
        printf("Parsed: Parenthesized expression\n");
    }
    ;

compound_statement:
    LBRACE statement_list RBRACE
    {
        printf("Parsed: Compound statement (block)\n");
    }
    | LBRACE RBRACE
    {
        printf("Parsed: Empty compound statement\n");
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error at line %d: %s\n", line_num, s);
}

int main(int argc, char *argv[]) {
    printf("=== PROGRAMMING LANGUAGE PARSER ===\n");
    printf("Parsing constructs: if, if-else, for loops\n");
    printf("================================================\n\n");

    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
        yyin = file;
        printf("Parsing file: %s\n\n", argv[1]);
    } else {
        printf("Enter your code (Ctrl+D to end):\n");
        yyin = stdin;
    }

    int result = yyparse();
    
    if (argc > 1) {
        fclose(yyin);
    }

    return result;
}