#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

void test_strcmp()
{
    char str1[15];
    char str2[15];
    int ret;

    strcpy(str1, "abcdef");
    strcpy(str2, "ABCDEF");

    ret = strcmp(str1, str2);
    if (ret < 0)
    {
        printf("str1 is less than str2");
    }
    else if (ret > 0)
    {
        printf("str2 is less than str1");
    }
    else
    {
        printf("str1 is equal to str2");
    }
}

void test_strstr()
{
    const char haystack[20] = "TutorialsPoint";
    const char needle[10] = "Point";
    char *ret;

    ret = strstr(haystack, needle);

    printf("The substring is: %s\n", ret);
}

void test_strchr()
{
    const char str[] = "http://www.tutorialspoint.com";
    const char ch = '.';
    char *ret;

    ret = strchr(str, ch);

    printf("String after |%c| is - |%s|\n", ch, ret);
}

void test_math_funcs()
{
    float val1, val2, val3, val4;

    val1 = -1.6;
    val2 = 2.8;

    printf("floor testing below:");
    printf("Value1 = %f \n", floor(val1));
    printf("Value2 = %f \n", floor(val2));

    printf("ceil testing below:");
    printf("Value1 = %f \n", ceil(val1));
    printf("Value2 = %f \n", ceil(val2));

    printf("sqrt testing below:");
    printf("Value1 = %f \n", sqrt(val1));
    printf("Value2 = %f \n", sqrt(val2));

    double x = 1;
    printf("exp testing below:");
    printf("The exponential value of %lf is %lf\n", x, exp(x));
    printf("The exponential value of %lf is %lf\n", x + 1, exp(x + 1));

    int a, b;
    printf("abs testing below:");
    a = abs(5);
    printf("value of a = %d\n", a);
    b = abs(-10);
    printf("value of b = %d\n", b);
}

void test_char()
{
    char c;

    printf("Enter character: ");
    c = getchar();

    printf("Character entered: ");
    putchar(c);
}

void test_strn_funcs()
{
    char example[50];

    strncpy(example, "TechOnTheNet.com knows strncpy!", 16);
    example[16] = '\0';
    printf("%s\n", example);

    char example2[50];
    strncpy(example, "Hello, world!", 20);
    printf("%s\n", example);

    char src[50], dest[50];

    strcpy(src, "This is source");
    strcpy(dest, "This is destination");

    strncat(dest, src, 10);

    printf("Final destination string : %s", dest);
}

void test_alloc()
{
    char *str;

    str = (char *)malloc(15);
    strcpy(str, "tutorialspoint");
    printf("%s", str);

    str = (char *)realloc(str, 25);
    strcat(str, ".com");
    printf("%s", str);

    free(str);
}

void test_memset()
{
    char str[50];

    strcpy(str, "This is string.h library function");
    puts(str);

    memset(str, '$', 7);
    puts(str);
}

void test_memcpy()
{
    const char src[50] = "http://www.tutorialspoint.com";
    char dest[50];
    strcpy(dest, "Heloooo!!");
    printf("%s\n", dest);
    memcpy(dest, src, strlen(src) + 1);
    printf("%s\n", dest);
}

void test_memcmp()
{
    char str1[15];
    char str2[15];
    int ret;

    memcpy(str1, "abcdef", 6);
    memcpy(str2, "ABCDEF", 6);

    ret = memcmp(str1, str2, 5);

    if (ret > 0)
    {
        printf("str2 is less than str1");
    }
    else if (ret < 0)
    {
        printf("str1 is less than str2");
    }
    else
    {
        printf("str1 is equal to str2");
    }
}

void test_memmove()
{
    char str[] = "1234567890";
    puts(str);
    memmove(str + 4, str + 3, 3); // copy from [4,5,6] to [5,6,7]
    puts(str);
}

int main(void)
{
    test_strcmp();
    test_strstr();
    test_strchr();
    test_math_funcs();
    test_char();
    test_strn_funcs();
    test_alloc();
    test_memset();
    test_memcpy();
    test_memcmp();
    test_memmove();

    return 0;
}