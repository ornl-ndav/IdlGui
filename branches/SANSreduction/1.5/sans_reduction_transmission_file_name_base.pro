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

PRO transmission_file_name_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  CASE Event.id OF
  
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_cancel'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_file_name_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;Browse button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_browse_button'): BEGIN
      trans_file_name_base_browse_file_name, Event
    END
    
    ;Browse path button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_path_button'): BEGIN
      trans_file_name_base_path_file_name, Event
    END
    
    ;file name text field
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_file_name'): BEGIN
      create_trans_file, Event
    END
    
    ;preview button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_preview'): BEGIN
      preview_trans_file, Event
    END
    
    ;ok button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_ok_button'): BEGIN
      create_trans_file, Event
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO transmission_file_name_base_gui, wBase, main_base_geometry, output_path, $
    output_file_name
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 400
  ysize = 300
  
  xoffset = main_base_xoffset + main_base_xsize/2 - xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2 - ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission File Name:',$
    UNAME        = 'transmission_file_name_base',$
    XOFFSET      = xoffset, $
    YOFFSET      = yoffset, $
    MAP          = 1, $
    /COLUMN, $
    /BASE_ALIGN_CENTER, $
    GROUP_LEADER = ourGroup)
    
  browse = WIDGET_BUTTON(wBase,$
    VALUE = 'BROWSE ...',$
    SCR_XSIZE = 390,$
    UNAME = 'trans_file_name_base_browse_button',$
    TOOLTIP = 'Select a file to overwrite with the new transmission file')
    
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  path = WIDGET_BUTTON(wBase,$
    VALUE = output_path,$
    SCR_XSIZE = 390,$
    UNAME = 'trans_file_name_base_path_button',$
    TOOLTIP = 'Select the destination of the transmission file')
    
  row = WIDGET_BASE(wBase,$
    /ROW)
    
  label = WIDGET_LABEL(row,$
    VALUE = 'File Name:')
    
  text = WIDGET_TEXT(row,$
    VALUE = output_file_name,$
    UNAME = 'trans_file_name_base_file_name',$
    /EDITABLE, $
    ;    /ALL_EVENTS, $
    XSIZE = 50)
    
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  xsize = 125
  cancel = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'CANCEL',$
    UNAME = 'trans_file_name_base_cancel')
    
  preview = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'PREVIEW / PLOT ...',$
    UNAME = 'trans_file_name_base_preview')
    
  OK = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'CREATE FILE',$
    UNAME = 'trans_file_name_base_ok_button',$
    SENSITIVE = 1)
    
END

;------------------------------------------------------------------------------
PRO trans_file_name_base_browse_file_name, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  main_global = (*file_global).main_global
  
  title     = 'Select a file to overwrite'
  path      = (*main_global).output_path
  file_name = DIALOG_PICKFILE(GET_PATH = new_path,$
    PATH = path,$
    TITLE = title,$
    /MUST_EXIST)
  IF (file_name[0] NE '') THEN BEGIN
  
    (*main_global).output_path = new_path
    
    file_name = file_name[0]
    file_basename = FILE_BASENAME(file_name)
    putTextFieldValue, Event, 'trans_file_name_base_file_name', file_basename
    putNewButtonValue, Event, 'trans_file_name_base_path_button', new_path
    
    (*file_global).main_global = main_global
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO trans_file_name_base_path_file_name, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  main_global = (*file_global).main_global
  
  title     = 'Select where you want to create the transmission file'
  path      = (*main_global).output_path
  path = DIALOG_PICKFILE(/DIRECTORY, $
    PATH = path,$
    TITLE = title,$
    /MUST_EXIST)
    
  IF (path[0] NE '') THEN BEGIN
  
    (*main_global).output_path = path[0]
    putNewButtonValue, Event, 'trans_file_name_base_path_button', path[0]
    (*file_global).main_global = main_global
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO  transmission_file_name_base, Event, MAIN_GLOBAL=main_global

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_manual_mode_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;provide a default outpt file name
  nexus_file_name = (*main_global).data_nexus_file_name
  run_number = getNexusRunNumber(nexus_file_name)
  output_file_name = 'transmission_' + STRCOMPRESS(run_number,/REMOVE_ALL)
  output_file_name += '.txt'
  
  ;build gui
  wBase1 = ''
  output_path = (*main_global).output_path
  transmission_file_name_base_gui, wBase1, main_base_geometry, output_path, $
    output_file_name
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  file_global = PTR_NEW({ wbase: wbase1,$
    global_trans: global, $
    main_event: (*global).main_event, $
    main_global: main_global})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = file_global
  
  XMANAGER, "transmission_file_name_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

;------------------------------------------------------------------------------
PRO create_trans_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  ;check first that the output file name is valid and does not exit
  file_name = getTextFieldValue(Event, 'trans_file_name_base_file_name')
  s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  path = getButtonValue(Event,'trans_file_name_base_path_button')
  output_file_name = path + s_file_name
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_file_name_base')
  
  IF (s_file_name EQ '') THEN BEGIN ;outptu file name is empty
    result = DIALOG_MESSAGE('Provide a valid transmission output file name', $
      TITLE = 'ERROR: File Name Invalid!',$
      /CENTER, $
      DIALOG_PARENT=id, $
      /ERROR)
    RETURN
  ENDIF
  
  IF (FILE_TEST(output_file_name)) THEN BEGIN ;file name already exist
    message = ['Do you want to overwrite this file: ',$
      output_file_name]
    result = DIALOG_MESSAGE(message, $
      /CENTER, $
      DIALOG_PARENT=id, $
      TITLE = 'File with same name already exists!', $
      /QUESTION)
    IF (result EQ 'No') THEN RETURN
  ENDIF
  
  ;Create trans file array
  create_trans_array, Event
  
  ;create file
  output_trans_file, Event
  
END

;------------------------------------------------------------------------------
PRO create_trans_array, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  ;retrieve info about pixel selected and file name
  global_trans = (*file_global).global_trans
  main_global = (*file_global).main_global
  
  bank_tube_pixel = (*global_trans).beam_center_bank_tube_pixel
  bank = bank_tube_pixel[0]
  tube = bank_tube_pixel[1]
  pixel = bank_tube_pixel[2]
  ;print, format='("bank: ",i4,", tube: ",i4,", pixel: ",i4)',bank,tube,pixel
  nexus_file_name = (*main_global).data_nexus_file_name
  
  ;retrieve distance sample_moderator
  distance_moderator_sample = $
    retrieve_distance_moderator_sample(nexus_file_name)
  distance_sample_beam_center_pixel = $
    retrieve_distance_bc_pixel_sample(nexus_file_name, bank, tube, pixel)
  total_distance = distance_moderator_sample + $
    distance_sample_beam_center_pixel
    
  both_banks = (*(*main_global).both_banks) ;[TOF,Pixel,Tube]
  nbr_tof = (size(both_banks))(1)
  
  trans_peak_tube = (*(*global_trans).trans_peak_tube)
  trans_peak_pixel = (*(*global_trans).trans_peak_pixel)
  
  ;check number of pixel part of the transmission file
  nbr_pixel = N_ELEMENTS(trans_peak_tube)
  trans_peak_array = LONARR(nbr_tof) ;total counts for each tof
  trans_peak_array_error = DBLARR(nbr_tof) ;total counts error for each tof
  index = 0
  WHILE (index LT nbr_pixel) DO BEGIN
    tube = trans_peak_tube[index]
    pixel = trans_peak_pixel[index]
    array_of_local_pixel = both_banks[*,pixel,tube] ;pixel from the transmission peak
    trans_peak_array += array_of_local_pixel
    trans_peak_array_error += array_of_local_pixel^2
    index++
  ENDWHILE
  
  ;take square root of result
  trans_peak_array_error = SQRT(trans_peak_array_error)
  
  ;get tof array
  tof_array = (*(*global_trans).tof_array)
  
  ;do the conversion from tof into Lambda
  mass_neutron = (*main_global).mass_neutron
  planck_constant = (*main_global).planck_constant
  coeff = planck_constant / (mass_neutron * DOUBLE(total_distance))
  
  lambda_axis = tof_array * 1e4 * coeff[0] ;1e4 to go into microS and Angstroms
  
  (*(*global_trans).transmission_peak_value) = trans_peak_array
  (*(*global_trans).transmission_peak_error_value) = trans_peak_array_error
  (*(*global_trans).transmission_lambda_axis) = lambda_axis
  
END

;------------------------------------------------------------------------------
PRO output_trans_file, Event, filename

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  ;retrieve info about pixel selected and file name
  global_trans = (*file_global).global_trans
  main_global = (*file_global).main_global
  main_event = (*file_global).main_event
  
  y_axis = (*(*global_trans).transmission_peak_value)
  y_error_axis = (*(*global_trans).transmission_peak_error_value)
  x_axis = (*(*global_trans).transmission_lambda_axis)
  
  ;get full file name
  file_name = getTextFieldValue(Event, 'trans_file_name_base_file_name')
  s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  path = getButtonValue(Event,'trans_file_name_base_path_button')
  output_file_name = path + s_file_name
  
  putTextFieldValue, main_event, $
    'sample_data_transmission_file_name_text_field', output_file_name
    
  nexus_file_name = (*main_global).data_nexus_file_name
  
  bank_tube_pixel = (*global_trans).beam_center_bank_tube_pixel
  bank = STRCOMPRESS(bank_tube_pixel[0],/REMOVE_ALL)
  tube = STRCOMPRESS(bank_tube_pixel[1],/REMOVE_ALL)
  pixel = STRCOMPRESS(bank_tube_pixel[2],/REMOVE_ALL)
  
  ;first part of file
  first_part = STRARR(5)
  first_part[0] = '#F transmission: ' + nexus_file_name
  first_part[1] = ''
  first_part[2] = "#S 1 Spectrum ID ('bank" + bank + "', (" + tube + $
    ", " + pixel + "))"
  first_part[3] = '#N 3'
  first_part[4] = '#L  wavelength(Angstroms)   Ratio()   Sigma()'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_file_name_base')
  
  error = 0
  CATCH, error
  IF (error NE 0) then begin
    CATCH, /CANCEL
    title = 'Transmission File Name Creation FAILED!'
    message_text = 'Creation of transmission file ' + output_file_name + $
      ' FAILED!'
    result = DIALOG_MESSAGE(message_text, $
      /CENTER, $
      DIALOG_PARENT=id, $
      /ERROR, $
      TITLE = title)
  ;put error statement here
  ENDIF ELSE BEGIN
    ;open output file
    OPENW, 1, output_file_name
    ;write first part
    FOR i=0,N_ELEMENTS(first_part)-1 DO BEGIN
      PRINTF, 1, first_part[i]
    ENDFOR
    FOR i=0,N_ELEMENTS(y_axis)-1 DO BEGIN
      line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + ' '
      line += STRCOMPRESS(y_axis[i],/REMOVE_ALL) + ' '
      line += STRCOMPRESS(y_error_axis[i],/REMOVE_ALL)
      PRINTF, 1, line
    ENDFOR
    PRINTF, 1, STRCOMPRESS(x_axis[N_ELEMENTS(x_axis)-1],/REMOVE_ALL)
    title =  'Transmission File has been created with SUCCESS!'
    message_text = 'Creation of transmission file ' + output_file_name + $
      ' WORKED!'
    result = DIALOG_MESSAGE(message_text, $
      /INFORMATION, $
      /CENTER, $
      DIALOG_PARENT=id, $
      TITLE = title)
  ENDELSE
  CLOSE, 1
  FREE_LUN, 1
  
  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='transmission_file_name_base')
  WIDGET_CONTROL, id, /DESTROY
  
  IF (error EQ 0) THEN BEGIN
    id = WIDGET_INFO((*main_global).transmission_manual_mode_id, $
      FIND_BY_UNAME='transmission_manual_mode_base')
    WIDGET_CONTROL, id, /DESTROY
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO preview_trans_file, Event

  create_trans_array, Event
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=file_global
  
  ;retrieve info about pixel selected and file name
  global_trans = (*file_global).global_trans
  main_global = (*file_global).main_global
  
  y_axis = (*(*global_trans).transmission_peak_value)
  y_error_axis = (*(*global_trans).transmission_peak_error_value)
  x_axis = (*(*global_trans).transmission_lambda_axis)
  
  ;get full file name
  file_name = getTextFieldValue(Event, 'trans_file_name_base_file_name')
  s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  path = getButtonValue(Event,'trans_file_name_base_path_button')
  output_file_name = path + s_file_name
  
  nexus_file_name = (*main_global).data_nexus_file_name
  
  bank_tube_pixel = (*global_trans).beam_center_bank_tube_pixel
  bank = STRCOMPRESS(bank_tube_pixel[0],/REMOVE_ALL)
  tube = STRCOMPRESS(bank_tube_pixel[1],/REMOVE_ALL)
  pixel = STRCOMPRESS(bank_tube_pixel[2],/REMOVE_ALL)
  
  ;first part of file
  first_part = STRARR(5)
  first_part[0] = '#F transmission: ' + nexus_file_name
  first_part[1] = ''
  first_part[2] = "#S 1 Spectrum ID ('bank" + bank + "', (" + tube + $
    ", " + pixel + "))"
  first_part[3] = '#N 3'
  first_part[4] = '#L  wavelength(Angstroms)   Ratio()   Sigma()'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_file_name_base')
  
  ;create big array
  sz_big_file = 5 + N_ELEMENTS(x_axis)
  big_array = STRARR(sz_big_file)
  index = 0
  WHILE (index LT 5) DO BEGIN
    big_array[index] = first_part[index]
    index ++
  ENDWHILE
  
  i = 0
  WHILE (i LT N_ELEMENTS(x_axis)-1) DO BEGIN
    line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + ' '
    line += STRCOMPRESS(y_axis[i],/REMOVE_ALL) + ' '
    line += STRCOMPRESS(y_error_axis[i],/REMOVE_ALL)
    big_array[index] = line
    i++
    index++
  ENDWHILE
  big_array[index] =  STRCOMPRESS(x_axis[N_ELEMENTS(x_axis)-1],/REMOVE_ALL)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_file_name_base')
  title = 'Preview of ' + output_file_name
  sans_reduction_xdisplayFile, GROUP=id, TEXT=big_array, TITLE=title, HEIGHT=50
  
  x_axis_plot = x_axis[0:N_ELEMENTS(x_axis)-2]
  
  iplot, x_axis_plot, y_axis,$
    /DISABLE_SPLASH_SCREEN, $
    /NO_SAVEPROMPT, $
    YERROR=y_error_axis, $
    /Y_ERRORBARS, $
    SYM_INDEX=7, $
    XTITLE = "Lambda (Angstroms)", $
    YTITLE = "Counts", $
    LINESTYLE = 6, $
    USE_DEFAULT_COLOR = 0, $
    SYS_COLOR=[255,0,0], $
    VIEW_ZOOM = 1.5, $
    BACKGROUND_COLOR=[255,255,255], $
    ERRORBAR_COLOR=[255,0,0], $
    XTEXT_COLOR = [0,0,255], $
    YTEXT_COLOR = [0,255,0], $
    COLOR = [0,0,0], $
    TITLE = 'Transmission file: ' + output_file_name
    
END













