#!/bin/bash
cd $(dirname $0)
cd ../blog
for file in $(ls *.erb) ; do
   echo ${file}

   sed -e "s/\[map/<div class=\"map\"/g" ${file} | sed -e "s/ style=\"width:763px; height:350px; border:1px solid gray; margin-right:0px; margin-bottom:15px; float:left;\"\]&nbsp;/><\/div>/g" > "${file}.txt"
   mv "${file}.txt" "${file}"

   sed -e "s/<img src='\/posts/<img src='<%= @site.base_url %>\/posts/g" ${file} > "${file}.txt"
   mv "${file}.txt" "${file}"

   sed -e "s/\"\/gpx\//\"<%= @site.base_url %>\/gpx\//g" ${file} > "${file}.txt"
   mv "${file}.txt" "${file}"
done