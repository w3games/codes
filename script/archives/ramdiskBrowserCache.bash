#!/bin/bash
#ramdiskBrowserCache

APPDATA=/dev/shm/APPDATA
FLASH_PLAYER=${HOME}/.macromedia/Flash_Player
OPERA=${HOME}/.opera/cache
FIREFOX=${HOME}/.cache/mozilla/firefox
GOOGLE=${HOME}/.cache/google-chrome/Default
CHROMIUM=${HOME}/.cache/chromium/Default
CRONTAB=${HOME}/Documents/settings/linux-configurations

ITEMS=(FLASH_PLAYER OPERA FIREFOX GOOGLE CHROMIUM)


if [ ! -d ${APPDATA} ] ; then
  mkdir ${APPDATA}
fi

if [ -d ${FLASH_PLAYER} ] && [ -d ${OPERA} ] && [ -d ${FIREFOX} ] && [ -d ${GOOGLE} ] && [ -d ${CHROMIUM} ] && [ ! -h ${FLASH_PLAYER} ] && [ ! -h ${OPERA} ] && [ ! -h ${FIREFOX} ] && [ ! -h ${GOOGLE} ] && [ ! -h ${CHROMIUM} ]; then
  for i in ${ITEMS[@]} ;
    do
      if [ ! -d ${APPDATA}/$i ] ; then
         mkdir ${APPDATA}/$i
      fi
      eval j='$'$i
      echo -e $(date +%T.%N | cut -c-12) "Syncing Cache from $j/ to ${APPDATA}/$i/"
      rsync -acHS -e "ssh -c arcfour256" --delete $j/ ${APPDATA}/$i/
      mv $j $j-renamed
      ln -s ${APPDATA}/$i $j ;
  done

  sudo -u ${USER} echo "0 */1 * * * /usr/local/bin/rsyncFromRamdiskToDisk" >> ${CRONTAB}/crontab
  crontab ${CRONTAB}/crontab
  echo -e $(date +%T.%N | cut -c-12) "Done"

elif [ -h ${FLASH_PLAYER} ] && [ -h ${OPERA} ] && [ -h ${FIREFOX} ] && [ -h ${GOOGLE} ] && [ -h ${CHROMIUM} ]; then
  sudo -u ${USER} sed -i '/rsyncFromRamdiskToDisk/d' ${CRONTAB}/crontab
  crontab ${CRONTAB}/crontab

  /usr/local/bin/rsyncFromRamdiskToDisk
  
  for i in ${ITEMS[@]} ;
    do
      eval j='$'$i
      rm $j
      mv $j-renamed $j ;
  done 

# rm -r ${APPDATA}
  echo -e $(date +%T.%N | cut -c-12) "Done"
fi
