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

;------------------------------------------------------------------------------
;- GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES - GENERAL ROUTINES
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
PRO activate_widget, Event, uname, activate_status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SENSITIVE=activate_status
END

;------------------------------------------------------------------------------
;- SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC FUNCTIONS - SPECIFIC 
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
PRO activate_less_more_xaxis_ticks, Event, value
activate_widget, Event, 'x_axis_ticks_base', value
END

;------------------------------------------------------------------------------
PRO display_file_names_transparency, Event, ascii_file_name
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get list of files
list_OF_files = (*(*global).list_OF_ascii_files)
;put list of files in droplist of transparency
putListOfFilesTransparency, Event, list_OF_files 
END

;------------------------------------------------------------------------------
PRO update_transparency_coeff_display, Event
index_selected = getTranFileSelected(Event)
WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (index_selected EQ 0) THEN BEGIN
    value = 'N/A'
ENDIF ELSE BEGIN
    trans_coeff_list = (*(*global).trans_coeff_list)
    coeff = trans_coeff_list[index_selected]
    coeff_percentage = 100*coeff
    putTextFieldValue, Event, 'transparency_coeff', $
      STRCOMPRESS(FIX(coeff_percentage),/REMOVE_ALL)
ENDELSE
END

;------------------------------------------------------------------------------
