PRO gg_Preview, Event, type

CASE type OF 
    'geometry': BEGIN
        full_file_name = getGeometryFileName(Event)
        title = 'geometry.xml file: ' + full_file_name
    END
    'cvinfo': BEGIN
        full_file_name = getCvinfoFileName(Event)
        title = 'cvinfo.xml file: ' + full_file_name
    END
    ELSE: BEGIN
        full_file_name = ''
    END
ENDCASE

IF (full_file_name NE '') THEN BEGIN
    XDISPLAYFILE, full_file_name, title = title
ENDIF

END
    
