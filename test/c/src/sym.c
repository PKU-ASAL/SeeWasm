#include <stdio.h>

int foo(char a){
    if (a < 'a') {
        printf("a");
        return 0;
    }
    else if (a < 'z') {
        printf("b");
        return 1;
    }
    else {
        printf("c");
        return 2;
    }
}

int main(int argc, char* argv[]){
    return foo(argv[1][0]);
}