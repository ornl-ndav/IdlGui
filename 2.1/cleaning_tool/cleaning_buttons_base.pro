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
pro cleaning_buttons_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_buttons
  main_base_id = (*global_buttons).main_base_id
  global_plot = (*global_buttons).global_plot
  
  case Event.id of
  
    ;cancel button will kill the main cleaning base
    widget_info(event.top, find_by_uname='cancel_cleaning_button'): begin
      widget_control, main_base_id, /destroy
    end
    
    ;remove selected points
    widget_info(event.top, find_by_uname='remove_selected_points_button'): begin
      remove_selected_points, base=main_base_id
      refresh_plot, base=main_base_id
    end
    
    ;full reset
    widget_info(event.top, find_by_uname='full_reset_cleaning_button'): begin
      full_reset_removed_points, base=main_base_id
    end
    
    ;validate cleaning and go back to main application
    widget_info(event.top, $
      find_by_uname='validate_cleaning_and_return_button'): begin
      remove_selected_points, base=main_base_id
      validate_cleaning, base=main_base_id, ok=ok
      if (ok) then begin
        main_event = (*global_plot).main_event
        steps_tab, main_event, 1
        widget_control, main_base_id, /destroy
      endif else begin
        ;inform user than he removed a full data set !!
        message_text = ['Make sure you do not select all the data points of' + $
          ' a same file!']
        title = 'Program is unable to validate your selection!'
        result = dialog_message(message_text, $
          /information,$
          title=title,$
          dialog_parent=main_base_id,$
          /center)
        full_reset_removed_points, base=main_base_id
      endelse
   endelse
end
    
    ;cw_bgroup of spin states repetition
    widget_info(event.top, $
      find_by_uname='validate_cleaning_for_other_spin_states'): begin
      widget_control, event.id, get_value=value
      if (value eq 0) then begin
        (*global_plot). bRepeatOtherSpin = 1b
      endif else begin
        (*global_plot). bRepeatOtherSpin = 0b
      endelse
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Builds the GUI of the X & Y input range base
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro cleaning_buttons_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset + 350
  
  ourGroup = WIDGET_BASE()
  
  title = 'Cleaning interface'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'cleaning_buttons_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /column, $
    kill_notify  = 'cleaning_buttons_base_cleanup', $
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  validate = widget_button(wBase,$
    value = 'REMOVE SELECTED POINTS',$
    uname = 'remove_selected_points_button')
  ;space = widget_label(wBase,$
  ;  value = ' ')
    
  repeat_process = cw_bgroup(wBase,$
    ['Yes','No'],$
    /row,$
    /no_release, $
    /exclusive,$
    uname = 'validate_cleaning_for_other_spin_states',$
    set_value=0,$
    label_left='Perform same cleaning for other spin states:')
    
    
  validate = widget_button(wBase,$
    value = 'VALIDATE CLEANING and RETURN TO MAIN APPLICATION',$
    uname = 'validate_cleaning_and_return_button')
    
  space = widget_label(wBase,$
    value =  ' ')
  last_row = widget_base(wBase,$
    /row)
  full_reset = widget_button(last_row,$
    value = 'FULL RESET',$
    scr_xsize = 100,$
    uname = 'full_reset_cleaning_button')
  space = widget_label(last_row,$
    value = '                         ')
  cancel = widget_button(last_row,$
    value = 'CANCEL',$
    scr_xsize = 100,$
    uname = 'cancel_cleaning_button')
    
    
end

;+
; :Description:
;    Killed routine
;
; :Params:
;    id
;
;
;
; :Author: j35
;-
pro xy_range_base_killed, id
  compile_opt idl2
  
;  catch, error
;  if (error ne 0) then begin
;    catch,/cancel
;    return
;  endif
  
;  ;get global structure
;  widget_control,id,get_uvalue=global_info
;  event = (*global_info).parent_event
  
end

;+
; :Description:
;    Cleanup routine
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro cleaning_buttons_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_buttons, /no_copy
  
  if (n_elements(global_buttons) eq 0) then return
  
  ptr_free, global_buttons
  
end

;+
; :Description:
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro cleaning_buttons_base, event=event, $
    main_base_id=main_base_id, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  endif else begin
    widget_control, main_base_id, get_uvalue=global_plot
    id = main_base_id
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  cleaning_buttons_base_gui, _base, $
    parent_base_geometry
    
  (*global_plot).cleaning_buttons_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_buttons = PTR_NEW({ _base: _base,$
    main_base_id: id, $
    global_plot: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_buttons
  
  XMANAGER, "cleaning_buttons_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='cleaning_buttons_base_cleanup'
    
end

