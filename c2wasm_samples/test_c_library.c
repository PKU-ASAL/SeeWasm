#include <stdio.h>
#include <string.h>
#include <math.h>

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

    printf("Value1 = %f \n", floor(val1));
    printf("Value2 = %f \n", floor(val2));

    printf("Value1 = %f \n", ceil(val1));
    printf("Value2 = %f \n", ceil(val2));
}

int main(void)
{
    test_strcmp();
    test_strstr();
    test_strchr();
    test_math_funcs();

    return 0;
}