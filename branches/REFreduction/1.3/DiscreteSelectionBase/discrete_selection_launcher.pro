;+
; :Description:
;    This routine will launch the tof_selection base
;
; :Params:
;    event
;
; :Author: j35
;-
pro discrete_selection_launcher, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  widget_control, /hourglass
  
  wBase = (*global).discrete_selection_base_id
  if (widget_info(wBase, /valid_id) ne 0) then return
  
  run_number = getTextFieldValue(event, 'load_data_run_number_text_field')
  
  ;data
  data = (*(*global).bank1_data)
  ;retrieve tof
  full_nexus_name = (*global).data_full_nexus_name
  if ((*global).instrument eq 'REF_M') then begin
    spin_state = 'Off_Off'
    iNexus = obj_new('IDLnexusUtilities', full_nexus_name, $
      spin_state=spin_state)
    y_axis = indgen(304)
  endif else begin
    iNexus = obj_new('IDLnexusUtilities', full_nexus_name)
    y_axis = indgen(256)
  endelse
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif else begin
    tof_axis = iNexus->get_tof_data()
  endelse
  catch,/cancel
  
  tof_min_max = get_input_tof_min_max(event)
  
  discrete_selection_base, main_base='MAIN_BASE',$
    event=event, $
    offset = 120,$
    tof_min_max = tof_min_max, $
    x_axis = tof_axis,$
    y_axis = y_axis,$
    data = data,$
    run_number= strcompress(run_number[0],/remove_all), $
    file_name = full_nexus_name
    
  widget_control, hourglass=0
  
end