#!/bin/bash
# funtooHomeBackup-test.sh
#

#sh /home/master/Documents/settings/linux-configurations/funtooHomeBackup-configCopy.sh

Backup=/mnt/backup/
Date=`date +%Y-%m%d-%H%M%S`

rsync -avcHS --delete --progress --stats --dry-run \
--exclude='*Trash*' \
--exclude='*cache*' \
--exclude='*Cache*' \
/home/master/ $Backup/master/
# > /home/master/Documents/settings/linux-configurations/configFiles/funtooHomeBackup-$Date.log
#xz /home/master/Documents/settings/linux-configurations/configFiles/funtooHomeBackup-$Date.log
