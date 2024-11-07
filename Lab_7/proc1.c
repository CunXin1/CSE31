#include <stdio.h>

int m = 10;
int n = 5;

int sum(int a, int b) {
    return a + b;
}

int main() {
    
    int a0 = m;
    int a1 = n;

    int v0 = sum(a0, a1);

    printf("%d\n", v0);

    return 0;
}
