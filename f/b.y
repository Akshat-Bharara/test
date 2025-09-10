%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char* s);
int yylex(void);
%}

%union 
{
    int ival;
    float fval;
    char cval;
    char* sval;
}

%token <sval> IDENTIFIER HEADER_FILE STRING_CONST
%token <ival> NUMBER
%token <fval> FLOAT_NUM
%token <cval> CHAR_CONST
%token INCLUDE INT FLOAT CHAR VOID RETURN MAIN
%token IF ELSE FOR WHILE DO
%token PRINTF SCANF
%token EQ NEQ LT GT LTE GTE ASSIGN
%token INCREMENT DECREMENT PLUS MINUS MUL DIV MOD
%token AND OR NOT
%token LPAREN RPAREN LBRACE RBRACE LSQUARE RSQUARE
%token SEMI COMMA HASH

%type <ival> expression condition
%type <sval> data_type

%left OR
%left AND
%left EQ NEQ
%left LT GT LTE GTE
%left PLUS MINUS
%left MUL DIV MOD
%right NOT
%right ASSIGN
%left INCREMENT DECREMENT

%%

program: 
      includes main_function { printf("Parsed: Complete C program\n"); }
    | main_function { printf("Parsed: C program without includes\n"); }
    ;

includes:
      include_statement
    | includes include_statement
    ;

include_statement:
      HASH INCLUDE LT IDENTIFIER GT { printf("Parsed: #include <%s>\n", $4); }
    | HASH INCLUDE HEADER_FILE { printf("Parsed: #include %s\n", $3); }
    | HASH INCLUDE STRING_CONST { printf("Parsed: #include %s\n", $3); }
    ;

main_function:
      data_type MAIN LPAREN RPAREN compound_statement 
      { printf("Parsed: main function with return type %s\n", $1); }
    | data_type MAIN LPAREN parameter_list RPAREN compound_statement
      { printf("Parsed: main function with parameters\n"); }
    ;

data_type:
      INT { $$ = strdup("int"); }
    | FLOAT { $$ = strdup("float"); }
    | CHAR { $$ = strdup("char"); }
    | VOID { $$ = strdup("void"); }
    ;

parameter_list:
      data_type IDENTIFIER { printf("Parsed parameter: %s %s\n", $1, $2); }
    | parameter_list COMMA data_type IDENTIFIER 
      { printf("Parsed parameter: %s %s\n", $3, $4); }
    ;

compound_statement:
      LBRACE statement_list RBRACE { printf("Parsed: compound statement\n"); }
    | LBRACE RBRACE { printf("Parsed: empty compound statement\n"); }
    ;

statement_list: 
      statement 
    | statement_list statement
    ;

statement:
      declaration_statement { printf("Parsed: declaration statement\n"); }
    | assignment_statement { printf("Parsed: assignment statement\n"); }
    | if_statement { printf("Parsed: IF statement\n"); }
    | if_else_statement { printf("Parsed: IF-ELSE statement\n"); }
    | for_loop { printf("Parsed: FOR loop\n"); }
    | while_loop { printf("Parsed: WHILE loop\n"); }
    | do_while_loop { printf("Parsed: DO-WHILE loop\n"); }
    | printf_statement { printf("Parsed: printf statement\n"); }
    | scanf_statement { printf("Parsed: scanf statement\n"); }
    | return_statement { printf("Parsed: return statement\n"); }
    | compound_statement
    | expression_statement
    ;

declaration_statement:
      data_type IDENTIFIER SEMI 
      { printf("Parsed declaration: %s %s\n", $1, $2); }
    | data_type IDENTIFIER ASSIGN expression SEMI
      { printf("Parsed declaration with initialization: %s %s\n", $1, $2); }
    | data_type IDENTIFIER LSQUARE NUMBER RSQUARE SEMI
      { printf("Parsed array declaration: %s %s[%d]\n", $1, $2, $4); }
    ;

assignment_statement:
      IDENTIFIER ASSIGN expression SEMI
      { printf("Parsed assignment: %s = expression\n", $1); }
    | IDENTIFIER INCREMENT SEMI
      { printf("Parsed increment: %s++\n", $1); }
    | IDENTIFIER DECREMENT SEMI
      { printf("Parsed decrement: %s--\n", $1); }
    ;

expression_statement:
      expression SEMI
    | SEMI { printf("Parsed: empty statement\n"); }
    ;

if_statement:
      IF LPAREN condition RPAREN statement
    ;

if_else_statement:
      IF LPAREN condition RPAREN statement ELSE statement
    ;

for_loop:
      FOR LPAREN expression SEMI condition SEMI expression RPAREN statement
    | FOR LPAREN declaration_statement condition SEMI expression RPAREN statement
    ;

while_loop:
      WHILE LPAREN condition RPAREN statement
    ;

do_while_loop:
      DO statement WHILE LPAREN condition RPAREN SEMI
    ;

printf_statement:
      PRINTF LPAREN STRING_CONST RPAREN SEMI
      { printf("Parsed printf with string: %s\n", $3); }
    | PRINTF LPAREN STRING_CONST COMMA argument_list RPAREN SEMI
      { printf("Parsed printf with arguments\n"); }
    ;

scanf_statement:
      SCANF LPAREN STRING_CONST COMMA argument_list RPAREN SEMI
      { printf("Parsed scanf statement\n"); }
    ;

argument_list:
      expression
    | argument_list COMMA expression
    ;

return_statement:
      RETURN expression SEMI { printf("Parsed return with value\n"); }
    | RETURN SEMI { printf("Parsed return without value\n"); }
    ;

expression:
      IDENTIFIER ASSIGN expression     
      { printf("Parsed assignment: %s\n", $1); }
    | expression PLUS expression       
      { printf("Parsed operator: +\n"); }
    | expression MINUS expression      
      { printf("Parsed operator: -\n"); }
    | expression MUL expression        
      { printf("Parsed operator: *\n"); }
    | expression DIV expression        
      { printf("Parsed operator: /\n"); }
    | expression MOD expression        
      { printf("Parsed operator: %%\n"); }
    | LPAREN expression RPAREN         
      { $$ = $2; }
    | NUMBER                           
      { $$ = $1; printf("Parsed number: %d\n", $1); }
    | FLOAT_NUM                        
      { $$ = (int)$1; printf("Parsed float: %f\n", $1); }
    | CHAR_CONST                       
      { $$ = (int)$1; printf("Parsed char: '%c'\n", $1); }
    | IDENTIFIER                       
      { $$ = 0; printf("Parsed identifier: %s\n", $1); }
    | IDENTIFIER LSQUARE expression RSQUARE
      { $$ = 0; printf("Parsed array access: %s[]\n", $1); }
    | IDENTIFIER INCREMENT
      { $$ = 0; printf("Parsed post-increment: %s++\n", $1); }
    | IDENTIFIER DECREMENT
      { $$ = 0; printf("Parsed post-decrement: %s--\n", $1); }
    | INCREMENT IDENTIFIER
      { $$ = 0; printf("Parsed pre-increment: ++%s\n", $2); }
    | DECREMENT IDENTIFIER
      { $$ = 0; printf("Parsed pre-decrement: --%s\n", $2); }
    ;

condition:
      expression EQ expression         
      { printf("Parsed condition: ==\n"); }
    | expression NEQ expression        
      { printf("Parsed condition: !=\n"); }
    | expression LT expression         
      { printf("Parsed condition: <\n"); }
    | expression GT expression         
      { printf("Parsed condition: >\n"); }
    | expression LTE expression        
      { printf("Parsed condition: <=\n"); }
    | expression GTE expression        
      { printf("Parsed condition: >=\n"); }
    | condition AND condition          
      { printf("Parsed logical: &&\n"); }
    | condition OR condition           
      { printf("Parsed logical: ||\n"); }
    | NOT condition                    
      { printf("Parsed logical: !\n"); }
    | LPAREN condition RPAREN          
      { $$ = $2; }
    | expression                       
      { $$ = $1; }
    ;

%%

void yyerror(const char* s)
{
    extern int yylineno;
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, s);
}

extern FILE *yyin;

int main(int argc, char **argv)
{
    if(argc < 2)
    {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if(!yyin)
    {
        perror("Error opening file");
        return 1;
    }
    
    printf("Parsing C program...\n");
    printf("=====================\n");
    
    int result = yyparse();
    
    fclose(yyin);
    
    if(result == 0)
        printf("\n=====================\nParsing completed successfully!\n");
    else
        printf("\n=====================\nParsing failed with errors.\n");
        
    return result;
}
