#!/bin/sh
#
#.spectrwm-baraction.sh for spectrwm status bar

SLEEP_SEC=10

while true; do
    echo "$(cat /proc/loadavg | cut -d ' ' -f1,2,3)"
    sleep $SLEEP_SEC
done
