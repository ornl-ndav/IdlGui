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

FUNCTION is_create_PvsC_button_enabled, Event, uname=uname

  ON_IOERROR, error
  
  ;if bin size is not 0 or empty
  bin_size = FIX(getTextFieldValue(Event, 'tab2_bin_size_value'))
  IF (bin_size EQ 0) THEN RETURN, 0
  
  ;if there is a file name defined
  file_name = getTextFieldValue(Event, 'tab2_file_name')
  IF (file_name EQ '') THEN RETURN, 0
  
  ;make sure there are at least 1 file name
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  IF (nbr_files_loaded EQ 0) THEN RETURN, 0
  
  RETURN, 1
  
  error:
  title = 'Input Error'
  message_text = 'The bin size you defined is not a valid number!'
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(message_text,$
    title=title,$
    /CENTER,$
    DIALOG_PARENT=id,$
    /ERROR)
    
  IF (N_ELEMENTS(uname) NE 0) THEN BEGIN
    putValue, Event, uname, ''
  ENDIF
  
END

;------------------------------------------------------------------------------
FUNCTION is_tab2_plot_button_enabled, Event

  ON_IOERROR, error
  
  ;if bin size is not 0 or empty
  bin_size = FIX(getTextFieldValue(Event, 'tab2_bin_size_value'))
  IF (bin_size EQ 0) THEN RETURN, 0
  
  ;make sure there are at least 1 file name
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  IF (nbr_files_loaded EQ 0) THEN RETURN, 0
  
  RETURN, 1
  
  error:
  RETURN, 0
  
END

;------------------------------------------------------------------------------
FUNCTION create_p_vs_c_ascii_array, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_fits_file = (*(*global).list_fits_file)
  nbr_files = getFirstEmptyXarrayIndex(event=event)
  commented_lines = STRARR(nbr_files+2) ;add space and axis definition
  index = 0
  WHILE (index LT nbr_files) DO BEGIN
    commented_lines[index] = '# ' + list_fits_file[index]
    index++
  ENDWHILE
  commented_lines[nbr_files] = ''
  commented_lines[nbr_files+1] = 'Time(microS) P(counts)'
  
  p_rebinned_x_array = (*(*global).p_rebinned_x_array)
  p_rebinned_y_array = (*(*global).p_rebinned_y_array)
  
  sz = N_ELEMENTS(p_rebinned_x_array)
  data_array = STRARR(sz)
  index = 0L
  WHILE (index LT sz) DO BEGIN
    x = STRCOMPRESS(p_rebinned_x_array[index],/REMOVE_ALL)
    y = STRCOMPRESS(p_rebinned_y_array[index],/REMOVE_ALL)
    data_array[index ] = x + ' ' + y
    index++
  ENDWHILE
  
  full_ascii_array = [commented_lines,data_array]
  
  RETURN, full_ascii_array
  
END
