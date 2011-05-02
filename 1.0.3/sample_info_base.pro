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
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro sample_info_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_info
  main_event = (*global_info).main_event
  
  case Event.id of
  
    else:
    
  endcase
  
end

;+
; :Description:
;    Create the text that will be displayed in the text field
;
; :Keywords:
;   file_type   ;ex 'xy Many z'
;
; :Returns:
;    text to display
;
; :Author: j35
;-
function create_sample_text, file_type=file_type
  compile_opt idl2
  
  if (strlowcase(strcompress(file_type,/remove_all)) eq 'xymanyz') then begin

  _final_text = strarr(6)
  _final_text[0] = ['Qx0   Qz0   I(Qx0,Qz0)   I(Qx0,Qz1)    I(Qx0,Qz2)   ' + $
  'I(Qx0,Qz3)   I(Qx0,Qz4)   I(Qx0,Qz5)']
  _final_text[1] = ['Qx1   Qz1   I(Qx1,Qz0)   I(Qx1,Qz1)    I(Qx1,Qz2)   ' + $
  'I(Qx1,Qz3)   I(Qx1,Qz4)   I(Qx1,Qz5)']
  _final_text[2] = ['Qx2   Qz2   I(Qx2,Qz0)   I(Qx2,Qz1)    I(Qx2,Qz2)   ' + $
  'I(Qx2,Qz3)   I(Qx2,Qz4)   I(Qx2,Qz5)']
  _final_text[3] = ['Qx3   Qz3   I(Qx3,Qz0)   I(Qx3,Qz1)    I(Qx3,Qz2)   ' + $
  'I(Qx3,Qz3)   I(Qx3,Qz4)   I(Qx3,Qz5)']
  _final_text[4] = ['      Qz4']
  _final_text[5] = ['      Qz5']
  
  return, _final_text
  endif

  return, 'N/A'
  
end

;+
; :Description:
;    builds the gui
;
; :Params:
;    wBase
;    parent_base_geometry
;
; :Keywords:
;    time_stamp
;    metadata
;    text
;    file_type      ;ex: 'xy Many z'
;
; :Author: j35
;-
pro sample_info_base_gui, wBase, $
    parent_base_geometry, $
    text=text, $
    file_type=file_type
      compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  
  xoffset = main_base_xoffset + 280
  yoffset = main_base_yoffset + 245 
  
  ourGroup = WIDGET_BASE()
  
  title = 'Sample for file format: ' + file_type
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'sample_info_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
   
  xsize_array = strlen(text)
  xsize = max(xsize_array)
  ysize = n_elements(text) 
      
  text = widget_text(wBase,$
    value = text,$
   xsize = xsize, $
   ysize = ysize, $
    /scroll)
    
end

;+
; :Description:
;
;
; :Keywords:
;    event
;    file_type   ;ex: 'xy Many z'
;
; :Author: j35
;-
pro sample_info_base, event=event, file_type=file_type

  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base')
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;parent base geometry
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = ''
  text = create_sample_text(file_type=file_type)
  sample_info_base_gui, _base, $
    parent_base_geometry, $
    text=text,$
    file_type=file_type
    
  (*global).sample_info_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    parent_event: event, $
    global: global })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "sample_info_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK
  
end

