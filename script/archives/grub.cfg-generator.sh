#!/bin/bash
# grub-generator.sh
#

boot-update
cd /boot/grub
cat grub-ubuntu.cfg >> grub.cfg
cat grub-sysrescuecd.cfg >> grub.cfg
