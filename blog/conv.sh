#!/bin/bash
for file in $(ls *.erb) ; do
   echo ${file}
   # sed -e "s/\[map/<div class=\"map\"/g" ${file} 
   sed -e "s/<img src='\/posts/<img src='\.\.\/\\.\.\/\.\.\/\\.\.\/posts/g" ${file} > "${file}.txt"
   mv "${file}.txt" "${file}"
done