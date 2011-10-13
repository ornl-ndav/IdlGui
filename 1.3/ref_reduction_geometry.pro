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

PRO populate_data_geometry_info, Event, nexus_file_name, spin_state=spin_state

  if (nexus_file_name eq '') then return
  
  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  iNexus = obj_new('NeXusMetadata', nexus_file_name, spin_state='Off_Off')
  
  ;get date and put it in place
  date = iNexus->getDate()
  putTextFieldValue, event, 'info_date', date
  
  ;get start
  start_time = iNexus->getStart()
  putTextFieldValue, event, 'info_start', start_time
  
  ;get end
  end_time = iNexus->getEnd()
  putTextFieldValue, event, 'info_end', end_time
  
  ;get duration
  duration = iNexus->getDuration()
  putTextFieldValue, event, 'info_duration', duration[0]
  
  ;proton charge
  proton_charge = iNexus->getProtonCharge()
  putTextfieldValue, event, 'info_proton_charge', proton_Charge[0]
  
  ;min bin
  min_bin = iNexus->getMinBin()
  putTextFieldValue, event, 'info_bin_min', min_bin[0]
  
  ;max bin
  max_bin = iNexus->getMaxBin()
  putTextFieldValue, event, 'info_bin_max', max_bin[0]
  
  ;bin size
  bin_size = iNexus->getBinSize()
  putTextFieldValue, event, 'info_bin_size', bin_size[0]
  
  ;bin type
  bin_type = iNexus->getBinType()
  putTextFieldValue, event, 'info_bin_type', bin_type[0]
  
  ;Dangle
  dangle_value = iNexus->getDangle()
  dangle_deg = dangle_value[0]
  putTextFieldValue, event, 'info_dangle_deg', dangle_deg
  dangle_rad = dangle_value[1]
  putTextFieldValue, event, 'info_dangle_rad', dangle_rad
  
  ;Dangle0
  dangle0_value = iNexus->getDangle0()
  putTextFieldvalue, event, 'info_dangle0_deg', dangle0_value[0]
  putTextFieldValue, event, 'info_dangle0_rad', dangle0_value[1]
;  dangle0 = dangle0_value[0] + ' degrees (' + dangle0_value[1] + ' rad)'
;  putTextFieldValue, event, 'info_dangle0', dangle0
  
  ;dirpix
  dirpix = iNexus->getDirpix()
  putTextFieldValue, event, 'info_dirpix', dirpix[0]
  
  ;detector sample distance
  dist_units = iNexus->getSampleDetDistance()
  dist = dist_units[0] + ' ' + dist_units[1]
  putTextFieldValue, event, 'info_detector_sample_distance', dist
  
  distance_sd_m = convert_distance(distance=dist_units[0],$
    from_unit=dist_units[1],$
    to_unit='m')
    
  ;moderator sample distance
  dMS_units = iNexus->getSampleModeratorDistance()
  if (dMS_units[0] ne 'N/A') then begin
    distance = abs(dMS_units[0])
    distance_ms_m = convert_distance(distance=distance,$
      from_unit=dMS_units[1],$
      to_unit='m')
      
    (*global).distance_moderator_sample = distance_sd_m + distance_ms_m
  endif
  
  ;populate tof values (if they are empty)
  _tof_min = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_min'),$
    /REMOVE_ALL)
  _tof_max = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_max'),$
    /REMOVE_ALL)
    
  if (_tof_min eq '' || _tof_max eq '') then begin
    tof_axis = (*(*global).tof_axis_ms)
    tof_min = tof_axis[0]
    tof_max = tof_axis[-1]
    if (isTOFcuttingUnits_microS(Event)) then begin ;microS
      tof_min *= 1000.
      tof_max *= 1000.
    endif
    putValue, event=event, 'tof_cutting_min', strcompress(tof_min,/remove_all)
    putValue, event=event, 'tof_cutting_max', strcompress(tof_max,/remove_all)
  endif
  
  ;  ;detector position
  ;  detPosition_units = iNexus->getDetPosition()
  ;  detPosition_m = convert_to_m(strcompress(detPosition_units[0],/remove_all), $
  ;    strcompress(detPosition_units[1],/remove_all))
  ;  (*global).detector_position_m = float(detPosition_m)
  
  obj_destroy, iNexus
  
END

;------------------------------------------------------------------------------
PRO calculate_data_refpix, Event

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    refpix = 'N/A'
  ENDIF ELSE BEGIN
  
    ON_IOERROR, done_calculation
    
    ymin = getTextFieldValue(Event,'data_d_selection_roi_ymin_cw_field')
    ymax = getTextFieldValue(Event,'data_d_selection_roi_ymax_cw_field')
    
    IF (ymin NE 0 AND ymax NE 0) THEN BEGIN
    
      ymin = FLOAT(ymin)
      ymax = FLOAT(ymax)
      refpix = MEAN([ymin,ymax])
      (*global).refpix = refpix
      
    ENDIF ELSE BEGIN
    
      refpix = 'N/A'
      
    ENDELSE
    
    putTextFieldValue, event, 'info_refpix', $
      STRCOMPRESS(refpix,/REMOVE_ALL), 0
      
    calculate_sangle, event
    
    RETURN
    
    done_calculation:
    refpix = 'N/A'
    putTextFieldValue, event, 'info_refpix', $
      STRCOMPRESS(refpix,/REMOVE_ALL), 0
      
  ENDELSE
  
END

;+
; :Description:
;   calculates the sangle value (deg and rad) and display its value in
;   its widget_label in the info (nexus information) of the data loaded
;
; :Params:
;    event
;
; :keywords:
;   refpix
;   sangle
;
;
; :Author: j35
;-
pro calculate_sangle, event, refpix=refpix, sangle=sangle
  compile_opt idl2
  
  debug = 0b
  if (debug) then message = ['Calculation of sangle']
  
  widget_control, event.top, get_uvalue=global
  
  on_ioerror, error
  
  ;retrieve dirpix and refpix
  dirpix = getTextFieldValue(event,'info_dirpix')
  if (debug) then message = [message, 'dirpix: ' + $
  strcompress(dirpix[0],/remove_all)]
  if (dirpix[0] eq 'N/A') then begin
    on_ioerror, null
    sangle = -1
    return
  endif
  f_dirpix = float(dirpix[0])
  if (debug) then message = [message, 'f_dirpix: ' + $
  strcompress(f_dirpix,/remove_all)]
  
  if (~keyword_set(refpix)) then begin
    refpix = getTextFieldValue(event,'info_refpix')
  endif
  f_refpix = float(refpix[0])
  if (debug) then message = [message, 'f_refpix: ' + $
  strcompress(f_refpix,/remove_all)]
  
  ;get distance into metre
  detector_sample_distance = getTextFieldValue(event,$
    'info_detector_sample_distance')
  distance_units = strsplit(detector_sample_distance[0],' ',/extract)
  f_det_sample_distance = convert_to_m(distance_units[0], $
    strcompress(distance_units[1],/remove_all))
  if (f_det_sample_distance eq -1) then message, /ioerror
  ;detector_position_m = (*global).detector_position_m
  ;detTransOffset_m    = (*global).detTransOffset_m
  ;f_det_sample_distance += detector_position_m - detTransOffset_m
  if (debug) then message = [message, $
  'f_det_sample_distance: ' + $
  strcompress(f_det_sample_distance,/remove_all)]
  
  ;get dangle and dangle0 in radians
  dangle_rad = getTextFieldValue(event,'info_dangle_rad')
  f_dangle_rad = FLOAT(dangle_rad[0])
  ;  dangle_rad = get_value_between_arg1_arg2(dangle[0], '\(', 'rad)')
  ;  f_dangle_rad = float(dangle_rad)
  if (debug) then message = [message, 'f_dangle_rad: ' + $
  strcompress(f_dangle_rad,/remove_all)]
  
  dangle0_rad = getTextFieldValue(event,'info_dangle0_rad')
  f_dangle0_rad = float(dangle0_rad[0])
;  dangle0_rad = get_value_between_arg1_arg2(dangle0[0], '\(', 'rad)')
; f_dangle0_rad = float(dangle0_rad)
  if (debug) then message = [message, 'f_dangle0_rad: ' + $
  strcompress(f_dangle0_rad,/remove_all)]
  
  ;get size of detectors
  det_size_m = float((*global).detector_size_m)
  if (debug) then message = [message, 'det_size_m: ' + $
  strcompress(det_size_m,/remove_all)]
  
  ;do the calculation
  part1 = (f_dangle_rad - f_dangle0_rad)/2.
  part2 = (f_dirpix - f_refpix) * det_size_m
  part3 = 2. * f_det_sample_distance
  
  rad_sangle = part1 + (part2/part3)
  (*global).rad_sangle = rad_sangle
  
   if (debug) then begin
    message = [message, 'sangle (rad): ' + $
    strcompress(rad_sangle,/remove_all)]
    xdisplayfile, '', text=message,title='debug of ref_reduction_geometry.pro'
  endif
 
  if (keyword_set(sangle)) then begin
    sangle = rad_sangle
    return
  endif
  
  deg_sangle = convert_rad_to_deg(rad_sangle)
  
  putTextFieldValue, event, 'info_sangle_deg', $
    strcompress(deg_sangle,/remove_all)
  putTextfieldValue, event, 'info_sangle_rad', $
    strcompress(rad_sangle,/remove_all)
  
 sangle = rad_sangle
   
  print
  
  return
  
  error:
  
  if (keyword_set(sangle)) then begin
    sangle = -1
    on_ioerror, null
    return
  endif
  
  putTextFieldValue, event, 'info_sangle_deg', 'N/A'
  putTextFieldValue, event, 'info_sangle_rad', 'N/A'
  
  on_ioerror, null
  return
  
end


;+
; :Description:
;    This convert the deg/rad dangle into the opposite units and display
;    its value in the corresponding dangle text field
;
; :Params:
;    event
;;
; :Author: j35
;-
pro convert_dangle_units, event, from=from, to=to
  compile_opt idl2
  
  if (from eq 'deg') then begin
    dangle_deg = float(getTextFieldValue(event,'info_dangle_deg'))
    dangle_rad = convert_deg_to_rad(dangle_deg)
    putTextFieldValue, event, 'info_dangle_rad', $
    strcompress(dangle_rad,/remove_all)
  endif else begin
    dangle_rad = float(getTextFieldValue(event,'info_dangle_rad'))
    dangle_deg = convert_rad_to_deg(dangle_rad)
    putTextFieldValue, event, 'info_dangle_deg', $
    strcompress(dangle_deg,/remove_all)
  endelse
  
end

;+
; :Description:
;    This convert the deg/rad dangle0 into the opposite units and display
;    its value in the corresponding dangle0 text field
;
; :Params:
;    event
;;
; :Author: j35
;-
pro convert_dangle0_units, event, from=from, to=to
  compile_opt idl2
  
  if (from eq 'deg') then begin
    dangle0_deg = float(getTextFieldValue(event,'info_dangle0_deg'))
    dangle0_rad = convert_deg_to_rad(dangle0_deg)
    putTextFieldValue, event, 'info_dangle0_rad', $
    strcompress(dangle0_rad,/remove_all)
  endif else begin
    dangle0_rad = float(getTextFieldValue(event,'info_dangle0_rad'))
    dangle0_deg = convert_rad_to_deg(dangle0_rad)
    putTextFieldValue, event, 'info_dangle0_deg', $
    strcompress(dangle0_deg,/remove_all)
  endelse
  
end

;+
; :Description:
;    This convert the deg/rad sangle into the opposite units and display
;    its value in the corresponding sangle text field
;
; :Params:
;    event
;
; :Keywords:
;    from
;
; :Author: j35
;-
pro convert_sangle_units, event, from=from
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (from eq 'deg') then begin
    sangle_deg = float(getTextFieldValue(event,'info_sangle_deg'))
    sangle_rad = convert_deg_to_rad(sangle_deg)
    putTextFieldValue, event, 'info_sangle_rad', $
      strcompress(sangle_rad,/remove_all)
  endif else begin
    sangle_rad = float(getTextFieldValue(event,'info_sangle_rad'))
    sangle_deg = convert_rad_to_deg(sangle_rad)
    putTextFieldValue, event, 'info_sangle_deg', $
      strcompress(sangle_deg,/remove_all)
  endelse
  
  (*global).rad_sangle = sangle_rad
  
end