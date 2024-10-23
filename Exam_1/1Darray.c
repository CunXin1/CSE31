#include <stdio.h>

int main() {
    int arr[7] = {10, 20, 30, 40, 0, 60, 70}; 

    int *a = (arr + 1); 
    int *b = &arr[6]; 

    int result = *(a + 2) + *(b - 1);

    printf("Value of *(a + 2) + *(b - 1): %d\n", result);

    return 0;
}
