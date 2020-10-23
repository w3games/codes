#!/bin/bash
#funtooHomeBackup-configCopy.sh
#
#
####################################################################################################################################
# 基本的な処理ルーチン
#find /home/master/ | egrep -v '/home/master/.local/share/Trash/' | afio -L $Name.log -ovZP xz $Name.xz.afio 2>&1 | tee $Name.list
####################################################################################################################################

# homeディレクトリ以外の要バックアップファイルをコピーする
Date=`date +%Y-%m%d-%H%M%S`
Files=/home/master/Documents/settings/linux-configurations/configFiles/$Date

mkdir -p $Files $Files/etc
cp -abdp /home/master/{.bash*,.inputrc,.xinitrc*,.Xresources} /var/lib/portage/world $Files/
cp -abdp /etc/* $Files/etc/
tar -cJf $Files/../$Date.tar.xz $Files/
sudo rm -r $Files
#cp -abdpR /etc/boot.conf /etc/fstab /etc/make.conf /etc/eixrc	$Files/etc/
#cp -abdp /etc/X11/xorg.conf*		$Files/etc/X11/
#cp -abdp /etc/portage/package.*	$Files/etc/portage/
#cp -abdp /etc/kernels/*		$Files/etc/kernels
