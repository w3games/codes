#!/bin/fish
#rsyncFromWindows.fish

if not set -q SUDO_USER >/dev/null
      set SUDO_USER leaf
end

set WINDOWS /mnt/windows
set WINDATA /mnt/windata
set WINUSER leaf
set WINNAVI2ch	$WINDOWS/Users/$WINUSER/AppData/Roaming/.navi2ch

for d in WINDOWS WINDATA
  if not test -d $$d
    mkdir $$d
    mountpoint -q $$d; or sudo mount $$d
  end
end
# if not test -d $WINDOWS 
#   mkdir $WINDOWS
# end
# mountpoint -q $WINDOWS; or sudo mount $WINDOWS

for i in Documents Pictures 
    echo \n"Syncing $i from Windows to Linux"
    rsync -ahvAHS \
	  --delete \
	  --exclude desktop.ini \
	  --exclude Thumbs.db \
	  --exclude My\ Music \
	  --exclude My\ Pictures \
	  --exclude My\ Videos \
	  --exclude Saved\ Pictures/ \
	  --exclude Camera\ Roll/ \
	  $WINDATA/Users/$WINUSER/$i/ /home/$SUDO_USER/$i/
end
echo \n"Syncing Downloads from Windows to Linux"
rsync -ahvAHSX \
	--delete \
	--exclude desktop.ini \
	--exclude Thumbs.db \
	$WINDATA/Users/$WINUSER/Downloads/ /home/$SUDO_USER/Downloads/windows/

echo \n"Syncing .navi2ch from Windows to Linux"
rsync -ahvAHSX \
	--delete \
	--dry-run \
	--exclude desktop.ini \
	--exclude Thumbs.db \
	$WINNAVI2ch/ /home/$SUDO_USER/.navi2ch/

find /home/$SUDO_USER/Documents/scripts/ \
	-type f \
	-name '*.tar.*' \
	-o -name '.keep_sys-apps_baselayout-0' \
	-prune \
	-o -exec chmod +x '{}' \;

chmod +x /home/$SUDO_USER/.wmii/wmiirc_local

for d in WINDOWS WINDATA
  umount $$d
  rmdir  $$d
end 
# umount $WINDOWS
# rmdir  $WINDOWS 
