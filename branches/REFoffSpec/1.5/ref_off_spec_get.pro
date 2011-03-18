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
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  RETURN, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;------------------------------------------------------------------------------
FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value[0]
END

function getValue, event=event, base=base, uname=uname
  if (keyword_set(event)) then begin
    return, getTextFieldValue(event, uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
    widget_control, id, get_value=value
    return, value
  endelse
end

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getDropListSelectedValue, Event, uname
  index_selected = getDropListSelectedIndex(Event,uname)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=list
  RETURN, list[index_selected]
END

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getComboListSelectedValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  RETURN, WIDGET_INFO(id, /COMBOBOX_GETTEXT)
END

;------------------------------------------------------------------------------
FUNCTION getCWBgroupValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getDroplistValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=list
  RETURN, list
END

;------------------------------------------------------------------------------
FUNCTION getTableValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;-------------------------------------------------------------------------------
FUNCTION getButtonStatus, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  RETURN, WIDGET_INFO(id, /BUTTON_SET)
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;Return the index of the ascii file selected in the first tab (step1)
FUNCTION getAsciiSelectedIndex, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ascii_file_list')
  index = WIDGET_INFO(id,/LIST_SELECT)
  RETURN, [index]
END

;------------------------------------------------------------------------------
;This function returns the number of plot loaded
FUNCTION getNbrFiles, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  list_OF_files = (*(*global).list_OF_ascii_files)
  sz = N_ELEMENTS(list_OF_files)
  RETURN, sz
END

;------------------------------------------------------------------------------
FUNCTION getTranFileSelected, Event
  index = getDropListSelectedIndex(Event,'transparency_file_list')
  RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION getShortName, list_OF_files
  sz = N_ELEMENTS(list_OF_files)
  IF (sz GT 0) THEN BEGIN
    new_list_OF_files = STRARR(sz)
    index = 0
    WHILE (index LT sz) DO BEGIN
      file_name  = list_OF_files[index]
      short_name = FILE_BASENAME(file_name)
      new_list_OF_files[index] = short_name
      ++index
    ENDWHILE
  ENDIF ELSE BEGIN
    new_list_OF_files = ['']
  ENDELSE
  RETURN, new_list_OF_files
END

;------------------------------------------------------------------------------
;This function returns the attenuator coefficient defined in the
;OPTIONS tab
FUNCTION getShiftingAttenuatorCoeff, Event
  percentage_value = getTextFieldValue(Event, 'transparency_shifting_options')
  RETURN, percentage_value/100.
END

;------------------------------------------------------------------------------
;This function returns the attenuator coefficient in percentage
;OPTIONS tab
FUNCTION getShiftingAttenuatorPercentage, Event
  percentage_value = getTextFieldValue(Event, 'transparency_shifting_options')
  RETURN, percentage_value
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1XminValue, Event
  RETURN, getTextFieldValue(Event, 'selection_info_xmin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1YminValue, Event
  RETURN, getTextFieldValue(Event, 'selection_info_ymin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1XmaxValue, Event
  RETURN, getTextFieldValue(Event, 'selection_info_xmax_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1YmaxValue, Event
  RETURN, getTextFieldValue(Event, 'selection_info_ymax_value')
END
;===================================================== STEP5 =====
; Change Code (RC Ward, 3 Jun 2010): These routines added to implement the xmin,ymin, xmax,ymax
; control of the plot in STEP 5
;------------------------------------------------------------------------------
FUNCTION getStep5XminValue, Event
  RETURN, getTextFieldValue(Event, 'step5_selection_info_xmin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep5YminValue, Event
  RETURN, getTextFieldValue(Event, 'step5_selection_info_ymin_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep5XmaxValue, Event
  RETURN, getTextFieldValue(Event, 'step5_selection_info_xmax_value')
END

;------------------------------------------------------------------------------
FUNCTION getStep5YmaxValue, Event
  RETURN, getTextFieldValue(Event, 'step5_selection_info_ymax_value')
END
;===================================================== STEP5 =====

;------------------------------------------------------------------------------
FUNCTION get_step4_step2_step2_lambda, Event
  lambda_left  = getTextFieldValue(Event,'step4_2_2_lambda1_text_field')
  lambda_right = getTextFieldValue(Event,'step4_2_2_lambda2_text_field')
  RETURN,[lambda_left,lambda_right]
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step1SelectionPixelRange, Event
  value = getTextFieldValue(Event,'selection_coverage_step4_step1')
  RETURN, FIX(value)
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step2PSYMselected, Event
  value = getCWBgroupValue(Event,'plot_2d_symbol')
  RETURN, value+1
END

;------------------------------------------------------------------------------
;This function takes array as an argument and will
;return the first index  >= lda1 and the last one <=lda2
;To determine in which order the search should be done (increasing
;or decreasing order) the first and last argument will be checked first
FUNCTION getArrayRangeFromlda1lda2, data, lda1, lda2

  FirstValue = data[0]
  data_size  = (SIZE(data))[1]
  LastValue  = data[data_size-1]
  
  left_index  = 0
  right_index = (data_size-1)
  
  found_left_index = 0
  IF (FirstValue LT LastValue) THEN BEGIN ;increasing order
    FOR i=0,(data_size-1) DO BEGIN
      IF (found_left_index EQ 0) THEN BEGIN
        IF (data[i] GE lda1) THEN BEGIN
          left_index       = i
          found_left_index = 1
        ENDIF
      ENDIF ELSE BEGIN
        IF (data[i] GT lda2) THEN BEGIN
          right_index = i-1
          BREAK
        ENDIF
      ENDELSE
    ENDFOR
  ENDIF ELSE BEGIN                ;decreasing order
    FOR i=0,(data_size-1) DO BEGIN
      IF (found_left_index EQ 0) THEN BEGIN
        IF (data[i] LE lda2) THEN BEGIN
          left_index       = i
          found_left_index = 1
        ENDIF
      ENDIF ELSE BEGIN
        IF (data[i] LT lda1) THEN BEGIN
          right_index = i-1
          BREAK
        ENDIF
      ENDELSE
    ENDFOR
  ENDELSE
  returnArray = [left_index, right_index]
  RETURN, returnArray
END

;------------------------------------------------------------------------------
FUNCTION getStep4Step2PlotType, Event
  RETURN, getCWBgroupValue(Event,'step4_step2_z_axis_linear_log')
END

;------------------------------------------------------------------------------
FUNCTION getPolarizationState, file_name
  pola_states = ['Off_Off','Off_On','On_Off','On_On']
  FOR i=0,3 DO BEGIN
    IF (STRPOS(file_name,'_' + pola_states[i]) NE -1) THEN $
      RETURN, pola_states[i]
  ENDFOR
  RETURN, 'N/A'
END

;------------------------------------------------------------------------------
FUNCTION getTableRowSelected, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  array_selected = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, array_selected[1]
END

;------------------------------------------------------------------------------
FUNCTION getTableSelection, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  array_selected = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, array_selected
END

;------------------------------------------------------------------------------
FUNCTION getOnlyDefineRunNumber, array

  sz = N_ELEMENTS(array)
  new_array = STRARR(1)
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (array[index] NE '') THEN BEGIN
      run_number = STRCOMPRESS(array[index],/REMOVE_ALL)
      IF (index EQ 0) THEN BEGIN
        new_array[0] = run_number
      ENDIF ELSE BEGIN
        new_array = [new_array,run_number]
      ENDELSE
    ENDIF
    index++
  ENDWHILE
  RETURN, new_array
END

;-----------------------------------------------------------------------------
PRO get_new_list, nexus_file_list, nexus_run_number, selection

  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF ELSE BEGIN
    sz = N_ELEMENTS(nexus_file_list)
    sz2 = sz - N_ELEMENTS(selection)
    new_nexus_file_list = STRARR(sz2)
    new_nexus_run_number = STRARR(1,11)
    j=0
    FOR i=0,(sz-1) DO BEGIN
      IF (WHERE(selection EQ i) EQ -1) THEN BEGIN
        new_nexus_file_list[j] = nexus_file_list[i]
        new_nexus_run_number[j] = nexus_run_number[i]
        j++
      ENDIF
    ENDFOR
    nexus_run_number = new_nexus_run_number
    nexus_file_list = new_nexus_file_list
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getReduceStep2NormOfRow, Event, row=row

  sRow = STRCOMPRESS(row,/REMOVE_ALL)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_file_list = (*(*global).reduce_tab2_nexus_file_list)
  sz = (SIZE(nexus_file_list))(1)
  IF (sz GT 1) THEN BEGIN
    uname = 'reduce_tab2_norm_combo' + sRow
    RETURN, getComboListSelectedValue(Event, uname)
  ENDIF ELSE BEGIN
    uname = 'reduce_tab2_norm_value' + sRow
    RETURN, getTextFieldValue(Event,uname)
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getReduceStep2SpinStateRow, Event, Row=row, $
    data_spin_state=data_spin_state
    
  sRow = STRCOMPRESS(row,/REMOVE_ALL)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ; Begin CHANGE ===May 29, 2010 =========================================================
  ; Change code (RC Ward, May 29, 2010): test to see if we can capture the spin states
  list_of_data_spin = (*global).list_of_data_spin
  
  reflect_spin_state_to_check = ['reduce_tab1_pola_1', $
    'reduce_tab1_pola_2',$
    'reduce_tab1_pola_3',$
    'reduce_tab1_pola_4']
  direct_spin_state_to_check = ['reduce_tab1_direct_pola_1', $
    'reduce_tab1_direct_pola_2',$
    'reduce_tab1_direct_pola_3',$
    'reduce_tab1_direct_pola_4']
  nbr_spin_states = N_ELEMENTS(reflect_spin_state_to_check)
  count_direct = 0
  FOR i=0,(nbr_spin_states-1) DO BEGIN
    reflect_enabled_status = 0
    direct_enabled_status = 0
    IF (isButtonSelected(Event, reflect_spin_state_to_check[i])) THEN BEGIN
      reflect_enabled_status = 1
    ENDIF
    IF (isButtonSelected(Event, direct_spin_state_to_check[i])) THEN BEGIN
      direct_enabled_status = 1
      count_direct = count_direct + 1
      index_direct = i
    ENDIF
  ;      print, "Spin States- Reflect: ", i, " status: ", reflect_enabled_status, $
  ;        "   Direct: ", i, " status: ", direct_enabled_status
  ENDFOR
  ;   print, " "
  ; test to see if there is a single direct (or normalization) spin state
  ;      print, count_direct
  IF (count_direct eq 1) then begin
    ; always use the single spin state selected by the user
    ; similar to old spin_mode = 2, but allows for all spin state possibilities
    data_spin = list_of_data_spin[index_direct]
    ;         print, "data_spin: ", data_spin
    RETURN, data_spin
  ENDIF ELSE BEGIN
    ; if not a single direct (normalization spin state), then match data spin state
    ; equivalent of old spin_mode = 1
    RETURN, data_spin_state
  ENDELSE
;
; END CHANGE ===May 29, 2010 =========================================================
  
; This is the old way to comput the spin_mode - comment out as os May 30, 2010
;  spin_mode = (*global).reduce_step1_spin_state_mode
  
;  CASE (spin_mode) OF
;    1: BEGIN ;match data spin state
;      RETURN, data_spin_state
;    END
;    2: BEGIN ;always off_off
;      RETURN, 'Off_Off'
;    END
;    3: BEGIN ;user defined
;      base_name = STRLOWCASE(data_spin_state)
;      uname = 'reduce_tab2_spin_combo_' + base_name + sRow
;      RETURN, getComboListSelectedValue(Event,uname)
;    END
;  ENDCASE
  
END

;..............................................................................
FUNCTION getReduceStep2SpinStateColumn, Event, row=row,$
    data_spin_state=data_spin_state
    
  sColumn = getReduceStep2SpinStateRow(Event, Row=row, $
    data_spin_state=data_spin_state)
  sColumn = STRLOWCASE(sColumn)
  
  CASE (sColumn) OF
    'off_off': RETURN, 1
    'off_on': RETURN, 2
    'on_off': RETURN, 3
    'on_on': RETURN, 4
  ENDCASE
END

;------------------------------------------------------------------------------
FUNCTION getReduceStep2NormFullName, Event, row=row

  sRow = STRCOMPRESS(row,/REMOVE_ALL)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_file_list = (*(*global).reduce_tab2_nexus_file_list)
  sz = (SIZE(nexus_file_list))(1)
  IF (sz GT 1) THEN BEGIN
    big_table = (*global).reduce_step2_big_table_norm_index
    index = big_table[row]
    uname = 'reduce_tab2_norm_combo' + sRow
    RETURN, nexus_file_list[index]
  ENDIF ELSE BEGIN
    RETURN, nexus_file_list[0]
  ENDELSE
  
END

;------------------------------------------------------------------------------
FUNCTION getDefaultReduceStep2RoiFileName, event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  instrument = (*global).instrument
  
  ;get norm run number
  norm_run = getTextFieldValue(Event,'reduce_step2_create_roi_norm_value')
  IF (instrument EQ 'REF_M') THEN BEGIN
    file = 'REF_M_' + norm_run + '_ROI.dat'
  ENDIF ELSE BEGIN
    file = 'REF_L_' + norm_run + '_ROI.dat'
  ENDELSE
  
  RETURN, file
END


;------------------------------------------------------------------------------
FUNCTION getDefaultReduceStep2BackRoiFileName, event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  instrument = (*global).instrument
  
  ;get norm run number
  norm_run = getTextFieldValue(Event,'reduce_step2_create_roi_norm_value')
  IF (instrument EQ 'REF_M') THEN BEGIN
    file = 'REF_M_' + norm_run + '_back_ROI.dat'
  ENDIF ELSE BEGIN
    file = 'REF_L_' + norm_run + '_back_ROI.dat'
  ENDELSE
  
  RETURN, file
END


;------------------------------------------------------------------------------
FUNCTION getListOfDataSpinStates, Event
  button_value=INTARR(4)
  FOR i=1,4 DO BEGIN
    uname = 'reduce_tab1_pola_' + STRCOMPRESS(i,/REMOVE_ALL)
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
    button_value[i-1] = WIDGET_INFO(id, /BUTTON_SET)
  ENDFOR
  RETURN, button_value
END

;------------------------------------------------------------------------------
FUNCTION getNbrWorkingPolaState, full_pola_state
  sz = (SIZE(full_pola_state))(1)
  IF (sz EQ 1 AND $
    full_pola_state[0] EQ '') THEN BEGIN
    RETURN, 0
  ENDIF ELSE BEGIN
    RETURN, sz
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getNormNexusOfIndex, Event, index, short_norm_file_list
  IF ((SIZE(short_norm_file_list))(1) EQ 1) THEN BEGIN
    RETURN, short_norm_file_list[0]
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    table = (*global).reduce_step2_big_table_norm_index
    selected_index = table[index]
    RETURN, short_norm_file_list[selected_index]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getNormRoiFileOfIndex, Event, row_data=row_data, base_name=base_name

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_spin_state_roi_table = (*(*global).nexus_spin_state_roi_table)
  norm_table = (*global).reduce_step2_big_table_norm_index
  
  sIndex = STRCOMPRESS(row_data,/REMOVE_ALL)
  data_base_uname = 'reduce_tab2_data_recap_base_#' + sIndex
  column = getReduceStep2SpinStateColumn(Event, Row=sIndex, $
    data_spin_state=base_name)
  roi_file = nexus_spin_state_roi_table[column,norm_table[row_data]]
  RETURN, roi_file
  
END

;------------------------------------------------------------------------------
FUNCTION getNormBackRoiFileOfIndex, Event, row_data=row_data, base_name=base_name

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_spin_state_back_roi_table = (*(*global).nexus_spin_state_back_roi_table)
  norm_table = (*global).reduce_step2_big_table_norm_index
  
  sIndex = STRCOMPRESS(row_data,/REMOVE_ALL)
  data_base_uname = 'reduce_tab2_data_recap_base_#' + sIndex
  column = getReduceStep2SpinStateColumn(Event, Row=sIndex, $
    data_spin_state=base_name)
  roi_file = nexus_spin_state_back_roi_table[column,norm_table[row_data]]
  RETURN, roi_file
  
END

;------------------------------------------------------------------------------
FUNCTION getRunNumbersFromAscii, list_of_ascii_files

  sz = N_ELEMENTS(list_of_ascii_files)
  list_of_runs = STRARR(sz)
  index = 0
  WHILE (index LT sz) DO BEGIN
    ascii_object = OBJ_NEW('IDL3columnsASCIIparser', $
      list_of_ascii_files[index])
    run_number = ascii_object->get_tag('#C data Run Number:')
    list_of_runs[index] = run_number
    index++
  ENDWHILE
  RETURN, list_of_runs
END

;----------------------------------------------------------------------------
FUNCTION getSangleSpinStateSelected, Event

  spin_state_to_change = ['reduce_sangle_1',$
    'reduce_sangle_2',$
    'reduce_sangle_3',$
    'reduce_sangle_4']
    
  spin_state = ['Off_Off',$
    'Off_On',$
    'On_Off',$
    'On_On']
    
  nbr_spin_states = N_ELEMENTS(spin_state_to_change)
  
  FOR i=0,(nbr_spin_states-1) DO BEGIN
    IF (isButtonSelected(Event,spin_state_to_change[i])) THEN $
      RETURN, spin_state[i]
  ENDFOR
  
  RETURN, ''
END

;------------------------------------------------------------------------------
;This function returns the TOF value of the cursor in the sangle main plot
FUNCTION getSangleTof, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 'N/A'
  ENDIF
  
  X = Event.x
  x_coeff = (*global).sangle_main_plot_congrid_x_coeff
  tof = (*(*global).sangle_tof)
  sz_tof = N_ELEMENTS(tof)
  
  tof_congrid = CONGRID(tof, sz_tof * x_coeff)
  RETURN, tof_congrid[X]
  
END

;------------------------------------------------------------------------------
;This function returns the pixel value of the cursor in the sangle main plot
FUNCTION getSanglePixel, Event
  ; Change code: add to get the global structure (RC Ward Feb 15, 2010)
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  y_coeff = 2.
  Y = Event.y
  pixel = FIX(Y/y_coeff)
  
  ;    IF (pixel GE 304L) THEN RETURN, 'N/A'
  IF (pixel GE (*global).detector_pixels_y) THEN RETURN, 'N/A'
  IF (pixel LT 0) THEN RETURN, 'N/A'
  RETURN, pixel
  
END

;------------------------------------------------------------------------------
FUNCTION getSangleYDeviceValue, Event, data_value

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  sangle_ysize_draw = (*global).sangle_ysize_draw
  y_coeff = (*global).sangle_main_plot_congrid_y_coeff
  
  ;  device = FLOAT(sangle_ysize_draw) * FLOAT(data_value) / FLOAT(*304L)
  device = FLOAT(sangle_ysize_draw) * FLOAT(data_value) / FLOAT((*global).detector_pixels_y)
  
  RETURN, device
  
END

;------------------------------------------------------------------------------
FUNCTION getSangleYDataValue, Event, device_value

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  sangle_ysize_draw = (*global).sangle_ysize_draw
  y_coeff = (*global).sangle_main_plot_congrid_y_coeff
  
  ;  data = (FLOAT(device_value) * FLOAT(304L) ) / FLOAT(sangle_ysize_draw)
  data = (FLOAT(device_value) * FLOAT((*global).detector_pixels_y) ) / FLOAT(sangle_ysize_draw)
  
  RETURN, data
  
END



;+
; :Description:
;    returns the index where the value has been found for the first time, or
;    last time, according to the flag, 'from' or 'to'
;
; :Keywords:
;    array
;    value
;    from
;    to
;
; :Author: j35
;-
function getIndexOfValueInArray, array=array, value=value, from=from, to=to
  compile_opt idl2
  
  if (keyword_set(from)) then begin
  
    _list_index = where(value ge array, nbr)
    if (nbr eq 0) then begin
      return, 0
    endif else begin
      return, (_list_index[-1])
    endelse
    
  endif
  
  if (keyword_set(to)) then begin
  
    _list_index = where(array le value, nbr)
    if (nbr eq 0) then begin
      return, -1
    endif else begin
      return, (_list_index[-1]-1)
    endelse
    
  endif
  
end


