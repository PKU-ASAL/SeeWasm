// #include <stdio.h>

// int foo(char a){
//     int b = 0;
//     // for(int i = 0; i < 0; ++i){
//     //     b += i;
//     // }
//     return 1;
// }

// int main(int argc, char* argv[]){
//     return foo(argv[1][0]);
// }


#include <stdio.h>

int foo(char a){
    if(a > 10){
        printf("a");
        return 0;
    }
    else if(a > 0){
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

