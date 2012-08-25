#!/bin/bash
for file in $(ls *.erb) ; do
   echo ${file}
   sed -e "s/\[map/<div class=\"map\"/g" ${file} | sed -e "s/ style=\"width:763px; height:350px; border:1px solid gray; margin-right:0px; margin-bottom:15px; float:left;\"\]&nbsp;/><\/div>/g" > "${file}.txt"
   mv "${file}.txt" "${file}"
done