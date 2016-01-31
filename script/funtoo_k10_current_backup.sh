#!/bin/bash
#funtoo_k10_current_backup.sh

# Initialize
#
if test $SUDO_USER=""
  then SUDO_USER=leaf
fi

# Configurations
#
BACKUPDIR="/home/$SUDO_USER/.backup_funtoo"
DISTRI="funtoo_k10_current"

DATE=$(date +%Y-%m%d-%H%M%S)
TO="root@pentium4:/mnt/$DISTRI"

for i in $BACKUPDIR $BACKUPDIR/$DISTRI
do
  if ! test -d $i
    then mkdir $i
  fi
done

# Main
#
echo "Collecting data for rsync."
cd $BACKUPDIR/$DISTRI
for i in boot etc lib/modules root usr/packages var
do
  if not test -d $i
    then mkdir -p $i
  fi
done

mountpoint -q /boot || mount /boot
rsync -ahAHSX \
	--delete \
	--exclude grub/fonts/ \
	--exclude grub/i386-pc/ \
	--exclude grub/locale/ \
	--exclude grub/themes/ \
	--exclude grub/unifont.pf2 \
	/boot/ boot/
umount /boot

for i in etc lib/modules usr/packages
do
    rsync -ahAHSX --delete /$i/ $i/
done

rsync -ahAHSX \
 	--delete \
	--exclude .cache/ \
	--exclude .ccache/ \
	--exclude .local/share/Trash/ \
	/root/ root/
	
rsync -ahAHSX \
 	--delete \
	--exclude git/ \
	--exclude lib/transmission/downloads/ \
	--exclude tmp/ \
	/var/ var/

echo "Syncing $DISTRI"
cd ..
rsync -ahAHSX \
      --del \
      --info=progress2 \
      --log-file=/var/log/rsync.log \
      $DISTRI/ $TO/

# Cleaning
#
rm -r $BACKUPDIR/$DISTRI/usr/packages
