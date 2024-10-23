#include <stdio.h>

int main() {
    int arr[3][3] = {   
        {10, 20, 30},
        {40, 50, 60},
        {70, 80, 90}
    };

    int *a = &arr[1][1]; 

    printf("Value at *(a + 3) - 2: %d\n", *(a + 3) - 2); 

    return 0;
}
