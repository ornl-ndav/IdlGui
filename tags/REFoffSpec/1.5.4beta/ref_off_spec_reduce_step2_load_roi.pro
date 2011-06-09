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

FUNCTION ParseBackgroundFileString, Event, StringText
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  result_array = strsplit(StringText,'_',/extract)
  IF ((*global).instrument EQ 'REF_L') THEN BEGIN
    Y = result_array[2]
  ENDIF ELSE BEGIN
    Y = result_array[1]
  ENDELSE
  RETURN, Y
END

;------------------------------------------------------------------------------
FUNCTION retrieveYMinMaxFromFile, Event, FileName
  ;to get the first line of the file
  cmd = 'head ' + FileName + ' -n 1'
  SPAWN, cmd, first_line
  ;to get the last line of the file
  cmd = 'tail ' + FileName + ' -n 1'
  SPAWN, cmd, last_line
  
  Ymin = ParseBackgroundFileString(Event, first_line)
  Ymax = ParseBackgroundFileString(Event, last_line)
  
  RETURN, [Ymin,Ymax]
END

;- Browse Selection File ------------------------------------------------------
PRO browse_reduce_step2_roi_file, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  extension  = 'dat'
  filter     = ['*_ROI.dat','*_ROI.txt']
  ; Change code (RC Ward, 24 July 2010): ROI files will always be loacted with reduction step files
  ; that is the path ias ascii_path
  ;  path       = (*global).roi_path
  path = (*global).ascii_path
  title      = 'Browsing for a ROI file'
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    TITLE             = title,$
    dialog_parent     = id, $
    /READ,$
    /MUST_EXIST)
    
  IF (file_name NE '') THEN BEGIN
  
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/hourglass
    
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      widget_control, hourglass=0
      LogText = '> Loading peak ROI ' + file_name + ' FAILED!'
      IDLsendToGeek_addLogBookText, Event, LogText
      
      message_text = 'Problem loading ROI file name: ' + file_name
      id = widget_info(event.top, find_by_uname='MAIN_BASE')
      result = dialog_message(message_text,$
        /center, $
        dialog_parent=id,$
        /ERROR, $
        title = 'Problem loading peak ROI!')
      return
    endif
    
    (*global).roi_path = new_path
    ; Change code (RC Ward, 17 July 2010): See if this updates the location of output files
    (*global).ascii_path = new_path
    
    ;    ;Load ROI button (Load, extract and plot)
    ;    load_roi_selection, Event, file_name
    
    Yarray = retrieveYminMaxFromFile(event,file_name)
    Y1 = Yarray[0]
    Y2 = Yarray[1]
    putTextFieldValue, Event, 'reduce_step2_create_roi_y1_value', $
      STRCOMPRESS(Y1,/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_step2_create_roi_y2_value', $
      STRCOMPRESS(Y2,/REMOVE_ALL)
      
    plot_reduce_step2_norm, Event ;refresh plot
    ;    (*global).norm_roi_y_selected = 'all'
    
    reduce_step2_plot_rois, event
    ;reduce_step2_manual_move, Event
    
    putTextFieldValue, Event, $
      'reduce_step2_create_roi_file_name_label',$
      file_name
      
    nexus_spin_state_roi_table = (*(*global).nexus_spin_state_roi_table)
    data_spin_state = (*global).tmp_reduce_step2_data_spin_state
    row = (*global).tmp_reduce_step2_row
    column = getReduceStep2SpinStateColumn(Event, row=row,$
      data_spin_state=data_spin_state)
      
    ;get Norm file selected
    norm_table = (*global).reduce_step2_big_table_norm_index
    nexus_spin_state_roi_table[column,norm_table[row]] = file_name
    (*(*global).nexus_spin_state_roi_table) = nexus_spin_state_roi_table
    
    ;turn off hourglass
    WIDGET_CONTROL,hourglass=0
    
  ENDIF ELSE BEGIN
  ;    IDLsendToGeek_addLogBookText, Event, '-> Operation CANCELED'
  ENDELSE
  
END

;+
; :Description:
;    Browse for a background roi file in the reduce/tab2
;
; :Params:
;    Event
;
;
;
; :Author: j35
;-
PRO browse_reduce_step2_back_roi_file, Event
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  extension  = 'dat'
  filter     = ['*_back_ROI.dat','*_back_ROI.txt']
  ; Change code (RC Ward, 24 July 2010): ROI files will always be loacted with reduction step files
  ; that is the path ias ascii_path
  ;  path       = (*global).roi_path
  path = (*global).ascii_path
  title      = 'Browsing for a background ROI file'
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    TITLE             = title,$
    dialog_parent     = id, $
    /READ,$
    /MUST_EXIST)
    
  IF (file_name NE '') THEN BEGIN
  
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/hourglass
    
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      widget_control, hourglass=0
      LogText = '> Loading Back. ROI ' + file_name + ' FAILED!'
      IDLsendToGeek_addLogBookText, Event, LogText
      
      message_text = 'Problem loading Back. ROI file name: ' + file_name
      id = widget_info(event.top, find_by_uname='MAIN_BASE')
      result = dialog_message(message_text,$
        /center, $
        dialog_parent=id,$
        /ERROR, $
        title = 'Problem loading back ROI!')
        
      return
    endif
    
    (*global).roi_path = new_path
    ; Change code (RC Ward, 17 July 2010): See if this updates the location of output files
    (*global).ascii_path = new_path
    
    ;    ;Load ROI button (Load, extract and plot)
    ;    load_roi_selection, Event, file_name
    
    Yarray = retrieveYminMaxFromFile(event,file_name)
    Y1 = Yarray[0]
    Y2 = Yarray[1]
    putTextFieldValue, Event, 'reduce_step2_create_back_roi_y1_value', $
      STRCOMPRESS(Y1,/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_step2_create_back_roi_y2_value', $
      STRCOMPRESS(Y2,/REMOVE_ALL)
      
    plot_reduce_step2_norm, Event ;refresh plot
    reduce_step2_plot_rois, event
    
    putTextFieldValue, Event, $
      'reduce_step2_create_back_roi_file_name_label',$
      file_name
      
    nexus_spin_state_back_roi_table = (*(*global).nexus_spin_state_back_roi_table)
    data_spin_state = (*global).tmp_reduce_step2_data_spin_state
    row = (*global).tmp_reduce_step2_row
    column = getReduceStep2SpinStateColumn(Event, row=row,$
      data_spin_state=data_spin_state)
      
    ;get Norm file selected
    norm_table = (*global).reduce_step2_big_table_norm_index
    nexus_spin_state_back_roi_table[column,norm_table[row]] = file_name
    (*(*global).nexus_spin_state_back_roi_table) = nexus_spin_state_back_roi_table
    
    ;turn off hourglass
    WIDGET_CONTROL,hourglass=0
    
  ENDIF ELSE BEGIN
  ;    IDLsendToGeek_addLogBookText, Event, '-> Operation CANCELED'
  ENDELSE
  
END


;- LOAD ROI -------------------------------------------------------------------
PRO load_and_plot_roi_file, Event, file_name

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;  ;Load ROI button (Load, extract and plot)
  ;  load_roi_selection, Event, file_name
  
  Yarray = retrieveYminMaxFromFile(event,file_name)
  Y1 = Yarray[0]
  Y2 = Yarray[1]
  putTextFieldValue, Event, 'reduce_step2_create_roi_y1_value', $
    STRCOMPRESS(Y1,/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_step2_create_roi_y2_value', $
    STRCOMPRESS(Y2,/REMOVE_ALL)
    
  ;  plot_reduce_step2_norm, Event ;refresh plot
  ;(*global).norm_roi_y_selected = 'all'
  ;reduce_step2_manual_move, Event
    
    
  reduce_step2_plot_rois, event
  display_roi_on_roi_selection_counts_vs_pixel_base, event
  
;          plot_reduce_step2_roi, Event
;        display_roi_on_roi_selection_counts_vs_pixel_base, event
  
END

pro load_and_plot_back_roi_file, event, file_name
  compile_opt idl2
  
  
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  Yarray = retrieveYminMaxFromFile(event,file_name)
  Y1 = Yarray[0]
  Y2 = Yarray[1]
  putTextFieldValue, Event, 'reduce_step2_create_back_roi_y1_value', $
    STRCOMPRESS(Y1,/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_step2_create_back_roi_y2_value', $
    STRCOMPRESS(Y2,/REMOVE_ALL)
    
  ;  plot_reduce_step2_norm, Event ;refresh plot
  ;  (*global).norm_roi_y_selected = 'all'
  ;  reduce_step2_manual_move, Event
    
  reduce_step2_plot_rois, event
  display_roi_on_roi_selection_counts_vs_pixel_base, event
  
  
end
