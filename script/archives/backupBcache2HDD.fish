#!/bin/fish
#
#backupBcache2HDD.fish

set BackupDirectory home
set BackupDevice sda4

if not mountpoint -q /home
   mount /home
end

if not mountpoint -q /mnt/$BackupDirectory-$BackupDevice
    mount /mnt/$BackupDirectory-$BackupDevice
end

rsync -ahAHSX --del --info=progress2 --log-file=/var/log/rsync.log \
      --exclude leaf/Desktop \
      --exclude leaf/Documents \
      --exclude leaf/Downloads \
      --exclude leaf/Music \
      --exclude leaf/Pictures \
      --exclude leaf/Videos \
      /home/ /mnt/$BackupDirectory-$BackupDevice/
