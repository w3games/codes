#!/bin/fish
#
#funtoo_k10_current_rsync.fish

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
mount -o defaults,compress=lzo,recovery,discard,ssd_spread,inode_cache,space_cache,subvol=$DISTRI,ro	LABEL="ssd"	$SSD
mount -o defaults,compress=lzo,recovery,autodefrag,inode_cache,space_cache,subvol=$DISTRI		LABEL="various"	$HDD

rsync -ahAHSX --delete --info=progress2 --exclude etc/fstab $SSD/ $HDD/

umount $SSD $HDD
rmdir  $SSD $HDD

