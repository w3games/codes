#!/bin/bash
#rsyncFromWindows.sh

mountpoint -q /mnt/windows || sudo mount /mnt/windows
for i in Documents Pictures Music Videos
do
    rsync -ahvAHS \
	  --del \
	  --exclude desktop.ini \
	  --exclude Thumbs.db \
	  /mnt/windows/Users/leaf/$i/ ~/$i/
done
rsync -ahvAHSX \
      --del \
      --exclude desktop.ini \
      --exclude Thumbs.db \
      /mnt/windows/Users/leaf/Downloads/ ~/Downloads/windows/
sudo umount /mnt/windows
