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

PRO preview_of_tof, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  wBase = (*global1).wBase
  
  nexus_file_name = (*global1).nexus_file_name
  tof_array = (*(*global1).tof_array)
  s_tof_array = STRCOMPRESS(tof_array,/REMOVE_ALL)
  
  title = 'TOF axis of ' + nexus_file_name
  done_button = 'DONE with TOF axis'

  sz = N_ELEMENTS(tof_array)
  new_tof_array = STRARR(1,sz+1)
  new_tof_array[0] = 'Bin #     TOF Range (microS)'
  index = 1
  WHILE (index LT sz) DO BEGIN
  new_tof_array[index] = STRCOMPRESS(index,/REMOVE_ALL) + $
  '          ' + s_tof_array[index-1] + ' -> ' + $
  s_tof_array[index]
  index++
  ENDWHILE
  XDISPLAYFILE, GROUP=wBase, $
    TITLE=title, $
    TEXT=new_tof_array, $
    DONE_BUTTON=done_button
    
END