flex -o qn2.c qn2.l
g++ -std=c++17 qn2.c -lfl -o qn2

./qn1 < qn2_input.c
