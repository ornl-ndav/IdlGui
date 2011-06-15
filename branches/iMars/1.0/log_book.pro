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
;    Display the log book
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_log_book, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;do not bring to life a new log book as there is already one activated
  if (widget_info((*global).log_book_id,/valid_id) eq 1) then return
  
  log_book = (*(*global).log_book)
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  geometry = widget_info(id, /geometry)
  xsize = geometry.xsize
  ysize = geometry.ysize
  xoffset = geometry.xoffset
  yoffset = geometry.yoffset
  
  xdisplayfile, '',$
    title='Log Book',$
    width=50,$
    height=50,$
    xoffset = xsize+xoffset,$
    yoffset = yoffset,$
    group=id,$
    text=log_book,$
    /editable,$
    wtext = log_book_id
    
  (*global).log_book_id = log_book_id
  
end

;+
; :Description:
;    This procedure retrieves the current contain of the log book
;    and update it with the new message fromt the global variable
;    called 'new_log_book_message' if the keywords message is not passed
;
; :Params:
;    event
;
; :Keywords:
;   message
;
; :Author: j35
;-
pro log_book_update, event, message=message
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (keyword_set(message)) then begin
    new_message = message
  endif else begin
    new_message = (*(*global).new_log_book_message)
  endelse
  
  time = get_time()
  new_message[0] = '['+time+']>' + string(new_message[0])
  log_book = (*(*global).log_book)
  
  log_book = [new_message, log_book]
  (*(*global).log_book) = log_book
  
  log_book_id = (*global).log_book_id
  if (widget_info(log_book_id,/valid_id) eq 0) then return
  
  widget_control, log_book_id, set_value=log_book
  
end

;+
; :Description:
;   Reset the log book
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro reset_log_book, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;initialize log book message
  log_book = ['------------------------------------------------------------',$
    'Log Book of iMars']
  (*(*global).log_book) = log_book
  
  log_book_update, event, message='Reset log book'
  
end

;+
; :Description:
;    This routines save the log book when the application is terminated
;
;
;
; :Keywords:
;    base
;    event
;    file_name
;
; :Author: j35
;-
pro save_log_book, base=base, event=event, file_name=file_name
  compile_opt idl2
  
  if (keyword_set(base)) then begin
  widget_control, base, get_uvalue=global
  endif else begin
  widget_control, event.top, get_uvalue=global
  endelse
  
  log_book = (*(*global).log_book)
  prefix = (*global).log_book_file_name_prefix
  suffix = (*global).log_book_file_name_suffix
  path = (*global).log_book_path
  time_stamp =  GenerateIsoTimeStamp()
  log_book_file_name = path + prefix + '_' + time_stamp + '.' + suffix
  
  openw, 1, log_book_file_name
  
  sz = n_elements(log_book)
  _index=0
  while (_index lt sz) do begin
  
    printf, 1, log_book[_index]
    
    _index++
  endwhile
  
  close, 1
  free_lun, 1
  
  file_name = log_book_file_name
  
end


