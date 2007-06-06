pro MOVE_FILE, ucams, tmp_folder, file_name

if (ucams EQ 'j35') then begin
	cmd = "cp "
	cmd += tmp_folder + file_name
	cmd += " /SNS/users/j35/" 
endif else begin
	cmd = "/usr/local/bin/ioncp " 
	cmd += tmp_folder+file_name
	cmd += " " + ucams
endelse

spawn, cmd

end
