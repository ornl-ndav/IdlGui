;####### GENERIC FUNCTIONS #######
FUNCTION isSwitchSelected, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END


;###### PARTICULAR FUNCTIONS #########
;this function returns 1 if the prenexus exist and 0 if 
;it does not exist
FUNCTION isPreNexusExistOnDas, Event, RunNumber, Instrument
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    (*global).prenexus_path = (*global).mac.prenexus_path
    return, 1
ENDIF eLSE BEGIN
    defaultPath = instrument + '-DAS-FS'
    cmd = 'findnexus --prenexus --listall --prefix=' $
      + defaultPath + ' -i' + Instrument
    cmd += ' ' + RunNumber
    spawn, cmd, listening
    sz = (size(listening))(1)
    FOR i=0,(sz-1) DO BEGIN
        prenexus_path = listening[i]
        text_to_compare = '/' + instrument + '-DAS-FS/*'
        isOnDas = strmatch(prenexus_path,text_to_compare)
        IF (isOnDas) THEN BEGIN
            (*global).prenexus_path = prenexus_path
            RETURN, 1
        ENDIF
    ENDFOR
    RETURN,0
ENDELSE
;(*global).prenexus_path = listening[0]
;result = STRMATCH(listening[0],'ERROR*')
;RETURN, ~result
END

;Returns 1 if the 'Instrument Shared Folder' has been
;selected
FUNCTION isInstrSharedFolderSelected, Event
valueArray = isSwitchSelected(Event,'shared_button')
RETURN, valueArray[0]
END

;Returns 1 if the 'Proposal Shared Folder' has been
;selected
FUNCTION isProposalSharedFolderSelected, Event
valueArray = isSwitchSelected(Event,'shared_button')
RETURN, valueArray[1]
END
