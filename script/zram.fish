#!/bin/fish
#
#zram.fish

set TMP ~/tmp

if [ ! -L $TMP ]
	if [ ! -d $TMP ]
		sudo mktemp -d -p /var/tmp/portage --suffix=_(logname) | xargs -I '{}' ln -fs '{}' $TMP
		sudo chown leaf:users $TMP
		chmod 755 $TMP
	end
end
