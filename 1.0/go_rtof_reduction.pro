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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    convert to theta/lambda
;
; :Keywords:
;    event
;    DATA
;    SD_d
;    MD_d
;    center_pixel
;    pixel_size
;    THLAM_array
;    THLAM_lamvec
;    THLAM_thvec
;
; :Author: j35
;-
pro build_rtof_THLAM, event = event, $
    DATA = DATA,$
    SD_d = SD_d, $
    MD_d = MD_d, $
    center_pixel = center_pixel,$
    pixel_size = pixel_size, $
    THLAM_array = THLAM_array, $
    THLAM_lamvec = THLAM_lamvec, $
    THLAM_thvec = THLAM_thvec
  compile_opt idl2
  
   THLAM = convert_THLAM(DATA, SD_d, MD_d, center_pixel, pixel_size)
   
   ;round the angles to the nearest 100th of a degree
   theta_val = round(DATA.theta*100.0)/100.0
   twotheta_val = round(DATA.twotheta*100.0)/100.0
   
   THLAM_array[*,*] = THLAM.data
   THLAM_thvec[*]   = THLAM.theta
   THLAM_lamvec[*]  = THLAM.lambda
  
end

;+
; :Description:
;    Calculate the lambda step (in angstroms)
;
; :Params:
;    event
;    tof
;
; :Author: j35
;-
function get_rtof_lambda_step, event, tof
  compile_opt idl2
  
  SD_d = get_d_sd_rtof(event) ;mm
  MD_d = get_d_md_rtof(event) ;mm
  
  d_SD_m = convert_distance(distance=SD_d,$
    from_unit='mm',$
    to_unit='m')
    
  d_MD_m = convert_distance(distance=MD_d,$
    from_unit='mm',$
    to_unit='m')
    
  d_MS_m = d_MD_m - d_SD_m
  
  tof0 = tof[0]
  tof1 = tof[1]
  tof = tof1-tof0
  
  lambda = calculate_lambda(tof_value=tof,$
    tof_units='ms',$
    d_SD_m = d_SD_m, $
    d_MS_m = d_MS_m , $
    lambda_units = 'angstroms')
    
  message = ['> Calculate the lambda step: ' + $
    strcompress(lambda,/remove_all) + ' Angstroms']
  log_book_update, event, message=message
  
  return, lambda
end

;+
; :Description:
;    this routine creates the structure of data/angles/tof
;
; :Params:
;    event
;    theta
;    twotheta
;
; :Author: j35
;-
function trim_data, event, $
    theta, $
    twotheta
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  message = strarr(11)
  i=0
  message[i++] = '> Create DATA structure:'
  
  _DATA = (*(*global).rtof_data)
  
  nbr_pixel = (size(_data,/dim))[0]
  message[i++] = '-> number of pixels: ' + strcompress(nbr_pixel,/remove_all)
  
  ;get tof array only
  first_spectrum = *_DATA[0]
  tof = float(reform(first_spectrum[0,*]))  ;[263]
  nbr_tof = n_elements(tof)
  message[i++] = '-> number of tofs: ' + strcompress(nbr_tof,/remove_all)
  
  ;adding 4 to angles
  theta += 4.0
  twotheta += 4.0
  message[i++] = '-> Adding 4.0 to theta and twotheta:'
  message[i++]= '  -> theta: ' + strcompress(theta,/remove_all) + ' radians'
  message[i++] = '  -> twotheta: ' + strcompress(twotheta,/remove_all) + ' radians'
  
  ;pixels min and max
  PIXmin = get_pixel_min_rtof(event)
  PIXmax = get_pixel_max_rtof(event)
  message[i++] = '-> [p1,p2]=[' + strcompress(PIXmin,/remove_all) + $
    ',' + strcompress(PIXmax,/remove_all) + ']'
    
  ;tof min and max
  TOFmin = get_tof_min_rtof(event)
  TOFmax = get_tof_max_rtof(event)
  message[i++] = '-> [t1,t2]=[' + strcompress(TOFmin,/remove_all) + $
    ',' + strcompress(TOFmax,/remove_all) + ']'
    
  ;get image  (y vs tof)
  image = fltarr(nbr_tof, nbr_pixel)
  index = 0
  while (index lt nbr_pixel) do begin
    _image_index = *_DATA[index]
    image[*,index] = _image_index[1,*]
    ++index
  endwhile
  ;help, image   ;[263,51]
  
  ;create pixel array
  pixel_max = fix(PIXmax)
  pixel_min = fix(PIXmin)
  pixels = indgen(pixel_max - pixel_min + 1) + pixel_min
  
  sz = size(pixels,/dim)
  message[i++] = '-> size(pixels): ' + strcompress(sz,/remove_all)
  sz = size(tof,/dim)
  message[i++] = '-> size(tof): ' + strcompress(sz,/remove_all)
  sz = size(image,/dim)
  message[i++] = '-> size(image): ' + strcompress(strjoin(sz,','),/remove_all)
  
  ;remove last tof (which is empty)
  image = image[0:-2,*]
  tof = tof[0:-2]
  
  DATA = {data:image, theta:theta, twotheta:twotheta, tof:tof, pixels:pixels}
  
  log_book_update, event, message=message
  
  return, DATA
end

;+
; :Description:
;    start reduction for rtof file
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro go_rtof_reduction, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;retrieve variables
  rtof_ascii_file = getValue(event=event,$
    uname='rtof_file_text_field_uname')
  rtof_ascii_file = rtof_ascii_file[0]
  
  rtof_nexus_geometry_file = getValue(event=event,$
    uname='rtof_nexus_geometry_file')
    
  message = ['> Starting rtof reduction:']
  message1 = ['  - rtof file: ' + rtof_ascii_file]
  message2 = ['  - geometry file: ' + rtof_nexus_geometry_file]
  log_book_update, event, message=[message,message1,message2]
  
  full_check_message = !null
  QZmax = get_ranges_qz_max_rtof(event)
  QZmin = get_ranges_qz_min_rtof(event)
  check_input, value=QZmax, $
    label='Range Q: Qz max', $
    full_check_message = full_check_message
  check_input, value=QZmin, $
    label='Range Q: Qz min', $
    full_check_message = full_check_message
  QZrange = [QZmin, QZmax]
  
  QXbins = get_bins_qx(event)
  check_input, value=QXbins, $
    label='Bins Qx', $
    full_check_message = full_check_message
  QZbins = get_bins_qz(event)
  check_input, value=QZbins, $
    label='Bins Qz', $
    full_check_message = full_check_message
    
  QXmin = get_ranges_qx_min_rtof(event)
  check_input, value=QXmin, $
    label='Range Q: Qx min', $
    full_check_message = full_check_message
  QXmax = get_ranges_qx_max_rtof(event)
  check_input, value=QXmax, $
    label='Range Q: Qx max', $
    full_check_message = full_check_message
  QXrange = [QXmin, QXmax]
  
  TOFmin = get_tof_min_rtof(event)
  check_input, value=TOFmin, $
    label='from TOF (ms)', $
    full_check_message = full_check_message
  TOFmax = get_tof_max_rtof(event)
  check_input, value=TOFmax, $
    label='to TOF (ms)', $
    full_check_message = full_check_message
  TOFrange = [TOFmin, TOFmax]
  
  center_pixel = get_center_pixel_rtof(event)
  check_input, value=center_pixel, $
    label='center pixel', $
    full_check_message = full_check_message
  pixel_size = get_pixel_size_rtof(event)
  check_input, value=pixel_size, $
    label='pixel size', $
    full_check_message = full_check_message
    
  PIXmin = get_pixel_min_rtof(event)
  check_input, value=PIXmin, $
    label='from pixel', $
    full_check_message = full_check_message
  PIXmax = get_pixel_max_rtof(event)
  check_input, value=PIXmax, $
    label='to pixel', $
    full_check_message = full_check_message
    
  SD_d = get_d_sd_rtof(event) ;mm
  check_input, value=SD_d, $
    label='distance sample to detector (mm)', $
    full_check_message = full_check_message
    
  MD_d = get_d_md_rtof(event) ;mm
  check_input, value=MD_d, $
    label='distance moderator to detector (mm)', $
    full_check_message = full_check_message
    
  qxwidth = float(get_qxwidth(event))
  check_input, value=qxwidth, $
    label='specular reflexion, QxWidth', $
    full_check_message = full_check_message
  tnum = fix(get_tnum(event))
  check_input, value=tnum, $
    label='specular reflexion, tnum', $
    full_check_message = full_check_message
    
  theta = get_theta(event)
  twotheta = get_twotheta(event)
  
  theta_rad = convert_angle(angle=theta.value, $
    from_unit=theta.units,$
    to_unit='degree')
  twotheta_rad = convert_angle(angle=twotheta.value, $
    from_unit=twotheta.units, $
    to_unit='degree')
    
  message = ['> Retrieved parameters.']
  log_book_update, event, message=message
  
  ;pop up dialog_message if at least one input is wrong
  sz = n_elements(full_check_message)
  if (sz ge 1) then begin
  
    widget_control, hourglass=0
    
    title = 'Input format error !'
    id = widget_info(event.top, find_by_uname='main_base')
    message = 'Check the following input value(s):'
    _full_check_message = '    * ' + full_check_message
    message = [message, _full_check_message]
    result = dialog_message(message, $
      /ERROR,$
      dialog_parent = id, $
      /center, $
      title = title)
      
    _message = ['> Error while retrieving the parameters for the rtof file:']
    message = [_message, message]
    log_book_update, event, message=message
    hide_progress_bar, event
    
    return
  endif
  
  ;  (*global).SD_d = SD_d
  ;  (*global).MD_d = MD_d
  
  ;read rtof ascii file
  _DATA = trim_data(event, $
    theta_rad, $
    twotheta_rad)
    
  ;calculate the lambda step
  lambda_step = get_rtof_lambda_step(event, _DATA.tof)
  
  fTOFmax = float(TOFmax)
  fTOFmin = float(TOFmin)
  iPIXmax = fix(PIXmax)
  iPIXmin = fix(PIXmin)
  
  ;Create an array that will contain all the data
  THLAM_array = make_array(floor((fTOFmax-fTOFmin)*5)+1, iPIXmax-iPIXmin+1)
  THLAM_lamvec = make_array(floor((fTOFmax-fTOFmin)*5)+1)
  THLAM_thvec = make_array(iPIXmax-iPIXmin+1)
  
  build_rtof_THLAM, event=event, $
    DATA=_DATA,$
    SD_d = SD_d, $
    MD_d = MD_d, $
    center_pixel = center_pixel,$
    pixel_size = pixel_size, $
    THLAM_array = THLAM_array, $
    THLAM_lamvec = THLAM_lamvec, $
    THLAM_thvec = THLAM_thvec
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end