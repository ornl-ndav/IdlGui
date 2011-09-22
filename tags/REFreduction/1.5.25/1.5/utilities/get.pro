;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    Return the index of the tab currently selected
;
;
;
; :Keywords:
;    event
;    uname
;
; :Author: j35
;-
function getTabValue, event=event, uname=uname
    id = widget_info(event.top, find_by_uname=uname)
  return, widget_info(id, /tab_current)
end

;+
; :Description:
;    This function returns the data value from the device value
;
;
;
; :Keywords:
;    event
;    type
;    device_value
;
; :Author: j35
;-
function getYDataFromDevice, event=event, type=type, device_value=device_value
  compile_opt idl2
  
  if (type eq 'data') then begin
    uname = 'load_data_D_draw'
  endif else begin
    uname = 'load_normalization_D_draw'
  endelse
  
  id = widget_info(event.top, find_by_uname=uname)
  geometry = widget_info(id,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  
  YdataMax = 256.
  
  return, fix((YdataMax * float(device_value)) / float(ysize))
  
end

;+
; :Description:
;    This function returns the device value from the data value
;
;
;
; :Keywords:
;    event
;    type
;    data_value
;
; :Author: j35
;-
function getYDeviceFromData, event=event, type=type, data_value=data_value
  compile_opt idl2
  
  if (type eq 'data') then begin
    uname = 'load_data_D_draw'
  endif else begin
    uname = 'load_normalization_D_draw'
  endelse
  
  id = widget_info(event.top, find_by_uname=uname)
  geometry = widget_info(id,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  
  YdataMax = 256.
  
  return, fix((float(data_value) * float(ysize))/ YdataMax)+1
  
end

;+
; :Description:
;    This return the value of the specified (by uname) widget
;
; :Keywords:
;    event
;    base
;    uname
;
; :Author: j35
;-
function getValue, event=event, base=base, uname=uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  widget_control, id, get_value=value
  return, value[0]
end

;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
  TextFieldID = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, TextFieldID, get_value = TextFieldValue
  RETURN, TextFieldValue
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
;This function returns the contain of the Main Log Book text field
FUNCTION getLogBookText, Event
  RETURN, getTextFieldValue(Event,'log_book_text_field')
END

;------------------------------------------------------------------------------
;This function returns the contain of the Data Log Book text field
FUNCTION getDataLogBookText, Event
  RETURN, getTextFieldValue(Event, 'data_log_book_text_field')
END

;------------------------------------------------------------------------------
;This function returns the contain of the Normalization Log Book text field
FUNCTION getNormalizationLogBookText, Event
  RETURN, getTextFieldValue(Event, 'normalization_log_book_text_field')
END

;------------------------------------------------------------------------------
FUNCTION getOutputPathFromButton, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='of_button')
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getXmlFileName, FullOutputFileName
  file_name_base = STRSPLIT(FullOutputFileName,'.txt',/EXTRACT)
  xml_file_name  = file_name_base[0] + '.rmd'
  RETURN, STRING(xml_file_name[0])
END

;------------------------------------------------------------------------------
FUNCTION getOutputFileName, Event
  id = WIDGET_INFO(Event.top,find_by_uname='of_text')
  WIDGET_CONTROL, id, get_value=value
  RETURN, STRING(value)
END

;------------------------------------------------------------------------------
;This function returns the result of cw_bgroup
FUNCTION getCWBgroupValue, Event, uname
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, get_value=value
  RETURN, value
END

;------------------------------------------------------------------------------
;This function returns the Reduction Q scale desired (lin or log)
FUNCTION getQScale, Event
  id = WIDGET_INFO(Event.top,find_by_uname='q_scale_b_group')
  WIDGET_CONTROL, id, get_value=value
  if (value EQ 0) then begin
    RETURN, 'lin'
  endif else begin
    RETURN, 'log'
  endelse
END

;------------------------------------------------------------------------------
;This function gives the Detector angle units (degrees or radians)
FUNCTION getDetectorAngleUnits, Event
  id = WIDGET_INFO(Event.top,find_by_uname='detector_units_b_group')
  WIDGET_CONTROL, id, get_value=value
  if (value EQ 0) then begin
    RETURN, 'degrees'
  endif else begin
    RETURN, 'radians'
  endelse
END

;------------------------------------------------------------------------------
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  RETURN, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getDropListSelectedValue, Event, uname
  index_selected = getDropListSelectedIndex(Event,uname)
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, get_value=list
  RETURN, list[index_selected]
END

;------------------------------------------------------------------------------
;This function returns the full path name of all the file to plot
FUNCTION getListOfFilestoPlot, Event, $
    IntermPlots, $
    ExtOfAllPlots, $
    IsoTimeStamp, $
    instrument, $
    run_number
    
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  FilesToPlotList = STRARR(1)
  
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
  sz=SIZE(IntermPlots)
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
  file_name = STRSPLIT(file,part_to_remove,/extract,/regex,count=length)
  file_name_only = file_name[length-1]
  RETURN, file_name_only
END

;------------------------------------------------------------------------------
FUNCTION getDataZoomFactor, Event
  id=WIDGET_INFO(Event.top,find_by_uname='data_zoom_scale_cwfield')
  WIDGET_CONTROL, id, get_value=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getNormZoomFactor, Event
  id=WIDGET_INFO(Event.top,find_by_uname='normalization_zoom_scale_cwfield')
  WIDGET_CONTROL, id, get_value=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getSliderValue, Event, uname
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, get_value=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getUDCoefficienT, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  IF ((*global).miniVersion EQ 1) THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 2
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getNbrLines, FileName
  cmd = 'wc -l ' + FileName
  SPAWN, cmd, result
  Split = STRSPLIT(result[0],' ',/extract)
  RETURN, Split[0]
END

;------------------------------------------------------------------------------
FUNCTION getNexusFromRunArray, Event, $
    data_runs, $
    instrument, $
    SOURCE_FILE=source_file
    
  NexusArray = ['']
  NewDataRun = ['']
  split1 = STRSPLIT(data_runs,',',/EXTRACT,COUNT=length)
  FOR i=0,(length-1) DO BEGIN
    isNexusExist = 0
    
    FullNexusName = find_full_nexus_name(Event, $
      split1[i], $
      instrument, $
      isNexusExist, $
      SOURCE_FILE=SOURCE_FILE)
    IF (isNexusExist) THEN BEGIN
      NexusArray = [NexusArray,FullNexusName]
      NewDataRun = [NewDataRun,split1[i]]
    ENDIF
  ENDFOR
  sz        = (SIZE(NexusArray))(1)
  data_runs = NewDataRun[1:(sz-1)]
  IF (sz GT 1) THEN RETURN, NexusArray[1:(sz-1)]
  RETURN, [-1]
END

;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
;This function gives the runs from the list of full nexus file names
FUNCTION get_runs_from_NeXus_full_path, list_OF_nexus_file_name, type
  IF (type EQ 'data') THEN BEGIN
    split_type = ' '
  ENDIF ELSE BEGIN
    split_type = ','
  ENDELSE
  step1      = STRSPLIT(list_OF_nexus_file_name,split_type,/EXTRACT,COUNT=length)
  ListOfRuns = STRARR(length)
  FOR i=0,(length-1) DO BEGIN
    iRunNumber = OBJ_NEW('IDLgetMetadata',step1[i])
    IF (OBJ_VALID(iRunNumber)) THEN BEGIN
      ListOfRuns[i] = STRCOMPRESS(iRunNumber->getRunNumber(),/REMOVE_ALL)
    ENDIF ELSE BEGIN
      ListOfRuns[i] = STRCOMPRESS(step1[i],/REMOVE_ALL)
    ENDELSE
  ENDFOR
  RETURN, ListOfRuns
END

;------------------------------------------------------------------------------
FUNCTION getPolarizationStateValueSelected, Event
  id_arrays = ['pola_state1_uname',$
    'pola_state2_uname',$
    'pola_state3_uname',$
    'pola_state4_uname']
  sz = N_ELEMENTS(id_arrays)
  FOR i=0,(sz-1) DO BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=id_arrays[i])
    value = WIDGET_INFO(id,/BUTTON_SET)
    IF (value EQ 1) THEN RETURN, i
  ENDFOR
  RETURN, 0
END

;-----------------------------------------------------------------------------
FUNCTION get_cvinfo, Event, INSTRUMENT=instrument, RUN_NUMBER = run_number

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  run_number = STRCOMPRESS(run_number,/remove_all)
  cmd = 'findnexus --prenexus -i ' + instrument + ' ' + run_number
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
  ENDIF ELSE BEGIN
    SPAWN, cmd, listening
    file_path = listening[0]
    cv_info = file_path + '/' + instrument + '_' + run_number
    cv_info += '_cvinfo.xml'
    RETURN, cv_info
  ENDELSE
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION isButtonSelected, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  result = WIDGET_INFO(id, /BUTTON_SET)
  RETURN, result
END

FUNCTION getPlotTabYaxisScale, Event
  ;linear
  uname = 'plot_tab_y_axis_lin'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'lin'
  ;log
  uname = 'plot_tab_y_axis_log'
  IF (isButtonSelected(Event,uname)) THEN RETURN, 'log'
  RETURN, ''
END









