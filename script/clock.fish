#!/bin/fish
#
#clock.fish

set LINE (math (tput lines)-1)
set COL  (math (tput cols)-1)

while tput cup $LINE 0
  # echo -n  (cat /proc/loadavg | cut -d ' ' -f1,2,3) " " (date +"%H:%M.%S   %F   %A ")
  echo -n  (date +" %A  %F  %H:%M.%S ")  (cat /proc/loadavg | cut -d ' ' -f1,2,3)
  tput cup $LINE $COL
  sleep 1
end
