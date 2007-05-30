pro MOVE_FILE, ucams, tmp_folder, file_name

cmd = "/usr/local/bin/ioncp " 
cmd += tmp_folder+file_name
cmd += " " + ucams
spawn, cmd

end

