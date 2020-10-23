#!/bin/sh
#
#2chproxy.sh

PROXY="$HOME/Documents/scripts/2chproxy.pl"

test -x ${PROXY} || exit 0;

ps x | grep "perl ${PROXY} -d" | grep -v grep > /dev/null
#pgrep 2chproxy.pl
if [ $? -ne 0 ]; then
  ${PROXY} -d
else
  ${PROXY} -k
fi
