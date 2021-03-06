#!/bin/sh
#
#proxy2ch.sh

PROXY2CH="$HOME/Documents/scripts/proxy2ch"

test -x ${PROXY2CH} || exit 0;

pgrep proxy2ch
if [ $? -ne 0 ]
 then
  ${PROXY2CH} -api JYW2J6wh9z8p8xjGFxO3M2JppGCyjQ:hO2QHdapzbqbTFOaJgZTKXgT2gWqYS \
	   --api-auth-ua "Mozilla/3.0 (compatible; JaneStyle/3.83)" \
  	   --api-auth-xua "JaneStyle/3.83" \
 	   --api-dat-ua "Mozilla/3.0 (compatible; JaneStyle/3.83)" \
	   --api-dat-xua "JaneStyle/3.83" \
	   -p 8080 &
 else
  pkill proxy2ch
fi

