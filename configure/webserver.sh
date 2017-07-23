#!/bin/bash

echo "Installing nginx..."

aptitude install nginx 
aptitude install php5-fpm

echo "need to set up con files for sites..."
P="/home/dtrckd/Desktop/workInProgress/conf/nginx/site-enables/"
cp $P/* /etc/nginx/site-enabled/

service nginx restart
