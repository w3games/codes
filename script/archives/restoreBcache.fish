#!/bin/fish
#
#restoreBcache.sh

for i in home portage ccache
    if not mountpoint -q /mnt/$i-sda3
        mount /mnt/$i-sda3
    end
end

rsync -ahAHSX --info=progress2 /mnt/home-sda3/ /home/
rsync -ahAHSX --info=progress2 /mnt/portage-sda3/ /usr/portage/
rsync -ahAHSX --info=progress2 /mnt/ccache-sda3/ /var/tmp/ccache/

for i in home portage ccache
    umount /mnt/$i-sda3
end
