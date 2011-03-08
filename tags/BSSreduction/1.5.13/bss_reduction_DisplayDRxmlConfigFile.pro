PRO BSSreduction_DisplayXmlConfigFile, Event, xmlFile

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

no_file = 0
catch, no_file

IF (no_file NE 0) THEN BEGIN

    catch,/cancel
    plot_file_found = 0    

ENDIF ELSE BEGIN

    openr,u,xmlFile,/get

;define an empty string variable to hold results from reading the file
    tmp = ''
    info_array = strarr(1)
    info_array[0] = '###### ' + xmlFile + ' ######'
    WHILE (NOT eof(u)) DO BEGIN
        readf,u,tmp
        info_array = [info_array,tmp]
    ENDWHILE
    close,u
    free_lun,u

    sz = (size(info_array))(1)

;put the metadata in the text field of the Plots tab
    putTextFieldArray, Event, 'xml_text', info_array, sz, 0    

ENDELSE

END

