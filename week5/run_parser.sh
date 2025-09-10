#!/bin/bash

yacc -d parser.y
lex scanner.l
gcc -o parser y.tab.c lex.yy.c -ly -ll

mkdir -p outputs

for i in {1..5}
do
    input_file="inputs/t${i}.c"
    output_file="outputs/t${i}.out"

    echo "Processing $input_file -> $output_file"

    ./parser "$input_file" > "$output_file"
done

rm lex.yy.c
rm y.tab.c
rm y.tab.h

echo "Done."
