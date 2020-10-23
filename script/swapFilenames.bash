#!/bin/bash
#swapFilenames

DATE=`date +%Y-%m%d-%H%M%S`

mv -i $1 $DATE
mv $2 $1
mv $DATE $2
