#!/bin/fish
#
# ORG2BCK_funtoo.fish

set DISTRI funtoo
set ORG /mnt/$DISTRI\_org
set BCK /mnt/$DISTRI\_bck

for c in ORG BCK
  if mountpoint -q $$c
    umount $$c
  else
    mkdir -p $$c
  end
end
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI,ro		LABEL="linux"	$ORG
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI_k10_current	LABEL="backup"	$BCK
mount --rbind /boot $ORG/boot

echo "Syncing ORG to BCK." \n
rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 # --exclude etc/fstab \
	 # --exclude var/tmp/ccache/ \
	 $ORG/ $BCK/

cp $ORG/etc/fstab /home/leaf/fstab_original

umount $ORG/boot $ORG $BCK
rmdir  $ORG $BCK

