#include <stdio.h>

int main() {
    char charlist[8] = "ABCDEFGH";  

    int *a = (int *) charlist;      

    a[0] = 256;                    

    printf("charlist[1] is: %x\n", charlist[1]);  

    return 0;
}
