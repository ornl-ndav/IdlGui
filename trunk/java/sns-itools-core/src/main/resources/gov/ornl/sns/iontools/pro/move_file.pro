pro MOVE_FILE, ucams, tmp_folder, file_name

output_folder = "/SNS/users/" + ucams + "/"

cmd = "cp " 
cmd += tmp_folder+file_name
cmd += " " + output_folder
spawn, cmd

end

