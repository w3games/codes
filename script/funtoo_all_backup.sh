#!/bin/bash
# funtoo_all_backup.sh

# Initialize and configurations
#
if test $SUDO_USER=""
  then SUDO_USER=leaf
fi

LOOPDEV="/mnt/udf"
BACKUPDIR="$LOOPDEV/backup_funtoo"
DISTRI="funtoo_k10_current funtoo_586_stable funtoo_pentium4_stable"
UDFFILE="/home/$SUDO_USER/funtoo_backup.udf"
DATE=$(date +%Y-%m%d-%H%M%S)
# BDSIZE=`echo $((23652352*2))KB`
BDSIZE=`dvd+rw-mediainfo /dev/sr0 | grep "Track Size" | gawk '{print $3}' | sed 's/KB//g' | bc`KB
TO="/mnt/sr0"

# Preparing for udf file
#

# Rename old $UDFFILE
# if test -f $UDFFILE
#   then mv $UDFFILE `dirname $UDFFILE`/`basename -s .udf $UDFFILE`-$DATE.udf
# fi

if not test -f $UDFFILE
  then
    truncate --size=$BDSIZE $UDFFILE
    mkudffs --utf8 --lvid="FUNTOO_BACKUP" $UDFFILE
fi
mountpoint -q $LOOPDEV || mount -o loop,rw $UDFFILE $LOOPDEV || exit 1

# Preparing DISTRI
#
for i in $DISTRI
do
  if not test -d /mnt/$i
    then mkdir -p /mnt/$i
  fi
  mountpoint -q /mnt/$i || mount /mnt/$i || exit 1
done

# Main
#
for i in $DISTRI
do
  mkdir -p $BACKUPDIR/$i

  echo "Collecting data of $i."
  cd $BACKUPDIR/$i
  for j in boot etc lib/modules root var
  do
    if not test -d $j
      then mkdir -p $j
    fi
  done
  
  if test $i="funtoo_k10_current"
    then
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
      
      for k in etc lib/modules
      do
          rsync -ahAHSX --delete --exclude .git/ /$k/ $k/
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
      	--exclude lib/portage/distfiles/ \
      	--exclude lib/portage/funtoo/ \
      	--exclude lib/transmission/downloads/ \
      	--exclude tmp/ \
      	/var/ var/
      
    else
      rsync -ahAHSX \
        --delete \
        --exclude grub/fonts/ \
        --exclude grub/i386-pc/ \
        --exclude grub/locale/ \
        --exclude grub/themes/ \
        --exclude grub/unifont.pf2 \
        /mnt/$i/boot/ boot/
 
      for k in etc lib/modules
      do
        rsync -ahAHSX --delete --exclude .git/ /mnt/$i/$k/ $k/
      done
 
      rsync -ahAHSX \
        --delete \
        --exclude .cache/ \
        --exclude .ccache/ \
        --exclude .local/share/Trash/ \
        /mnt/$i/root/ root/
 
      rsync -ahAHSX \
        --delete \
        --exclude git/ \
        --exclude lib/portage/distfiles/ \
        --exclude lib/transmission/downloads/ \
        --exclude tmp/ \
        /mnt/$i/var/ var/
   fi
done

# Clean up
sleep 10
umount $LOOPDEV
