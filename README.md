A set of utilites for linux to process multimedia files

1. cd2mp3.sh - Extracts files from audio disks and converts them to mp3
2. photo.sh - Processes all image files in a particular folder
    - Reduces the size of original image
    - Extracts the location via google API if images were geo tagged
    - Embeds a QR code that containes the copyright, location or whatever text you specify
3. prepare_for_web.sh - Reduces all videos in a given folder and embeds a given text in all video files
4. cloudsync.sh - A shell script that uses rclone (http://rclone.org) to upload files in a given location to multiple cloud storage services
