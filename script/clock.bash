#!/bin/bash
#
#clock.bash

LINE=$(($(tput lines)-1))
COL=$(($(tput cols)-1))

while :
  do
    tput cup $LINE 0
    echo -n $(date +"%H:%M.%S %F %A ")
    tput cup $LINE $COL
    sleep 1
  done
