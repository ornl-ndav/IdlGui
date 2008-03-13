PRO MapBase, Event, uname, MapStatus
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, MAP=MapStatus
END

;-------------------------------------------------------------------------------
PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END

;*******************************************************************************
;*******************************************************************************
PRO ValidatePlotButton, Event
;check first that the file exist
RoiFileName   = getRoiFileName(Event)
NexusFileName = getFullNexusFileName(Event)
IF (FILE_TEST(RoiFileName) AND FILE_TEST(NexusFileName)) THEN BEGIN
                                ;is Full Nexus Name not empty
    IF (isFullNexusNameEmpty(Event) EQ 1 OR $
        isRoiFileNameEmpty(Event) EQ 1) THEN BEGIN
        validateStatus = 0
    ENDIF ELSE BEGIN
        validateStatus = 1
    ENDELSE
ENDIF ELSE BEGIN
    validateStatus = 0
ENDELSE
ActivateWidget, Event, 'plot_button', validateStatus
END



