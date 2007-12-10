function get_up_to_date_geo_tran_file, instrument

case instrument of
    'REF_L': beam_line = '4B'
    'REF_M': beam_line = '4A'
    'BSS'  : beam_line = '2'
    'ARCS' : beam_line = '18'
endcase

path_to_files_of_interest = "/SNS/" + instrument
path_to_files_of_interest += "/2006_1_" + beam_line + "_CAL/calibrations/"

;generic file names
geometry_file = instrument + "_geom_*.nxs"
translation_file = instrument + "_*.nxt"

;get up-to-date geometry_file
ls_cmd = path_to_files_of_interest + geometry_file
spawn, "ls " + ls_cmd, geometry_list, err_listening

geometry_file = reverse(geometry_list[sort(geometry_list)])

;get up-to-date translation_file
ls_cmd = path_to_files_of_interest + translation_file
spawn, "ls " + ls_cmd, translation_list, err_listening

translation_file = reverse(translation_list[sort(translation_list)])

;combine results
array_result=[geometry_file[0], translation_file[0]]

return, array_result

end
