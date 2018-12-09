#!/bin/fish
#
# restore_funtoo_k10_current.fish

set DISTRI funtoo
set BACKUP /mnt/$DISTRI\_from
set MASTER /mnt/$DISTRI\_to

for c in MASTER BACKUP
  if mountpoint -q $$c
    umount $$c
  else
    mkdir -p $$c
  end
end
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI			LABEL="linux"	$MASTER
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI\_k10_current,ro	LABEL="backup"	$BACKUP
# mount --rbind /boot $MASTER/boot

echo "Syncing from BACKUP to MASTER." \n
rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 --exclude boot/ \
	 --exclude home/ \
	 --exclude proc/ \
	 --exclude sys/ \
	 --exclude tmp/ \
	 --exclude var/lib/portage/distfiles/ \
	 $BACKUP/ $MASTER/

cp /home/leaf/fstab_original $MASTER/etc/fstab

umount $MASTER $BACKUP
rmdir  $MASTER $BACKUP

