#!/bin/fish
#
#funtoo_k10_current_restore.fish

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
mount -o defaults,compress=lz4,recovery,discard,ssd,inode_cache,space_cache,subvol=$DISTRI	LABEL="ssd"	$SSD
mount -o defaults,compress=lz4,recovery,autodefrag,inode_cache,space_cache,ro,subvol=var	LABEL="various"	$SSD/var
mount -o defaults,compress=lz4,recovery,autodefrag,inode_cache,space_cache,ro,subvol=$DISTRI	LABEL="various"	$HDD

rsync -ahAHSX --delete --info=progress2 --exclude etc/fstab $HDD/ $SSD/

cp /home/leaf/fstab_ssd $SSD/etc/fstab

umount $SSD/var $SSD $HDD
rmdir  $SSD $HDD

