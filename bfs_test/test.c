#include <stdio.h>

int foo(char a){
    int b = 0;
    for(int i = 0; i < b; ++i){
        b += i;
    }
    return 1;
}

int main(int argc, char* argv[]){
    return foo(argv[1][0]);
}