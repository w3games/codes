#!/bin/fish
#
#backup_compile_world.fish

for i in linux-headers binutils gcc glibc
  emerge -1q $i
end

emerge -bej --keep-going=y --with-bdeps=y @world

funtoo_k10_current_backup.sh
backupHome.fish
backup2dvd.fish

halt
