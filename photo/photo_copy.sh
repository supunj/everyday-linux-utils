#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

source_path="$1"
destination_path="$2"

for file in `find $source_path -maxdepth 1 -type f -name "*.JPG" -o -name "*.jpg"`
do
        # Exract file info
        file_name=$(basename "$file")
        file_size=$(stat -c %s "$file")
        DateTimeOriginal=$(identify -format "%[exif:DateTimeOriginal]" $file)        
        GPSLatitude=$(identify -format "%[exif:GPSLatitude]" $file)
        GPSLatitudeRef=$(identify -format "%[exif:GPSLatitudeRef]" $file)
        GPSLongitude=$(identify -format "%[exif:GPSLongitude]" $file)
        GPSLongitudeRef=$(identify -format "%[exif:GPSLongitudeRef]" $file)

        # Extract year
        year=$(awk -F: '{print $1}' <<< $DateTimeOriginal)
        # Extract month
        case "$(awk -F: '{print $2}' <<< $DateTimeOriginal)" in
                '01') month='January' ;;
                '02') month='February' ;;
                '03') month='March' ;;
                '04') month='April' ;;
                '05') month='May' ;;
                '06') month='June' ;;
                '07') month='July' ;;
                '08') month='August' ;;
                '09') month='September' ;;
                '10') month='October' ;;
                '11') month='November' ;;
                '12') month='December' ;;
        esac

        echo -ne "File->$file_name | "

        # Copy to the destination
        mkdir -p $destination_path/$year/$month
        cp $file $destination_path/$year/$month/$file_name
        
        echo "Done!"
done
