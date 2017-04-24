#!/bin/sh
#
# Git Fetch from Funtoo Portage Tree to Local Mirror

cd /usr/portage

# Get HEAD Commits
LOCAL_COMMIT=`su nobody -s "/bin/sh" -c "git --no-pager log --pretty=format:%H -1"`
REMOTE_COMMIT=`su nobody -s "/bin/sh" -c "git ls-remote origin HEAD" | cut -f 1`

# Main
if [ $LOCAL_COMMIT != $REMOTE_COMMIT ]
  then
    echo "New ebuilds arrived."
    exit 0
  else
    echo "Already up-to-date."
    exit 1
fi
