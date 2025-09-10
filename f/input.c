// #include <stdio.h>

int main() {
    int a = 10;
    int b = 20;
    float result = 0.0;
    char ch = 'A';
    
    printf("Enter a number: ");
    scanf("%d", &a);
    
    if (a > b) {
        printf("a is greater than b\n");
        result = a + b;
    } else {
        printf("b is greater or equal to a\n");
        result = b - a;
    }
    
    for (int i = 0; i < 5; i++) {
        printf("Loop iteration: %d\n", i);
        a++;
    }
    
    while (b > 0) {
        b--;
        if (b == 15) {
            break;
        }
    }
    
    return 0;
}
