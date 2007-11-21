FUNCTION find_full_nexus_name, Event, run_number, isNexusExist

cmd = "findnexus -iBSS "
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"error*",/FOLD_CASE)
    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
    return, full_nexus_name
endif else begin
    if (full_nexus_name EQ '') then begin
        isNeXusExist = 0
        return, full_nexus_name
    endif else begin
        isNeXusExist = 1
        return, full_nexus_name[0]
    endelse
endelse

end
