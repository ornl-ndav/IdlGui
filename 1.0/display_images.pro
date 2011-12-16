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
;    This routine initialize all the images of the main GUI
;
;
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro initialize_all_images, main_base=main_base, $
    event=event
  compile_opt idl2
  
  if (keyword_set(main_base)) then begin
    widget_control, main_base, get_uvalue=global
  endif else begin
    widget_control, event.top, get_uvalue=global
  endelse
  
  list_button = (*global).list_button_main_base
  sz = n_elements(list_button)
  _index=0
  while (_index lt sz) do begin
  
    display_images, main_base=main_base, $
      event=event, $
      button=list_button[_index], $
      status='off'
      
    _index++
  endwhile
  
end

;+
; :Description:
;    This procedure displays the images of the main base
;    (zoom, contrast and metadata)
;
; :Keywords:
;    main_base
;    event
;    button     from the list ['metadata','zoom','contrast']
;    status     ['on','off']
;
; :Author: j35
;-
pro display_images, main_base=main_base, $
    event=event, $
    button=button, $
    status=status
  compile_opt idl2
  
  ;uname of the widget_draw where to display the image
  draw_uname = button + '_uname'
  png_path = 'iMars_images' + path_sep()
  png_suffix = '.png'
  png_file_name = png_path + button + '_' + status + png_suffix
  
  ;read the png file
  png = read_png(png_file_name)
  
  if (keyword_set(main_base)) then begin
    id = widget_info(main_base, $
      find_by_uname=draw_uname)
  endif else begin
    id = widget_info(event.top, $
      find_by_uname=draw_uname)
  endelse
  
  widget_control, id, get_value=value_id
  wset, value_id
  tv, png, 0,0, /true
  
end

;+
; :Description:
;    This routine adds the ORNL logo to the bottom of the application
;
;
;
; :Keywords:
;    main_base
;
; :Author: j35
;-
pro display_logo, main_base=main_base
compile_opt idl2

logo_file_name = 'iMars_images' + path_sep() + 'ornl_logo.png'

png = read_png(logo_file_name)
if (keyword_set(main_base)) then begin
  id = widget_info(main_base, $
  find_by_uname='logo_uname')
  endif else begin
  id = widget_info(event.top, $
  find_by_uname='logo_uname')
  endelse
  
  widget_control, id, get_value=value_id
  wset, value_id
  tv, png, 0,0, /true
  
end

