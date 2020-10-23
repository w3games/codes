#!/bin/bash
# funtooHomeBackup.sh
#

Backup=/mnt/backup
Date=`date +%Y-%m%d-%H%M%S`

umount /mnt/sdc1 2> /dev/null
rmdir /mnt/sdc1 2> /dev/null
mkdir /mnt/sdc1
mount /dev/sdc1 /mnt/sdc1
btrfs subvol snapshot /mnt/sdc1/backup /mnt/sdc1/snapshot/$Date
umount /mnt/sdc1
rmdir /mnt/sdc1

umount $Backup 2> /dev/null
mount $Backup

#sh /home/master/Documents/settings/linux-configurations/funtooHomeBackup-configCopy.sh

# home
rsync -avcHS --delete --progress --stats -e "ssh -c arcfour256" \
--exclude="[Tt]rash/" \
--exclude="[Cc]ache*/" \
--exclude=".windows-SSD/" \
/home/master/ $Backup/master/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-$Date.log
xz /home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-$Date.log

# subhome
rsync -avcHS --delete --progress --stats -e "ssh -c arcfour256" \
/mnt/subhome/ $Backup/subhome/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-subhome-$Date.log
xz /home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-subhome-$Date.log

# etc
rsync -avcHS --delete --progress --stats -e "ssh -c arcfour256" \
/etc/ $Backup/etc/ 2>&1 | tee \
/home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-etc-$Date.log
xz /home/master/Documents/settings/linux-configurations/logs/funtooHomeBackup-etc-$Date.log

umount $Backup
