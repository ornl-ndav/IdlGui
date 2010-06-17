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

;------------------------------------------------------------------------------
;- GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
PRO activate_widget, Event, uname, activate_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SENSITIVE=activate_status
END

;------------------------------------------------------------------------------
PRO activate_widget_list, Event, uname_list, activate_status
  sz = N_ELEMENTS(uname_list)
  FOR i=0,(sz-1) DO BEGIN
    activate_widget, Event, uname_list[i], activate_status
  ENDFOR
END

;------------------------------------------------------------------------------
PRO selectDroplistIndex, Event, uname, index
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SET_DROPLIST_SELECT=index
END

;------------------------------------------------------------------------------
PRO SetDroplistValue, Event, uname, list
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SET_VALUE=list
END

;------------------------------------------------------------------------------
PRO MapBase, Event, uname, map_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, MAP=map_status
END

;..............................................................................
PRO MapList, Event, uname_list, map_status
  sz = N_ELEMENTS(uname_list)
  FOR i=0,(sz-1) DO BEGIN
    MapBase, Event, uname_list[i], map_status
  ENDFOR
END

;------------------------------------------------------------------------------
PRO SetComboboxSelect, Event, uname, index
  id = WIDGET_INFO(Event.top, find_by_uname=uname)
  widget_control, id, SET_COMBOBOX_SELECT=index
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
PRO activate_browse_gui, Event, value
  uname_list = ['x_axis_ticks_base',$
    'ascii_preview_button',$
    'refresh_step2_plot',$
    'step2_zmax',$
    'step2_zmin',$
    'step2_z_reset']
  activate_widget_list, Event, uname_list, value
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  index = WHERE((*global).ucams EQ (*global).super_users)
  IF (index NE -1) THEN BEGIN ;for super users
    activate_widget, Event, 'transparency_base', value
  ENDIF
END

;------------------------------------------------------------------------------
PRO display_file_names_transparency, Event, ascii_file_name
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get list of files
  list_OF_files = (*(*global).list_OF_ascii_files)
  ;get only short file name of all files
  short_list_OF_files = getShortName(list_OF_files)
  ;put list of files in droplist of transparency
  putListOfFilesTransparency, Event, short_list_OF_files
END

;------------------------------------------------------------------------------
PRO update_transparency_coeff_display, Event
  index_selected = getTranFileSelected(Event)
;  print, index_selected
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  IF (index_selected EQ 0) THEN BEGIN
    value = 'N/A'
    putTextFieldValue, Event, 'transparency_coeff', value
  ENDIF ELSE BEGIN
    trans_coeff_list = (*(*global).trans_coeff_list)
;    print, trans_coeff_list
    coeff = trans_coeff_list[index_selected]
    coeff_percentage = 100.*coeff
    putTextFieldValue, Event, 'transparency_coeff', $
      STRCOMPRESS(FLOAT(coeff_percentage),/REMOVE_ALL)
  ENDELSE
END

;------------------------------------------------------------------------------
PRO select_list, Event, index_selected
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ascii_file_list')
  WIDGET_CONTROL, id, SET_LIST_SELECT=index_selected
END

;------------------------------------------------------------------------------
PRO move_selection, Event, TYPE=type
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;get list of files
  list_OF_files  = (*(*global).list_OF_ascii_files)
  NbrFiles       = N_ELEMENTS(list_OF_Files)
  index_selected = getAsciiSelectedIndex(Event)
  
  ;get list of file selected
  ;list_OF_files_selected = list_OF_files[index_selected]
  sz = N_ELEMENTS(index_selected)
  CASE (type) OF
    'up': BEGIN
      i = 0
      WHILE (i LT sz) DO BEGIN
        IF (index_selected[i] GT 0) THEN BEGIN
          bPrevSelected = isThisIndexSelected(Event, $
            index_selected, $
            index_selected[i]-1)
          IF (~bPrevSelected) THEN BEGIN
            prev_name = list_OF_files[index_selected[i]-1]
            curr_name = list_OF_files[index_selected[i]]
            list_OF_Files[index_selected[i]]   = prev_name
            list_OF_Files[index_selected[i]-1] = curr_name
            index_selected[i] = index_selected[i]-1
          ENDIF
        ENDIF
        ++i
      ENDWHILE
    END
    'down': BEGIN
      i = sz-1
      WHILE (i GE 0) DO BEGIN
        IF (index_selected[i] LT NbrFiles-1) THEN BEGIN
          bPrevSelected = isThisIndexSelected(Event, $
            index_selected, $
            index_selected[i]+1)
          IF (~bPrevSelected) THEN BEGIN
            next_name = list_OF_files[index_selected[i]+1]
            curr_name = list_OF_files[index_selected[i]]
            list_OF_Files[index_selected[i]]   = next_name
            list_OF_Files[index_selected[i]+1] = curr_name
            index_selected[i] = index_selected[i]+1
          ENDIF
        ENDIF
        --i
      ENDWHILE
    END
    ELSE:
  ENDCASE
  
  ;repopulate list
  putAsciiFileList, Event, list_OF_files
  ;save list of files
  (*(*global).list_OF_ascii_files) = list_OF_Files
  ;reset selection
  select_list, Event, index_selected
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  ;display list of ascii_file_name in transparency percentage button
  display_file_names_transparency, Event, ascii_file_name ;_gui
  readAsciiData, Event ;read the ascii files and store value in a pointer
  plotAsciiData, Event
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO  InformLogBook, Event, min_array, max_array, xmax_array, ymax_array
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  list_OF_files = (*(*global).list_OF_ascii_files)
  sz = N_ELEMENTS(list_OF_Files)
  index = 0
  text = ['> Information about loaded files:']
  WHILE (index LT sz) DO BEGIN
    new_text  = '-> ' + list_OF_files[index]
    new_text += ' : MIN = ' + STRCOMPRESS(min_array[index],/REMOVE_ALL)
    new_text += ' : MAX = ' + STRCOMPRESS(max_array[index],/REMOVE_ALL)
    new_text += ' (First Point at max value is at ('
    new_text += STRCOMPRESS(xmax_array[index],/REMOVE_ALL)
    new_text += ',' + STRCOMPRESS(ymax_array[index],/REMOVE_ALL)
    new_text += ')'
    text = [text,new_text]
    ++index
  ENDWHILE
  IDLsendToGeek_addLogBookText, Event, text
END

;------------------------------------------------------------------------------
PRO delete_ascii_file_from_list, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  activate_widget, Event, 'ascii_delete_button', 0
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  list_OF_files = (*(*global).list_OF_ascii_files)
  sz = N_ELEMENTS(list_OF_Files)
  index_selected = getAsciiSelectedIndex(Event)
  ;index selected becomes blank lines
  list_OF_files[index_selected] = ''
  index = WHERE(list_OF_files NE '', nbr)
  IF (nbr GT 0) THEN BEGIN
    new_list_OF_ascii_files = list_OF_files(index)
  ENDIF ELSE BEGIN
    new_list_OF_ascii_files = STRARR(1)
    full_reset_of_application, Event
  ENDELSE
  (*(*global).list_OF_ascii_files) = new_list_OF_ascii_files
  ;repopulate list
  putAsciiFileList, Event, new_list_OF_ascii_files
  ;display list of ascii_file_name in transparency percentage button
  updateStep3FileNames, Event ;_shifting (update the files names in step3)
  
  index = WHERE((*global).ucams EQ (*global).super_users)
  IF (index NE -1) THEN BEGIN     ;for super users only
    display_file_names_transparency, Event, new_list_OF_ascii_files ;_gui
  ENDIF
  
  IF (new_list_OF_ascii_files[0] EQ '') THEN BEGIN
    (*global).something_to_plot = 0
    ;clear plot
    id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step2_draw')
    WIDGET_CONTROL, id_draw, GET_VALUE=id_value
    WSET,id_value
    ERASE
  ENDIF ELSE BEGIN
    readAsciiData, Event ;read the ascii files and store value in a pointer
    plotAsciiData, Event        ;plot the ascii files (_plot.pro)
  ENDELSE
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO CheckShiftingGui, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;activate if at least two files loaded and first and another pixel
  ;selection has been made
  uname_list = ['auto_shifting_mode']
  ;check how many pixel have been selected

; Code change (RC Ward, Feb 19, 2010): replaced ref_x_list with ref_pixel_list in this routine
; to fix problem that "Realign Data" button was not being activated in the case of entering
; text values. Since in that case only ref_pixel_list was being set. Works OK with mouse action.
; 
;  ref_x_list = (*(*global).ref_x_list)
;  index = WHERE(ref_x_list NE 0,nbr)
  ref_pixel_list = (*(*global).ref_pixel_list)
  index = WHERE(ref_pixel_list NE 0,nbr)
  current_list_OF_files = (*(*global).list_OF_ascii_files)
  sz = N_ELEMENTS(current_list_OF_files)
  IF (nbr GT 1 AND $
;    ref_x_list[0] NE 0 AND $
     ref_pixel_list[0] NE 0 AND $
    sz GE 2) THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activate_widget_list, Event, uname_list, activate_status
  
  ;activate if there is at least two files loaded and file selected is
  ;not the first one
  uname_list = ['manual_shifting_mode_base']
  index_selected = $
    getDropListSelectedIndex(Event, $
    'active_file_droplist_shifting')
  IF (sz GT 1 AND $
    index_selected NE 0) THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activate_widget_list, Event, uname_list, activate_status
  
  ;activate down and up reference (first frame) when there is at least
  ;one file plotted
  uname_list = ['reference_base_shifting',$
    'selection_mode_base',$
    'selection_mode_base_label',$
    'x_axis_less_more_label',$
    'x_axis_less_ticks_shifting',$
    'x_axis_more_ticks_shifting',$
    'z_axis_linear_log_shifting',$
    'step3_zmax',$
    'step3_zmin',$
    'step3_z_reset']
  IF (current_list_OF_files[0] NE '') THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activate_widget_list, Event, uname_list, activate_status
END

;------------------------------------------------------------------------------
PRO checkScalingGui, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  current_list_OF_files = (*(*global).list_OF_ascii_files)
  uname_list = ['step4_zmax',$
    'step4_zmin',$
    'step4_z_reset']
  IF (current_list_OF_files[0] NE '') THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  activate_widget_list, Event, uname_list, activate_status
  
END

;------------------------------------------------------------------------------
PRO check_status_of_reduce_step1_buttons, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  new_table = (*(*global).reduce_tab1_table)
  
  IF (new_table[0,0] EQ '') THEN BEGIN
    status = 0
  ENDIF ELSE BEGIN
    status = 1
  ENDELSE
  uname_list = ['reduce_step1_remove_selection_button']
  IF ((*global).instrument EQ 'REF_M' ) THEN BEGIN
    uname_list = [uname_list, 'reduce_step1_sangle_button']
  ENDIF
  
  ;'reduce_step1_display_y_vs_tof_button',$
  ;reduce_step1_display_y_vs_x_button']
  activate_widget_list, Event, uname_list, status
  
END

;------------------------------------------------------------------------------
PRO Reduce_step2_polarization_active, Event, status
  MapBase, Event, 'reduce_step2_polarization_base', status
  MapBase, Event, 'reduce_step2_polarization_mode_hidden_base', 0^status
END

;------------------------------------------------------------------------------
PRO create_output_i_vs_q_gui, Event, status
  title_status = 0^FIX(status)
  putTextFieldValue, Event, 'i_vs_q_output_base_title', $
    'List of I vs Q or TOF files'
  MapBase, Event, 'i_vs_q_output_base', status
;MapBase, Event, 'i_vs_q_output_hidden_title_base', title_status
END
