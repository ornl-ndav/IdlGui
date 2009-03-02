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

;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
  TextFieldID = widget_info(Event.top,find_by_uname=uname)
  widget_control, TextFieldID, get_value = TextFieldValue
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
  return, getTextFieldValue(Event,'log_book_text_field')
END

;------------------------------------------------------------------------------
;This function returns the contain of the Data Log Book text field
FUNCTION getDataLogBookText, Event
  return, getTextFieldValue(Event, 'data_log_book_text_field')
END

;------------------------------------------------------------------------------
;This function returns the contain of the Normalization Log Book text field
FUNCTION getNormalizationLogBookText, Event
  return, getTextFieldValue(Event, 'normalization_log_book_text_field')
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
  id = widget_info(Event.top,find_by_uname='of_text')
  widget_control, id, get_value=value
  RETURN, STRING(value)
END

;------------------------------------------------------------------------------
;This function returns the result of cw_bgroup
FUNCTION getCWBgroupValue, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=value
  return, value
END

;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
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
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=list
  return, list[index_selected]
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

;------------------------------------------------------------------------------
FUNCTION getDataZoomFactor, Event
  id=widget_info(Event.top,find_by_uname='data_zoom_scale_cwfield')
  widget_control, id, get_value=value
  return, value
END

;------------------------------------------------------------------------------
FUNCTION getNormZoomFactor, Event
  id=widget_info(Event.top,find_by_uname='normalization_zoom_scale_cwfield')
  widget_control, id, get_value=value
  return, value
END

;------------------------------------------------------------------------------
FUNCTION getSliderValue, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=value
  return, value
END

;------------------------------------------------------------------------------
FUNCTION getUDCoefficienT, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  IF ((*global).miniVersion EQ 1) THEN BEGIN
    RETURN, 1
  ENDIF ELSE BEGIN
    RETURN, 2
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getNbrLines, FileName
  cmd = 'wc -l ' + FileName
  spawn, cmd, result
  Split = strsplit(result[0],' ',/extract)
  RETURN, Split[0]
END

;------------------------------------------------------------------------------
FUNCTION getNexusFromRunArray, Event, $
    data_runs, $
    instrument, $
    SOURCE_FILE=source_file
 
  NexusArray = ['']
  NewDataRun = ['']
  split1 = strsplit(data_runs,',',/EXTRACT,COUNT=length)
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
  sz        = (size(NexusArray))(1)
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
