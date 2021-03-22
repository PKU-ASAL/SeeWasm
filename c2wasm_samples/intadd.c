#include <stdio.h>
int intadd(int a,int b){
    return a+b;
}
int main(int argc, char ** argv) {
int a,b;
scanf("%d %d",&a,&b);
int result = intadd(a,b);
printf("%d",result);
}