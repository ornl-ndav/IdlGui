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
;    this routine will load the configuration file
;
; :Params:
;    event
;
; :Author: j35
;-
pro load_configuration_function, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Select the TOF configuration file you want to load!'
  tof_config_path = (*global).tof_config_path
  
  file_name = dialog_pickfile(default_extension='config',$
    /must_exist, $
    filter=['*.config'],$
    dialog_parent=id,$
    title=title,$
    path=tof_config_path,$
    get_path=new_path)
    
  if (file_name[0] ne '') then begin
  
    load_configuration_file, event=event, $
      file_name=file_name[0], $
      new_path=new_path
      
  endif
  
end

;+
; :Description:
;    This procedures takes the config file name given as argument and
;    load the tof config. file
;
; :Keywords:
;    event
;    base
;    file_name
;    new_path
;
; :Author: j35
;-
pro load_configuration_file, event=event, $
    base=base, $
    file_name=file_name, $
    new_path=new_path
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global
  endif else begin
    widget_control, base, get_uvalue=global
  endelse
  
  (*global).tof_config_path = new_path
  (*global).current_tof_config_file_name = file_name[0]
  
  file = obj_new('idlxmlparser',file_name[0])
  if (~obj_valid(file)) then return
   
  min_tof = file->getValue(tag=['configuration','tof','min'])
  if (min_tof eq -1) then return
  max_tof = file->getValue(tag=['configuration','tof','max'])
  units_tof = file->getValue(tag=['configuration','tof','units'])
  obj_destroy, file
  
  if (min_tof eq 'N/A') then min_tof = ''
  if (max_tof eq 'N/A') then max_tof = ''
  if (units_tof eq 'microS') then begin
    uname = 'reduce_data_tof_units_micros'
  endif else begin
    uname = 'reduce_data_tof_units_ms'
  endelse
  
  if (keyword_set(event)) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  widget_control, id, /set_button
  
  putValue, base=base, event=event, 'tof_cutting_min', $
    strcompress(min_tof[0],/remove_all)
  putValue, base=base, event=event, 'tof_cutting_max', $
    strcompress(max_tof[0],/remove_all)
    
end

;+
; :Description:
;    This routine will save the configuration file
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro save_configuration_function, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Define or pick a TOF configuration file!'
  tof_config_path = (*global).tof_config_path
  
  file_name = dialog_pickfile(default_extension='config',$
    filter=['*.config'],$
    dialog_parent=id,$
    title=title,$
    /write, $
    path=tof_config_path,$
    get_path=new_path)
    
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    title = 'Error while saving the TOF configuration file!'
    message_text = ['TOF paramters have not been saved !                      ']
    
    result = dialog_message(message_text, $
      dialog_parent=id,$
      /error,$
      /center, $
      title=title)
      
    return
  endif
  
  if (file_name[0] ne '') then begin
  
    (*global).tof_config_path = new_path
    (*global).current_tof_config_file_name = file_name[0]
    
    min_tof = strcompress(getValue(event=event, $
      uname='tof_cutting_min'),/remove_all)
    max_tof = strcompress(getValue(event=event, $
      uname='tof_cutting_max'),/remove_all)
      
    if (min_tof eq '') then min_tof='N/A'
    if (max_tof eq '') then max_tof='N/A'
    
    if (isTOFcuttingUnits_microS(Event)) then begin
      units_tof = 'microS'
    endif else begin
      units_tof = 'ms'
    endelse
    
    ;define the file
    config_array = ['<configuration>',$
      '   <tof>',$
      '      <min>' + min_tof + '</min>',$
      '      <max>' + max_tof + '</max>',$
      '      <units>' + units_tof + '</units>', $
      '   </tof>',$
      '</configuration>']
      
    sz = n_elements(config_array)
    openw, 1 , file_name[0]
    for i=0,(sz-1) do begin
      printf, 1, config_array[i]
    endfor
    close, 1
    free_lun, 1
    
  endif
  
  title = 'TOF configuration file has been saved!'
  message_text = ['Parameters saved:                                         ',$
    '',$
    '   min TOF : ' + min_tof[0] + ' ' + units_tof[0], $
    '   max TOF : ' + max_tof[0] + ' ' + units_tof[0], $
    '','',$
    'Config file name: ' + file_name[0]]
    
  result = dialog_message(message_text, $
    dialog_parent=id,$
    /center, $
    /information, $
    title=title)
    
end