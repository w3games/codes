#!/bin/sh
#
# Git Fetch from Funtoo Portage Tree to Local Mirror

# cd /var/git/funtoo/ports-2012.git
cd /usr/portage

# Get HEAD Commits
LOCAL_COMMIT=`su nobody -s "/bin/sh" -c "git log --pretty=format:%H -1"`
REMOTE_COMMIT=`su nobody -s "/bin/sh" -c "git ls-remote origin HEAD" | cut -f 1`

# Main
if [ $LOCAL_COMMIT != $REMOTE_COMMIT ]
  then
    # su nobody -s "/bin/sh" -c "git fetch"
    echo "New ebuilds arrived."
  else
    echo "Already up-to-date."
    exit 1
fi
