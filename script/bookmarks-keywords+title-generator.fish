#!/bin/fish
#
# bookmarks keywords+title generator

grep \<DD\> ~/Documents/homepage/bookmarks.html \
| sed -e 's/^[ ]*//g' \
| sed -e 's/^<DD>/・/g' \
| sort -u >> ~/Documents/homepage/bookmarks-title.txt

echo "[Keywords]" > ~/Documents/homepage/bookmarks-keywords.txt
grep SHORTCUTURL ~/Documents/homepage/bookmarks.html \
| sed -e 's/.*SHORTCUTURL=\"\(.*\).*$/\1/' \
| sed -e 's/<\/A>$//g' \
| sed -e 's/^/・/g' \
| sort -u >> ~/Documents/homepage/bookmarks-keywords.txt

echo >> ~/Documents/homepage/bookmarks-keywords.txt
echo "[Titles]" >> ~/Documents/homepage/bookmarks-keywords.txt

cat ~/Documents/homepage/bookmarks-title.txt >> ~/Documents/homepage/bookmarks-keywords.txt 

scp -p ~/Documents/homepage/bookmarks-{keywords,title}.txt leaf@vaionote:~/www/localhost/homepage/
