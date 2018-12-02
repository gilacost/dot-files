#!/bin/sh

declare -a signs=("aquarius" "aries" "cancer" "capricorn" "geminis" "leo" "libra" "piscis" "sagitarius" "scorpio" "taurus" "virgo")

for s in "${signs[@]}"
do
  curl -O "https://s3.amazonaws.com/tboeassets/images/star/star_"$s"_v01_2551.png"
  curl -O "https://s3.amazonaws.com/tboeassets/images/star/star_kids_"$s"_v01_2551.png"
done

