#!/bin/sh
# rsync between amd64 and vaionote

rsync -avcHS --delete --progress --stats /home/master/Documents/ master@vaionote:Documents/ 2>&1 | tee rsync-vaionote-Documents-`date +%Y-%m%d-%H%M%S`.log
rsync -avcHS --delete --progress --stats /home/master/Pictures/ master@vaionote:Pictures/ 2>&1 | tee rsync-vaionote-Pictures-`date +%Y-%m%d-%H%M%S`.log

