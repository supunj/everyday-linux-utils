#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

source_path="$1"
destination_path="$2"

for file in `find $source_path -maxdepth 1 -type f -name "*.MP4" -o -name "*.mp4" -o -name "*.MTS" -o -name "*.mts" -o -name "*.MPG" -o -name "*.mpg"`
do
        # Exract file info
        file_name=$(basename "$file")
        original_file_size=$(( $( stat -c '%s' $file) / 1024 / 1024 ))
             
        echo -ne "File->$file_name | Original Size->$original_file_size | "

        avconv -i $file -s hd480 -acodec aac -strict experimental -ac 2 -ar 44100 -ab 192k -vf "drawtext=fontfile='/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf':text='Copyright-Supun Jayathilake(supunj@gmail.com)':x=main_w-text_w:y=main_h-text_h:fontsize=16:fontcolor=white" $destination_path/${file_name%.*}.mp4

        processed_file_size=$(( $( stat -c '%s' $destination_path/${file_name%.*}.mp4) / 1024 / 1024 ))
        
        echo "Processed Size->$processed_file_size | Done!"
done
