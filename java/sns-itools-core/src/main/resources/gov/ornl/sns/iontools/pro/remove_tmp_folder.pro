PRO REMOVE_TMP_FOLDER, tmp_folder_name

cmd = "rm -rf "
cmd += tmp_folder_name
spawn, cmd
end
