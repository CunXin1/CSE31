#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declarations of the two functions you will implement
// Feel free to declare any helper functions or global variables
void printPuzzle(char** arr);
char toUpper(char c);
void printInt(int** arr);
int isValid(int x, int y);
void searchPuzzle(char** arr, char* word);
int repeatSearch(char **arr, int **path, int x, int y, char *word, int index);
int noRepeatSearch(char **arr, int **path, int x, int y, char *word, int index);
void output(int **path, int found);
int getDx(int dir);
int getDy(int dir);
int bSize;

// Main function, DO NOT MODIFY 	
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <puzzle file name>\n", argv[0]);
        return 2;
    }
    int i, j;
    FILE *fptr;

    // Open file for reading puzzle
    fptr = fopen(argv[1], "r");
    if (fptr == NULL) {
        printf("Cannot Open Puzzle File!\n");
        return 0;
    }

    // Read the size of the puzzle block
    fscanf(fptr, "%d\n", &bSize);
    
    // Allocate space for the puzzle block and the word to be searched
    char **block = (char**)malloc(bSize * sizeof(char*));
    char *word = (char*)malloc(20 * sizeof(char));

    // Read puzzle block into 2D arrays
    for(i = 0; i < bSize; i++) {
        *(block + i) = (char*)malloc(bSize * sizeof(char));
        for (j = 0; j < bSize - 1; ++j) {
            fscanf(fptr, "%c ", *(block + i) + j);            
        }
        fscanf(fptr, "%c \n", *(block + i) + j);
    }
    fclose(fptr);

    printf("Enter the word to search: ");
    scanf("%s", word);
    
    // Print out original puzzle grid
    printf("\nPrinting puzzle before search:\n");
    printPuzzle(block);
    // Call searchPuzzle to the word in the puzzle
    searchPuzzle(block, word);
    return 0;
}

// Function to get the x-direction offset based on direction index
int getDx(int dir) {
    switch (dir) {
        case 0: return -1;
        case 1: return -1;
        case 2: return -1;
        case 3: return 0;
        case 4: return 0;
        case 5: return 1;
        case 6: return 1;
        case 7: return 1;
        default: return 0;
    }
}

// Function to get the y-direction offset based on direction index
int getDy(int dir) {
    switch (dir) {
        case 0: return -1;
        case 1: return 0;
        case 2: return 1;
        case 3: return -1;
        case 4: return 1;
        case 5: return -1;
        case 6: return 0;
        case 7: return 1;
        default: return 0;
    }
}

// Function to print the puzzle grid
void printPuzzle(char** arr) {
    // This function will print out the complete puzzle grid (arr). 
    // It must produce the output in the SAME format as the samples 
    // in the instructions.
    // Your implementation here...
    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            printf("%c ", *(*(arr + i) + j));
        }
        printf("\n");
    }
    printf("\n");
}

// Function to convert a character to uppercase
char toUpper(char c) {
    if (c >= 'a' && c <= 'z')
        return c - ('a' - 'A');
    return c;
}

// Function to print the integer path grid
void printInt(int** arr) {
    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            printf("%d\t", *(*(arr + i) + j));
        }
        printf("\n");
    }
}

// Function to check if the coordinates are within the grid
int isValid(int x, int y) {
    return x >= 0 && x < bSize && y >= 0 && y < bSize;
}

// Function to search without repeating cells
int noRepeatSearch(char **arr, int **path, int x, int y, char *word, int index) {
    if (toUpper(*(*(arr + x) + y)) != toUpper(*(word + index)) || *(*(path + x) + y) != 0) {
        return 0;
    }

    *(*(path + x) + y) = index + 1;

    if (*(word + index + 1) == '\0') {
        return 1;
    }

    for(int dir = 0; dir < 8; dir++) {
        int newX = x + getDx(dir);
        int newY = y + getDy(dir);
        if (isValid(newX, newY)) {
            if (noRepeatSearch(arr, path, newX, newY, word, index + 1)) {
                return 1;
            }
        }
    }

    *(*(path + x) + y) = 0;
    return 0;
}

// Function to search allowing cell reuse
int repeatSearch(char **arr, int **path, int x, int y, char *word, int index) {
    int found = 0;

    if (toUpper(*(*(arr + x) + y)) != toUpper(*(word + index))) {
        return 0;
    }

    *(*(path + x) + y) = *(*(path + x) + y) * 10 + (index + 1);

    if (*(word + index + 1) == '\0') {
        return 1;
    }

    for (int dir = 0; dir < 8; dir++) {
        int newX = x + getDx(dir);
        int newY = y + getDy(dir);
        if (isValid(newX, newY)) {
            if (repeatSearch(arr, path, newX, newY, word, index + 1)) {
                found = 1;
            }
        }
    }

    if (found) {
        return 1;
    } else {
        *(*(path + x) + y) /= 10;
        return 0;
    }
}

// Function to search the puzzle for the word
void searchPuzzle(char **arr, char *word) {
    int found = 0;
    int **path = (int **)malloc(bSize * sizeof(int *));
    for (int i = 0; i < bSize; i++) {
        *(path + i) = (int *)calloc(bSize, sizeof(int));
    }

    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            if (toUpper(*(*(arr + i) + j)) == toUpper(*(word + 0))) {
                if (noRepeatSearch(arr, path, i, j, word, 0)) {
                    found = 1;
                    break;
                }
                if (repeatSearch(arr, path, i, j, word, 0)) {
                    found = 1;
                    break;
                }
            }
        }
    }
    output(path, found);
}

// Function to output the search results
void output(int **path, int found) {