#include <stdio.h>

// Function declarations
int getInput();
void writePunish(int repeat, int typo);

int main()
{
    int repeat = 0;
    int typo = 0;
    
    // Get and the repeat count from the user
    printf("Enter the repetition count for the punishment phrase: ");
    repeat = getInput();
    while(repeat == -1) {
        printf("You entered an invalid value for the repetition count! Please re-enter: ");
        repeat = getInput();
    }
    printf("\n");
    
    // Get and the typo count from the user
    printf("Enter the line where you want to insert the typo: ");
    typo = getInput();
    while(typo == -1 || typo > repeat) {
        printf("You entered an invalid value for the typo count! Please re-enter: ");
        typo = getInput();
    }
    printf("\n");
    
    //get output
    writePunish(repeat, typo);
    
    return 0;
}

// Function to check if the input is a positive integer input from the user
int getInput() {
    int num;
    if (scanf("%d", &num) == 1 && num > 0) {
        return num;
    } else {
        while (getchar() != '\n');
        return -1;
    }
}

// Function to write out the punishment
void writePunish(int repeat, int typo){
    for (int i = 1; i <= repeat; i++) {
        if (i == typo) {
            printf("Cading wiht is C avesone!\n");
        } else {
            printf("Coding with C is awesome!\n");
        }
    }
}