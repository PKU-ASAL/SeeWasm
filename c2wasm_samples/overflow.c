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

int minus_one(num)
{
    // underflow here
    unsigned int num_one = num - 1;
    printf("%x", num_one);

    return 0;
}

int minus_two_variable(b, a)
{
    unsigned int c = b - a;
    printf("%x", c);

    return 0;
}

int main(void)
{
    unsigned int num = 0xffffffff;
    printf("%x", num);
    add_one(num);

    unsigned int a = 0xfffffff0;
    unsigned int b;
    scanf("%x", &b);
    add_two_variable(a, b);

    num = 0;
    minus_one(num);
    minus_two_variable(b, a);

    return 0;
}