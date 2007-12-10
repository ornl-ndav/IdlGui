function get_up_to_date_geo_tran_map_file, instrument

case instrument of
    'REF_L': beam_line = '4B'
    'REF_M': beam_line = '4A'
    'BSS'  : beam_line = '2'
    'ARCS' : beam_line = '18'
endcase

path_to_files_base = "/SNS/" + instrument
path_array = [path_to_files_base + "/2006_1_" + beam_line + "_CAL/calibrations/",$
              path_to_files_base + "/2008_1_" + beam_line + "_CAL/calibrations/"]
sz = (size(path_array))(1)

;generic file names
geometry_file    = instrument + '_geom_*.xml'
translation_file = instrument + '_*.nxt'
mapping_file     = instrument + '_TS_*.dat'

;get up-to-date geometry_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + geometry_file
    spawn, 'ls ' + ls_cmd, geom, geom_error
    IF (geom[0] NE '') THEN BEGIN
        geom_file = reverse(geom[sort(geom)])
        BREAK
    ENDIF
ENDFOR

;get up-to-date translation_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + translation_file
    spawn, 'ls ' + ls_cmd, trans, trans_error
    IF (trans[0] NE '') THEN BEGIN
        trans_file = reverse(trans[sort(trans)])
        BREAK
    ENDIF
ENDFOR

;get up-to-date mapping_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + mapping_file
    spawn, 'ls ' + ls_cmd, map, map_error
    IF (map[0] NE '') THEN BEGIN
        map_file = reverse(map[sort(map)])
        BREAK
    ENDIF
ENDFOR

;combine results
array_result=[geom_file[0], trans_file[0], map_file[0]]
return, array_result

end
