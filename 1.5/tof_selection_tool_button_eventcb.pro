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
;    This returns the min and max TOF values (in ms) defined by the user
;
; :Params:
;    event
;
; :Author: j35
;-
function get_input_tof_min_max, event
  compile_opt idl2
  
  tof_min = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_min'),/REMOVE_ALL)
  IF (tof_min NE '') THEN BEGIN
  
    ON_IOERROR, error_min
    error_status = 1b
    tof_min = FLOAT(tof_min)
    
    IF (isTOFcuttingUnits_microS(Event)) THEN tof_min /= 1000.
    
    error_status = 0b
    
    error_min:
    if (error_status eq 1b) then tof_min = -1.
    
  endif else begin
  
    tof_min = -1.
    
  endelse
  
  
  tof_max = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_max'),/REMOVE_ALL)
  IF (tof_max NE '') THEN BEGIN
  
    ON_IOERROR, error_max
    error_status = 1b
    tof_max = FLOAT(tof_max)
    
    IF (isTOFcuttingUnits_microS(Event)) THEN tof_max /= 1000.
    
    error_status = 0b
    
    error_max:
    if (error_status eq 1b) then tof_max = -1.
    
  endif else begin
  
    tof_max = -1.
    
  endelse
  
  return, [tof_min,tof_max]
end

;+
; :Description:
;    This routine will launch the tof_selection base
;
; :Params:
;    event
;
; :Author: j35
;-
pro tof_selection_tool_button_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  widget_control, /hourglass
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    widget_control, hourglass=0
    
    message_text = ' No data to display!                   '
    title = 'Please load a NeXus file first'
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    result = dialog_message(message_text, $
      /center, $
      dialog_parent=id, $
      /information,$
      title=title)
  endif else begin
  
    run_number = getTextFieldValue(event, 'load_data_run_number_text_field')
    
    ;data
    data = (*(*global).bank1_data)
    ;retrieve tof
    full_nexus_name = (*global).data_full_nexus_name
    if ((*global).instrument eq 'REF_M') then begin
      spin_state = 'Off_Off'
      iNexus = obj_new('IDLnexusUtilities', full_nexus_name, spin_state=spin_state)
      y_axis = indgen(304)
    endif else begin
      iNexus = obj_new('IDLnexusUtilities', full_nexus_name)
      y_axis = indgen(256)
    endelse
    tof_axis = iNexus->get_tof_data()
    
    tof_min_max = get_input_tof_min_max(event)
    
    tof_selection_base, main_base='MAIN_BASE',$
      event=event, $
      offset = 50,$
      tof_min_max = tof_min_max, $
      x_axis = tof_axis,$
      y_axis = y_axis,$
      data = data,$
      run_number= strcompress(run_number[0],/remove_all), $
      file_name = full_nexus_name
      
    widget_control, hourglass=0
    
  endelse
  
end