#!/usr/bin/env bash

selected="$(printf 'language\ncore-util'| fzf --height 40% --reverse --border)"

read -p "$selected : " lang
read -p "query >> " query

if [ $selected == "language" ]; then
	url=$lang/$(echo $query | tr ' ' '+')
else
	url=$lang~$query
fi


echo $url
curl "cht.sh/$url" | bat& 

while [ : ];do sleep 1 ;done
