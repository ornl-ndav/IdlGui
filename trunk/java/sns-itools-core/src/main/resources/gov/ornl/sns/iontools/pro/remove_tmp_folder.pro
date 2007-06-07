PRO REMOVE_TMP_FOLDER, tmp_folder_name

cmd = "/usr/local/bin/ionrmdir "
cmd += string(tmp_folder_name)
spawn, cmd
end
