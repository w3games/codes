#!/bin/bash
#rsyncToWindows.sh

mountpoint -q /mnt/windows || sudo mount /mnt/windows
for i in Documents Pictures Music Videos
do
    rsync -ahvAHS \
	  --del \
	  --exclude desktop.ini \
	  --exclude Thumbs.db \
	   ~/$i/ /mnt/windows/Users/leaf/$i/
done
rsync -ahvAHSX \
      --del \
      --exclude desktop.ini \
      --exclude Thumbs.db \
      ~/Downloads/windows/ /mnt/windows/Users/leaf/Downloads/
sudo umount /mnt/windows
