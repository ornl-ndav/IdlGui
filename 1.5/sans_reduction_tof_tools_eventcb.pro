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

PRO populate_tof_tools_base, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tof_counts = (*(*global).tof_counts)
  tof_tof = (*(*global).array_of_tof_bins)
  
  sz = N_ELEMENTS(tof_tof)
  
  tof_base = (*global).tof_tools_base
  
  ;populate 'display a predefined tof range'
  ;select everything by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-2
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
  ;populate 'play tofs'
  ;select first 10 bins by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-2
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
END
