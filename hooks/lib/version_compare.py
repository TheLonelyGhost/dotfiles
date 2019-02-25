#!/usr/bin/env python
from __future__ import print_function

import re
import sys

try:
    cmp
except NameError:
    def cmp(a, b):
        return (a > b) - (a < b)


def sanitize(ver):
    return re.sub(r'(^v|[^A-Za-z0-9\._-])', '', ver)


def version_compare(a, b):
    a = a.split('.')
    b = b.split('.')
    for idx in range(0, max(len(a), len(b))):
        if len(a) < (idx + 1):
            a[idx] = '0'
        elif len(b) < (idx + 1):
            b[idx] = '0'

        comparison = cmp(a[idx].strip(), b[idx].strip())
        if comparison != 0:
            return comparison

    return 0


def main():
    a = sanitize(sys.argv[2])
    b = sanitize(sys.argv[3])

    # print('First: {}'.format(repr(a)))
    # print('Second: {}'.format(repr(b)))

    comparison = version_compare(a, b)
    if comparison == -1:
        # b is the higher version
        # print('Higher: {}'.format(b))
        exit(5)
    elif comparison == 1:
        # a is the higher version
        # print('Higher: {}'.format(a))
        exit(0)

    # print('Higher: {}'.format('<neither>'))
    exit(0)


if __name__ == '__main__':
    main()
