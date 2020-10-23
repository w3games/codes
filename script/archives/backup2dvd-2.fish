#!/bin/fish
#
#backup2dvd.fish

#
# CONTENTS,HOMECFG.tar,DISTRI.tar → POOLUDF
# POOLUDF → BKUPIMG.sqfs
# BKUPIMG.sqfs →BURNUDF
# Burning BURNUDF
#

# setting
 set CONTENTS Documents Pictures
 set DATE (date +"%Y-%m%d-%H%M%S")
 set DEVICE /dev/sr0
 set DISTRI funtoo_k10_current_backup
 if not set -q SUDO_USER
   set SUDO_USER leaf
 end
 set BACKUPDIR /home/$SUDO_USER/.backup
 set HOMECFG $BACKUPDIR/home_$SUDO_USER\_cfg
 for i in $BACKUPDIR $BACKUPDIR_/$DISTRI $HOMECFG
   mkdir $i
 end
 set EXCLUDEALL Desktop Documents Downloads Pictures Public Music Templates Videos (echo $BACKUPDIR | sed 's/\/home\/'$SUDO_USER'\///g') .cache .ccache
 set POOLUDF $BACKUPDIR/funtoo_k10_current_home\_$SUDO_USER\_backup.udf
 set BURNUDF $BACKUPDIR/funtoo_k10_current_home\_$SUDO_USER\_burn.udf
 
 mktemp -d | tee /tmp/tmp_name_backup_$DATE
 set TMPNAME (cat /tmp/tmp_name_backup_$DATE)
 set BKUPIMG $TMPNAME/funtoo_k10_current-home\_$SUDO_USER\_backup.sqfs
 set MNTNAME /mnt/(gawk -F \/ '{print $3}' /tmp/tmp_name_backup_$DATE)
 set MNTPOINT $MNTNAME\_0 $MNTNAME\_1
 
 for i in 1 2
   if not test -d $MNTPOINT[$i]
     mkdir $MNTPOINT[$i]
   end
 end

# blanking
 dvd+rw-format -force $DEVICE
 #dvd+rw-format -blank $DEVICE
 echo "reloading tray"
 eject --traytoggle $DEVICE
 eject --trayclose $DEVICE

# set loop image
 #set TRACKSIZE (dvd+rw-mediainfo $DEVICE | grep "Track Size" | gawk '{print $3}' | sed 's/KB//g' | bc)\KB
 set TRACKSIZE 4GB

 if not test -f $POOLUDF
   truncate -s 10GB $POOLUDF
   mkudffs --lvid="BACKUP_POOL" --utf8 $POOLUDF
 end
 if test -f $BURNUDF
   rm $BURNUDF
 end
   truncate -s $TRACKSIZE $BURNUDF
   mkudffs --lvid="BACKUP" --utf8 $BURNUDF
 
   losetup -d /dev/loop0
   losetup /dev/loop0 $POOLUDF
   losetup -d /dev/loop1
   losetup /dev/loop1 $BURNUDF

 for i in 1 2
   mount /dev/loop(math $i-1) $MNTPOINT[$i]
 end

# /home/$SUDO_USER
 echo "Collecting /home/$SUDO_USER $CONTENTS."
 for i in $CONTENTS
   rsync -ahAHSX --del --info=progress2 /home/$SUDO_USER/$i/ $MNTPOINT[1]/$i/
 end
 
 echo "Gathering /home/$SUDO_USER Configs"
 set -e EXCLUDE
 for i in (seq 1 (count $EXCLUDEALL))
   set EXCLUDE $EXCLUDE --exclude $EXCLUDEALL[$i]/
 end
 rsync -ahAHSX --del --info=progress2 $EXCLUDE /home/$SUDO_USER/ $HOMECFG/
 if test -f $MNTPOINT[1]/home\_$SUDO_USER\_*.tar
   rm $MNTPOINT[1]/home\_$SUDO_USER\_*.tar
 end
 tar cfp - $HOMECFG/ > $MNTPOINT[1]/home\_$SUDO_USER\_$DATE.tar 

# funtoo system
 echo "Gathering $DISTRI"
 mountpoint -q /boot; or mount /boot
 cd $BACKUPDIR/$DISTRI
 mkdir -p {boot,etc,lib/modules,usr/portage/packages,var/lib/portage}
 
 echo "Collecting boot"
 rsync -ahAHSX \
 	--del \
 	--exclude grub/fonts/ \
 	--exclude grub/i386-pc/ \
 	--exclude grub/locale/ \
 	--exclude grub/themes/ \
 	--exclude grub/unifont.pf2 \
 	/boot/ boot/
 umount /boot
 
 for i in etc lib/modules usr/portage/packages
     echo "Collecting $i"
     rsync -ahAHSX --del --info=progress2 /$i/ $i/
 end
 echo "Copying world"
 cp -p /var/lib/portage/world var/lib/portage/
 if test -f $MNTPOINT[1]/$DISTRI\_*.tar
   rm $MNTPOINT[1]/$DISTRI\_*.tar
 end
 tar cfp - $BACKUPDIR/$DISTRI/ > $MNTPOINT[1]/$DISTRI\_$DATE.tar

# squashfs
 if test -f $BKUPIMG
   rm $BKUPIMG
 else
   mksquashfs $MNTPOINT[1] $BKUPIMG -processors 2
 end
 cp $BKUPIMG $MNTPOINT[2]

# Change Attributes
 chown -R $SUDO_USER:users $MNTPOINT[1] 
 chown    $SUDO_USER:users $POOLUDF
 chmod -R a+r $MNTPOINT[1]
 chmod -R go-w $MNTPOINT[1]

# Burning
 env -u SUDO_COMMAND growisofs -dvd-compat -Z $DEVICE=$BURNUDF

# Clean
 for i in 1 2
   umount $MNTPOINT[$i]
   rmdir $MNTPOINT[$i]
   losetup -d /dev/loop(math $i-1)
 end
 rm -r $TMPNAME
 rm /tmp/tmp_name_backup_$DATE

 rm $POOLUDF
 rm $BURNUDF
