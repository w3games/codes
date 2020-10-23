#!/bin/fish
#
#backup2dvd.fish

#
# CONTENTS,HOMECFG.tar,DISTRI.tar - BACKUPDIR
# BACKUPDIR - BKUPIMG.sqfs
# Burning BKUPIMG.sqfs
#

# setting
 if not set -q SUDO_USER
   set SUDO_USER leaf
 end
 set BACKUPDIR /home/$SUDO_USER/.backup
 set CONTENTS Documents Pictures
 set DATE (date +"%Y-%m%d-%H%M%S")
 set DEVICE /dev/sr0
 set DISTRI funtoo_k10_current_backup
 set HOMECFG $BACKUPDIR/home_$SUDO_USER\_cfg
 for i in $BACKUPDIR $BACKUPDIR_/$DISTRI $HOMECFG
   if not test -d $i
     mkdir $i
   end
 end
 set EXCLUDEALL Desktop Documents Downloads Pictures Public Music Templates Videos (echo $BACKUPDIR | sed 's/\/home\/'$SUDO_USER'\///g') .cache .ccache
 
 mktemp -d | tee /tmp/tmp_name_backup_$DATE
 set TMPNAME (cat /tmp/tmp_name_backup_$DATE)
 set BKUPIMG $TMPNAME/funtoo_k10_current-home\_$SUDO_USER\_backup.sqfs

# /home/$SUDO_USER Configs
 echo "Gathering /home/$SUDO_USER Configs"
 set -e EXCLUDE
 for i in (seq 1 (count $EXCLUDEALL))
   set EXCLUDE $EXCLUDE --exclude $EXCLUDEALL[$i]/
 end
 rsync -ahAHSX --del --info=progress2 $EXCLUDE /home/$SUDO_USER/ $HOMECFG/

# funtoo system
 echo "Gathering $DISTRI"
 mountpoint -q /boot; or mount /boot
 cd $BACKUPDIR/$DISTRI
 for i in boot etc lib/modules usr/portage/packages var/lib/portage
   if not test -d $i
     mkdir -p $i
   end
 end
 
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

 echo "Copying world file"
 cp -p /var/lib/portage/world var/lib/portage/

# squashfs
 if test -f $BKUPIMG
   rm $BKUPIMG
 else
   mksquashfs /home/$SUDO_USER/$CONTENTS $HOMECFG $BACKUPDIR/$DISTRI $BKUPIMG -processors 5
 end

# blanking
 dvd+rw-format -force $DEVICE
 #dvd+rw-format -blank $DEVICE
 echo "reloading tray"
 eject --traytoggle $DEVICE
 eject --trayclose $DEVICE

# Burning
 env -u SUDO_COMMAND growisofs -Z $DEVICE -R -J $BKUPIMG

# Clean
 rmdir $BACKUPDIR
 rm -r $TMPNAME
 rm /tmp/tmp_name_backup_$DATE
