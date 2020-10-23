#!/bin/fish
#
#funtoo_k10_stable

set FROMDIR /mnt/funtoo_k10_stable
set TODIR   /mnt/funtoo_k10_stable_backup

for i in FROMDIR TODIR
  if not test -d $$i
    mkdir $$i
  end
  mountpoint -q $$i; or mount $$i
end

rsync -ahAHSX \
      --del \
      --info=progress2 \
      --log-file=/var/log/rsync.log \
      $FROMDIR/ $TODIR/

for i in FROMDIR TODIR
  umount $$i
  rmdir $$i
end
