#!/bin/sh

for age in $(seq -f "%03g" 1 150)
do
  url="https://s3.amazonaws.com/tboeassets/images/ages/ages_"$age"_v01_2551.png"
  curl -O $url
done

