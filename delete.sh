#!/bin/bash
puths=("/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/" "/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/upload/")
siteputh="/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/"
expansion=".*\(doc\|docx\|xls\|xlsx\|pdf\|rar\|zip\|jpg\|JPG\|jpeg\|gif\|rtf\|7z\|png\)$"
date=$(date +"%Y-%m-%d")
for puth in ${puths[@]}; do
    find $puth -maxdepth 1 -type f -regex $expansion -exec basename {} \; >file.txt
    sed -i '/^ /d' file.txt
    sed -i '/^-/d' file.txt
    sed -i '/^!/d' file.txt
    while read file; do
        grepfile=$(grep -rl --include="*.php" --exclude-dir={bitrix,upload} "$file" "$siteputh")
        if [[ -z "$grepfile" ]]; then
            echo "Delete file - $puth$file" >>"$date.log"
            rm "$puth$file"
        fi
    done <file.txt
done
