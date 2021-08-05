#include <stdio.h>
#include <stdlib.h>

#define N 5

void bubble_sort(int a[], int n);

void bubble_sort(int a[], int n)
{
    for (int i = 0; i < n - 1; i++)
    {
        for (int j = 0; j < n - 1 - i; j++)
        {
            if (a[j] > a[j + 1])
            {
                int temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;
            }
        }
    }
}

int main()
{
    int num[N] = {3, 1, 5, 2, 4};

    bubble_sort(num, N);

    for (int i = 0; i < N; i++)
        printf("%d ", num[i]);
    printf("\n");

    return 0;
}