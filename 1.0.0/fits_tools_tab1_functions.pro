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

FUNCTION retrieve_data_of_new_file, Event=event, $
    file_name=file_name, $
    sData=sData
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0b
  ENDIF
  
  IF ((*global).SIMULATE_FITS_LOADING EQ 'yes') THEN BEGIN
    
    rand1 = randomu(100L,100)
    rand2 = randomu(200L,100)
    rand3 = randomu(300L,100)
    time = INDGEN(100)
    x    = FIX(rand1 * 100)
    y    = FIX(rand2 * 100)
    pulse = FIX(rand3 * 100)
  
  ENDIF ELSE BEGIN
  
    ;reading file
    sData = mrdfits(file_name, 1, header, status=status)
    
    time = sData.count
    x = sData.x
    y = sData.y
    pulse = sData.p
    
  ENDELSE
  
  index = getFirstEmptyXarrayIndex(event=event)
  
  x_array = (*(*global).pXArray)
  y_array = (*(*global).pYArray)
  p_array = (*(*global).pPArray)
  time_array = (*(*global).pTimeArray)
  
  *x_array[index] = x
  *y_array[index] = y
  *p_array[index] = pulse
  *time_array[index] = time
  
  (*(*global).pXArray) = x_array
  (*(*global).pYArray) = y_array
  (*(*global).pPArray) = p_array
  (*(*global).pTimeArray) = time_array
  
  RETURN, 1b
  
END

;------------------------------------------------------------------------------
FUNCTION tab1_table_not_empty, Event

  tab1_table = TRANSPOSE(getTableValue(event=Event, 'tab1_fits_table'))
  cell1 = STRCOMPRESS(tab1_table[0],/REMOVE_ALL)
  
  IF (cell1 NE '') THEN RETURN, 1b
  RETURN, 0b
  
END

;------------------------------------------------------------------------------
FUNCTION at_last_one_not_empty_selected_cell, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab1_selection = (*global).tab1_selection
  top_sel = tab1_selection[0]
  bottom_sel = tab1_selection[1]
  
  tab1_table = TRANSPOSE(getTableValue(event=Event, 'tab1_fits_table'))
  index = top_sel
  WHILE (index LE bottom_sel) DO BEGIN
    cell1 = STRCOMPRESS(tab1_table[index],/REMOVE_ALL)
    IF (cell1 NE '') THEN RETURN, 1b
    index++
  ENDWHILE
  RETURN, 0b
  
END







