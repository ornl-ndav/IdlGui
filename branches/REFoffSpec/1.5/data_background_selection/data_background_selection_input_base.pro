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
pro pixel_selection_input_base_event, Event
  compile_opt idl2

      widget_control, event.top, get_uvalue=global_info
  
  case Event.id of
  
    ;pixel1 and pixel2 input boxes
    widget_info(event.top, find_by_uname='tof_selection_tof1_uname'): begin
      top_base = (*global_info).top_base
      global_tof_selection = (*global_info).global_tof_selection
      save_tof_selection_tofs, event=event
      display_tof_selection_tof, base=top_base
      display_counts_vs_tof, $
        base=(*global_tof_selection).tof_selection_counts_vs_tof_base_id, $
        global_tof_selection
    end
    widget_info(event.top, find_by_uname='tof_selection_tof2_uname'): begin
      top_base = (*global_info).top_base
      global_tof_selection = (*global_info).global_tof_selection
      save_tof_selection_tofs, event=event
      display_tof_selection_tof, base=top_base
      display_counts_vs_tof, $
        base=(*global_tof_selection).tof_selection_counts_vs_tof_base_id, $
        global_tof_selection
    end
    
    ;browse ROI
    widget_info(event.top, $
      find_by_uname='pixel_selection_browse'): begin
      data_background_selection_browse_roi, event
       save_pixel_selection_pixels, event=event
       top_base = (*global_info).top_base
       display_pixel_selection, base=top_base ;display selection on main plot
       global_pixel_selection = (*global_info).global_pixel_selection
       base = (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
       data_background_display_counts_vs_pixel, base=base, global_pixel_selection
    end
    
    ;validate tof selected
    widget_info(event.top, $
      find_by_uname='validate_tof_selection_selected_uname'): begin
      tof1_value = getValue(event=event, uname='tof_selection_tof1_uname')
      tof2_value = getValue(event=event, uname='tof_selection_tof2_uname')
      
      ;pop up an error dialog message if tof1 and 2 have the same values
      if (tof1_value eq tof2_value) then begin
        id = widget_info(event.top, find_by_uname='tof_selection_base')
        message_text = ['TOF 1 and 2 have the same valuee!',$
          '',$
          'TOF1 (ms): ' + strcompress(tof1_value,/remove_all), $
          'TOF2 (ms): ' + strcompress(tof2_value,/remove_all)]
        result = dialog_message(message_text, $
          title = 'Error in the range of TOF selected',$
          dialog_parent=id, $
          /ERROR)
        return
      endif
      
      ;make sure tof1 is smaller than tof2
      
      if (tof1_value eq 0.) then begin
        tof_min = 0.
        tof_max = tof2_value
      endif
      
      if (tof2_value eq 0.) then begin
        tof_min = tof1_value
        tof_max = 0.
      endif
      
      ;when none of them is equal to 0.
      if (tof1_value * tof2_value ne 0) then begin
        tof_min = min([tof1_value,tof2_value],max=tof_max)
      endif
      
      ;put tof values in main GUI
      widget_control, event.top, get_uvalue=global_info
      global_tof_selection = (*global_info).global_tof_selection
      main_event = (*global_tof_selection).main_event
      
      tof_axis = (*global_tof_selection).x_axis
      index_tof_range = get_index_tof_range([tof_min, tof_max], $
        tof_axis)
        
      global = (*global_tof_selection).global
      (*global).index_of_tof_range = index_tof_range
      
      if (isTOFcuttingUnits_microS(main_event)) then begin
        tof_min *= 1000.
        tof_max *= 1000.
      endif
      
      putValue, event=main_event, $
        'tof_cutting_min', $
        strcompress(tof_min,/remove_all)
      putValue, event=main_event, $
        'tof_cutting_max', $
        strcompress(tof_max,/remove_all)
        
      ;refresh main plot
      REFreduction_DataBackgroundPeakSelection, main_event
      
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
      
    end
    
    ;cancel tof selected
    widget_info(event.top, $
      find_by_uname='cancel_tof_selection_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Browse for a ROI file, retrieve the Pixel 1 and 2 and
;    display their values in Pixel1 & Pixel2. Also refresh the main plot
;    with the selection and the counts vs pixel.
;
; :Params:
;    event
;
; :Author: j35
;-
pro data_background_selection_browse_roi, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_pixel_selection = (*global_info).global_pixel_selection
  global = (*global_pixel_selection).global
  
  ;retrieve infos
  extension = 'dat'
  filter = ['*_back_ROI.dat','*_back_ROI.txt']
  path = (*global).ascii_path
  title = 'Browsing for a Background ROI file'
  widget_id = widget_info(event.top, find_by_uname='pixel_selection_base')
  
  file_name = dialog_pickfile(default_extension=extension, $
    filter=filter, $
    get_path = new_path, $
    path = path, $
    dialog_parent = widget_id, $
    title = title,$
    /read,$
    /must_exist)
    
  if (file_name[0] ne '') then begin ;retrieve pixel1 and pixel2
  
    widget_control, /hourglass
    
    (*global).roi_path = new_path
    (*global).ascii_path = new_path
    
    main_event = (*global_pixel_selection).main_event
    Yarray = retrieveYminMaxFromFile(main_event, file_name[0])
    Y1 = Yarray[0]
    Y2 = Yarray[1]
    putTextFieldValue, event, 'pixel_selection_pixel1_uname', $
      strcompress(Y1,/remove_all)
    putTextFieldValue, event, 'pixel_selection_pixel2_uname', $
      strcompress(Y2,/remove_all)
      
  endif
  
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
pro pixel_selection_input_base_gui, wBase, $
    parent_base_geometry, $
    pixel_selection = pixel_selection
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Pixel 1 and 2 selection'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'pixel_selection_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'pixel_selection_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  pixel1 = pixel_selection[0]
  pixel2 = pixel_selection[1]
  
  row1 = widget_base(wBase,$
    /row)
    
  if (pixel1 eq -1) then begin
    px1 = cw_field(row1,$
      xsize = 5,$
      /float,$
      title = '         Pixel1',$
      /row,$
      /return_events,$
      uname = 'pixel_selection_pixel1_uname')
  endif else begin
    px1 = cw_field(row1,$
      xsize = 5,$
      value = tof1,$
      /float,$
      title = 'Pixel2',$
      /row,$
      /return_events,$
      uname = 'pixel_selection_pixel1_uname')
  endelse
  
  if (pixel2 eq -1) then begin
    px2 = cw_field(row1,$
      xsize = 5,$
      /float,$
      title = '                    Pixel2',$
      /row,$
      /return_events,$
      uname = 'pixel_selection_pixel2_uname')
  endif else begin
    px2 = cw_field(row1,$
      xsize = 5,$
      /float,$
      value = tof2, $
      title = '      Pixel2',$
      /row,$
      /return_events,$
      uname = 'pixel_selection_pixel2_uname')
  endelse
  
  space = widget_label(wBase,$
    value = 'or')
    
  browse = widget_button(wBase,$
    value = 'Browse...',$
    uname = 'pixel_selection_browse')
  roi_base = widget_base(wBase,/row)
  label = widget_label(roi_base,$
    value = 'Data Back. Loaded:')
  value = widget_label(roi_base,$
    value = 'N/A',$
    /align_left, $
    uname = 'pixel_selection_roi_file_name_loaded',$
    scr_xsize = 300)
    
  space = widget_label(wBase,$
    value = ' ')
  space = widget_label(wBase,$
    value = ' ')
    
  row4 = widget_base(wBase,$
    /row)
    
  cancel = widget_button(row4,$
    value = 'EXIT Background selection',$
    uname = 'cancel_pixel_selection_selected_uname',$
    scr_xsize = 160)
    
  space = widget_label(row4,$
    value = '      ')
    
  row4 = widget_button(row4,$
    value = 'Create Data Background ROI and EXIT',$
    uname = 'validate_pixel_selection_selected_uname',$
    scr_xsize = 300)
    
end

;+
; :Description:
;    Save the pixel defined in the pixel input boxes
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro save_pixel_selection_pixels, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_pixel_selection = (*global_info).global_pixel_selection
  
  pixel_selection = (*global_pixel_selection).pixel_selection
  
  pixel1 = getValue(event=event, uname='pixel_selection_pixel1_uname')
  pixel2 = getValue(event=event, uname='pixel_selection_pixel2_uname')
  
  pixel_range = (*global_pixel_selection).yrange
  ymin = pixel_range[0]
  ymax = pixel_range[1]
  
  pixel1 = (pixel1 gt ymax) ? -1 : pixel1
  pixel2 = (pixel2 gt ymax) ? -1 : pixel2
  
  pixel1 = (pixel1 lt ymin) ? -1 : pixel1
  pixel2 = (pixel2 lt ymin) ? -1 : pixel2
  
  pixel_selection = [pixel1,pixel2]
  (*global_pixel_selection).pixel_selection = pixel_selection
  
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
pro pixel_selection_base_killed, id
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
pro counts_info_base_cleanup, tlb
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
pro pixel_selection_input_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_pixel_selection
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_pixel_selection
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  pixel_selection = (*global_pixel_selection).pixel_selection
  
  _base = 0L
  pixel_selection_input_base_gui, _base, $
    parent_base_geometry, $
    pixel_selection = pixel_selection
    
  (*global_pixel_selection).pixel_selection_input_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global_pixel_selection: global_pixel_selection })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "pixel_selection_input_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='counts_info_base_cleanup'
    
end

