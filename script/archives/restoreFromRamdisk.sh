#/bin/bash
#restoreFromRamdisk.sh

if [ -h $HOME/.cache ] && [ -h $HOME/.macromedia/Flash_Player ] && [ -h $HOME/.mozilla/firefox/wdle87ex.default/Cache ] && [ -h $HOME/.opera/cache ]; then
 sudo -u $USER sed -i '/rsyncFromRamdisk.sh/d' $HOME/Documents/settings/linux-configurations/crontab
 crontab $HOME/Documents/settings/linux-configurations/crontab

 bash $HOME/Documents/settings/linux-configurations/rsyncFromRamdisk.sh
 rm $HOME/.cache $HOME/.macromedia/Flash_Player $HOME/.mozilla/firefox/wdle87ex.default/Cache $HOME/.opera/cache
 mv $HOME/.cache-renamed $HOME/.cache
 mv $HOME/.macromedia/Flash_Player-renamed $HOME/.macromedia/Flash_Player
 mv $HOME/.mozilla/firefox/wdle87ex.default/Cache-renamed $HOME/.mozilla/firefox/wdle87ex.default/Cache
 mv $HOME/.opera/cache-renamed $HOME/.opera/cache

# rm -r /dev/shm/appdata
fi
