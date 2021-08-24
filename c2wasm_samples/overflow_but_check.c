#include <stdio.h>
#include <assert.h>

int add_one(num)
{
    // overflow here
    unsigned int num_one = num + 1;
    printf("%x", num_one);

    assert(num_one <= num);

    return 0;
}

int add_two_variable(a, b)
{
    unsigned int c = a + b;
    printf("%x", c);

    assert(c <= a && c <= b);

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

    return 0;
}