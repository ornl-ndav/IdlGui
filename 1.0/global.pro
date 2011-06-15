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

FUNCTION getGlobal
compile_opt idl2

  file = OBJ_NEW('idlxmlparser', '.iMars.cfg')
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = get_ucams()
  ENDELSE
  
  ;define global variables
  global = ptr_new ({ $
    version:           VERSION,$
    application:       APPLICATION, $
    
    top_base: 0L, $
    
    ;progress bar
    pb_number_of_steps: 1, $  ;total number of steps of the progress bar
    pb_each_step_xsize: 1, $ ;device size of the steps
    pb_ysize: 10, $ ;ysize of the progres bar
    pb_step: 0, $ ;where we are in the progress
    
    ;list of all the buttons of the main base
    list_button_main_base: ['zoom','contrast','metadata'], $
    preview_file_metadata: ptr_new(0L), $ ;metadata files file
    
    normalized_plot_base_id: 0L, $
    
    ;can be either 'data_file', 'open_beam' or 'dark_field'
    current_type_selected: '', $
    
    ;x and y size of data previewed
    size_preview_data: intarr(2), $
    preview_data: ptr_new(0L), $
    
    log_book: ptr_new(0L), $
    log_book_id: 0L, $
    log_book_path: '~/', $
    log_book_file_name_prefix: '.iMars',$
    log_book_file_name_suffix: 'log',$
    
    ;['smooth','lee filtering']
    gamma_filtering: 0, $
    gamma_filtering_coeff: 5, $
    
    ;['mean','min'] multi_selection
    multi_selection: 0, $
    
    ;rotation 0:0degree, 1:90degrees, 2:180degrees, 3:270degrees
    settings_rotation: 0, $
    
    ;transpose   0:no   1:yes
    settings_transpose: 0, $
        
    ;settings base
    settings_base_id: 0L, $
    
    ;list of zoom/preview base ids
    list_of_preview_display_base: ptr_new(0L), $
    
    full_log_book: ptr_new(0L), $
    new_log_book_message: ptr_new(0L), $
    
    path: '~/', $
    config_path: '~/', $
    
    file_extension: 'fits',$
    file_filter: '*fits',$
    
    last_term: 0L$
    })
    
  return, global
  
end
