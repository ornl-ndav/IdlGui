FUNCTION find_full_nexus_name, Event, run_number, instrument, isNexusExist

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
