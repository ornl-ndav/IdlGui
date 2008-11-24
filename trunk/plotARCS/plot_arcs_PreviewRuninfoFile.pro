PRO PreviewRuninfoFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

runinfoFileName = (*global).runinfoFileName

IF (runinfoFileName NE '') THEN BEGIN
    XDISPLAYFILE, runinfoFileName
ENDIF

END
