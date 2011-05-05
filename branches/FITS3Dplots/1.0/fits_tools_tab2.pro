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

PRO tab2_create_ascii_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).need_to_recalculate_rebinned_step2) THEN BEGIN
    create_p_vs_c_combined_rebinned, Event
  ENDIF
  string_array = create_p_vs_c_ascii_array(Event)
  
  sz = N_ELEMENTS(string_array)
  
  path = getButtonValue(Event,'tab2_where_button')
  full_file_name = getTextFieldValue(Event, 'tab2_file_name')
  file_name = path + full_file_name[0]
  
  OPENW, 1, file_name
  index = 0L
  WHILE (index LT sz) DO BEGIN
    PRINTF, 1, string_array[index]
    index++
  ENDWHILE
  
  CLOSE, 1
  FREE_LUN, 1
  
END

;------------------------------------------------------------------------------
PRO tab2_preview_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).need_to_recalculate_rebinned_step2) THEN BEGIN
    create_p_vs_c_combined_rebinned, Event
  ENDIF
  string_array = create_p_vs_c_ascii_array(Event)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  title = 'Preview of '
  file_name = getTextFieldValue(Event, 'tab2_file_name')
  title = title + file_name[0]
  
  XDISPLAYFILE, '', TEXT=string_array,$
    TITLE = title, $
    GROUP = id, $
    GLOBAL = global
    
END

;------------------------------------------------------------------------------
PRO create_p_vs_c_combined_rebinned, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;bin size of step2
  bin_size = LONG(getTextFieldValue(Event, 'tab2_bin_size_value'))
  bin_size = bin_size[0] ;microS
  
  time_resolution_microS = (*global).time_resolution_microS
  
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  
;  p_array = (*(*global).pPArray)
  p_time_array = (*(*global).pTimeArray)
 
  ;max_time that is determined by the chopper speed
  max_time_chooper = getTextFieldValue(Event,'tab1_max_time') ;ms
  max_time_chooper = FLOAT(max_time_chooper[0]) * 1000. ;to be in microS
  
  ;define new size
  ;new_array_size = LONG(FLOAT(old_sz) / (FLOAT(bin_size)*1000)) ;to be in ns
  new_array_size = max_time_chooper / FLOAT(bin_size)
;  new_array_size = new_array_size[0]
  
  IF (new_array_size NE LONG(new_array_size)) THEN new_array_size++
  new_sz = LONG(new_array_size)
  p_rebinned_array = LONARR(new_sz+1)
  
  big_index = 0
  WHILE (big_index LT nbr_files_loaded) DO BEGIN
  
    time_array = *p_time_array[big_index]
    
    sz = N_ELEMENTS(time_array)
    local_index = 0L
    WHILE (local_index LT sz) DO BEGIN
      time = time_array[local_index]*time_resolution_microS
      ;print, 'time/bin_size: ' + string(time/bin_size)
      p_rebinned_array[LONG(time / bin_size)] += 1
            ++local_index
    ENDWHILE
    
    big_index++
  ENDWHILE
  
  (*(*global).p_rebinned_y_array) = p_rebinned_array
  p_rebinned_x_array = LINDGEN(new_sz+1) * bin_size
  
  (*(*global).p_rebinned_x_array) = p_rebinned_x_array
  
END

;------------------------------------------------------------------------------
PRO define_path, Event, tab=tab

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  ;retrieve infos
  path  = (*global).output_path
  title = 'Select where you want to create the ascii file!'
  folder = DIALOG_PICKFILE(GET_PATH = new_path,$
    DIALOG_PARENT = id, $
    PATH = path,$
    TITLE = title,$
    /DIRECTORY,$
    /READ,$
    /MUST_EXIST)
    
  IF (folder NE '') THEN BEGIN
    (*global).output_path = folder
    putNewButtonValue, Event, 'tab2_where_button', folder
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO update_tab2_pvsc_ascii_file_name, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_fits_file = (*(*global).list_fits_file)
  
  ;get number of fits files loaded
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  
  ;retrieve first part of fits file name (bases on first fits file loaded)
  ;name should be 121609_1 -> 121609
  first_fits_file = list_fits_file[0]
  base_name = FILE_BASENAME(first_fits_file[0])
  name_array = STRSPLIT(base_name,'_',/EXTRACT)
  base_name = name_array[0]
  
  ;create default P vs C file name
  output_file_name = base_name + '_' + STRCOMPRESS(nbr_files_loaded,/REMOVE_ALL)
  IF (nbr_files_loaded EQ 1) THEN BEGIN
    file_prefix = 'file'
  ENDIF ELSE BEGIN
    file_prefix = 'files'
  ENDELSE
  output_file_name += file_prefix + '_PvsC.txt'
  
  putValue, Event, 'tab2_file_name', output_file_name
  
END

;------------------------------------------------------------------------------
PRO check_create_pvsc_button_status, Event, uname=uname
  status = is_create_PvsC_button_enabled(Event,uname=uname)
  activate_widget, Event, 'tab2_create_ascii_file_button', status
END

;------------------------------------------------------------------------------
PRO check_tab2_plot_button_status, Event
  status = is_tab2_plot_button_enabled(Event)
  activate_widget, Event, 'tab2_bin_size_plot', status
  activate_widget, Event, 'tab2_preview_ascii_file_button', status
END