pro RENAME_MOVE_FILE, ucams, tmp_folder, old_file_name, new_file_name

if (ucams EQ 'j35') Then begin
	cmd = "cp " 
	cmd += tmp_folder + old_file_name
	cmd += " /SNS/users/j35/" + new_file_name
endif else begin
	cmd = "/usr/local/bin/ionrncp " 
	cmd += tmp_folder+old_file_name
	cmd += " " + new_file_name
	cmd += " " + ucams
endelse

spawn, cmd
print, cmd
end
