#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

source_path="$1"
destination_path="$2"

for file in `find $source_path -maxdepth 1 -type f -name "*.JPG" -o -name "*.jpg"`
do
        # Exract file info
        file_name=$(basename "$file")       
        DateTimeOriginal=$(identify -format "%[exif:DateTimeOriginal]" $file)
        DateTime=$(identify -format "%[exif:DateTime]" $file)
        
        echo -ne "File->$file_name | "

        # In older cameras, the original data time exif is not present. In such cases, use DateTime exif
        if [ "$DateTimeOriginal" = "" ]
        then
                if [ "$DateTime" != "" ]
                then
                        echo -ne "Using DateTime exif | "
                        DateTimeOriginal=$DateTime
                else
                        echo -ne "Undated->0000:00:00 00:00:00 | "
                        DateTimeOriginal="0000:00:00 00:00:00"
                fi
        fi

        GPSLatitude=$(identify -format "%[exif:GPSLatitude]" $file)
        GPSLatitudeRef=$(identify -format "%[exif:GPSLatitudeRef]" $file)
        GPSLongitude=$(identify -format "%[exif:GPSLongitude]" $file)
        GPSLongitudeRef=$(identify -format "%[exif:GPSLongitudeRef]" $file)
        ExifImageLength=$(identify -format "%[exif:ExifImageLength]" $file)

        # Extract year
        year=$(awk -F: '{print $1}' <<< $DateTimeOriginal)
        # Extract month
        case "$(awk -F: '{print $2}' <<< $DateTimeOriginal)" in
                '00') month='' ;;
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
        
        # Get location from google
        if [ "$GPSLatitude" = "" -o "$GPSLatitudeRef" = "" -o "$GPSLongitude" = "" -o "$GPSLongitudeRef" = "" ]
        then
                location="No GPS Data"
        else
                location=$(python3 ./fetchloc.py ${GPSLatitude//[[:blank:]]/} $GPSLatitudeRef ${GPSLongitude//[[:blank:]]/} $GPSLongitudeRef)
        fi

        echo -ne "Location->$location | "

        # Generate QR code
        qr_string="Copyright : Supun Jayathilake"$'\n'"Google : supunj@gmail.com"$'\n'"Facebook : supun.jayathilake"$'\n'"Taken : $DateTimeOriginal"$'\n'"Location : $location"
        
        if [ "$ExifImageLength" -gt 1999 ]
        then
                qr_size="3"
        else
                qr_size="2"
        fi
        
        echo -ne "QR Gen->$qr_size | "
        qrencode -l H -v 10 -s "$qr_size" -o /tmp/qr.png "$qr_string"
        
        # Add watermark
        echo -ne "QR Add | "
        #composite -dissolve 100% -gravity SouthEast -quality 100 /tmp/qr.png $file /tmp/watermarked.jpg
        convert /tmp/qr.png -fill grey50 -colorize 40 miff:- | composite -dissolve 70% -gravity SouthEast - $file /tmp/watermarked.jpg

        watermarked_file_size=$(stat -c %s /tmp/watermarked.jpg)

        echo -ne "Size->$watermarked_file_size | "

        # Checksize
        if [ "$watermarked_file_size" -gt 3000000 ]
        then
                echo -ne  "Re-size | " 
                convert /tmp/watermarked.jpg -define jpeg:extent=3000kb /tmp/watermarked_processed.jpg
        else
                echo -ne  "Size is ok | "
                cp /tmp/watermarked.jpg /tmp/watermarked_processed.jpg
        fi

        # Copy to the destination
        mkdir -p $destination_path/$year/$month
        cp /tmp/watermarked_processed.jpg $destination_path/$year/$month/$file_name
        
        echo "Done!"
        
        # Re-set
        unset DateTimeOriginal
        unset DateTime
        unset location
        unset qr_size
        unset qr_string
        unset GPSLatitude
        unset GPSLatitudeRef
        unset GPSLongitude
        unset GPSLongitudeRef
        unset ExifImageLength
        unset year
        unset month
        unset watermarked_file_size
done
