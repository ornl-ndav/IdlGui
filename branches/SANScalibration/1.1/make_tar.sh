#!/bin/bash

file_name_to_search="SANScalibration.cfg"
list_of_files_folders="sans_calibration.sav SANScalibration README install_SANScalibration images drversion SANScalibration.cfg"

application=`./get_application.pl $file_name_to_search`
version=`./get_version.pl $file_name_to_search`

tar_file_name="./"$application"_"$version".tar"
#create tar file
tar cvf $tar_file_name $list_of_files_folders

