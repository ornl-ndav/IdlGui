PRO REFreduction_DefineOutputPath, Event
path = DIALOG_PICKFILE(/DIRECTORY,$
                       TITLE = 'Select a folder',$
                       /MUST_EXIST)
IF (path NE '') THEN BEGIN
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
NewOutputFileName += '_' + strcompress((*global).data_run_number,/remove_all)
NewOutputFileName += '_' + strcompress(IsoTimeStamp,/remove_all)
(*global).OutputFileName = NewOutputFileName
ExtOfAllPlots = (*(*global).ExtOfAllPlots)
NewOutputFileName += ExtOfAllPlots[0]
putTextFieldValue, event, 'of_text', NewOutputFileName, 0
END
