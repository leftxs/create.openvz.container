#!/bin/bash
# Copied from: http://serverfault.com/questions/273464/bash-ping-successful-program
while :; do
    ping -c 1 8.8.8.8 >/dev/null 2>&1
    if [ $? = 0 ]; then
        break
    else
        echo timeout
    fi
    sleep 1
done
echo the internet is back up
