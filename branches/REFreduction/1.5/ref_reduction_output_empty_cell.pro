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

PRO empty_cell_output_folder, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path  = (*global).browse_data_path
  title = 'Select a destination folder for the ascii file'
  
  result = DIALOG_PICKFILE(/DIRECTORY,$
    /MUST_EXIST,$
    PATH=path,$
    TITLE=title)
    
  IF (result NE '') THEN BEGIN
    (*global).browse_data_path = path
    putLabelValue, Event, 'empty_cell_output_folder_button', result
  ENDIF
  
END

;-----------------------------------------------------------------------------
PRO create_empty_cell_output_file, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL, /HOURGLASS
  
  ;get metadata
  ;;full name of data file
  ;;full name of empty cell file
  ;;A,B, D and Scaling Factor used
  data_file       = (*global).data_nexus_full_path
  empty_cell_file = (*global).empty_cell_nexus_full_path
  
  A = getTextFieldValue(Event, 'empty_cell_substrate_a')
  B = getTextFieldValue(Event, 'empty_cell_substrate_b')
  D = getTextFieldValue(Event, 'empty_cell_diameter')
  
  data_proton_charge        = (*global).data_proton_charge
  empty_cell_proton_charge  = (*global).empty_cell_proton_charge
  distance_sample_moderator = (*global).empty_cell_distance_moderator_sample
  
  ;recap data
  recap_data    = (*(*global).SF_RECAP_D_TOTAL_ptr)
  ntof          = (size(recap_data))(2)
  data_tof_axis = (*(*global).sf_empty_cell_tof)
  
  ;scaling factor
  SF = getTextFieldValue(Event,'scaling_factor_equation_value')
  
  nbr_metadata = 11 ;number of metadata
  metadata_array = STRARR(nbr_metadata)
  metadata_array[0] = '#F data: ' + data_file
  metadata_array[1] = '#F empty_cell: ' + empty_cell_file
  metadata_array[2] = '#D ' + GenerateReadableIsoTimeStamp()
  metadata_array[3] = '#C data proton charge (picoCoulomb): ' + $
    STRCOMPRESS(data_proton_charge,/REMOVE_ALL)
  metadata_array[4] = '#C empty cell proton charge (picoCoulomb): ' + $
    STRCOMPRESS(empty_cell_proton_charge,/REMOVE_ALL)
  metadata_array[5] = '#C A(cm^-1): ' + A
  metadata_array[6] = '#C B(cm^-2): ' + B
  metadata_array[7] = '#C D(cm): ' + D
  metadata_array[8] = '#C Scaling Factor: ' + SF
  metadata_array[9] = '#C distance sample moderator(m): ' + $
    STRCOMPRESS(distance_sample_moderator,/REMOVE_ALL)
  metadata_array[10] = ''
  
  ;retrieve output file name
  folder = getButtonValue(Event,'empty_cell_output_folder_button')
  file_name = getTextFieldValue(Event,'empty_cell_output_file_name_text_field')
  output_file_name = folder + file_name
  
  global_axes_description = '#L time_of_flight(microsecond) data() sigma()'
  single_axes_0 = '#N 3'
  single_axes_1 = "#S Spectrum ID ('bank1',("
  single_axes_2 = ',all))'
  
  OPENW, 1, output_file_name
  
  ;Write the metadata first
  FOR i=0,(nbr_metadata-1) DO BEGIN
    PRINTF, 1, metadata_array[i]
  ENDFOR
  
  FOR pixel=0,255 DO BEGIN
    PRINTF, 1, single_axes_1 + STRCOMPRESS(pixel,/REMOVE_ALL) + single_axes_2
    PRINTF, 1, single_axes_0
    PRINTF, 1, global_axes_description
    FOR tof=0,ntof DO BEGIN
      IF (recap_data[tof,pixel] NE 0) THEN BEGIN
        text = STRCOMPRESS(data_tof_axis[tof],/REMOVE_ALL) + '   '
        text += STRCOMPRESS(recap_data[tof,pixel],/REMOVE_ALL) + '   0'
        PRINTF,1, text
      ENDIF
    ENDFOR
  ENDFOR
  
  CLOSE, 1
  FREE_LUN, 1
  
  ;validate or not the preview button according to success of file creation
  check_empty_cell_recap_output_file_name, Event
  
  WIDGET_CONTROL, HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO check_empty_cell_recap_output_file_name, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  folder = getButtonValue(Event,'empty_cell_output_folder_button')
  file_name = getTextFieldValue(Event,'empty_cell_output_file_name_text_field')
  
  ;recreate full name of file
  full_file_name = folder + file_name
  
  ;check if file name exists or not and if it does, activate PREVIEW
  IF (FILE_TEST(full_file_name)) THEN BEGIN
    activate_preview = 1b
  ENDIF ELSE BEGIN
    activate_preview = 0b
  ENDELSE
  ActivateWidget, Event, 'empty_cell_preview_of_ascii_button', activate_preview
  
  IF (file_name NE '' AND (*global).bRecapPlot EQ 1b) THEN BEGIN
    activate_go = 1b
  ENDIF ELSE BEGIN
    activate_go = 0b
  ENDELSE
  ActivateWidget, Event, 'empty_cell_create_output_file_button', activate_go
  
END

;-------------------------------------------------------------------------------
PRO preview_empty_cell_output_file, Event

  folder = getButtonValue(Event,'empty_cell_output_folder_button')
  file_name = getTextFieldValue(Event,'empty_cell_output_file_name_text_field')
  
  ;recreate full name of file
  full_file_name = folder + file_name
  
  ;preview file
  xdisplayfile, full_file_name, TITLE='Preview of ' + full_file_name[0]
  
  
END