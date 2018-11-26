#!/bin/sh

books=(${1})
api_images_base_url="https://api.thebookofeveryone.com:443/bookbuilder/images/getimageofpage/book_id/"
size=768


for b in "${books[@]}"
do
  echo "${b}\n"
  for i in $(eval echo {0..55})
  do
    wget "${api_images_base_url}${b}/page_number/${i}/size/${size}/quality/90/type/png" -O "${b}_${i}.png";
  done
done
