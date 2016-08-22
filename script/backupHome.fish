#!/bin/fish
#
#backupHome

# Settings
set SUBVOL home-phenom2
set BACKUP root@pentium4:/mnt/$SUBVOL
#set DEVICE /mnt/backup

# Main
#if not test -d $BACKUP
#  mkdir $BACKUP
#end

#mountpoint -q $BACKUP; or mount $BACKUP

echo "Syncing Home"
rsync -ahAHSX \
      --delete \
      --exclude leaf/.cache/ \
      --exclude leaf/.backup_funtoo/ \
      --exclude leaf/.git/ \
      --exclude leaf/.wine \
      --exclude leaf/.wine/ \
      --exclude ftps/ \
      --exclude gits/ \
      --exclude mirrors/ \
      --exclude tmp/ \
      --info=progress2 \
      --log-file=/var/log/rsync.log \
      /home/ $BACKUP/

#umount $BACKUP
#rmdir $BACKUP

## Snapshot
#if not test -d $DEVICE
#  mkdir $DEVICE
#end
#
#mountpoint -q $DEVICE; or mount $DEVICE
#
#btrfs subvol snapshot $DEVICE/$SUBVOL $DEVICE/snapshot/$SUBVOL-(date +%Y-%m%d-%H%M)
#
#umount $DEVICE
#rmdir $DEVICE
