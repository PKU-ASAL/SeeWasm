#include<stdio.h>
#include<string.h>
void swap(char*a,char*b){
	char tmp = *a;
	*a=*b;
	*b=tmp;
}
void RotateArray()
{
	char str[100];

	printf("Please input Character array: ");
	scanf("%s",str);

	int start = 0;
	int end = strlen(str) - 1;

	while (start < end)
	{
		swap(str+start, str+end);
		start++;
		end--;
	}

	int wordsize = 0;
	//将每个单词逆置
	for (int i = 0; i <= strlen(str); i++)
	{
		if (str[i] != ' ' && str[i] != '\0')//考虑最后一个单词
		{
			wordsize++;
			continue;
		}

		if (wordsize == 1)
		{
			wordsize = 0;
			continue;
		}

		start = i - wordsize;
		end = i - 1;
		while (start < end)
		{
			swap(str+start, str+end);
			start++;
			end--;
		}
		wordsize = 0;
	}

	 printf("The new Character array is: %s\n",str);

}
int main(int argc, char ** argv) {
	RotateArray();
}