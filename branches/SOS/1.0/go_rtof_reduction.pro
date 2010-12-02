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

function convert_to_QxQz_rtof, data,$
    theta_vec, $
    lambda_vec, $
    qxvec, $
    qzvec, $
    lambda_step, $
    theta_rad
  compile_opt idl2

  lambda_bin_vec = lambda_vec
  data_size = size(data,/dim)
  si = size(qxvec,/dim)
  qx_bins = si[0]
  
  si = size(qzvec,/dim)
  qz_bins=si[0]
  
  theta_in = theta_rad
  
  ;*********************************************************
  ; REBIN TOF vs PIX MATRIX into QX vs QZ SPACE
  ;*********************************************************
  
  ;Create the map in the Qx and Qz space of the
  ;lambda and theta map
  
  ;QxQz_values[Qx_lo, Qx_hi, Qz_lo, Qz_hi, data]
  QxQz_values = make_array(5,data_size[0]*data_size[1],/float)
  
  index = 0
  for i=0, data_size[0]-1 do begin ;loop ovefr wavelength values
    for j=0, data_size[1]-1 do begin ;loop over theta values
    
      lambdaval=lambda_vec[i]
      
      if data[i,j] gt 0 then begin
      
        lambdalo=lambda_bin_vec[i]
        lambdahi=lambdalo+lambda_step
        
        if j ne data_size[1]-1 then theta_step=abs(theta_vec[j+1]-theta_vec[j])
        thetahi = theta_vec[j]+theta_step/2
        thetalo = theta_vec[j]-theta_step/2
        
        Qx_lo = (2.0*!pi/lambdahi) * (cos(thetahi)-cos(theta_in))
        Qx_hi = (2.0*!pi/lambdalo) * (cos(thetalo)-cos(theta_in))
        
        Qz_lo= (2.0*!pi/lambdahi) * (sin(thetalo)+sin(theta_in))
        Qz_hi= (2.0*!pi/lambdalo) * (sin(thetahi)+sin(theta_in))
        
        QXQZ_values[0,index] = Qx_lo
        QXQZ_values[1,index] = Qx_hi
        QXQZ_values[2,index] = Qz_lo
        QXQZ_values[3,index] = Qz_hi
        QXQZ_values[4,index] = data[i,j]
        
        index++
        
      endif
    endfor
  endfor
  
  si=size(QXQZ_values,/dim)
  si=si[1]
  
  QXQZ_ARRAY=make_array(qx_bins,qz_bins,/float)
  QxQZ_count=make_array(qx_bins,qz_bins,/float)
  
  ;below is the binning method
  ok=0
  count=0.0
  fullcount=0.0
  tecount=0.0
  becount=0.0
  recount=0.0
  lecount=0.0
  
  total_area = 0.0
  
  while (ok eq 0) do begin
  
    QX_lo=QXQZ_values[0,count]
    QX_hi=QXQZ_values[1,count]
    
    QZ_lo=QXQZ_values[2,count]
    QZ_hi=QXQZ_values[3,count]
    
    int=QXQZ_values[4,count]

    ;check where is the last index of data
    
    ;get the last index where QX_lo is smaller or equal to the QX axis
    QX_lo_pos=max(where(QX_lo ge QXvec, nbr_qx_lo_pos))
    
    ;get the first index where QX_hi is bigger or equal to the QX axis
    QX_hi_pos=min(where(QX_hi le QXvec, nbr_qx_hi_pos))
    
    QZ_lo_pos=max(where(QZ_lo ge QZvec, nbr_qz_lo_pos))

    QZ_hi_pos=min(where(QZ_hi le QZvec, nbr_qz_hi_pos))
    
    if nbr_qz_lo_pos eq 0 then QZ_lo_pos=0
    if nbr_qz_hi_pos eq 0 then QZ_hi_pos=qz_bins-1
    if nbr_qx_lo_pos eq 0 then Qx_lo_pos=0
    if nbr_qx_hi_pos eq 0 then Qx_hi_pos=qx_bins-1
    
    ;below crudely splits the intensity equally among all bins
    ;calculate the number of bins in each of the new box
    totalbins=(QX_hi_pos-QX_lo_pos+1)*(QZ_hi_pos-QZ_lo_pos+1)

    for loopx=QX_lo_pos,QX_hi_pos do begin
      for loopy=QZ_lo_pos,QZ_hi_pos do begin
        QXQZ_ARRAY[loopx,loopy]=QXQZ_ARRAY[loopx,loopy]+(int/totalbins)
        QXQZ_count[loopx,loopy]=QXQZ_count[loopx,loopy]+1.0
      endfor
    endfor
    
    if count eq si-1 then ok=1
    count++
  endwhile
   
  ;multiply *QZ^4
  qxqz4=qxqz_array
  for loop=0,qz_bins-1 do begin
    qxqz4[*,loop]=qxqz_array[*,loop]*qzvec[loop]^4
  endfor

  qxqz_norm = qxqz_count*0.0
  
  for loopx=0, qx_bins-1 do begin
  for loopz=0, qz_bins-1 do begin
  qxqz_norm[loopx,loopz] = qxqz_array[loopx,loopz]/qxqz_count[loopx,loopz]
  endfor
  endfor
  
  norm=qxqz_array/qxqz_count
  badlist=where(finite(norm) eq 0)
  norm[badlist]=0.0

  return, norm
end

;+
; :Description:
;    Convert the tof/pixel array into QxQz
;
; :Keywords:
;    event
;    lambda_step
;    qxbins
;    qzbins
;    qxrange
;    qzrange
;    THLAM_array
;    THLAM_thvec
;    THLAM_lamvec
;    QxQz_array
;    qxvec
;    qzvec
;    theta_rad
;
; :Author: j35
;-
pro make_QXQZ_rtof, event = event, $
    lambda_step = lambda_step, $
    qxbins = qxbins, $
    qzbins = qzbins, $
    qxrange = qxrange, $
    qzrange = qzrange, $
    THLAM_array = THLAM_array, $
    THLAM_thvec = THLAM_thvec, $
    THLAM_lamvec = THLAM_lamvec, $
    QxQz_array = QxQz_array, $
    qxvec = qxvec, $
    qzvec = qzvec, $
    theta_rad
  compile_opt idl2
  
  message = ['> Building QxQz array: ']
  
  ;Initialize the range of steps for x and z axis
  ;will go from -0.004 to 0.004 with 500steps (qxbins)
  qxvec=(findgen(qxbins)/(qxbins-1))*(qxrange[1]-qxrange[0])+qxrange[0]
  ;will go from 0 to 0.3 with 500steps
  qzvec=(findgen(qzbins)/(qzbins-1))*(qzrange[1]-qzrange[0])+qzrange[0]
  
  QxQz_array = convert_to_QxQz_rtof(THLAM_array,$
    THLAM_thvec, $
    THLAM_lamvec, $
    qxvec, $
    qzvec, $
    lambda_step, $
    theta_rad)
    
    message1 = '-> size(QxQz_array) : [' + $
    strcompress(strjoin(size(QxQz_array,/dim),','),/remove_all) + ']'
    message = [message,message1]
    log_book_update, event, message=message
    
end

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
  
  message = ['> Build THLAM (Theta-Lambda) array for loaded data set']
  
  THLAM = convert_THLAM(DATA, SD_d, MD_d, center_pixel, pixel_size)
  
  ;round the angles to the nearest 100th of a degree
  theta_val = round(DATA.theta*100.0)/100.0
  twotheta_val = round(DATA.twotheta*100.0)/100.0
  
  THLAM_array[*,*] = THLAM.data
  THLAM_thvec[*]   = THLAM.theta
  THLAM_lamvec[*]  = THLAM.lambda
  
  message1 = ['-> theta: ' + strcompress(theta_val,/remove_all) + $
    ' degrees']
  message2 = ['-> twotheta ' + strcompress(twotheta_val,/remove_all) + $
    ' degrees']
  message = [message,message1,message2]
  
  log_book_update, event, message=message
  
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
  widget_control, /hourglass
  
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
    
  QxQz_array = make_array(qxbins, qzbins)
  
  make_QXQZ_rtof, event = event, $
    lambda_step = lambda_step, $
    qxbins = qxbins, $
    qzbins = qzbins, $
    qxrange = qxrange, $
    qzrange = qzrange, $
    THLAM_array = THLAM_array, $
    THLAM_thvec = THLAM_thvec, $
    THLAM_lamvec = THLAM_lamvec, $
    QxQz_array = QxQz_array, $
    qxvec = qxvec, $
    qzvec = qzvec, $
    theta_rad
  
    ;create metadata
    time_stamp = GenerateReadableIsoTimeStamp()
    metadata = produce_rtof_metadata_structure(event, $
      time_stamp = time_stamp, $
      rtof_file = rtof_ascii_file, $
      rtof_nexus_geometry_file = rtof_nexus_geometry_file, $
      qzmax = QZmax,$
      qzmin = QZmin, $
      qxbins = QXbins, $
      qzbins = QZbins, $
      qxmin = QXmin, $
      qxmax = QXmax, $
      tofmin = TOFmin, $
      tofmax = TOFmax, $
      pixmin = PIXmin, $
      pixmax = PIXmax, $
      center_pixel = center_pixel, $
      pixel_size = pixel_size, $
      d_sd = SD_d, $
      d_md = MD_d, $
      qxwidth = qxwidth, $
      tnum = tnum)
    
    offset = 50
    final_plot, event=event, $
    offset = offset, $
    time_stamp = time_stamp, $
    data = QxQz_array,$
    x_axis = qxvec,$
    y_axis = qzvec,$
    metadata = metadata, $
    default_loadct = 5, $
    ;    default_scale_settings = default_scale_settings, $
    ;    current_plot_setting = current_plot_setting, $
    ;    Data_x = Data_x, $
    ;    Data_y = Data_y, $ ;Data_y
    ;    start_pixel = start_pixel, $
    main_base_uname = 'main_base', $
    output_folder = (*global).output_path

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  widget_control, hourglass=0
  
  
end