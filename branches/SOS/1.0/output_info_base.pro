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
;   main base event. Take care of all the events
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
    
      parent_event = (*global_info).parent_event
      refresh_plot, parent_event, recalculate=1
      save_background, event=parent_event
      (*global_plot).shift_key_status = 0b
      
      
      id = widget_info(Event.top, $
        find_by_uname='output_info_base')
      widget_control, id, /destroy
    end
    
    ;ok button
    widget_info(event.top, find_by_uname='ok_output_info_base'): begin
      ok_output_info_event, event
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Create the Counts vs Qx/Qz ascii files
;
; :Keywords:
;    xaxis
;    yaxis
;    output_file_name
;
; :Returns:
;   1 if the file has been created with success
;   0 if the process failed
;
; :Author: j35
;-
function create_ascii_file, xaxis=xaxis, $
    yaxis=yaxis, $
    output_file_name = output_file_name
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch, /cancel
    return, 0
  endif
  
  _xaxis = reform(xaxis)
  _yaxis = reform(yaxis)
  
  openw, 1, output_file_name
  
  sz = n_elements(_xaxis)
  for i=0,(sz-1) do begin
    _line = strcompress(_xaxis[i],/remove_all)
    _line += '   ' + strcompress(_yaxis[i],/remove_all)
    printf, 1, _line
  endfor
  
  close, 1
  free_lun, 1
  
  if (~file_test(output_file_name)) then return, 0
  
  return, 1
end

;+
; :Description:
;    This routine creates the jpeg files
;
; :Params:
;    Event
;
; :Author: j35
;-
function create_jpeg_file, xaxis = xaxis, $
    yaxis = yaxis, $
    xtitle = xtitle, $
    is_yaxis_type_linear = is_yaxis_type_linear, $
    output_file_name = output_file_name
  compile_opt idl2
  
  thisDevice = !D.name
  set_plot, 'PS'
  device, filename=output_file_name
  
  if (is_yaxis_type_linear) then begin
    plot, xaxis, yaxis, xtitle=xtitle, ytitle='Counts'
  endif else begin
    plot, xaxis, yaxis, xtitle=xtitle, ytitle='Counts', /ylog
  endelse
  device, /close_file
  set_plot, thisDevice
  
  if (~file_test(output_file_name)) then return, 0
  
  return, 1
end

;+
; :Description:
;    procedure reached by the OK button
;
; :Params:
;    event
;
; :Author: j35
;-
pro ok_output_info_event, event
  compile_opt idl2
  
  _base_file_name = getValue(event=event, uname='base_file_name')
  _path = getValue(event=event, uname='base_output_folder')
  _output_file = _path + _base_file_name
  
  widget_control, event.top, get_uvalue=global_info
  
  global_plot = (*global_info).global_plot
  
  ;do we want counts vs qx ascii
  qx_ascii = isButtonSelected(event=event, uname='qx_ascii_file')
  validate_qx_base = (*global_info).validate_qx_base
  
  list_of_files_produced = !null
  
  if (qx_ascii && validate_qx_base) then begin
    ext = '_IvsQx.txt'
    output_file_name = _output_file + ext
    result = create_ascii_file(xaxis=(*(*global_plot).counts_vs_qx_xaxis), $
      yaxis=(*(*global_plot).counts_vs_qx_data), $
      output_file_name = output_file_name)
      
    if (result) then begin ;files created with success
      _message = '---> OK'
    endif else begin
      _message = '---> FAILED'
    endelse
    _text = output_file_name + _message
    list_of_files_produced = [list_of_files_produced, _text]
  endif
  
  ;do we want counts vs qx jpg
  qx_jpeg = isButtonSelected(event=event, uname='qx_jpg_file')
  if (qx_jpeg && validate_qx_base) then begin
    ext = '_IvsQx.ps'
    output_file_name = _output_file + ext
    result = create_jpeg_file(xaxis = (*(*global_plot).counts_vs_qx_xaxis), $
      yaxis = (*(*global_plot).counts_vs_qx_data), $
      xtitle = 'Qx', $
      is_yaxis_type_linear = (*global_plot).counts_vs_qx_lin, $
      output_file_name = output_file_name)
      
    if (result) then begin ;files created with success
      _message = '---> OK'
    endif else begin
      _message = '---> FAILED'
    endelse
    _text = output_file_name + _message
    list_of_files_produced = [list_of_files_produced, _text]
  endif
  
  ;do we want counts vs qz ascii
  qz_ascii = isButtonSelected(event=event, uname='qz_ascii_file')
  validate_qz_base = (*global_info).validate_qz_base
  if (qz_ascii && validate_qz_base) then begin
    ext = '_IvsQz.txt'
    output_file_name = _output_file + ext
    result = create_ascii_file(xaxis=(*(*global_plot).counts_vs_qz_xaxis), $
      yaxis=(*(*global_plot).counts_vs_qz_data), $
      output_file_name = output_file_name)
      
    if (result) then begin ;files created with success
      _message = '---> OK'
    endif else begin
      _message = '---> FAILED'
    endelse
    _text = output_file_name + _message
    list_of_files_produced = [list_of_files_produced, _text]
  endif
  
  ;do we want counts vs qz jpg
  qz_jpeg = isButtonSelected(event=event, uname='qz_jpg_file')
  IF (qz_jpeg && validate_qz_base) then begin
    ext = '_IvsQz.ps'
    output_file_name = _output_file + ext
    result = create_jpeg_file(xaxis = (*(*global_plot).counts_vs_qz_xaxis), $
      yaxis = (*(*global_plot).counts_vs_qz_data), $
      xtitle = 'Qz', $
      is_yaxis_type_linear = (*global_plot).counts_vs_qz_lin, $
      output_file_name = output_file_name)
      
    if (result) then begin ;files created with success
      _message = '---> OK'
    endif else begin
      _message = '---> FAILED'
    endelse
    _text = output_file_name + _message
    list_of_files_produced = [list_of_files_produced, _text]
  endif
  
  title = 'Status of files created'
  id = widget_info(event.top, find_by_uname='output_info_base')
  result = dialog_message(list_of_files_produced, $
    /information, $
    title = title, $
    /center, $
    dialog_parent = id)
    
  if (strlowcase(result) eq 'ok') then begin
  
    parent_event = (*global_info).parent_event
    refresh_plot, parent_event, recalculate=1
    save_background, event=parent_event
    (*global_plot).shift_key_status = 0b
    
    id = widget_info(Event.top, $
      find_by_uname='output_info_base')
    widget_control, id, /destroy
  endif
  
end

;+
; :Description:
;    Builds the GUI
;
; :Params:
;    wBase
;    parent_base_geometry
;
; :Keywords:
;    output_folder
;    default_base_file
;
; :Author: j35
;-
pro output_info_base_gui, wBase, $
    parent_base_geometry, $
    output_folder = output_folder, $
    default_base_file = default_base_file, $
    validate_qx_base = validate_qx_base, $
    validate_qz_base = validate_qz_base
    
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
    sensitive = validate_qx_base, $
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
    value = 'ps (_IvsQx.ps)',$
    uname = 'qx_jpg_file')
    
  space = widget_label(part1,$
    value = '    ')
    
  part12 = widget_base(part1,$
    sensitive = validate_qz_base, $
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
    value = 'ps (_IvsQz.ps)',$
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
    default_base_file = default_base_file, $
    validate_qx_base = validate_qx_base, $
    validate_qz_base = validate_qz_base, $
    counts_vs_qz_lin = counts_vs_qz_lin, $
    counts_vs_qx_lin = counts_vs_qx_lin
    
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = ''
  output_info_base_gui, _base, $
    parent_base_geometry, $
    output_folder = output_folder, $
    default_base_file = default_base_file, $
    validate_qx_base = validate_qx_base, $
    validate_qz_base = validate_qz_base
    
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    parent_event: event, $
    
    validate_qx_base: validate_qx_base, $ ;1 if sensitive=1
    validate_qz_base: validate_qz_base, $ ;1 if sensitive=1
    counts_vs_qz_lin: counts_vs_qz_lin, $ ;1 if linear, 0 if log
    counts_vs_qx_lin: counts_vs_qx_lin, $
    
    output_folder: output_folder, $
    global_plot: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "output_info_base", _base, GROUP_LEADER = ourGroup, /no_block, $
    cleanup='output_info_base_cleanup'
    
end

