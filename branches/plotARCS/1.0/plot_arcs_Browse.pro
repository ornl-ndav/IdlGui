FUNCTION BrowseRunNumber, Event, $
                     default_extension, $
                     filter,$
                     title,$
                     path

full_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                 FILTER            = filter,$
                                 TITLE             = title,$
                                 PATH              = path,$
                                 /MUST_EXIST)
RETURN, full_file_name
END






PRO BrowseEventRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_extension = (*global).default_extension
filter            = (*global).event_filter
title             = 'Select an Event File ... '

event_full_file_name = BrowseRunNumber(Event, $
                                       default_extension, $
                                       filter, $
                                       title, $
                                       path)

IF (event_full_file_name NE '') THEN BEGIN
;put file name in widget_text
    putTextInTextField, Event, 'event_file', event_full_file_name
    message = 'User browsed for event file: ' + event_full_file_name
    appendLogBook, Event, message
ENDIF
END


PRO BrowseHistoFile, Event  
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_extension = (*global).default_extension
filter            = (*global).histo_map_filter
title             = 'Select an Histogram Mapped File ... '

histo_full_file_name = BrowseRunNumber(Event, $
                                       default_extension, $
                                       filter, $
                                       title, $
                                       path)

IF (histo_full_file_name NE '') THEN BEGIN
;put file name in widget_text
    putTextInTextField, Event, 'histo_mapped_text_field', histo_full_file_name
    message = 'User browsed for histo. mapped file: ' + histo_full_file_name
    appendLogBook, Event, message
ENDIF
END
