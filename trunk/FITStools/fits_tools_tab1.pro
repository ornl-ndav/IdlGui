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
  
  tab1_table = getTableValue(event=Event, 'tab1_fits_table')
  tab1_table = TRANSPOSE(tab1_table)
  new_tab1_table = STRARR(max_nbr_fits_files)
  
  index = 0
  new_index = 0
  WHILE (index LT max_nbr_fits_files) DO BEGIN
    IF (index LT top_sel OR $
      index GT bottom_sel) THEN BEGIN
      new_tab1_table[new_index] = tab1_table[index]
      new_index++
    ENDIF
    index++
  ENDWHILE
  
  putValueInTable, Event, 'tab1_fits_table', TRANSPOSE(new_tab1_table)
  
END