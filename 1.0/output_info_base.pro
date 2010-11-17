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
pro output_info_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_info
  
  case Event.id of
  
    ;base file name text field
    widget_info(event.top, find_by_uname='base_file_name'): begin
      value = getValue(event=event, uname='base_file_name')
      if (strcompress(value,/remove_all) eq '') then begin
        status_go = 0
      endif else begin
        status_go = 1
      endelse
      activate_button, event=event, $
        status = status_go, $
        uname='ok_output_info_base'
    end
    
    ;output folder button
    widget_info(event.top, find_by_uname='base_output_folder'): begin
      current_path = getValue(event=event, uname='base_output_folder')
      title = 'Select output folder'
      new_path = dialog_pickfile(path=current_path,$
        /must_exist,$
        /directory,$
        title = title)
      putValue, event=event, 'base_output_folder', new_path
    end
    
    ;cancel button
    widget_info(event.top, find_by_uname='cancel_output_info_base'): begin
          id = widget_info(Event.top, $
        find_by_uname='output_info_base')
      widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

pro output_info_base_gui, wBase, $
    parent_base_geometry, $
    output_folder = output_folder, $
    default_base_file = default_base_file
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize/2
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset+100
  
  ourGroup = WIDGET_BASE()
  
  title = 'Output of info selections: file/plots'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'output_info_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    scr_xsize    = 450,$
    scr_ysize    = 250, $
    kill_notify  = 'output_info_base_killed', $
    /column,$
    /modal, $
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  ;counts vs Qx and Qz part
  part1 = widget_base(wBase,$
    /row,$
    frame=1)
    
  space = widget_label(part1,$
    value = '    ')
    
  part11 = widget_base(part1,$
    /column)
    
  row1 = widget_label(part11,$
    value = 'Counts vs Qx')
  row1Base = widget_base(part11,$
    /row)
  row1col2Base = widget_base(row1Base,$
    /column,$
    /nonexclusive)
  button1 = widget_button(row1col2Base,$
    value = 'ascii file (_IvsQx.txt)',$
    uname = 'qx_ascii_file')
  widget_control, button1, /set_button
  button2 = widget_button(row1col2Base,$
    value = 'jpeg (_IvsQx.jpg)',$
    uname = 'qx_jpg_file')
    
  space = widget_label(part1,$
    value = '    ')
    
  part12 = widget_base(part1,$
    /column)
    
  row1 = widget_label(part12,$
    value = 'Counts vs Qz')
  row1Base = widget_base(part12,$
    /row)
  row1col2Base = widget_base(row1Base,$
    /column,$
    /nonexclusive)
  button1 = widget_button(row1col2Base,$
    value = 'ascii file (_IvsQz.txt)',$
    uname = 'qz_ascii_file')
  widget_control, button1, /set_button
  button2 = widget_button(row1col2Base,$
    value = 'jpeg (_IvsQz.jpg)',$
    uname = 'qz_jpg_file')
    
  space = widget_label(wBase,$
    value = ' ')
    
  ;path and name
  part2 = widget_base(wBase,$
    /column,$
    frame=1)
    
  row1 = widget_base(part2,$
    /row)
  label = widget_label(row1,$
    value = 'Base file name')
  name = widget_text(row1,$
    value = default_base_file,$
    /all_events, $
    xsize = 54,$
    /editable,$
    uname = 'base_file_name')
    
  where = widget_button(part2,$
    value = output_folder,$
    uname = 'base_output_folder',$
    scr_xsize = 440)
    
  space = widget_label(wBase,$
    value = ' ')
    
  row3 = widget_base(wBase,$
    /align_center,$
    /row)
  cancel = widget_button(row3,$
    value = 'CANCEL',$
    scr_xsize = 130,$
    uname = 'cancel_output_info_base')
  space = widget_label(row3,$
    value = '           ')
  ok = widget_button(row3,$
    value = 'OK',$
    scr_xsize = 200,$
    uname = 'ok_output_info_base')
    
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
pro output_info_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  ;get global structure
  widget_control,id,get_uvalue=global_info
  event = (*global_info).parent_event
  refresh_plot, event
  
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
pro output_info_base_cleanup, tlb
  compile_opt idl2
  widget_control, tlb, get_uvalue=global_info, /no_copy
  if (n_elements(global_info) eq 0) then return
  ptr_free, global_info
end

;+
; :Description:
;   base that will show the x, y, counts values
;   as well as the counts vs tof and counts vs pixel of cursor
;   position
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro output_info_base, event=event, $
    parent_base_uname = parent_base_uname, $
    output_folder = output_folder, $
    default_base_file = default_base_file
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = ''
  output_info_base_gui, _base, $
    parent_base_geometry, $
    output_folder = output_folder, $
    default_base_file = default_base_file
    
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    parent_event: event, $
    output_folder: output_folder, $
    global: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "output_info_base", _base, GROUP_LEADER = ourGroup, /no_block, $
    cleanup='output_info_base_cleanup'
    
end

