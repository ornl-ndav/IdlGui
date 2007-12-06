;this function returns 1 if the prenexus exist and 0 if 
;it does not exist
FUNCTION isPreNexusExist, Event, RunNumber, Instrument
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
cmd = 'findnexus --prenexus -i' + Instrument
cmd += ' ' + RunNumber
spawn, cmd, listening
(*global).prenexus_path = listening[0]
result = STRMATCH(listening[0],'ERROR*')
RETURN, ~result
END
