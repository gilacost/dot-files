#!/bin/sh

vals=($(seq -f "%02g" 1 12))
for s in "${vals[@]}"
do
    echo $s
    m_file_name="supe_m_${s}_v04_2551.png"
    url="https://s3.amazonaws.com/tboeassets/images/pages/super_powers/$m_file_name"
    echo $m_file_name
    curl -O "$url"
    convert -size 2851x2851 xc: $m_file_name -fx 'v.p[-100,-100]' "supe_m_${s}_v04_2851.png"
    resizer "supe_m_${s}_v04_2851.png"

    f_file_name="supe_f_${s}_v04_2551.png"
    url="https://s3.amazonaws.com/tboeassets/images/pages/super_powers/$f_file_name"
    echo $f_file_name
    curl -O "$url"
    convert -size 2781x2851 xc: $f_file_name -fx 'v.p[-100,-100]' "supe_f_${s}_v04_2851.png"
    resizer "supe_f_${s}_v04_2851.png"

done
