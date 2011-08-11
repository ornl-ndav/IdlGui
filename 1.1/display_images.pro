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

;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    global
;
; :Keywords:
;    main_base
;    event
;    status   ;1 for file found, 0 for not file not found
;
; :Author: j35
;-
PRO display_file_found_or_not, main_base=main_base, $
    event=event, $
    status=status
    compile_opt idl2
          
  case (status) OF
    0: BEGIN ;file not found
      mode1 = read_png('SOS_images/not_found_file.png')
    END
    1: BEGIN ;activate previous button
      mode1 = read_png('SOS_images/found_file.png')
    END
  ENDCASE
  
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode1_id = WIDGET_INFO(MAIN_BASE, $
    FIND_BY_UNAME='rtof_nexus_file_status_uname')
  ENDIF ELSE BEGIN
    mode1_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='rtof_nexus_file_status_uname')
  ENDELSE
  
  ;mode1
  WIDGET_CONTROL, mode1_id, GET_VALUE=id
  WSET, id
  TV, mode1, 0,0,/true
  
END

;+
; :Description:
;    display the Sample widget draw button
;
; :Keywords:
;    main_base
;    event
;    status   0:for off and 1: for on
;
; :Author: j35
;-
pro display_output_sample_button, main_base=main_base, $
event=event, $
status=status
compile_opt idl2

  case (status) OF
    0: BEGIN ;file not found
      mode1 = read_png('SOS_images/sample_off.png')
    END
    1: BEGIN ;activate previous button
      mode1 = read_png('SOS_images/sample_on.png')
    END
  ENDCASE
  
  uname = 'example_of_output_format_draw'
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode1_id = WIDGET_INFO(MAIN_BASE, $
    FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode1_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode1
  WIDGET_CONTROL, mode1_id, GET_VALUE=id
  WSET, id
  TV, mode1, 0,0,/true


end
