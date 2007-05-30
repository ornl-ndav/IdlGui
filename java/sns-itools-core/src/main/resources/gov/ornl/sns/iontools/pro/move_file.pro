pro MOVE_FILE, ucams, tmp_folder, file_name

print, "in move_file"
output_folder = "/SNS/users/" + ucams

cmd = "cp " 
cmd += tmp_folder+file_name
cmd += " " + output_folder
print, cmd

end

