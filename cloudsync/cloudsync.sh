#!/bin/bash

# Author - Supun Jayathilake (supunj@gmail.com)

base_folder='/mnt/cloudsync'
cloud_folder=''

# rclone remote names
gdrive_remote='gdrive'
onedrive_remote='onedrive'
dropbox_remote='dropbox'
gdrive_amani_remote='gdrive_amani'

# i use the same remote name for the local folders. change if required
gdrive_path=$base_folder/$gdrive_remote
onedrive_path=$base_folder/$onedrive_remote
dropbox_path=$base_folder/$dropbox_remote
gdrive_amani_path=$base_folder/$gdrive_amani_remote

folder_depth=5

# loop through paths
for search_path in $gdrive_path $onedrive_path $dropbox_path $gdrive_amani_path
do
    # find in one path at a time in order to get the relative path
    for relative_file_path in `find $search_path -maxdepth $folder_depth -type f -not -name "*.done" -printf '%P\n'`
    do
            # Exract file info
            remote_path=$(dirname "$relative_file_path")
            absolute_file_path=$search_path/$relative_file_path

            # derive the storage based on the folder path
            case $search_path in
              $gdrive_path) storage_service=$gdrive_remote ;;
              $onedrive_path) storage_service=$onedrive_remote ;;
              $gdrive_path) storage_service=$dropbox_remote ;;
              $gdrive_amani_path) storage_service=$gdrive_amani_remote ;;
            esac

            # upload to cloud storage
            echo -ne "Uploading " $absolute_file_path " to " $storage_service:$cloud_folder/$remote_path
            rclone copy $absolute_file_path $storage_service:$cloud_folder/$remote_path
            echo " - Done!"

            # rename the file
            mv $absolute_file_path $absolute_file_path.done

            # wait for few seconds before resuming
            sleep 3
    done
done
