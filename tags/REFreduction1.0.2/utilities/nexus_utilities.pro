FUNCTION find_full_nexus_name, Event, run_number, instrument, isNexusExist

cmd = "findnexus -i" + instrument 
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
result = strmatch(full_nexus_name,"ERROR*")
if (result GE 1) then begin
    isNeXusExist = 0
endif else begin
    isNeXusExist = 1
endelse

return, full_nexus_name
end




FUNCTION find_list_nexus_name, Event, run_number, instrument, isNexusExist

cmd = "findnexus -i" + instrument 
cmd += " " + strcompress(run_number,/remove_all)
cmd += " --listall"
spawn, cmd, full_nexus_name, err_listening

;get size of result
sz = (size(full_nexus_name))(1)

;check if nexus exists
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")

    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
endif else begin
    isNeXusExist = 1
endelse

return, full_nexus_name
end

