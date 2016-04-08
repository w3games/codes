#!/bin/fish
#
# rsyncToWindows.fish

if not set -q SUDO_USER >/dev/null
      set SUDO_USER leaf
end

set WINDOWS	/mnt/windows
set WINDATA	/mnt/windata
set WINUSER	leaf
set WINNAVI2ch	$WINDOWS/Users/$WINUSER/AppData/Roaming/.navi2ch

for d in WINDOWS WINDATA
  if not test -d $$d
    mkdir $$d
  end
  mountpoint -q $$d; or sudo mount $$d
end
# if not test -d $WINDOWS 
#   mkdir $WINDOWS
# end
# mountpoint -q $WINDOWS; or sudo mount $WINDOWS

for i in Documents Pictures
    if not test -d $WINDATA/Users/$WINUSER/$i
       mkdir -p $WINDATA/Users/$WINUSER/$i
    end
    echo \n"Syncing $i from Linux to Windows"
    rsync -ahvAHSX \
	  --delete \
	  --exclude desktop.ini \
	  --exclude Thumbs.db \
	  --exclude My\ Music \
	  --exclude My\ Pictures \
	  --exclude My\ Videos \
	  --exclude Saved\ Pictures/ \
	  --exclude Camera\ Roll/ \
	  /home/$SUDO_USER/$i/ $WINDATA/Users/$WINUSER/$i/
end

#if not test -d $WINDOWS/Users/$WINUSER/Downloads
#   mkdir $WINDOWS/Users/$WINUSER/Downloads
#end
#echo \n"Syncing Downloads from Linux to Windows"
#rsync -ahvAHSX \
#      --delete \
#      --exclude desktop.ini \
#      --exclude Thumbs.db \
#      /home/$SUDO_USER/Downloads/windows/ $WINDOWS/Users/$WINUSER/Downloads/

if not test -d $WINNAVI2ch 
      mkdir $WINNAVI2ch 
end
echo \n"Syncing .navi2ch from Linux to Windows"
rsync -ahvAHSX \
      --delete \
      --exclude desktop.ini \
      --exclude Thumbs.db \
      /home/$SUDO_USER/.navi2ch/ $WINNAVI2ch/

for d in WINDOWS WINDATA
  umount $$d
  rmdir  $$d
end
# umount $WINDOWS
# rmdir  $WINDOWS
