#!/bin/fish
#
# SSD2HDD_funtoo_k10_current.fish

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
mount -o defaults,compress=zstd,usebackuproot,autodefrag,subvol=var		LABEL="various"	$SSD
mount -o defaults,compress=zstd,usebackuproot,autodefrag,subvol=var		/dev/sde1	$HDD

echo "Syncing SSD to HDD." \n
rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 $SSD/ $HDD/

cp $SSD/etc/fstab /home/leaf/fstab_ssd

umount $SSD/boot $SSD $HDD
rmdir  $SSD $HDD

