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
pro refpix_input_base_event, Event
  compile_opt idl2
  
  case Event.id of
  
    ;pixel1 and pixel2 input boxes
    widget_info(event.top, find_by_uname='refpix_pixel1_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      save_refpixel_pixels, base=top_base
      display_refpixel_pixels, base=top_base
      calculate_refpix, base=top_base
      global_refpix = (*global_info).global_refpix
      display_counts_vs_pixel, $
        base=(*global_refpix).refpix_counts_vs_pixel_base_id, $
        global_refpix
    end
    widget_info(event.top, find_by_uname='refpix_pixel2_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      save_refpixel_pixels, base=top_base
      display_refpixel_pixels, base=top_base
      calculate_refpix, base=top_base
      global_refpix = (*global_info).global_refpix
      display_counts_vs_pixel, $
        base=(*global_refpix).refpix_counts_vs_pixel_base_id, $
        global_refpix
    end
    
    widget_info(event.top, find_by_uname='refpix_value_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      display_refpix_user_input_value, base=top_base
      putValue, event=event, 'refpix_pixel1_uname', ''
      putValue, event=event, 'refpix_pixel2_uname', ''
    end
    
    widget_info(event.top, find_by_uname='validate_refpix_selected_uname'): begin
      ;validate refpix selected
      refpix_value = getValue(event=event, uname='refpix_value_uname')
      if (refpix_value eq 0) then refpix_value = ''
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      ;get row selected in configuration file
      global_refpix = (*global_info).global_refpix
      row_selected = (*global_refpix).row_index
      ;retrieve configuration table, make changes at given row and put it back
      main_event = (*global_refpix).main_event
      table = getValue(event=main_event,uname='ref_m_metadata_table')
      table[3,row_selected] = strcompress(refpix_value,/remove_all)
      ;      putValue, event=main_event, 'ref_m_metadata_table', table
      calculate_configuration_sangle_values, $
        event=main_event, $
        config_table=table
      putValue, event=main_event, 'ref_m_metadata_table', table
      id_counts = (*global_refpix).refpix_counts_vs_pixel_base_id
      if (widget_info(id_counts, /valid_id) ne 0) then begin
        widget_control, id_counts, /destroy
      endif
      widget_control, top_base, /destroy
    end
    
    ;cancel refpix selected
    widget_info(event.top, find_by_uname='cancel_refpix_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      global_refpix = (*global_info).global_refpix
      id_counts = (*global_refpix).refpix_counts_vs_pixel_base_id
      widget_control, top_base, /destroy
      if (widget_info(id_counts, /valid_id) ne 0) then begin
        widget_control, id_counts, /destroy
      endif
    end
    
    else:
    
  endcase
  
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
pro refpix_input_base_gui, wBase, $
    parent_base_geometry, $
    default_refpix_value=default_refpix_value, $
    refpix_pixels = refpix_pixels
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
    
  pixel1 = refpix_pixels[0]
  pixel2 = refpix_pixels[1]
  
  row1 = widget_base(wBase,$
    /row)
    
  if (pixel1 eq 0) then begin
    pixel1 = cw_field(row1,$
      xsize = 3,$
      /integer,$
      title = 'Pixel 1:',$
      /row,$
      /return_events,$
      uname = 'refpix_pixel1_uname')
  endif else begin
    pixel1 = cw_field(row1,$
      xsize = 3,$
      value = pixel1,$
      /integer,$
      title = 'Pixel 1:',$
      /row,$
      /return_events,$
      uname = 'refpix_pixel1_uname')
  endelse
  
  if (pixel2 eq 0) then begin
    pixel2 = cw_field(row1,$
      xsize = 3,$
      /integer,$
      title = '      Pixel 2:',$
      /row,$
      /return_events,$
      uname = 'refpix_pixel2_uname')
  endif else begin
    pixel2 = cw_field(row1,$
      xsize = 3,$
      /integer,$
      value = pixel2, $
      title = '      Pixel 2:',$
      /row,$
      /return_events,$
      uname = 'refpix_pixel2_uname')
  endelse
  
  if (default_refpix_value ne '') then begin
    _default_refpix_value = strcompress(default_refpix_value,/remove_all)
  endif else begin
    _default_refpix_value = 'N/A'
  endelse
  
  row2 = widget_base(wBase,$
    /row)
  label = widget_label(row2,$
    value = '     ===>  Refpix:')
  value = widget_label(row2,$
    value = _default_refpix_value,$
    uname = 'refpix_value_uname',$
    scr_xsize = 100)
    
  ;refpix = cw_field(wBase, $
  ;  xsize = 5,$
  ;  title = '       ===>  Refpix:',$
  ;  /row,$
  ;  /return_events,$
  ;  uname = 'refpix_value_uname')
    
  space = widget_label(wBase,$
    value = ' ')
    
  row4 = widget_base(wBase,$
    /row)
    
  cancel = widget_button(row4,$
    value = 'Cancel',$
    uname = 'cancel_refpix_selected_uname',$
    scr_xsize = 50)
    
  space = widget_label(row4,$
    value = '     ')
    
  row4 = widget_button(row4,$
    value = 'Use this refpix',$
    uname = 'validate_refpix_selected_uname',$
    scr_xsize = 150)
    
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
pro tof_selection_input_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_refpix
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_refpix
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  refpix_pixels = (*global_refpix).refpix_pixels
  
  _base = 0L
  refpix_input_base_gui, _base, $
    parent_base_geometry, $
    default_refpix_value=default_refpix_value, $
    refpix_pixels = refpix_pixels
    
  (*global_refpix).refpix_input_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global_refpix: global_refpix })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "refpix_input_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup='counts_info_base_cleanup'
    
end

