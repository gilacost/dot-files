#!/bin/bash
for filename in ./*.png; do
  echo $filename
  echo $(basename "$filename" .png)
  mv "$filename" "$(basename "$filename" .png)"
done
