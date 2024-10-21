#include <stdio.h>
#include <stdlib.h>

void upcase_by_ref( char** n ) { 
    char* p = *n;
    if (*p >= 'a' && *p <= 'z') {  
            *p -= 32;  
        }
}

void upcase_name(char* names[], int i) { 
    upcase_by_ref( &(names[i]) );
}

int main() {
    
    char name0[] = "alice";
    char name1[] = "bob";
    char name2[] = "charlie";
    char name3[] = "diana";

    char* names[] = {name0, name1, name2, name3};

    int num_names = sizeof(names) / sizeof(char*);

    for (int i = 0; i < num_names; i++) {
        upcase_name(names, 3);
    }

    for (int i = 0; i < num_names; i++) {
        printf("%s\n", names[i]);
    }

    return 0;
}
