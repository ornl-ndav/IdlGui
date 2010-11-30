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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

pro check_go_button, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global
  tab_id = widget_info(event.top,find_by_uname='tab_uname')
 endif else begin
  widget_control, base, get_uvalue=global
  tab_id = widget_info(base,find_by_uname='tab_uname')
endelse
  CurrTabSelect = widget_info(tab_id,/tab_current)
  
  activate_go_button = 1
  
  case (CurrTabSelect) of
    0: begin ;working with NeXus
    
      activate_go_button = 1
      big_table = getValue(event=event,base=base,uname='tab1_table')
      if (big_table[0,0] eq '') then begin
        activate_go_button = 0
      endif else begin
        first_empty_row = get_first_empty_row_index(big_table, type='data')
        _index = 0
        while(_index lt first_empty_row) do begin
          if (big_table[1,_index] eq '') then begin
            activate_go_button = 0
            break
          endif
          _index++
        endwhile
      endelse
    end
    
    1: begin ;working with rtof
    
      activate_go_button = 0
      
    end
    
    else:
    
  endcase
  
  activate_button, event=event, $
    main_base=base, $
    status= activate_go_button, $
    uname= 'go_button'
    
end