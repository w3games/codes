#!/bin/sh
#swapFilenames

DATE=`date +%Y-%m%d-%H%M-%S`
TMPFILE=`mktemp -u`
TMPNAME=`basename $TMPFILE`-$DATE

mv -i "$1"        "$TMPNAME"
mv    "$2"        "$1"
mv    "$TMPNAME"  "$2"
