#include <stdio.h>
#include <string.h>
void swap(char *a, char *b)
{
	char tmp = *a;
	*a = *b;
	*b = tmp;
}
void RotateArray()
{
	char str[100];

	printf("Please input a word: ");
	scanf("%s", str);

	int start = 0;
	int end = strlen(str) - 1;

	while (start < end)
	{
		swap(str + start, str + end);
		start++;
		end--;
	}

	printf("The new word is: %s\n", str);
}
int main(int argc, char **argv)
{
	RotateArray();
}
