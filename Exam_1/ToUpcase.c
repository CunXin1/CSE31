#include <stdio.h>
#include <stdlib.h>

void upcase_by_ref( char** n ) { 
    char* p = *n;
    while(*p) {
        if (*p >= 'a' && *p <= 'z') {  
            *p -= 32;  
        }
        p++;
    }
}

void upcase_name(char* names[], int i) { 
    upcase_by_ref( &(names[i]) );
}

int main() {





    //char* names[] = {"alice", "bob", "charlie", "diana"};




    char name0[] = "alice";
    char name1[] = "bob";
    char name2[] = "charlie";
    char name3[] = "diana";
    char* names[] = {name0, name1, name2, name3};





    upcase_name(names, 2);
    
    for(int i = 0; i < 4; i++){
        printf("%s\n", names[i]);
    }

    return 0;
}
