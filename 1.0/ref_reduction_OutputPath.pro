PRO REFreduction_DefineOutputPath, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path = DIALOG_PICKFILE(/DIRECTORY,$
                       PATH = (*global).dr_output_path,$
                       TITLE = 'Select a folder',$
                       /MUST_EXIST)
miniVersionLength = 10
maxiVersionLength = 40
IF (path NE '') THEN BEGIN
    (*global).dr_output_path = path
    length = strlen(path)
    IF ((*global).miniVersion EQ 1) THEN BEGIN
        IF (length GT miniVersionLength) THEN BEGIN
            path = '[...]' + strmid(path,length-miniVersionLength,miniVersionLength)
        ENDIF
    ENDIF ELSE BEGIN
        IF (length GT maxiVersionLength) THEN BEGIN
            path = '[...]' + strmid(path,length-maxiVersionLength,maxiVersionLength)
        ENDIF
    ENDELSE
;replace title of button
    SetButtonValue, Event, 'of_button', path
ENDIF
END


PRO DefineDefaultOutputName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;force name of output file according to time stamp
IsoTimeStamp = RefReduction_GenerateIsoTimeStamp()
(*global).IsoTimeStamp = IsoTimeStamp
NewOutputFileName = (*global).instrument
NewOutputFileName += '_' + (*global).DataRunNumber
NewOutputFileName += '_' + strcompress(IsoTimeStamp,/remove_all)
(*global).OutputFileName = NewOutputFileName
ExtOfAllPlots = (*(*global).ExtOfAllPlots)
NewOutputFileName += ExtOfAllPlots[0]
putTextFieldValue, event, 'of_text', NewOutputFileName, 0
END


PRO REFreduciton_DefineOutputFile, Event 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
NewOutputFileName = getOutputFileName(Event)
;remove .txt if any
StringArray = strsplit(NewOutputFileName,'.',/extract)
newOutputFileName = StringArray[0]
(*global).OutputFileName = NewOutputFileName
END
