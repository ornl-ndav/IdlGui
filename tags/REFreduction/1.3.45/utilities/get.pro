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

;**********************************************************************
;GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL
;**********************************************************************

;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable_ref_m, var
  CASE (var) OF
    ;number of columns in the Table (active/data/norm/s1/s2...)
    'ColumnIndexes' : RETURN, 8
    'NbrColumn'     : RETURN, 9
    'RowIndexes'    : RETURN, 19
    'NbrRow'        : RETURN, 20
    'BatchFileHeadingLines' : RETURN, 3
    ELSE:
  ENDCASE
  RETURN, 'NA'
END





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

;------------------------------------------------------------------------------
;+
; :Description:
;   This function returns the number of spin states selected
;
; :Params:
;    event
;
; :Author: j35
;-
function get_nbr_spin_states, event

  widget_control, event.top, get_uvalue=global
  spin_state_config = (*global).spin_state_config
  nbr_spin = total(spin_state_config)
  return, nbr_spin
  
end


;+
; :Description:
;   This routine returns the current row selected in the batch table
;
; :Params:
;    Event
;
; :Author: j35
;-
FUNCTION getCurrentRowSelected, Event
  id = Widget_Info(Event.top,find_by_uname='batch_table_widget')
  SelectedCell = widget_Info(id,/table_select)
  RowSelected  = SelectedCell[1]
  RETURN, RowSelected
END

;+
; :Description:
;   returns the run number for REF_L and REF_M instruments
;
; :Params:
;    nexus_full_path
;
; :Keywords:
;    instrument
;
; :Author: j35
;-
function get_ref_run_number, nexus_full_path, instrument=instrument
  compile_opt idl2
  
  error_file = 0
  CATCH, error_file
  IF (error_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ''
  ENDIF ELSE BEGIN
    fileID = h5f_open(nexus_full_path)
  ENDELSE
  
  if (instrument eq 'REF_M') then begin
    run_number_path = '/entry-Off_Off/run_number/'
  endif else begin
    run_number_path = '/entry/run_number/'
  endelse
  
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    h5f_close, fileID
    RETURN, ''
  ENDIF ELSE BEGIN
    pathID     = h5d_open(fileID, run_number_path)
    run_number = h5d_read(pathID)
    h5d_close, pathID
    RETURN, run_number
  endelse
  
end

;------------------------------------------------------------------------------
;This function retrives the first run number of the top row input
function GetMajorRunNumber_ref_m, Event

  widget_control,event.top,get_uvalue=global
  
  BatchTable = (*(*global).BatchTable_ref_m)
  MajorRuns = BatchTable[1,0]
  MajorRunsArray = strsplit(MajorRuns,',',/extract)
  MajorRun = MajorRunsArray[0]
  RETURN, MajorRun
END

;+
; :Description:
;   returns the string between two arguments
;
; :Params:
;    base_string
;    arg1
;    arg2

; :Author: j35
;-
function get_value_between_arg1_arg2, base_string, arg1, arg2
  compile_opt idl2
  
  Split1 = strsplit(base_string[0],arg1,/EXTRACT,/REGEX,COUNT=length)
  if (length GT 1) then begin
  
    Split2 = strsplit(Split1[1],arg2,/EXTRACT,/REGEX)
    return, Split2[0]
  endif else begin
    return, ''
  endelse
end


;+
; :Description:
;   this function returns the cvinfo file using the data run number
;   and findnexus with --prenexus flag to get the cvinfo file
;
; :Params:
;    event

; :Author: j35
;-
function getcvinfo_file, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  data_run_number = getTextFieldValue(event,$
    'load_data_run_number_text_field')
  instrument = (*global).instrument
  
  cmd = 'findnexus --prenexus -i ' + instrument + ' ' + data_run_number
  spawn, cmd, listening
  
  cvinfo_name = '/' + instrument + '_' + data_run_number
  cvinfo_name += '_cvinfo.xml'
  
  return, listening[0] + cvinfo_name
  
end


function getgeometry_file, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  instrument = (*global).instrument
  
  cmd = 'findcalib -g -i ' + instrument
  spawn, cmd, listening
  return, listening[0]
  
end