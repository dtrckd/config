#!/bin/sh
df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read output;
do
  used=$(echo $output | awk '{print $1}' | sed s/%//g)
  partition=$(echo $output | awk '{print $2}')
  if [ $used -ge 60 ]; then
	  echo "The partition \"$partition\" on $(hostname) has used $used% at $(date)"
  fi
done
