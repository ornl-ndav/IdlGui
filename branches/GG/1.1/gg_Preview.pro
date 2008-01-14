PRO gg_previewUpdateGeoXmlTextField, Event 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
file_name = (*global).new_geo_xml_filename
putInTextField, Event, 'geometry_text_field', file_name
END





PRO gg_Preview, Event, type
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
CASE type OF 
    'geometry': BEGIN
        full_file_name = getGeometryFileName(Event)
        title = full_file_name
        IF (full_file_name NE '') THEN BEGIN
            XDISPLAYFILE, Event, $
              full_file_name, $
              TITLE = title, $
              MODAL = 1,$
              /EDITABLE
        ENDIF
    END
    'cvinfo': BEGIN
        full_file_name = getCvinfoFileName(Event)
        title = full_file_name
        IF (full_file_name NE '') THEN BEGIN
            XDISPLAYFILE, Event, $
              full_file_name, $
              TITLE = title
        ENDIF
    END
    ELSE: 
ENDCASE
END
    



