#!/bin/fish
#
# BCK2ORG_funtoo.fish

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
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI		LABEL="linux"	$ORG
mount -o defaults,compress=zstd,usebackuproot,autodefrag,inode_cache,space_cache,subvol=$DISTRI,ro	LABEL="backup"	$BCK
mount --rbind /boot $ORG/boot

echo "Syncing BCK to ORG." \n
rsync 	 -ahAHSX \
	 --delete \
	 --info=progress2 \
	 # --exclude etc/fstab \
	 # --exclude root/.ccache/ \
	 # --exclude var/tmp/ccache/ \
	 $BCK/ $ORG/

cp $ORG/etc/fstab /home/leaf/fstab_original

umount $ORG/boot $ORG $BCK
rmdir  $ORG $BCK

