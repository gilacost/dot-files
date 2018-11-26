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

if [[ $1 =~ ^(.*)_2551\.(.*)$ ]]; then
  basename=${BASH_REMATCH[1]}
  ext=${BASH_REMATCH[2]}
  width=`identify -format '%w' $1`
  height=`identify -format '%h' $1`

  sizes=(64 128 256 512 768 1024 1536 2048)
  for size in "${sizes[@]}" ; do
    currentWidth=`expr $size \* $width / 2551`
    currentHeight=`expr $size \* $height / 2551`
    target=$basename"_"$size"."$ext
    convert $1 -resize $currentWidth"x"$currentHeight $target
  done
else
  echo "error: input file must end with _2551"
  exit -2
fi
