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

FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTableValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
;this function returns the first row and column of the selection
FUNCTION getCellSelectedTab1, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, selection[0:1]
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTab2_cl_array, Event
  path = getButtonValue(Event,'tab2_manual_input_folder')
  path = STRCOMPRESS(path,/REMOVE_ALL)
  prefix = getTextFieldValue(Event,'tab2_manual_input_suffix_name')
  prefix = STRCOMPRESS(prefix,/REMOVE_ALL)
  suffix = getTextFieldValue(Event,'tab2_manual_input_prefix_name')
  suffix = STRCOMPRESS(suffix,/REMOVE_ALL)
  cl_text_array = STRARR(2)
  cl_text_array[0] = path + prefix+ '_'
  cl_text_array[1] = '.' + suffix
  RETURN, cl_text_array
END

;------------------------------------------------------------------------------
FUNCTION getSelectionButtonValue, Event
  uname_list = ['selection_1','selection_2','selection_3']
  sz = 3
  FOR i=0,(sz-1) DO BEGIN
    value = getTextFieldValue(Event,uname_list[i])
    IF (value NE '') THEN RETURN, i+1
  ENDFOR
  return, -1
END

