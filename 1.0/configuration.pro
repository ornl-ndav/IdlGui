;===============================================================================
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
;===============================================================================

;+
; :Description:
;    This routine will load a configuration file and will
;    repopulate all the fields using these infos
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro load_configuration, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  cfg_full_file_name = dialog_pickfile(default_extension='.cfg', $
    dialog_parent=id, $
    path=path, $
    /read, $
    filter = '*.cfg', $
    get_path=new_path, $
    title = 'Load configuration file')
    
  if (cfg_full_file_name[0] eq '') then return
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    message_text = ['Configuration file failed to load!','',$
      ' File: ' + cfg_full_file_name[0], $
      'File format is not supported by this application']
    result = dialog_message (message_text,$
      /error,$
      /center,$
      dialog_parent=id,$
      title = 'Configuration file failed to load!')
      
    message = 'Loading of configuration file: ' + cfg_full_file_name[0] + $
      ' ... FAILED!'
    Log_book_update, event, message=message
    
  endif else begin
  
    (*global).config_path = new_path
    restore, filename=cfg_full_file_name, /relaxed_structure_assignment
    
    repopulate_gui, event, cfg_structure
    
    message = 'Loading of configuration file: ' + cfg_full_file_name[0] + $
      ' ... OK!'
    Log_book_update, event, message=message
    
  endelse
  
end

;+
; :Description:
;    This function will create a structure of all the settings and parameters
;    used in the application
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function retrieve_cfg_structure, event
  compile_opt idl2
  
  iStructure = obj_new("IDLconfiguration")
  _structure = iStructure.getConfig(event)
  obj_destroy, iStructure
  
  return, _structure
end

;+
; :Description:
;    This routine is going to ask the user for a configuration file name
;    and will save the configuration currently in used
;
; :Keywords:
;    event
;
;
;
; :Author: j35
;-
pro save_configuration, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  cfg_full_file_name = dialog_pickfile(default_extension='.cfg',$
    dialog_parent=id, $
    filter='*.cfg',$
    /overwrite_prompt, $
    path=path, $
    /write,$
    get_path=new_path, $
    title='Save configuration file')
    
  if (cfg_full_file_name[0] eq '') then return
  
  cfg_structure = retrieve_cfg_structure(event)
  (*global).config_path = new_path
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    message_text = ['Error while trying to create the configuration',$
      cfg_full_file_name,'','Please contact j35@ornl.gov to investigate error',$
      '','Configuration not save !']
    result = dialog_message(message_text, $
      /error, $
      dialog_parent=id,$
      /center, $
      title = 'Configuration not saved!')
    text = 'Save configuration file: ' + cfg_full_file_name[0] + ' FAILED!'
    Log_book_update, Event, message=text
    
    message = 'Saving configuration into file: ' + cfg_full_file_name[0] + $
      ' ... FAILED!'
    Log_book_update, event, message=message
    
  endif else begin
  
    save, cfg_structure, filename=cfg_full_file_name
    
    text = 'Saved configuration file: ' + cfg_full_file_name[0]
    Log_book_update, Event, message=text
    
    message = 'Saving configuration into file: ' + cfg_full_file_name[0] + $
      ' ... OK!'
    Log_book_update, event, message=message
    
  endelse
  
end

;+
; :Description:
;    repopulate the application using the config structure retrieved
;
; :Params:
;    event
;    _structure
;
;
;
; :Author: j35
;-
pro repopulate_gui, event, _structure
  compile_opt idl2
  
  ;reset tables
  reset_table, event=event, uname = 'data_files_table'
  reset_table, event=event, uname = 'open_beam_table'
  reset_table, event=event, uname = 'dark_field_table'
  
  ;data files
  data_files = _structure.list_data_files
  id = widget_info(event.top, find_by_uname='data_files_table')
  widget_control, id, insert_rows=n_elements(data_files)-1
  table = reform(data_files,1,n_elements(data_files))
  putValue, event=event, 'data_files_table', table
  
  ;open beam
  open_beam_files = _structure.list_open_beam_files
  id = widget_info(event.top, find_by_uname='open_beam_table')
  widget_control, id, insert_rows=n_elements(open_beam_files)-1
  table = reform(open_beam_files,1,n_elements(open_beam_files))
  putValue, event=event, 'open_beam_table', table
  
  ;dark field
  df_files = _structure.list_dark_field_files
  id = widget_info(event.top, find_by_uname='dark_field_table')
  widget_control, id, insert_rows=n_elements(df_files)-1
  table = reform(df_files,1,n_elements(df_files))
  putValue, event=event, 'dark_field_table', table
  
  ;file currently selected
  select_file, event=event, uname='data_files_table', $
    _structure.selected_data_file
  select_file, event=event, uname='open_beam_table', $
    _structure.selected_open_beam_file
  select_file, event=event, uname='dark_field_table', $
    _structure.selected_dark_field_file
    
  ;name of file currently previewed
  putValue, event=event, 'preview_file_name_label', _structure.preview_file
    
  ;is with gamma or not
  setButton, event=event, uname='with_gamma_filtering_uname', $
    _structure.is_with_gamma_filtering
    
  ;roi
  putValue, event=event, 'roi_text_field_uname', _structure.roi_loaded
  
  ;output folder
  putValue, event=event, 'output_folder_button', _structure.output_folder
  
  ;output file format
  setButton, event=event, uname='format_tiff_button', $
    _structure.is_tiff_selected
  setButton, event=event, uname='format_fits_button', $
    _structure.is_fits_selected
  setButton, event=event, uname='format_png_button', $
    _structure.is_png_selected
    
    ;display preview of file selected
  type = _structure.type
  preview_currently_selected_file, event=event, type=type
    
end