%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
extern FILE *yyin;

int syntax_errors = 0;
int semantic_errors = 0;
%}

/* Token definitions */
%token INT FLOAT_TYPE CHAR_TYPE VOID
%token IF ELSE WHILE FOR RETURN
%token PRINTF SCANF MAIN
%token PLUS MINUS MULTIPLY DIVIDE ASSIGN
%token EQ NE LT GT LE GE AND OR NOT
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE
%token NUMBER FLOAT_NUM STRING_LITERAL CHAR_LITERAL IDENTIFIER

/* Precedence and associativity */
%left OR
%left AND
%left EQ NE
%left LT GT LE GE
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right NOT
%right ASSIGN

/* Start symbol */
%start program

%%

/* Grammar rules */
program:
    function_list
    {
        printf("Program parsed successfully!\n");
        if (syntax_errors == 0 && semantic_errors == 0)
            printf("No errors detected.\n");
        else
            printf("Total errors: %d syntax, %d semantic\n", syntax_errors, semantic_errors);
    }
    ;

function_list:
    function_list function
    | function
    ;

function:
    type IDENTIFIER LPAREN parameter_list RPAREN LBRACE statement_list RBRACE
    | type MAIN LPAREN RPAREN LBRACE statement_list RBRACE
    | VOID IDENTIFIER LPAREN parameter_list RPAREN LBRACE statement_list RBRACE
    | VOID MAIN LPAREN RPAREN LBRACE statement_list RBRACE
    ;

type:
    INT
    | FLOAT_TYPE
    | CHAR_TYPE
    ;

parameter_list:
    parameter_list COMMA parameter
    | parameter
    | /* empty */
    ;

parameter:
    type IDENTIFIER
    ;

statement_list:
    statement_list statement
    | statement
    | /* empty */
    ;

statement:
    declaration SEMICOLON
    | assignment SEMICOLON
    | function_call SEMICOLON
    | if_statement
    | while_statement
    | for_statement
    | return_statement SEMICOLON
    | compound_statement
    ;

declaration:
    type variable_list
    ;

variable_list:
    variable_list COMMA IDENTIFIER
    | IDENTIFIER
    ;

assignment:
    IDENTIFIER ASSIGN expression
    ;

function_call:
    PRINTF LPAREN argument_list RPAREN
    | SCANF LPAREN argument_list RPAREN
    | IDENTIFIER LPAREN argument_list RPAREN
    ;

argument_list:
    argument_list COMMA expression
    | expression
    | /* empty */
    ;

if_statement:
    IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    ;

while_statement:
    WHILE LPAREN expression RPAREN statement
    ;

for_statement:
    FOR LPAREN assignment SEMICOLON expression SEMICOLON assignment RPAREN statement
    | FOR LPAREN declaration SEMICOLON expression SEMICOLON assignment RPAREN statement
    ;

return_statement:
    RETURN expression
    | RETURN
    ;

compound_statement:
    LBRACE statement_list RBRACE
    ;

expression:
    expression PLUS expression
    | expression MINUS expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression EQ expression
    | expression NE expression
    | expression LT expression
    | expression GT expression
    | expression LE expression
    | expression GE expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    | LPAREN expression RPAREN
    | IDENTIFIER
    | NUMBER
    | FLOAT_NUM
    | STRING_LITERAL
    | CHAR_LITERAL
    ;

%%

void yyerror(const char *s) {
    printf("Syntax Error: %s\n", s);
    syntax_errors++;
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            printf("Error: Cannot open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Starting C code validation...\n");
    yyparse();
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}