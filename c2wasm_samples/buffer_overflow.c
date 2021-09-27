#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vulnerableFunc(void)
{
    char a[8];
    strcpy(a, "abcdefsdfsdfsdf");
}

void vulnerableFunc2(void)
{
    char src[30], dest[30];

    strcpy(src, "This is source");
    strcpy(dest, "This is destination");

    // buffer overflow here
    strcat(dest, src);

    printf("Final destination string : |%s|", dest);
}

void nonVulnerableFunc(void)
{
    char buffer[30];

    strcpy(buffer, "this is non-vulnerable");
}

int main(void)
{
    nonVulnerableFunc();
    vulnerableFunc();
    vulnerableFunc2();

    return 0;
}