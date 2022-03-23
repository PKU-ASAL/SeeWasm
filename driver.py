import sys
import os


def test():
    # print(sys.argv)
    os.system("python3 eunomia_entry -f " + sys.argv[1] +
              " -s --solver lab --onlyfunc main --need_mapper")


if __name__ == '__main__':
    test()
