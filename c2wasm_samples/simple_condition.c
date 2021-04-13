#include <stdio.h>

int main(int argc, char **argv){
    if(argc < 1) {
        printf("how???\n");
    } else if(argc == 1) {
        printf("no arg\n");
    } else {
        printf("number of arg: %d\n", argc);
    }
    return 0;
}