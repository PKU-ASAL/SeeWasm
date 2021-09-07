#include <stdio.h>

int signed_int_add(void)
{
    int a, b;
    a = 2147483640;
    // b = 1;
    scanf("%d", &b);
    int c = a + b;
    printf("%d", c);

    return 0;
}

int signed_int_add_restricted(void)
{
    int a, b;
    a = 2147483640;
    // b = 1;
    scanf("%d", &b);
    if (b > 3)
    {
        return -1;
    }
    int c = a + b;
    printf("%d", c);

    return 0;
}

int signed_int_add_restricted_invalid(void)
{
    int a, b;
    a = 2147483640;
    // b = 1;
    scanf("%d", &b);
    if (b > 10)
    {
        return -1;
    }
    int c = a + b;
    printf("%d", c);

    return 0;
}

int unsigned_int_add_restricted(void)
{
    unsigned int a, b;
    a = 2147483640;
    // b = 1;
    scanf("%u", &b);
    if (b > 3)
    {
        return -1;
    }
    unsigned int c = a + b;
    printf("%u", c);

    return 0;
}

int main(void)
{
    signed_int_add();
    signed_int_add_restricted();
    signed_int_add_restricted_invalid();
    unsigned_int_add_restricted();

    return 0;
}