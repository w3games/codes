#!/bin/fish
#
#backup2dvd.fish

## Flowchart ##
#
# Collecting {FNTSYS,world} -> BACKUPDIR
# Archiving  {/home/SUDO_USER,BACKUPDIR} -> BKUPIMG.sqfs
# Burn BKUPIMG.sqfs
#
###############

# intialize
 if not set -q SUDO_USER
   set SUDO_USER leaf
 end
 set BACKUPDIR /home/$SUDO_USER/.backup_funtoo/funtoo_k10_current
 set DATE (date +"%Y-%m%d-%H%M%S")
 set DEVICE /dev/sr0
 if not test -d $BACKUPDIR
   mkdir -p $BACKUPDIR
 end
 set FNTSYS boot etc lib/modules root var
 
 mktemp -d | tee /tmp/tmp_name_backup_$DATE
 set TMPNAME (cat /tmp/tmp_name_backup_$DATE)
 # For overflow zramfs of /tmp
 # mktemp -dp /home/$SUDO_USER | tee /home/$SUDO_USER/tmp_name_backup_$DATE
 # set TMPNAME (cat /home/$SUDO_USER/tmp_name_backup_$DATE)
 set BKUPIMG $TMPNAME/funtoo_k10_current-home\_$SUDO_USER\_backup.sqfs

 set EXCLUDE Desktop Downloads Public Music Templates Videos .cache .ccache .git .local/share/Trash tmp_name_backup_$DATE $TMPNAME

# collecting funtoo system
 echo "Gathering Funtoo Linux K10 Current"
 mountpoint -q /boot; or mount /boot
 cd $BACKUPDIR
 for i in (seq 1 (count $FNTSYS))
   if not test -d $FNTSYS[$i]
     mkdir -p $FNTSYS[$i]
   end
 end

 echo "Collecting boot"
 rsync -ahvAHSX \
 	--delete \
 	--exclude grub/fonts/ \
 	--exclude grub/i386-pc/ \
 	--exclude grub/locale/ \
 	--exclude grub/themes/ \
 	--exclude grub/unifont.pf2 \
 	/boot/ boot/
 umount /boot
 
 for c in etc lib/modules
     echo "Collecting $c"
     rsync -ahAHSX \
     	   --delete \
	   --info=progress2 \
	   /$c/ $c/
 end

 echo "Collecting root"
 rsync -ahAHSX \
 	--delete \
	--info=progress2 \
	--exclude .cache/ \
	--exclude .ccache/ \
	--exclude .local/share/Trash/ \
	/root/ root/
	
 echo "Collecting var"
 rsync -ahAHSX \
 	--delete \
	--info=progress2 \
	--exclude git/ \
	--exclude lib/transmission/downloads/ \
	--exclude tmp/ \
	/var/ var/

# squashfs
 if test -f $BKUPIMG
   rm $BKUPIMG
 end
 mksquashfs /home/$SUDO_USER $BKUPIMG -comp xz -processors 6 -e $EXCLUDE

# blanking
# dvd+rw-format -blank=full $DEVICE
 dvd+rw-format -blank $DEVICE
 echo "$DEVICE: reloading tray"
 eject --traytoggle $DEVICE
 eject --trayclose $DEVICE

# Burning
 env -u SUDO_COMMAND growisofs -Z $DEVICE -R -J $BKUPIMG

# Clean
 rm -r (dirname $BACKUPDIR)
 rm -r $TMPNAME
 rm /tmp/tmp_name_backup_$DATE
