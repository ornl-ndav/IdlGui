pro dumpBinaryData, full_nexus_name

;create tmp_working_path
;get global structure
tmp_working_path = "~/"

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
tmp_output_file_name = 'REF_L_tmp_histo_data.dat'
cmd_dump += tmp_output_file_name

spawn, cmd_dump, listening

end

