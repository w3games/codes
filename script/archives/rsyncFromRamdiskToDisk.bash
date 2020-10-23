#!/bin/bash
#rsyncFromRamdisk

APPDATA=/dev/shm/APPDATA
FLASH_PLAYER=${HOME}/.macromedia/Flash_Player
OPERA=${HOME}/.opera/cache
FIREFOX=${HOME}/.cache/mozilla/firefox
GOOGLE=${HOME}/.cache/google-chrome/Default
CHROMIUM=${HOME}/.cache/chromium/Default

ITEMS=(FLASH_PLAYER OPERA FIREFOX GOOGLE CHROMIUM)

for i in ${ITEMS[@]} ;
  do
    eval j='$'$i
    echo -e $(date +%T.%N | cut -c-12) "Syncing Cache from ${APPDATA}/$i/ to $j/"
    rsync -acHS -e "ssh -c arcfour256" --delete ${APPDATA}/$i/ $j/ ;
done
