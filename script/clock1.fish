#!/bin/fish
#
# clock.fish

while sleep 10
	tput sc
	tput cup 0 (math (tput cols)-16)
	set_color red
	date +"%a %b%e, %H:%M"
	tput rc
end
