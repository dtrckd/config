#!/usr/bin/env python
from time import time
## Init
t0 = time()
import sys

##########
## Chronometre or alarm CLI.
##
## Format for alarm date is understood in CLI as a integer for the day (of the current month)
## and a string style 14h23 for the hour and second.
##########

# TODO
# set the alarm deamon to ring/scream/explode

usage="Usage: chrono [-a/--alarm] {name of chrono/alarm}"
title = ''
is_alarm = False
fuck_test = True
for i, arg in enumerate(sys.argv):
    if arg == "--alarm" or arg == "-a":
        is_alarm = True
    else:
        if i == len(sys.argv)-1 and i == 0:
            print(usage)
            exit()
        elif i > 0:
            if fuck_test:
                space = ''
                fuck_test = False
            else:
                space =' '
            title = title + space + arg


def chrono(title):
    while True:
        key = raw_input(title)
        chrono = time() - t0
        seconds = int(chrono)
        minutes = seconds / 60
        hours = minutes / 60
        print('  %dh %dm %ds\n' % (hours, minutes, seconds))

def alarm_init(title):
    import re
    arg_error = 'format date error: specifie a day plus a time as (hour)h(minute) as argument'
    day_re = re.compile("^[0-9]+$")
    time_re = re.compile("^([0-9]+)h([0-9]+)$")
    date = title.split(' ')
    if len(date) != 2:
        print(arg_error + ", take 2 argument only !")
        exit(1)
    for d in date:
        day_test = day_re.match(d)
        time_test = time_re.match(d)
        if day_test:
            day = day_test.group(0)
        elif time_test:
            hour = time_test.group(1)
            minute = time_test.group(2)
        else:
            print(arg_error)
            exit(2)
    return day, hour, minute

def alarm(date):
    print(date)
    print("code and explode")

try:
    if is_alarm:
        alarm(alarm_init(title))
    else:
        chrono(title + '`s chronos:')
except KeyboardInterrupt:
    pass



