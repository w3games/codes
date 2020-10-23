#!/bin/sh
#
#p2pool.sh

P2POOL="$HOME/.bitcoin/p2pool/run_p2pool.py"

test -x ${P2POOL} || exit 0;

ps -x | grep "python2.7 ${P2POOL}" | grep -v grep
if [ $? -ne 0 ]
then
 python2.7 ${P2POOL} $@
else
 kill $(ps -x | grep "python2.7 ${P2POOL}" | grep -v grep | cut -d \  -f 1)
fi
