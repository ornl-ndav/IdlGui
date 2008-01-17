;Returns the Run Number from the INPUT base
FUNCTION getEventRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END


;Returns the contain of the Event file widget_text (in INPUT base)
FUNCTION getEventFile, Event
id = widget_info(Event.top,find_by_uname='event_file')
widget_control, id, get_value=event_file
RETURN, event_file
END


;Returns the full path up to the prenexus folder
;example: /ARCS-DAS-FS/2007_1_18_SCI/ARCS_16/
FUNCTION getRunPath, Event, RunNumber, runFullPath
IF (!VERSION.os EQ 'darwin') THEN BEGIN
;get global structure
    id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
    widget_control,id,get_uvalue=global
    runFullPath = (*global).mac_arcs_folder
    RETURN, 1
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        catch,/cancel
        RETURN, 0
    ENDIF ELSE BEGIN
        spawn, 'findnexus -iARCS --prenexus ' + RunNumber, listening
        IF (strmatch(listening[0],'*ERROR*')) THEN BEGIN
            RETURN, 0
        ENDIF ELSE BEGIN
            runFullPath = listening[0]
            RETURN, 1
        ENDELSE
    ENDELSE
ENDELSE
END
