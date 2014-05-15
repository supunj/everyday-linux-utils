#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

CD_DIRVE=.
OUTPUT_FOLDER=/media/ntfs_data/Songs/Temp

input="$1"

for file in `find $CD_DIRVE -maxdepth 1 -type f -name "*.wav" -o -name "*.WAV"`
do
	file_name=$(basename ${file%.*})
	
	#Convert	
	avconv -i $file -acodec libmp3lame -ab 128k /tmp/$file_name.mp3

	#Add id3 tag for artist
	lame --ta $1 /tmp/$file_name.mp3 $OUTPUT_FOLDER/$file_name.mp3

	#Remove the temp file	
	rm /tmp/$file_name.mp3
	
	echo -ne $file
done
	
echo 'Done.'

IFS=$SAVEIFS

