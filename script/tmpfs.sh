#!/bin/bash
#
#tmpfs.sh

if [ ! -L tmp ]; then
	sudo mktemp -d -p /var/tmp/tmpfs --suffix=_`logname` | xargs -I '{}' ln -fs '{}' ~/tmp
	sudo chown leaf:users ~/tmp
	chmod 755 ~/tmp
fi
