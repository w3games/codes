#!/bin/fish
#
# HDD2SSD_funtoo_k10_current.fish

set DISTRI funtoo_k10_current
set SSD /mnt/$DISTRI\_ssd
set HDD /mnt/$DISTRI\_hdd

for c in SSD HDD
  if mountpoint -q $$c
    umount $$c
  else
    mkdir -p $$c
  end
end
mount -o defaults,compress=zstd,usebackuproot,discard,ssd,inode_cache,space_cache,subvol=$DISTRI	LABEL="ssd"	$SSD
mount -o defaults,compress=zstd,usebackuproot,autodefrag,subvol=var	LABEL="various"	$SSD/var
mount -o defaults,compress=zstd,usebackuproot,autodefrag,ro,subvol=$DISTRI	LABEL="various"	$HDD

echo "Syncing HDD to SSD." \n
rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 --exclude etc/fstab \
	 --exclude var/tmp/ccache/ \
	 $HDD/ $SSD/
# rsync -nvahAHSX --delete -exclude etc/fstab $HDD/ $SSD/

cp /home/leaf/fstab_ssd $SSD/etc/fstab

umount $SSD/var $SSD $HDD
rmdir  $SSD $HDD

