// Sample C input for lexer testing

#include <stdio.h>

// Global array declarations
int numbers[10];
float temperatures[5];
char name[50];
double values[3];

// Functions
void printNumbers(int arr[], int size);
int sumArray(int arr[], int size);
float averageTemperature(float temps[], int count);

// Function definitions
void printNumbers(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int sumArray(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

float averageTemperature(float temps[], int count) {
    float sum = 0.0;
    for (int i = 0; i < count; i++) {
        sum += temps[i];
    }
    return sum / count;
}

// Another array in local scope
void localArrayExample(void) {
    int localNumbers[4] = {1, 2, 3, 4};
    for (int i = 0; i < 4; i++) {
        printf("%d ", localNumbers[i]);
    }
}
