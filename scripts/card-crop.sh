#!/bin/sh

if ! [ -x `command -v identify` ]; then
  echo "error: install imagemagick before using this script"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "USAGE ./"`basename "$0"` "path/to/image_2551.png"
  exit -1
fi

if ! [ -f $1 ]; then
  echo "error: file not found"
  exit -3
fi

target=`echo $1 | sed "s/\.png/-cropped\.png/g"`
convert $1 -crop 2542x2551+9+0 $target

