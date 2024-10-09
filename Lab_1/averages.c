#include <stdio.h>
#include <stdlib.h>

int checkNumber(int num); // Check if the sum of digits is even or odd
void printOutput(int count); // Print the prompt with the correct ordinal suffix

int main(){
    int sumOfOdd = 0, sumOfEven = 0;
    int oddCount = 0, evenCount = 0;
    int count = 1;
    
    int input = -1;
    
// Loop to read inputs until the user enters '0'
    while(1){
        printOutput(count);
        scanf("%d", &input);

	// Break the loop if input is '0'
        if (input == 0) break;
        
        int result = checkNumber(input);
        
	// Accumulate sums and counts based on the digit sum being even or odd
        if (result == 1){
            sumOfEven += input;
            evenCount++;
        } else if (result == -1){
            sumOfOdd += input;
            oddCount++;
        }
        count++;
    }
    
    // Output the results
    if (evenCount > 0 && oddCount > 0){
        printf("\nAverage of input values whose digits sum up to an even number: %.2f", (double)sumOfEven / evenCount);
        printf("\nAverage of input values whose digits sum up to an odd number: %.2f", (double)sumOfOdd / oddCount);
    } else if (evenCount > 0 && oddCount == 0){
        printf("\nAverage of inputs whose digits sum up to an even number: %.2f", (double)sumOfEven / evenCount);
    } else if (evenCount == 0 && oddCount > 0){
        printf("\nAverage of inputs whose digits sum up to an odd number: %.2f", (double)sumOfOdd / oddCount);
    } else {
        printf("\nThere is no average to compute.");
    }
    return 0;
}

// Function to calculate if the sum of digits is even or odd
int checkNumber(int num){
    int sum = 0;
    while(num != 0){
        sum += abs(num % 10);
        num /= 10;
    }
    
    if (sum % 2 == 0) {
        return 1;
    } else {
        return -1;
    }
    
}

// Function to output the ordinal number prompt
void printOutput(int count){
    const char* suffix = "th";
    switch (count % 10) {
        case 1: 
                suffix = "st"; 
                break;
            case 2: 
                suffix = "nd"; 
                break;
            case 3: 
                suffix = "rd";  
                break;
            default:
                suffix = "th"; 
                break;
    }
    if (count >= 11 && count <= 13) {
        suffix = "th";
    }
    printf("Enter the %d%s value: ", count, suffix);
}