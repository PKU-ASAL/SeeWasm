#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int check_password(int fd)
{
    char buf[5];
    if (read(fd, buf, 5) != -1)
    {
        if (buf[0] == 'h' && buf[1] == 'e' &&
            buf[2] == 'l' && buf[3] == 'l' &&
            buf[4] == 'o')
            return 1;
    }
    return 0;
}

int main(int argc, char **argv)
{
    int fd;

    if (argc >= 2)
    {
        if ((fd = open(argv[1], O_RDONLY)) != -1)
        {
            if (check_password(fd))
            {
                printf("Password found in %s\n", argv[1]);
                close(fd);
                return 0;
            }
            close(fd);
            return 1;
        }
    }

    if (check_password(0))
    {
        printf("Password found in standard input\n");
        return 0;
    }

    return 1;
}