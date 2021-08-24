#include <stdio.h>

int main(void)
{
    int a = 5;
    int b = 2;
    printf("%d", a / b);

    int c;
    scanf("%d", &c);
    printf("%d", a / c);

    int d;
    scanf("%d", &d);
    if (d == 0)
    {
        return -1;
    }
    printf("%d", a / d);

    return 0;
}