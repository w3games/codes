#!/bin/bash
#
#zram.sh

if [ ! -L ~/tmp ]; then
	if [ ! -d ~/tmp ]; then
		rm ~/tmp
		sudo mktemp -d -p /var/tmp/portage --suffix=_`logname` | xargs -I '{}' ln -fs '{}' ~/tmp
		sudo chown leaf:users ~/tmp
		chmod 755 ~/tmp
	fi
fi
