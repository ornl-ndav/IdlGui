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
;    Makes the conversion from tof_range value to tof_range index
;
; :Params:
;    tof_range
;    tof_axis
;
; :Author: j35
;-
function get_index_tof_range, tof_range, tof_axis
  compile_opt idl2
  
  tof_min = tof_range[0]
  case (tof_min) of
    -1: tof_axis_min = 0
    else: begin
      _index = where(tof_min ge tof_axis, nbr)
      if (nbr eq 0) then begin
        tof_axis_min = 0
      endif else begin
        tof_axis_min = _index[-1]+1
      endelse
    end
  endcase
  
  tof_max = tof_range[1]
  case (tof_max) of
    -1: tof_axis_max = -1
    else: begin
      _index = where(tof_axis le tof_max, nbr)
      if (nbr eq 0) then begin
        tof_axis_max = -1
      endif else begin
        tof_axis_max = _index[-1]
      endelse
    end
  endcase
  
  return, [tof_axis_min, tof_axis_max]
end

;+
; :Description:
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro discrete_selection_input_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_tof_selection = (*global_info).global_tof_selection
  
  case Event.id of
  
    ;load roi
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_load_button'): begin
      load_discrete_roi_selection, event=event
    end
    
    ;save roi
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_save_button'): begin
      save_discrete_roi_selection, event=event
    end
    
    ;roi text field
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_text_field'): begin
      ;refresh main plot
      base = (*global_tof_selection).wBase
      display_discrete_selection_pixel_list, base=base
      
      ;can we enabled or not the save ROI button
      check_status_of_save_discrete_list, event=event
    end
    
    ;from text field
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_from_px'): begin
      ;refresh main plot
      base = (*global_tof_selection).wBase
      display_discrete_selection_pixel_list, base=base
    end
    
    ;to text field
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_to_px'): begin
      ;refresh main plot
      base = (*global_tof_selection).wBase
      display_discrete_selection_pixel_list, base=base
    end
    
    ;+
    widget_info(event.top, $
      find_by_uname='discrete_roi_selection_plus'): begin
      add_pixel_to_list, event=event
      
      ;refresh main plot
      base = (*global_tof_selection).wBase
      display_discrete_selection_pixel_list, base=base
      
      ;can we enabled or not the save ROI button
      check_status_of_save_discrete_list, event=event
    end
    
    ;validate ROIs selected
    widget_info(event.top, $
      find_by_uname='validate_discrete_selection_selected_uname'): begin
      
      roi_base = (*global_tof_selection).discrete_selection_input_base
      pixel_list = getValue(base=roi_base,$
        uname='discrete_roi_selection_text_field')
      global = (*global_tof_selection).global
      (*(*global).discrete_roi_selection) = pixel_list
      
      main_event = (*global_tof_selection).main_event
      ReplotAllSelection, main_event
      
      ;populate application with min and max pixel selected
      populate_main_base_with_pixel_range, event=main_event, $
        pixel_list=pixel_list
        
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
      
    end
    
    ;cancel tof selected
    widget_info(event.top, $
      find_by_uname='cancel_discrete_selection_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    This procedure retrieves the min and max pixels of the various selection
;    and populate the peak min and max fields with these values
;
;
;
; :Keywords:
;    event
;    pixel_list
;
; :Author: j35
;-
pro populate_main_base_with_pixel_range, event=event, $
    pixel_list=pixel_list
  compile_opt idl2
  
  
  ;go from ['123 -> 145','111 -> 250']
  ;to [[123,145],[111,250]]
  _pixel_list = parse_discrete_roi_selection(pixel_list)
  
  ;get min and max pixels [111,250]
  pixel_range = calculate_pixel_range(_pixel_list)
  
  pixel_min = pixel_range[0]
  pixel_max = pixel_range[1]
  
  putValue, event=event, 'data_d_selection_roi_ymin_cw_field', $
    strcompress(pixel_min,/remove_all)
  putValue, event=event, 'data_d_selection_roi_ymax_cw_field', $
    strcompress(pixel_max,/remove_all)
    
end

;+
; :Description:
;    Check if the save button can be enabled or not
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro check_status_of_save_discrete_list, event=event, base=base
  compile_opt idl2
  
  uname='discrete_roi_selection_text_field'
  if (keyword_set(event)) then begin
    pixel_list = getValue(event=event, $
      uname=uname)
  endif else begin
    pixel_list = getValue(base=base, $
      uname=uname)
  endelse
  
  if (pixel_list[0] ne '') then begin
    status = 1
  endif else begin
    status = 0
  endelse
  
  activate_widget, event=event, base=base, $
    uname='discrete_roi_selection_save_button', status=status
    
end

;+
; :Description:
;    This routine will load the .
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro load_discrete_roi_selection, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_tof_selection = (*global_info).global_tof_selection
  global = (*global_tof_selection).global
  
  path = (*global).tof_config_path
  id = widget_info(event.top, find_by_uname='discrete_peak_selection_base')
  title = 'Load discrete ROI selection'
  default_extension = 'txt'
  
  file_name = dialog_pickfile(default_extension=default_extension,$
    dialog_parent=id,$
    filter=['*discrete_roi.txt'],$
    get_path=new_path,$
    path=path,$
    title=title,$
    /must_exist,$
    /read)
    
  file_name = file_name[0]
  if (file_name ne '') then begin
    (*global).tof_config_path = new_path
    
    openr, 1, file_name
    nbr_lines = file_lines(file_name)
    pixel_list = strarr(nbr_lines)
    readf, 1, pixel_list
    close,1
    free_lun, 1
    
    putValue, event=event, 'discrete_roi_selection_text_field', pixel_list
    
    base = (*global_tof_selection).wBase
    display_discrete_selection_pixel_list, base=base
    
    ;can we enabled or not the save ROI button
    check_status_of_save_discrete_list, event=event
    
  endif
  
end

;+
; :Description:
;    This routine saves the ROI selection made
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro save_discrete_roi_selection, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_tof_selection = (*global_info).global_tof_selection
  global = (*global_tof_selection).global
  
  path = (*global).tof_config_path
  id = widget_info(event.top, find_by_uname='discrete_peak_selection_base')
  title = 'Save discrete ROI selection'
  default_extension = 'txt'
  
  file_name = dialog_pickfile(default_extension=default_extension,$
    dialog_parent=id,$
    filter=['*discrete_roi.txt'],$
    get_path=new_path,$
    path=path,$
    title=title,$
    /overwrite_prompt,$
    /write)
    
  if (file_name[0] ne '') then begin
    (*global).tof_config_path = new_path
    
    file_name = file_name[0]
    
    pixel_list = getValue(event=event, $
      uname='discrete_roi_selection_text_field')
      
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
    
  endif
  
end

;+
; :Description:
;    Add 'from Px' and 'to Px' to list of pixels
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro add_pixel_to_list, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  
  roi_list = string(getValue(event=event, $
    uname='discrete_roi_selection_text_field'))
  if (roi_list[0] eq '') then roi_list = !null
  
  from_px = strcompress(getValue(event=event, $
    uname='discrete_roi_selection_from_px'),/remove_all)
  to_px = strcompress(getValue(event=event, $
    uname='discrete_roi_selection_to_px'),/remove_all)
    
  on_ioerror, wrong_format
  
  fix_from_px = fix(from_px)
  fix_to_px = fix(to_px)
  
  if (fix_to_px eq 0) then return
  if (fix_from_px eq 0) then return
  
  new_selection = strcompress(from_px,/remove_all) + ' -> ' + $
    strcompress(to_px,/remove_all)
  roi_list = [roi_list,new_selection]
  
  putValue, event=event, 'discrete_roi_selection_text_field', roi_list
  
  ;clear 'from Px' and 'to Px'
  putValue, event=event, 'discrete_roi_selection_from_px', ''
  putValue, event=event, 'discrete_roi_selection_to_px', ''
  
  wrong_format:
  return
  
end

;+
; :Description:
;    Builds the GUI of the info base
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro discrete_selection_input_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Discrete peaks selection'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'discrete_peak_selection_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'discrete_peak_selection_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  row = widget_base(wBase,$
    /row)
    
  col1 =  widget_base(row,$
    /column)
  label = widget_label(col1,$
    value = 'ROIs (ex: Px1 -> Px2)')
  rois = widget_text(col1,$
    /editable,$
    xsize=10,$
    ysize=11,$
    uname = 'discrete_roi_selection_text_field')
    
  col2 = widget_base(row,$
    /column)
  load = widget_button(col2,$
    scr_xsize=100,$
    uname = 'discrete_roi_selection_load_button',$
    value = 'Load...')
  save = widget_button(col2,$
    scr_xsize=100,$
    value = 'Save...',$
    sensitive = 0,$
    uname = 'discrete_roi_selection_save_button')
    
  space = widget_label(col2,$
    value = ' ')
    
  row2=widget_base(col2,$
    /row)
  label = widget_label(row2,$
    value = 'From Px')
  value = widget_text(row2,$
    value = '',$
    xsize=3,$
    /editable,$
    uname='discrete_roi_selection_from_px')
    
  row2=widget_base(col2,$
    /row)
  label = widget_label(row2,$
    value = '  to Px')
  value = widget_text(row2,$
    value = '',$
    xsize=3,$
    /editable,$
    uname='discrete_roi_selection_to_px')
    
  plus = widget_button(col2,$
    value = '+',$
    scr_xsize=50,$
    uname='discrete_roi_selection_plus')
    
  row3b = widget_label(wBase,$
    /align_left,$
    value = "Left click main plot to select 'From Px'")
  row3b = widget_label(wBase,$
    /align_left,$
    value = "and right click to select 'to Px'")
    
  space = widget_label(wBase,$
    value = ' ')
    
  row4 = widget_base(wBase,$
    /row)
  cancel = widget_button(row4,$
    value = 'Cancel',$
    uname = 'cancel_discrete_selection_selected_uname',$
    scr_xsize = 50)
  space = widget_label(row4,$
    value = '  ')
  row4 = widget_button(row4,$
    value = 'Use these ROIs and EXIT',$
    uname = 'validate_discrete_selection_selected_uname')
    
end

;+
; :Description:
;    Save the tof defined in the tof input boxes
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro save_discrete_selection_tofs, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_tof_selection = (*global_info).global_tof_selection
  
  tof_selection_tof = (*global_tof_selection).tof_selection_tof
  
  tof1 = getValue(event=event, uname='discrete_selection_tof1_uname')
  tof2 = getValue(event=event, uname='discrete_selection_tof2_uname')
  
  tof_range = (*global_tof_selection).xrange
  xmin = tof_range[0]
  xmax = tof_range[1]
  
  tof1 = (tof1 gt xmax) ? -1 : tof1
  tof2 = (tof2 gt xmax) ? -1 : tof2
  
  tof1 = (tof1 lt xmin) ? -1 : tof1
  tof2 = (tof2 lt xmin) ? -1 : tof2
  
  tof_selection_tof = [tof1,tof2]
  (*global_tof_selection).tof_selection_tof = tof_selection_tof
  
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
pro discrete_pixel_selection_base_killed, id
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
pro discrete_counts_info_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_info, /no_copy
  
  if (n_elements(global_info) eq 0) then return
  
  ptr_free, global_info
  
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
pro discrete_selection_input_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof_selection
    top_base = (*global_tof_selection).wBase
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_tof_selection
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  tof_selection_tof = (*global_tof_selection).tof_selection_tof
  
  _base = 0L
  discrete_selection_input_base_gui, _base, $
    parent_base_geometry
    
  (*global_tof_selection).discrete_selection_input_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global_tof_selection: global_tof_selection })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "discrete_selection_input_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='discrete_counts_info_base_cleanup'
    
  last_discrete_selection_roi_saved = $
    (*global_tof_selection).last_discrete_selection_roi_saved
    
  sz = size(last_discrete_selection_roi_saved)
  
  if (sz[0] eq 1) then begin
    putValue, base=_base, 'discrete_roi_selection_text_field', $
      last_discrete_selection_roi_saved
      
    ;refresh main plot
    base = (*global_tof_selection).wBase
    display_discrete_selection_pixel_list, base=base
    
    ;can we enabled or not the save ROI button
    check_status_of_save_discrete_list, base=_base
    
  endif
  
end

