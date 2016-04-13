#!/bin/sh
#
#snapshot_home-phenom2.sh

mkdir /mnt/sdb1
mount /dev/sdb1 /mnt/sdb1
btrfs subvolume snapshot /mnt/home-phenom2 /mnt/sdb1/snapshot/home-phenom2-`(date +%Y-%m%d-%H%M)`
umount /mnt/sdb1
rmdir /mnt/sdb1
