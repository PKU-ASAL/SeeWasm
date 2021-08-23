#include <stdio.h>

int add_one(num)
{
    // overflow here
    unsigned int num_one = num + 1;
    printf("%x", num_one);

    return 0;
}

int add_two_variable(a, b)
{
    unsigned int c = a + b;
    printf("%x", c);

    return 0;
}

int main(void)
{
    unsigned int num = 0xffffffff;
    add_one(num);

    unsigned int a = 0xfffffff0;
    unsigned int b;
    scanf("%x", &b);
    add_two_variable(a, b);

    return 0;
}