#!/bin/fish
#swapFilenames

set DATE (date +%Y-%m%d-%H%M-%S)
set TMPFILE (mktemp -u)
set TMPNAME (basename $TMPFILE)-$DATE

mv -i $1        $TMPNAME
mv    $2        $1
mv    $TMPNAME  $2
