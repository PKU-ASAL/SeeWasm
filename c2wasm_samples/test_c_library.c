#include <stdio.h>
#include <string.h>

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

int main(void)
{
    test_strcmp();
    test_strstr();

    return 0;
}