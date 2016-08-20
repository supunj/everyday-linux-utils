#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

source_path="$1"
destination_path="$2"

input="$1"

for file in `find $source_path -maxdepth 1 -type f -name "*.wav" -o -name "*.WAV"`
do
	file_name=$(basename ${file%.*})
	
	#Convert	
	avconv -i $file -acodec libmp3lame -ab 128k /tmp/$file_name.mp3

	#Add id3 tag for artist
	lame --ta $1 /tmp/$file_name.mp3 $destination_path/$file_name.mp3

	#Remove the temp file	
	rm /tmp/$file_name.mp3
	
	echo -ne $file
done
	
echo 'Done.'

IFS=$SAVEIFS

