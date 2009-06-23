#!/bin/bash

file_name_to_search="SANScalibration.cfg"
list_of_files_folders="SANScalibration miniSANScalibration sans_calibration.sav mini_sans_calibration.sav README install_SANScalibration SANScalibration_images drversion SANScalibration.cfg"

application=`./get_application.pl $file_name_to_search`
version=`./get_version.pl $file_name_to_search`

tar_file_name="./"$application"_"$version".tar"
#create tar file
tar cvf $tar_file_name $list_of_files_folders
