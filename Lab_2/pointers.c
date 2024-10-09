#include <stdio.h>

int main() {
    int x, y, *px, *py;
    int arr[10];
    //2
    x = 0;
    y = 0;
    for (int i = 0; i < 10; i++) {
        arr[i] = 0;
    }

    // 1
    printf("x = %d\n", x);
    printf("y = %d\n", y);
    printf("arr[0] = %d\n", arr[0]);

    // 3
    printf("Address of x: %p\n", (void*)&x);
    printf("Address of y: %p\n", (void*)&y);

    // 4
    px = &x;
    py = &y;

    // 5
    printf("Value of px: %d\n", *px);
    printf("Address of px: %p\n", (void*)px);
    printf("Value of py: %d\n", *py);
    printf("Address of py: %p\n", (void*)&py);

    // 6
    for (int i = 0; i < 5; i++) {
        printf("arr[%d] = %d\n", i, *(arr + i));
    }

    // 7
    printf("Address of arr: %p\n", (void*)arr);
    printf("Address of arr[0]: %p\n", (void*)&arr[0]);

    // 8
    printf("Address of arr variable: %p\n", (void*)&arr);
    
    return 0;
}
