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

FUNCTION ask_to_validate_exclusion_input, Event

  message = 'Do you want to validate your exclusion region selection?'
  title = 'Validate Exclusion Region Selection?'
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(message,$
    DIALOG_PARENT = id,$
    /CENTER,$
    /QUESTION,$
    title=title)
  RETURN, result
  
END

;-------------------------------------------------------------------------------
FUNCTION get_nbr_elements_except_jk_line, FileStringArray, nbr_jk

  nbr_lines = N_ELEMENTS(FileStringArray)
  jk_array = STRPOS(FileStringArray,'#jk: ')
  jk = WHERE(jk_array NE -1, nbr_jk)
  RETURN, nbr_lines - nbr_jk
  
END

;------------------------------------------------------------------------------
FUNCTION isJkSliceDataSelected, Event
  uname = 'reduce_jk_tab3_tab2_slice_yes_button'
  value = isButtonSelected(Event, uname)
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION isJkSliceTimeSelected, Event
  uname = 'reduce_jk_tab3_tab2_time_slice'
  value = isButtonSelected(Event, uname)
  RETURN, value
END