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
;    This routine save the ROI
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro save_roi, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Save ROIs selection'
  default_extension = 'txt'
  
  file_name = dialog_pickfile(default_extension=default_extension,$
    dialog_parent=id,$
    filter=['*_ROI.txt'],$
    get_path=new_path,$
    path=path,$
    title=title,$
    /overwrite_prompt,$
    /write)
    
  if (file_name[0] ne '') then begin
    (*global).path = new_path
    
    catch, error
    if (error ne 0) then begin
      catch,/cancel
      
      message = 'Saved ROI into file: ' + file_name + ' ... FAILED!'
      log_book_update, event, message=message
      
    endif else begin
    
      file_name = file_name[0]
      pixel_list = getValue(event=event, uname='roi_text_field_uname')
      
      openw, 1 , file_name
      sz = n_elements(pixel_list)
      index=0
      while (index lt sz) do begin
        _line = pixel_list[index]
        if (strcompress(_line,/remove_all) ne '') then printf, 1, _line
        index++
      endwhile
      close, 1
      free_lun, 1
      
      message = 'Saved ROI into file: ' + file_name + ' ... OK!'
      log_book_update, event, message=message
      
    endelse
    
  endif
  
end

;+
; :Description:
;    This routine load the ROI
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro load_roi, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Load ROIs selection'
  default_extension = 'txt'
  
  file_name = dialog_pickfile(default_extension=default_extension,$
    dialog_parent=id,$
    filter=['*_ROI.txt'],$
    get_path=new_path,$
    path=path,$
    title=title,$
    /must_exist,$
    /read)
    
  file_name = file_name[0]
  if (file_name ne '') then begin
    (*global).path = new_path
    
    catch, error
    if (error ne 0) then begin
      catch,/cancel
      
      message = 'Loading of ROI file: ' + file_name + ' ... FAILED!'
      log_book_update, event, message=message
      
    endif else begin
    
      openr, 1, file_name
      nbr_lines = file_lines(file_name)
      pixel_list = strarr(nbr_lines)
      readf, 1, pixel_list
      close,1
      free_lun, 1
      
      putValue, event=event, 'roi_text_field_uname', pixel_list
      
      type = (*global).current_type_selected
      preview_currently_selected_file, event=event, type=type
      
      message = 'Loaded ROI file: ' + file_name + ' ... OK!'
      log_book_update, event, message=message
      
    endelse
    
  endif
  
end

;+
; :Description:
;    This refresh the main preview plot and the ROI on top of it
;    and is reached by the ROI widget_text box.
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro refresh_roi, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  type = (*global).current_type_selected
  preview_currently_selected_file, event=event, type=type
  
  refresh_zoom_base, event=event
  
end

;+
; :Description:
;    This refresh the ROI of the currently opened zoom_base
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro refresh_zoom_base, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  list_id = (*(*global).list_of_preview_display_base)
  clean_list = clean_zoom_base_id(dirty_list=list_id)
  
  nbr_id = n_elements(clean_list)
  _index=0
  while (_index lt nbr_id) do begin
  
    _id = list_id[_index]
    
    plot_zoom_data, base=_id
    plot_zoom_roi, base=_id
    
    _index++
  endwhile
  
end



