;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


;This function returns the contain of the Main Log Book text field
FUNCTION getLogBookText, Event
return, getTextFieldValue(Event,'log_book_text_field')
END


;This function returns the contain of the Data Log Book text field
FUNCTION getDataLogBookText, Event
return, getTextFieldValue(Event, 'data_log_book_text_field')
END


;This function returns the contain of the Normalization Log Book text field
FUNCTION getNormalizationLogBookText, Event
return, getTextFieldValue(Event, 'normalization_log_book_text_field')
END


FUNCTION getOutputPathFromButton, Event
id = widget_info(Event.top,find_by_uname='of_button')
widget_control, id, get_value=value
RETURN, value
END

FUNCTION getOutputFileName, Event
id = widget_info(Event.top,find_by_uname='of_text')
widget_control, id, get_value=value
RETURN, value
END


;This function returns the result of cw_bgroup
FUNCTION getCWBgroupValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
return, value
END


;This function returns the Reduction Q scale desired (lin or log)
FUNCTION getQScale, Event
id = widget_info(Event.top,find_by_uname='q_scale_b_group')
widget_control, id, get_value=value
if (value EQ 0) then begin
    return, 'lin'
endif else begin
    return, 'log'
endelse
END


;This function gives the Detector angle units (degrees or radians)
FUNCTION getDetectorAngleUnits, Event
id = widget_info(Event.top,find_by_uname='detector_units_b_group')
widget_control, id, get_value=value
if (value EQ 0) then begin
    return, 'degrees'
endif else begin
    return, 'radians'
endelse
END


;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
return, widget_info(id, /droplist_select)
END


;This function gives the value of the index selected
FUNCTION getDropListSelectedValue, Event, uname
index_selected = getDropListSelectedIndex(Event,uname)
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=list
return, list[index_selected]
END

;-------------------------------------------------------------------------------

;This function returns the full path name of all the file to plot
FUNCTION getListOfFilestoPlot, Event, $
                               IntermPlots, $
                               ExtOfAllPlots, $
                               IsoTimeStamp, $
                               instrument, $
                               run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

FilesToPlotList = strarr(1)

;base name    ex: REF_L_3000
;path      = (*global).dr_output_path
;print, 'path: ' + path ;REMOVE_ME
;file_name = (*global).OutputFileName
;print, 'file_name: ' + file_name ;REMOVE_ME
;base_name = path + file_name

TxtFileName   = getOutputFileName(Event)
TxtFilePath   = getOutputPathFromButton(Event)
BaseNameArray = STRSPLIT(TxtFileName,'.txt',/extract)
BaseName      = BaseNameArray[0]
FullBaseName  = TxtFilePath + BaseName

;main data reduction plot (.txt)
MainFile = FullBaseName + ExtOfAllPlots[0]
FilesToPlotList[0] = MainFile

;xml file (.rdc)
XmlFile = FullBaseName + ExtOfAllPlots[1]
FilesToPlotList = [FilesToPlotList,XmlFile]

;other intermediate files
sz=size(IntermPlots)
Nbr = sz[1]
FOR i=0,(Nbr-1) DO BEGIN
    IF (IntermPlots[i] EQ 1) THEN BEGIN
        FileName = FullBaseName + ExtOfAllPlots[i+1]
        FilesToPlotList = [FilesToPlotList,FileName]
    ENDIF
ENDFOR

RETURN, FilesToPlotList
END

;------------------------------------------------------------------------------

;this function returns only the file name (whitout the path)
FUNCTION getFileNameOnly, file
part_to_remove="/"
file_name = strsplit(file,part_to_remove,/extract,/regex,count=length) 
file_name_only = file_name[length-1]
return, file_name_only
END



FUNCTION getDataZoomFactor, Event
id=widget_info(Event.top,find_by_uname='data_zoom_scale_cwfield')
widget_control, id, get_value=value
return, value
END



FUNCTION getNormZoomFactor, Event
id=widget_info(Event.top,find_by_uname='normalization_zoom_scale_cwfield')
widget_control, id, get_value=value
return, value
END


FUNCTION getSliderValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
return, value
END


FUNCTION getUDCoefficienT, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
IF ((*global).miniVersion EQ 1) THEN BEGIN
    RETURN, 1
ENDIF ELSE BEGIN
    RETURN, 2
ENDELSE
END


FUNCTION getNbrLines, FileName
cmd = 'wc -l ' + FileName
spawn, cmd, result
Split = strsplit(result[0],' ',/extract)
RETURN, Split[0]
END


FUNCTION getNexusFromRunArray, Event, data_runs, instrument
NexusArray = ['']
NewDataRun = ['']
split1 = strsplit(data_runs,',',/EXTRACT,COUNT=length)
FOR i=0,(length-1) DO BEGIN
    isNexusExist = 0
    FullNexusName = find_full_nexus_name(Event, $
                                         split1[i], $
                                         instrument, $
                                         isNexusExist)
    IF (isNexusExist) THEN BEGIN
        NexusArray = [NexusArray,FullNexusName]
        NewDataRun = [NewDataRun,split1[i]]
    ENDIF
ENDFOR
sz        = (size(NexusArray))(1)
data_runs = NewDataRun[1:(sz-1)]
IF (sz GT 1) THEN RETURN, NexusArray[1:(sz-1)]
RETURN, [-1]
END



FUNCTION getFilePathAndName, FullFileName
FullArray = STRSPLIT(FullFileName,'/',/EXTRACT,COUNT=length)
IF (length GT 2) THEN BEGIN
    PathArray = FullArray[0:length-2]
    Path      = STRJOIN(PathArray,'/')
ENDIF ELSE BEGIN
    Path      = FullArray[0]
ENDELSE
File = FullArray[length-1]
RETURN, ['/' + Path + '/', File]
END
