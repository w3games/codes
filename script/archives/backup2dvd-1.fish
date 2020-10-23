#!/bin/fish
#
#backup2dvd.fish

# setting
 set CONTENTS Documents Pictures
 set EXCLUDEALL Desktop Documents Downloads Pictures Public Music Templates Videos .cache
 set DATE (date +"%Y-%m%d-%H%M%S")
 set DISTRI funtoo_k10_current_backup
 if not set -q SUDO_USER >/dev/null
   set SUDO_USER leaf
 end
 set BACKUPUDF /home/$SUDO_USER/.home\_$SUDO_USER\_backup.udf
 set EXCLUDEDOC $BACKUPUDF .cache .ccache
 
 mktemp -d | tee /tmp/tmp_name_backup_$DATE
 set TMPNAME (cat /tmp/tmp_name_backup_$DATE)
 cd $TMPNAME
 set MNTPOINT /mnt/(gawk -F \/ '{print $3}' /tmp/tmp_name_backup_$DATE)
 
 if not test -d $MNTPOINT
   mkdir $MNTPOINT
 end

# blank DVD & set loop image
 dvd+rw-format -blank /dev/sr0
 eject -T /dev/sr0
 eject -T /dev/sr0
 
 if not test -f $BACKUPUDF
   truncate -s 4596992KB $BACKUPUDF
   mkudffs --lvid="BACKUP" --utf8 $BACKUPUDF
 end
 
 losetup /dev/loop0 $BACKUPUDF
 mount /dev/loop0 $MNTPOINT

# /home/$SUDO_USER
 echo "Collecting Data for home/$SUDO_USER Contents."
 set -e EXCLUDE
 for i in (seq 1 (count $EXCLUDEDOC))
   set EXCLUDE $EXCLUDE --exclude $EXCLUDEALL[$i]/
 end
 for i in $CONTENTS
   rsync -ahAHSX --del --info=progress2 $EXCLUDE /home/$SUDO_USER/$i/ $MNTPOINT/$i/
 end
 
 mkdir home_$SUDO_USER
 set -e EXCLUDE
 for i in (seq 1 (count $EXCLUDEALL))
   set EXCLUDE $EXCLUDE --exclude $EXCLUDEALL[$i]/
 end
 rsync -ahAHSX --del --info=progress2 $EXCLUDE /home/$SUDO_USER/ home_$SUDO_USER/
 tar cfp - home\_$SUDO_USER/ | xz --threads=0 - > $MNTPOINT/home\_$SUDO_USER\_$DATE.tar.xz

# funtoo system
 echo "Collecting Data for funtoo system."
 mountpoint -q /boot; or mount /boot
 mkdir -p $DISTRI/{boot,etc,lib/modules,usr/portage/packages,var/lib/portage,}
 cd $DISTRI
 
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
     rsync -ahAHSX --del --info=progress2 /$i/ $i/
 end
 cp -p /var/lib/portage/world var/lib/portage/
 cd $TMPNAME
 tar cfp - $DISTRI/ | xz --threads=0 - > $MNTPOINT/$DISTRI.tar.xz

# writing
 chown -R $SUDO_USER:users $MNTPOINT
 chmod -R a+r $MNTPOINT
 chmod -R go-w $MNTPOINT
 env -u SUDO_COMMAND growisofs -dvd-compat -Z /dev/sr0=$BACKUPUDF

# Clean
 umount $MNTPOINT
 rmdir $MNTPOINT
 losetup -d /dev/loop0
 rm -r $TMPNAME
 rm /tmp/tmp_name_backup_$DATE
# rm $BACKUPUDF
