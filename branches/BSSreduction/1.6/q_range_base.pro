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

pro q_range_base_event, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global_q_range
  global = (*global_q_range).global
  main_event = (*global_q_range).main_event
  
  case Event.id of
  
    ;cancel button
    widget_info(event.top, $
      find_by_uname='q_range_cancel_button_uname'): begin
      id = widget_info(Event.top, $
        find_by_uname='q_range_base_uname')
      widget_control, id, /destroy
    end
    
    ;tofmin and tofmax
    widget_info(event.top, find_by_uname='tof_min_value'): begin
    evaluate_tof_min_value, event
    end
    widget_info(event.top, find_by_uname='tof_max_value'): begin
    evaluate_tof_max_value, event
    end
    
    ;    ;email2 widget_text
    ;    widget_info(event.top, $
    ;    find_by_uname='email2'): begin
    ;
    ;      (*global_settings).save_setup = 1b
    ;
    ;      ;check that email match
    ;      check_email_match, event=event, result=result
    ;      if (result eq 'Yes') then begin
    ;        (*global_settings).save_setup = 0b
    ;        return
    ;      endif
    ;      if (result eq 'OK') then begin
    ;        (*global_settings).save_setup = 0b
    ;        return
    ;      endif
    ;      if (result eq 'No') then begin
    ;        ;turn off the email output in main base
    ;        turn_off_email_output, event
    ;
    ;        id = widget_info(Event.top, $
    ;          find_by_uname='email_configure_widget_base')
    ;        widget_control, id, /destroy
    ;      endif
    ;      if (result eq '') then begin
    ;        save_status_of_email_configure_button, event
    ;        id = widget_info(Event.top, $
    ;          find_by_uname='email_configure_widget_base')
    ;        widget_control, id, /destroy
    ;      endif
    ;
    ;    end
    ;
    ;    ;close button
    ;    widget_info(event.top, $
    ;      find_by_uname='email_configure_base_close_button'): begin
    ;
    ;      (*global_settings).save_setup = 1b
    ;
    ;      ;check that email match
    ;      check_email_match, event=event, result=result
    ;      if (result eq 'Yes') then begin
    ;        (*global_settings).save_setup = 0b
    ;        return
    ;      endif
    ;      if (result eq 'OK') then begin
    ;        (*global_settings).save_setup = 0b
    ;        return
    ;      endif
    ;      if (result eq 'No') then begin
    ;        ;turn off the email output in main base
    ;        turn_off_email_output, event
    ;
    ;        id = widget_info(Event.top, $
    ;          find_by_uname='email_configure_widget_base')
    ;        widget_control, id, /destroy
    ;      endif
    ;      if (result eq '') then begin
    ;        save_status_of_email_configure_button, event
    ;        id = widget_info(Event.top, $
    ;          find_by_uname='email_configure_widget_base')
    ;        widget_control, id, /destroy
    ;      endif
    ;
    ;    end
    ;
    else:
    
  endcase
  
end

;+
; :Description:
;    Describe the procedure.
;
;
;
; :Keywords:
;    q_width
;    q_min
;    q_max
;    binning_type     'lin' or 'log'
;
; :Author: j35
;-
function calculate_nbr_bins, q_width=q_width, $
    q_min = q_min, $
    q_max = q_max, $
    binning_type = binning_type
  compile_opt idl2
  
  case (binning_type) of
    'lin': begin
      delta_q = float(q_max) - float(q_min)
      nbr_bins = delta_q / float(q_width)
    end
    'log': begin
    
    end
  endcase
  
  return, fix(nbr_bins[0])
end

;+
; :Description:
;    this will calculate the Qmin or Qmax using the given TOFmin or TOFmax
;
; :Keywords:
;    event
;    tof
;    bMin
;
; :Author: j35
;-
function calculate_q, event=event, tof=tof, bMin=bMin
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_q_range
  
  tof_q_structure = (*global_q_range).tof_q_structure
  h_over_mn = tof_q_structure.h_over_mn
  
  pixel_distance_s = tof_q_structure.pixel_distance
  if (keyword_set(bMin)) then begin
    _d = pixel_distance_s[0]
  endif else begin
    _d = pixel_distance_s[1]
  endelse
  
  polar_angle_s = tof_q_structure.polar_angle
  if (keyword_set(bMin)) then begin
    polar_angle = polar_angle_s[0]
  endif else begin
    polar_angle = polar_angle_s[1]
  endelse
  
  four_pi = 4. * !PI
  
  _d_over_tof = float(_d) / float(tof)
  _lambda = (h_over_mn / _d_over_tof)
  Q = (four_pi / _lambda) * sin(polar_angle/2.)
  
  return, Q*1.e-10    ;to be in Angstroms
  
end

;+
; :Description:
;    This will calculate the new Qmin using the TOFmin defined
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro evaluate_tof_min_value, event
  compile_opt idl2
  
  tof_min = getValue(id=event.id)
  q_min = calculate_q(event=event, tof=tof_min)
  putValue, event, 'q_max_value', strcompress(q_min,/remove_all)
  
end


;+
; :Description:
;    This will calculate the new Qmax using the TOFmax defined
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro evaluate_tof_max_value, event
  compile_opt idl2
  
  tof_max = getValue(id=event.id)
  q_max = calculate_q(event=event, tof=tof_max, /bMin)
  putValue, event, 'q_min_value', strcompress(q_max,/remove_all)
  
end

;+
; :Description:
;    Calculates the new TOFmin using this Qmin entry
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro q_min_value, event
  compile_opt idl2
  
  q_min = getValue(id=event.id)
  tof_min = calculate_tof(event=event, q=q_min, /bMin)
  putValue, event, 'tof_min_value', strcompress(tof_min,/remove_all)
  
end

;+
; :Description:
;    Calculates the new TOFmax using this Qmax entry
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro q_max_value, event
  compile_opt idl2
  
  q_max = getValue(id=event.id)
  tof_max = calculate_tof(event=event, q=q_max, /bMax)
  putValue, event, 'tof_max_value', strcompress(tof_max,/remove_all)
  
end

;
;;+
;; :Description:
;;   Reached when the settings base is killed
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;pro email_settings_killed, id
;  compile_opt idl2
;
;  ;get global structure
;  widget_control,id,get_uvalue=global_settings
;  global = (*global_settings).global
;  main_event = (*global_settings).main_event
;
;  if ((*global_settings).save_setup eq 0b) then begin
;    message_text = ['New setup (if any) has not been saved!']
;    title = 'Leaving without saving new setup!'
;    result = dialog_message(message_text,$
;      information = 1,$
;      title = title, $
;      /center,$
;      dialog_parent = id)
;    ActivateWidget, main_event, 'email_configure', 1
;  endif else begin
;    if ((*global_settings).turn_off_email_output eq 1b) then begin
;      id1 = widget_info(main_event.top, find_by_uname='send_by_email_output')
;      widget_control, id1, set_value = 1
;      id2 = widget_info(main_event.top, find_by_uname='email_configure')
;      widget_control, id2, sensitive = 0
;    endif else begin
;      ActivateWidget, main_event, 'email_configure', 1
;    endelse
;  endelse
;
;  id = widget_info(id, $
;    find_by_uname='email_configure_widget_base')
;  widget_control, id, /destroy
;
;end

;------------------------------------------------------------------------------
PRO q_range_base_gui, wBase, main_base_geometry, global, $
    tof_min=tof_min, $
    tof_max=tof_max, $
    q_min=q_min, $
    q_max=q_max, $
    nbr_bins=nbr_bins
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  ;  xsize = 350
  ;  ysize = 130
  ;
  xoffset = main_base_xsize/2 - 250
  xoffset += main_base_xoffset - 100
  
  yoffset = main_base_ysize/2
  yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Q range',$
    UNAME        = 'q_range_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize,$
    MAP          = 1,$
    ;    kill_notify  = 'email_settings_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    ;    /column,$
    GROUP_LEADER = ourGroup)
    
  title = widget_label(wBase,$
    value = 'Rebin parameters',$
    xoffset= 20,$
    yoffset = 115)
    
  main_base = widget_base(wBase,$
    /column)
    
  row1 = widget_base(main_base,$
    /row)
    
  col1 = widget_base(row1,$
    /column)
    
  rowa = widget_base(col1,$
    /row)
  lambda_min=cw_field(rowa,$
    value=strcompress(tof_min,/remove_all),$
    title='           TOF min (s)',$
    uname = 'tof_min_value',$
    /row,$
    /return_events, $
    /floating,$
    xsize=10)
  rowb = widget_base(col1,$
    /row)
  lambda_min=cw_field(rowb,$
    value=strcompress(q_min,/remove_all),$
    title='  Q min (Angstroms^-1)',$
    uname = 'q_min_value', $
    /return_events, $
    /row,$
    /floating,$
    xsize=10)
    
  space = widget_label(row1,$
    value= '     ')
    
  col2 = widget_base(row1,$
    /column)
    
  rowa = widget_base(col2,$
    /row)
  lambda_min=cw_field(rowa,$
    value=strcompress(tof_max,/remove_all),$
    uname = 'tof_max_value',$
    title='           TOF max (s)',$
    /return_events, $
    /row,$
    /floating,$
    xsize=10)
  rowb = widget_base(col2,$
    /row)
  lambda_min=cw_field(rowb,$
    value=strcompress(q_max,/remove_all),$
    title='  Q max (Angstroms^-1)',$
    uname = 'q_max_value', $
    /return_events, $
    /row,$
    /floating,$
    xsize=10)
    
  space = widget_label(main_base,$
    value =  ' ')
    
  col = widget_base(main_base,$
    /column,$
    frame=1)
    
  rowc = widget_base(col,$
    /row)
  rowc1 = widget_base(rowc,$
    /nonexclusive)
  but1 = widget_button(rowc1,$
    value='Qwidth')
  widget_control, but1, /set_button
  txt = widget_text(rowc,$
    value= '0.01',$
    xsize = 10)
  label = widget_label(rowc,$
    value = 'Nbr bins:')
  val = widget_label(rowc,$
    value = strcompress(nbr_bins,/remove_all),$
    /align_left,$
    scr_xsize = 100,$
    uname='nbr_bins_uname')
    
  space=widget_label(rowc,$
    value='   ')
    
  rowc2 = widget_base(rowc,$
    /nonexclusive)
  but1 = widget_button(rowc2,$
    value='Nbr bins')
  txt = widget_text(rowc,$
    value= '',$
    xsize = 10,$
    sensitive=0)
  label = widget_label(rowc,$
    value = 'Bins size',$
    sensitive=0)
  val = widget_label(rowc,$
    value = 'N/A',$
    /align_left, $
    scr_xsize = 100,$
    uname='bins_size_uname')
    
  rowc2 = widget_base(col,$
    /row,$
    /exclusive)
  but1 = widget_button(rowc2,$
    value = 'Linear binning')
  widget_control, but1, /set_button
  but2 = widget_button(rowc2,$
    value = 'Log binning')
    
  rowd = widget_base(main_base,$
    /row)
  cancel = widget_button(rowd,$
    uname = 'q_range_cancel_button_uname',$
    value = 'CANCEL')
  space = widget_label(rowd,$
    value = '                                             ')
  plot = widget_button(rowd,$
    value = 'PLOT Counts vs Q ...')
  output = widget_button(rowd,$
    value = 'OUTPUT Ascii file ...')
    
END


PRO q_range_base, main_base=main_base, Event=event, $
    tof_min=tof_min, $
    tof_max=tof_max, $
    q_min=q_min, $
    q_max=q_max, $
    tof_q_structure=tof_q_structure
    
  compile_opt idl2
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  default_q_width = 0.001
  nbr_bins = calculate_nbr_bins(q_width=default_q_width, $
    q_min = q_min, $
    q_max = q_max, $
    binning_type = 'lin')
    
  ;build gui
  wBase1 = ''
  q_range_base_gui, wBase1, $
    main_base_geometry, global, $
    tof_min=tof_min, $
    tof_max=tof_max, $
    q_min=q_min, $
    q_max=q_max, $
    nbr_bins = nbr_bins
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_q_range = PTR_NEW({ wbase: wbase1,$
    global: global, $
    tof_q_structure: tof_q_structure, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_q_range
  
  XMANAGER, "q_range_base", wBase1, GROUP_LEADER = ourGroup, /NO_BLOCK
  
END

