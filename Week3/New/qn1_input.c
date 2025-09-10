#include<stdio.h>
int add(int x, int y){
    int z = x + y;
    return z;
}
int main(){
    int x;
    int y;
    scanf("%d", x);
    scanf("%d",y);
    int answer = add(x,y);
    return answer;
}