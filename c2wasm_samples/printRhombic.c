#include<stdio.h>
void PrintRhombic()
{
	int line = 0;
	printf("Please input a Odd: ");
	scanf("%d",&line);
	int spacenumber = line / 2;
	int starnumber = 1;
	for (int i = 0; i < line; i++){
		if (i <= line / 2){
			for (int j = 0; j < spacenumber; j++){
				printf(" ");
			}
			for (int j = 0; j < starnumber; j++){
				printf("*");
			}
			printf("\n");
			if (i == line / 2){
				continue;
			}
			spacenumber--;
			starnumber += 2;
		}
		else{
			spacenumber++;
			starnumber -= 2;
			for (int j = 0; j < spacenumber; j++){
				printf(" ");
			}
			for (int j = 0; j < starnumber; j++){
				printf("*");
			}
			printf("\n");
		}
	}
	int colnmn = line;
	for (int i = 1; i <= line; i++){
		if (i <= (line / 2 + 1)){
			for (int j = 1; j <= colnmn; j++){
				if (((colnmn + 1) / 2) - (i - 1) <= j && j <= ((colnmn + 1) / 2) + (i - 1)){
					printf("*");
				}
				else{
					printf(" ");
				}
			}
			printf("\n");
		}
		else{
			for (int j = 1; j <= colnmn; j++){
				if (((colnmn + 1) / 2) - (line - i) <= j && j <= ((colnmn + 1) / 2) + (line - i)){
					printf("*");
				}
				else{
					printf(" ");
				}
			}
			printf("\n");
		}
	}
}

int main(int argc, char ** argv){
	PrintRhombic();
}