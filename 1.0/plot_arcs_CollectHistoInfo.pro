PRO getHistogramInfo, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

runinfoFileName = (*global).runinfoFileName
;look for info if file exist and end with .xml
result = strmatch(runinfoFileName,'*_runinfo.xml')
IF (result EQ 1 AND $
    FILE_TEST(runinfoFileName) EQ 1) THEN BEGIN
    min_time_bin = getBinOffsetFromDas(Event, runinfoFileName)
    putTextInTextField, Event, 'min_time_bin', strcompress(min_time_bin,/remove_all)
    max_time_bin = getBinMaxSetFromDas(Event, runinfoFileName)
    putTextInTextField, Event, 'max_time_bin', strcompress(max_time_bin,/remove_all)
;    bin_width    = getBinWidthSetFromDas(Event, runinfoFileName)
    bin_width = (*global).bin_width
    putTextInTextField, Event, 'bin_width', strcompress(bin_width,/remove_all)
    bin_type     = getBinTypeFromDas(Event, runinfoFileName)
    IF (bin_type EQ 'linear') THEN BEGIN
        setHistogrammingTypeValue, Event, 0
    ENDIF ELSE BEGIN
        setHistogrammingTypeValue, Event, 1
    ENDELSE
ENDIF
END
