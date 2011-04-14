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

;##############################################################################
;******************************************************************************

;this function creates and update the Q1, Q2, SF... arrays when a file is added
PRO CreateArrays, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

;number of files loaded
(*global).NbrFilesLoaded += 1

Qmin_array  = (*(*global).Qmin_array)
Qmax_array  = (*(*global).Qmax_array)
Q1_array    = (*(*global).Q1_array)
Q2_array    = (*(*global).Q2_array)
SF_array    = (*(*global).SF_array)
angle_array = (*(*global).angle_array)
color_array = (*(*global).color_array)
FileHistory = (*(*global).FileHistory)

Qmin_array = [Qmin_array,0]
Qmax_array = [Qmax_array,0]
Q1_array   = [Q1_array,0]
Q2_array   = [Q2_array,0]
SF_array   = [SF_array,0]

;get current angle value entered
angleValue  = (*global).angleValue
angle_array = [angle_array,angleValue]

colorIndex  = getColorIndex(Event)
color_array = [color_array, colorIndex]
FileHistory = [FileHistory,'']

(*(*global).Qmin_array)  = Qmin_array
(*(*global).Qmax_array)  = Qmax_array
(*(*global).Q1_array)    = Q1_array
(*(*global).Q2_array)    = Q2_array
(*(*global).SF_array)    = SF_array
(*(*global).angle_array) = angle_array
(*(*global).color_array) = color_array
(*(*global).FileHistory) = FileHistory

END

