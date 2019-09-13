#!/usr/bin/env python3
import sys, os
#from lxml.html.soupparser import fromstring
from lxml import html

def parse_args(settings):
    # Script Arguments Parsing
    j = 1
    if len(sys.argv) < 2:
        print(settings['usage'])
        exit(1)

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
                exit(1)

        j += 1
        if j == len(sys.argv):
            break


if __name__ == '__main__':


    settings = dict(
        debug = -1,
        verbose = None,
        usage = 'Usage: xpath PATTERN FILE',
        file = None,
        pattern = None,
    )

    parse_args(settings)

    pattern = settings['pattern']
    fn = settings['file']
    with open(fn) as _f:
        strings = _f.read()

    tree = html.fromstring(strings)
    for node in tree.xpath(pattern):
        #print(node)
        print(html.tostring(node))
        #print(o.tag)
        #print(o.attrib)
        #print(o.text)


