#!/bin/sh
#
# Git Fetch from Funtoo Portage Tree to Local Mirror

# cd /var/git/funtoo/xorg-kit.git
cd /var/lib/portage/funtoo/xorg-kit

# Get HEAD Commits
LOCAL_COMMIT=`"/bin/sh" -c "git --no-pager log --pretty=format:%H -1"`
REMOTE_COMMIT=`"/bin/sh" -c "git ls-remote origin HEAD" | cut -f 1`

# Main
if [ $LOCAL_COMMIT != $REMOTE_COMMIT ]
  then
    echo "New ebuilds arrived."
    exit 0
  else
    echo "Already up-to-date."
    exit 1
fi
