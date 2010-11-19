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

PRO main_base_event, Event

  ;get global structure
  wWidget = Event.top          ;widget id
  widget_control, wWidget, get_uvalue=global
  
  case (Event.id) of
  
    widget_info(wWidget, find_by_uname='main_base'): BEGIN
    end
    
    ;MENU
    ;view log book button
    widget_info(wWidget, find_by_uname='view_log_book_switch'): begin
    
      view_log_book_id = (*global).view_log_book_id
      if (widget_info(view_log_book_id, /valid_id) eq 0) then begin
        groupID = widget_info(event.top, find_by_uname='main_base')
        
        id = widget_info(wWidget, find_by_uname='main_base')
        geometry = widget_info(id,/geometry)
        
        main_base_xoffset = geometry.xoffset
        main_base_yoffset = geometry.yoffset
        main_base_xsize = geometry.xsize
        ;        main_base_ysize = geometry.ysize
        
        xoffset = main_base_xoffset + main_base_xsize
        yoffset = main_base_yoffset
        
        text = (*(*global).full_log_book)
        
        xdisplayfile, 'LogBook', $
          text=text,$
          height = 70,$
          title='Live Log Book',$
          group = groupID, $
          wtext=view_log_book_id, $
          xoffset = xoffset, $
          yoffset = yoffset
        (*global).view_log_book_id = view_log_book_id
        
      endif
      
    end
    
    ;TAB1
    ;Data run numbers text field
    widget_info(wWidget, find_by_uname='data_run_numbers_text_field'): begin
      widget_control, /hourglass
      data_run_numbers_event, event
      clear_text_field, event=event, uname='data_run_numbers_text_field'
      ;retrieve distances from first data nexus file loaded
      retrieve_data_nexus_distances, event=event
      widget_control, hourglass=0
      check_go_button, event
    end
    
    ;Browse data button
    widget_info(wWidget, find_by_uname='data_browse_button'): begin
      browse_data_button_event, event
      ;retrieve distances from first data nexus file loaded
      retrieve_data_nexus_distances, event=event
      check_go_button, event
    end
    
    ;Normalization run number text field
    widget_info(wWidget, find_by_uname='norm_run_number_text_field'): begin
      widget_control, /hourglass
      norm_run_number_event, event
      widget_control, hourglass=0
      check_go_button, event
    end
    
    ;Browse norm button
    widget_info(wWidget, find_by_uname='norm_browse_button'): begin
      browse_norm_button_event, event
      check_go_button, event
    end
    
    ;full reset
    widget_info(wWidget, find_by_uname='full_reset'): begin
      full_reset, event
    end
    
    ;GO REDUCTION
    widget_info(wWidget, find_by_uname='go_button'): begin
      go_reduction, event
    end
    
    ;--- tab2 (work with rtof) ----
    
    ;rtof text field
    widget_info(wWidget, find_by_uname='rtof_file_text_field_uname'): begin
      check_preview_rtof_button_status, event
    end
    
    
    
    else:
  endcase
  
end

