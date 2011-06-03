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
;    This procedures is reached when the user right click any of the three
;    tables.
;
;
;
; :Keywords:
;    event
;    type
;
; :Author: j35
;-
pro table_right_click, event=event, type=type
  compile_opt idl2
  
  file_name_selected = get_file_selected_of_type(event=event, type=type)
  if (strcompress(file_name_selected[0],/remove_all) eq '') then return
  
  if (tag_names(event, /structure_name) EQ 'WIDGET_CONTEXT') THEN BEGIN
  
    case (type) of
      'data_file': begin
        uname='context_data_file_base'
      end
      'open_beam': begin
        uname='context_open_beam_base'
      end
      'dark_field': begin
        uname='context_dark_field_base'
      end
    endcase
    
    id = widget_info(event.top, find_by_uname=uname)
    widget_displaycontextmenu, event.id, event.X, event.Y, id
  endif
  
end

;+
; :Description:
;    Delete the current rows selected in the 3 tables
;
;
;
; :Keywords:
;    event
;    type
;
; :Author: j35
;-
pro delete_selection, event=event, type=type
  compile_opt idl2
  
  case (type) of
    'data_file': begin
      uname='data_files_table'
    end
    'open_beam': begin
      uname='open_beam_table'
    end
    'dark_field': begin
      uname='dark_field_table'
    end
  endcase
  
  ;row_selected = get_table_row_selected(event=event, uname=uname)
  row_selected = get_table_lines_selected(event=event, uname=uname)
  
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, /use_table_select
  widget_control, id, /delete_rows
  widget_control, id, set_table_select=[-1,-1]
  
  catch, error
  if (error ne 0) then begin ;means table is empty
    catch,/cancel
    widget_control, id, /insert_rows
  endif
  table = getValue(event=event,uname=uname)
  
  full_reset_of_preview_base, event=event
  
end
