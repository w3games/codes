#!/bin/fish
#screenshot

set DIR $HOME/Pictures/Screenshots
set DATE (date +%Y-%m%d@%H%M%S)
set NAME $DIR/screenshot-$DATE.png
set LOG $DIR/screenshots.log

# Check if the dir to store the screenshots exists, else create it: 
if not test -d $DIR
	mkdir -p $DIR
end

switch $argv
	case window
		import +repage $NAME		# Screenshot a selected window
	case screen
		import -window root $NAME	# Screenshot the entire screen
	case area
		import +repage $NAME		# Screenshot a selected area
	case '*'
		import +repage $NAME		# Screenshot a selected window
end

# Save the screenshot in the directory and edit the log
echo $NAME >> $LOG
