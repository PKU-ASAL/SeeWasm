#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vulnerableFunc(void)
{
    char a[8];
    // buffer overflow here
    strcpy(a, "abcdefsdfsdfsdf");

    // print a to test
    printf("%s", a);
}

void vulnerableFunc2(void)
{
    char src[30], dest[30];

    strcpy(src, "This is source");
    strcpy(dest, "This is destination");

    // print to test
    printf("%s", src);
    printf("%s", dest);

    // buffer overflow here
    strcat(dest, src);

    // print to test
    printf("Final destination string : |%s|", dest);
}

void nonVulnerableFunc(void)
{
    char buffer[30];
    strcpy(buffer, "this is non-vulnerable");

    // print char 'h' to verify if the memory is normal
    printf("%c", buffer[1]);
}

int main(void)
{
    nonVulnerableFunc();
    vulnerableFunc();
    vulnerableFunc2();

    return 0;
}