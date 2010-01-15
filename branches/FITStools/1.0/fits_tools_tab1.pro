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

PRO remove_selected_tab1_fits_files, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  max_nbr_fits_files = (*global).max_nbr_fits_files
  tab1_selection = (*global).tab1_selection
  top_sel = tab1_selection[0]
  bottom_sel = tab1_selection[1]
  
  new_list_fits_file = STRARR(max_nbr_fits_files)
  list_fits_file = (*(*global).list_fits_file)
  
  tab1_table = getTableValue(event=Event, 'tab1_fits_table')
  tab1_table = TRANSPOSE(tab1_table)
  new_tab1_table = STRARR(max_nbr_fits_files)
  
  index = 0
  new_index = 0
  WHILE (index LT max_nbr_fits_files) DO BEGIN
    IF (index LT top_sel OR $
      index GT bottom_sel) THEN BEGIN
      new_list_fits_file[new_index] = list_fits_file[index]
      new_tab1_table[new_index] = tab1_table[index]
      new_index++
    ENDIF
    index++
  ENDWHILE
  
  putValueInTable, Event, 'tab1_fits_table', TRANSPOSE(new_tab1_table)
  
  x_array = (*(*global).pXArray)
  y_array = (*(*global).pYArray)
  p_array = (*(*global).pPArray)
  time_array = (*(*global).pTimeArray)
  (*(*global).list_fits_file) = new_list_fits_file
  
  max_nbr_fits_files = (*global).max_nbr_fits_files
  new_x_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  new_y_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  new_p_array    = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  new_time_array = PTRARR(max_nbr_fits_files,/ALLOCATE_HEAP)
  
  last_index = getFirstEmptyXarrayIndex(event=event) + 1
  index = 0
  new_index = 0
  
  IF (last_index GT 1) THEN BEGIN
    WHILE (index LT last_index) DO BEGIN
      IF (index LT top_sel OR $
        index GT bottom_sel) THEN BEGIN
        
        temp_array = *x_array[index]
        *new_x_array[new_index] = temp_array
        
        temp_array = *y_array[index]
        *new_y_array[new_index] = temp_array
        
        temp_array = *p_array[index]
        *new_p_array[new_index] = temp_array
        
        temp_array = *time_array[index]
        *new_time_array[new_index] = temp_array
        
        new_index++
      ENDIF
      index++
    ENDWHILE
  ENDIF
  
  (*(*global).pXArray)    = new_x_array
  (*(*global).pYArray)    = new_y_array
  (*(*global).pPArray)    = new_p_array
  (*(*global).pTimeArray) = new_time_array
  
END

;------------------------------------------------------------------------------
PRO tab1_right_click_data_preview, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab1_selection = (*global).tab1_selection
  index = tab1_selection[0]
  
  x_array = (*(*global).pXArray)
  y_array = (*(*global).pYArray)
  p_array = (*(*global).pPArray)
  time_array = (*(*global).pTimeArray)
  
  xarray  = *x_array[index]
  yarray  = *y_array[index]
  parray  = *p_array[index]
  tarray  = *time_array[index]
  
  max_time = MAX(tarray,MIN=min_time)
  max_time *= (*global).time_resolution_microS
  min_time *= (*global).time_resolution_microS
  info_array1 = '#Min time recorded: ' + STRCOMPRESS(min_time,/REMOVE_ALL)
  info_array1 += ' microS'
  info_array2 = '#Max time recorded: ' + STRCOMPRESS(max_time,/REMOVE_ALL)
  info_array2 += ' microS ('
  info_array2 += STRCOMPRESS(float(max_time)/1000.,/REMOVE_ALL) + ' mS)'
  info_array3 = ''
  info_array = [info_array1, info_array2, info_array3]
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    data_array = data_array[0:i-1]
  ENDIF ELSE BEGIN
  
    data_array = STRARR(5002L)
    data_array[0] = '#X  Y  P  time(*25ns)'
    FOR i=1,5001L DO BEGIN
      x = STRCOMPRESS(xarray[i-1],/REMOVE_ALL)
      y = STRCOMPRESS(yarray[i-1],/REMOVE_ALL)
      p = STRCOMPRESS(parray[i-1],/REMOVE_ALL)
      t = STRCOMPRESS(tarray[i-1],/REMOVE_ALL)
      data_array[i] = x + ' ' + y + ' ' + p + ' ' + t
    ENDFOR
    
  ENDELSE
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  list_fits_file = (*(*global).list_fits_file)
  tab1_selection = (*global).tab1_selection
  index = tab1_selection[0]
  file_name = list_fits_file[index]
  short_file_name = FILE_BASENAME(file_name)
  title = 'X, Y, P and C for first 5000 events of file -> ' + short_file_name
  
  XDISPLAYFILE, '', TEXT=[info_array,data_array],$
    /EDITABLE, $
    TITLE = title, $
    GROUP = id, $
    PATH=(*global).output_path, $
    GLOBAL=global
    
END