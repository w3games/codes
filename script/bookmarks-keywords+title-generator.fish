#!/bin/fish
#
# bookmarks keywords+title generator

set BOOKMARK ~/Documents/settings/firefox/bookmarks.html

grep "<DD>" $BOOKMARK \
	| sed -e 's/<[^>]*>//g' \
	| sed -e 's/^$//g' \
	| sed -e 's/^ *//g' \
	| sed -e 's/^/・/g' \
	| sort -u > ~/Documents/homepage/bookmarks-title.txt

grep "<DT>" $BOOKMARK \
	| sed -e 's/<[^>]*>//g' \
	| sed -e 's/^$//g' \
	| sed -e 's/^ *//g' \
	| sed -e 's/^/・/g' \
	| sort -u >> ~/Documents/homepage/bookmarks-title.txt

echo "[Keywords]" > ~/Documents/homepage/bookmarks-keywords.txt

grep SHORTCUTURL $BOOKMARK \
	| sed -e 's/<[^>]*>//g' \
	| sed -e 's/^$//g' \
	| sed -e 's/^ *//g' \
	| sed -e 's/^/・/g' \
	| sort -u >> ~/Documents/homepage/bookmarks-keywords.txt

echo >> ~/Documents/homepage/bookmarks-keywords.txt
echo "[Titles]" >> ~/Documents/homepage/bookmarks-keywords.txt

cat ~/Documents/homepage/bookmarks-title.txt >> ~/Documents/homepage/bookmarks-keywords.txt 


# cp -p ~/Documents/homepage/bookmarks-{keywords,title}.txt /mnt/funtoo_586_stable/home/leaf/www/localhost/homepage/
# scp -p ~/Documents/homepage/bookmarks-{keywords,title}.txt leaf@vaionote:~/www/localhost/homepage/
