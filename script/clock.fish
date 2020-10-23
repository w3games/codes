#!/bin/fish
#
#clock.fish

set LINE (math (tput lines)-1)
set COL  (math (tput cols)-1)

clear
tput cup $LINE 0
cal -n 3 -S

while tput cup $LINE 0
  # echo -n (date +"%H:%M.%S   %F   %A ") " " (cat /proc/loadavg | cut -d ' ' -f1,2,3)
  # echo -n " " (env LC_ALL=ja_JP.utf8 date +"%a  %F  %H:%M.%S ") (cat /proc/loadavg | cut -d ' ' -f1,2,3)
  echo -n  " " (cat /proc/loadavg | cut -d ' ' -f1,2,3) " " (date)
  # echo -n "     " (cat /proc/loadavg | cut -d ' ' -f1,2,3) "                      " (date +"%H:%M.%S ")
  # echo -n "           " (date +"%H:%M.%S ") "                     " (cat /proc/loadavg | cut -d ' ' -f1,2,3)
  # echo -n (uptime)
  tput cup $LINE $COL
  sleep 2
end
