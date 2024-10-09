#include <stdio.h>
#include <stdlib.h>


int** matMult(int** a, int** b, int n) {
	// (4) Implement your matrix multiplication here. 
	// You will need to create a new matrix to store the product.
    int** c = (int**)malloc(n * sizeof(int*));
	int i, j, k;
    for (i = 0; i < n; i++) {
		*(c + i) = (int*)malloc(n * sizeof(int));
        for (j = 0; j < n; j++) {
            *(*(c + i) + j) = 0;  
			//c[i][j] = 0;
            for (k = 0; k < n; k++) {
                *(*(c + i) + j) += *(*(a + i) + k) * *(*(b + k) + j);
				//c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return c;
}

void printArray(int **array, int n) {
	// (2) Implement your printArray function here
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            printf("%d  ", *(*(array + i) + j));
        }
        printf("\n");
    }
}


int main() {
	int n = 4;
	// (1) Define 2 (n x n) arrays (matrices). 
	int **matA = (int**)malloc(n * sizeof(int*));
	int **matB = (int**)malloc(n * sizeof(int*));

	for(int i = 0; i < n; i++) {
    	*(matA + i) = (int*) calloc(n, sizeof(int));
		*(matB + i) = (int*) calloc(n, sizeof(int));
	}

	for (int i = 0; i < n; i++) {
    	for (int j = 0; j < n; j++) {
            *(*(matA + i) + j) = i + 1;
			*(*(matB + i) + j) = j + 2;
    	}
	}

	// (3) Call printArray to print out the 2 arrays here.
	printf("Matrix A:\n");
	printArray(matA, n);
	printf("Matrix B:\n");
	printArray(matB, n);
	
	// (5) Call matMult to multiply the 2 arrays here.
	int **matC = matMult(matA, matB, n);
	
	// (6) Call printArray to print out resulting array here.
	printf("Matrix C:\n");
	printArray(matC, n);
	
    return 0;
}