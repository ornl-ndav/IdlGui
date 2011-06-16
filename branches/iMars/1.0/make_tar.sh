#!/bin/bash

#Create by j35@ornl.gov
#Run this program to create a tar file

# HELP
#> ./make_tar.sh <name of file that contain the APPLICATION and VERSION tags>
#ex
#> ./make_tar.sh iMars.cfg
#

file_name_to_search=$1
list_of_files_folders='iMars_images iMars.sav README'

application=`./get_application.pl $file_name_to_search`
version=`./get_version.pl $file_name_to_search`

tar_file_name="./"$application"_"$version".tar"
#create tar file
tar cvf $tar_file_name $list_of_files_folders
