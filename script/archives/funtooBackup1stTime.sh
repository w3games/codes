#!/bin/bash
# funtooBackup1stTime.sh
#

Backup=/mnt/backup
Date=`date +%Y-%m%d-%H%M%S`

umount $Backup 2> /dev/null
mount $Backup

# home
#rsync -acHS --delete --progress --stats -e "ssh -c arcfour256" \
#--exclude="[Tt]rash/" --exclude="[Cc]ache*/" \
#/home/master/ $Backup/master/ 2>&1 | tee \
#/home/master/Documents/settings/linux-configurations/logs/funtooBackup-$Date.log

#xz /home/master/Documents/settings/linux-configurations/logs/funtooBackup-$Date.log
#chown master:master /home/master/Documents/settings/linux-configurations/logs/funtooBackup-$Date.log.xz
cp -p /home/master/Documents/settings/linux-configurations/logs/funtooBackup-$Date.log.xz \
$Backup/Documents/settings/linux-configurations/logs/

# subhome
rsync -acHS --delete --progress --stats -e "ssh -c arcfour256" \
/mnt/subhome/ $Backup/subhome/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooBackup-subhome-$Date.log

xz /home/master/Documents/settings/linux-configurations/logs/funtooBackup-subhome-$Date.log
chown master:master /home/master/Documents/settings/linux-configurations/logs/funtooBackup-subhome-$Date.log.xz
cp -p /home/master/Documents/settings/linux-configurations/logs/funtooBackup-subhome-$Date.log.xz \
$Backup/Documents/settings/linux-configurations/logs/

# etc
rsync -acHS --delete --progress --stats -e "ssh -c arcfour256" \
/etc/ $Backup/etc/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooBackup-etc-$Date.log

xz /home/master/Documents/settings/linux-configurations/logs/funtooBackup-etc-$Date.log
chown master:master /home/master/Documents/settings/linux-configurations/logs/funtooBackup-etc-$Date.log.xz
cp -p /home/master/Documents/settings/linux-configurations/logs/funtooBackup-etc-$Date.log.xz \
$Backup/Documents/settings/linux-configurations/logs/

# applications
mount /mnt/windows
rsync -acHS --delete --progress --stats -e "ssh -c arcfour256" \
/mnt/windows/Documents\ and\ Settings/w3game/My\ Documents/applications/ $Backup/applications/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooBackup-applications-$Date.log

xz /home/master/Documents/settings/linux-configurations/logs/funtooBackup-applications-$Date.log
chown master:master /home/master/Documents/settings/linux-configurations/logs/funtooBackup-applications-$Date.log.xz
cp -p /home/master/Documents/settings/linux-configurations/logs/funtooBackup-applications-$Date.log.xz \
$Backup/Documents/settings/linux-configurations/logs/

umount /mnt/windows

#
umount $Backup
