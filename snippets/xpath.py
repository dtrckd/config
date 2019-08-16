#!/usr/bin/env python3
import sys, os
from lxml.html.soupparser import fromstring

def parse_args(settings):
    # Script Arguments Parsing
    j = 1
    for i, _arg in enumerate(sys.argv):
        arg = sys.argv[j]
        if arg == "-v":
            settings['verbose'] = 1
        elif arg in ("-s", '--short'):
            settings['short'] = True
        else:
            if settings.get('pattern') is None:
                settings['pattern'] = arg
            elif settings.get('file') is None:
                settings['file'] = arg
            if j == 0:
                print(settings['usage'])
                exit()

        j += 1
        if j == len(sys.argv):
            break


if __name__ == '__main__':


    settings = dict(
        debug = -1,
        verbose = None,
        usage = 'xpath pattern file',
        file = None,
        pattern = None,
    )

    parse_args(settings)

    pattern = settings['pattern']
    fn = settings['file']
    with open(fn) as _f:
        strings = _f.read()

    p = fromstring(strings)
    pp = p.xpath(pattern)
    for o in pp:
        print(o)


