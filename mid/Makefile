# Makefile for C Parser using Lex and Yacc

CC = gcc
CFLAGS = -Wall -g

# Default target
all: c_parser

# Generate parser from yacc file
y.tab.c y.tab.h: parser.y
	yacc -d parser.y

# Generate lexer from lex file
lex.yy.c: lexer.l y.tab.h
	lex lexer.l

# Compile the parser
c_parser: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o c_parser y.tab.c lex.yy.c -ll

# Test with sample files
test: c_parser
	@echo "Testing with sample C files..."
	@echo "Valid program:"
	./c_parser test_valid.c
	@echo "\nInvalid program:"
	./c_parser test_invalid.c

# Clean generated files
clean:
	rm -f y.tab.c y.tab.h lex.yy.c c_parser

# Create sample test files
samples:
	@echo "Creating sample test files..."
	@echo -e "#include <stdio.h>\nint main() {\n    int x = 10;\n    printf(\"Hello World\");\n    return 0;\n}" > test_valid.c
	@echo -e "int main() {\n    int x = 10\n    printf(\"Missing semicolon\")\n    return 0;\n}" > test_invalid.c
	@echo "Sample files created: test_valid.c and test_invalid.c"

.PHONY: all test clean samples