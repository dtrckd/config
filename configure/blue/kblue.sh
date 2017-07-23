#!/bin/bash

pid=$(ps -u | grep "ssh.*-p 24.*vapwn.fr$" | tr -s ' ' | cut  -d ' ' -f 2 )

kill $pid 
