#!/bin/fish
#
# funtoo_k10_current_backup.fish

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
mount -o defaults,compress=lzo,recovery,discard,ssd,inode_cache,space_cache,subvol=$DISTRI	LABEL="ssd"	$SSD
mount -o defaults,compress=lzo,recovery,autodefrag,inode_cache,space_cache,subvol=var		LABEL="various"	$SSD/var
mount -o defaults,compress=lzo,recovery,autodefrag,inode_cache,space_cache,subvol=$DISTRI	LABEL="various"	$HDD

rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 --exclude etc/fstab \
	 --exclude var/tmp/ccache/ \
	 $SSD/ $HDD/

cp $SSD/etc/fstab /home/leaf/fstab_ssd

umount $SSD/var $SSD $HDD
rmdir  $SSD $HDD

