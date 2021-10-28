// C/C++ program to demonstrate that floating point
// addition may not be associative.
#include <stdio.h>

int main()
{
    // A and B have sane values but apposite signs
    float A = -500000000;
    float B = 400000000;

    float C = 1;

    printf("A + (B + C) is equal to %f \n", A + (B + C));
    printf("(A + B) + C is equal to %f", (A + B) + C);

    return 0;
}
