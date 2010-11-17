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
;    retrieves the 2D spectrum of the normalization file
;    ex: Array[2,751]
;
; :Params:
;    event
;    norm_nexus   full path of the normalization nexus file
;
;-
function get_normalization_spectrum, event, norm_nexus
  compile_opt idl2
  
  message = ['> Start retrieving normalization spectrum [tof,counts] ... ']
  message = [message, '-> NeXus file name: ' + norm_nexus]
  log_book_update, event, message=message
  
  iNorm = obj_new('IDLnexusUtilities', norm_nexus)
  spectrum = iNorm->get_TOF_counts_data()
  obj_destroy, iNorm
  
  message = ['> Done with retrieving normalization spectrum [tof,counts]']
  sz = size(spectrum)
  message1 = '-> size(spectrum): [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
  message = [message, message1]
  log_book_update, event, message=message
  
  return, spectrum
end

;+
; :Description:
;    Trim the spectrum to keep only the TOF range specified
;
; :Params:
;    spectrum
;
; :Keywords:
;    TOFrange    = [TOFmin, TOFmax]
;
;-
function trim_spectrum, event, spectrum, TOFrange=TOFrange
  compile_opt idl2
  
  message = ['> Triming normalization spectrum:']
  
  _TOFmin = TOFrange[0]
  _TOFmax = TOFrange[1]
  
  message1 = '-> TOFmin: ' + strcompress(_TOFmin,/remove_all)
  message2 = '-> TOFmax: ' + strcompress(_TOFmax,/remove_all)
  log_book_update, event, message = [message, message1, message2]
  
  list = where(spectrum[0,*] ge _TOFmin and spectrum[0,*] le _TOFmax)
  spectrum = spectrum[*,list]
  spectrum[1,*] = spectrum[1,*]/max(spectrum[1,*]) ;normalize spectrum to 1
  
  sz = size(spectrum)
  message3 = '-> size(spectrum): [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
  log_book_update, event, message = [message, message1, message2, message3]
  
  return, spectrum
end

;+
; :Description:
;    Retrieve all the important information from each data nexus files
;    and keep only the range desired
;
; :Params:
;    event
;    filename
;    TOFmin
;    TOFmax
;    PIXmin
;    PIXmax
;
; :Returns:
;   data    structure {data:image, theta:theta, twotheta:twotheta,$
;                      tof:tof, pixels:pixel}
;
;-
function read_nexus, event, filename, TOFmin, TOFmax, PIXmin, PIXmax
  compile_opt idl2
  
  message = strarr(13)
  i=0
  message[i++] = '> Read data from NeXus ' + filename
  
  iFile = obj_new('IDLnexusUtilities', filename)
  
  ;get data [tof, pixel_x, pixel_y]
  image = iFile->get_y_tof_data()
  sz = size(image)
  message[i++] = '-> retrieved Y vs TOF data [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
    
  ;get tof array only
  tof = iFile->get_TOF_data()
  sz = size(tof)
  message[i++] = '-> retrived tof axis data [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
    
  ;get angles
  _Theta = iFile->get_theta()
  _TwoTheta = iFile->get_twoTheta()
  
  theta = _theta.value
  twotheta = _twotheta.value
  
  theta_units = _theta.units
  twotheta_units = _twotheta.units
  
  message[i++] = '-> retrieved theta: ' + strcompress(theta,/remove_all) + $
    ' ' + strcompress(theta_units,/remove_all)
  message[i++] = '-> retrieved twotheta: ' + strcompress(twotheta,/remove_all) + $
    ' ' + strcompress(twotheta_units,/remove_all)
    
  obj_destroy, iFile
  
  Theta=theta+4.0
  TwoTheta=TwoTheta+4.0
  
  message[i++] = '-> Adding 4.0 to theta and twotheta'
  message[i++] = '  -> theta: ' + strcompress(theta,/remove_all) + $
    ' ' + strcompress(theta_units,/remove_all)
  message[i++] = '  -> twotheta: ' + strcompress(twotheta,/remove_all) + $
    ' ' + strcompress(twotheta_units,/remove_all)
    
  ;Determine where is the first and last tof in the range
  list=where(TOF ge TOFmin and TOF le TOFmax)
  t1=min(where(TOF ge TOFmin))
  t2=max(where(TOF le TOFmax))
  
  message[i++] = '-> [t1,t2]=[' + strcompress(t1,/remove_all) + $
    ',' + strcompress(t2,/remove_all) + ']'
    
  pixels=findgen(256)
  p1=min(where(pixels ge PIXmin))
  p2=max(where(pixels le PIXmax))
  
  message[i++] = '-> [p1,p2]=[' + strcompress(p1,/remove_all) + $
    ',' + strcompress(p2,/remove_all) + ']'
    
  TOF=TOF[t1:t2]
  PIXELS=pixels[p1:p2]
  
  image=image[t1:t2,p1:p2]
  
  sz = size(tof)
  message[i++] = '-> size(TOF): ' + strcompress(strjoin(sz,','),/remove_all)
  sz = size(pixels)
  message[i++] = '-> size(pixels): ' + strcompress(strjoin(sz,','),/remove_all)
  sz = size(image)
  message[i++] = '-> size(image): ' + strcompress(strjoin(sz,','),/remove_all)
  
  ;image -> data (counts)
  ;tof   -> tof axis
  ;pixels -> list of pixels to keep in calculation
  DATA={data:image, theta:theta, twotheta:twotheta, tof:tof, pixels:pixels}
  
  log_book_update, event, message = message
  
  return, DATA
  
end

;+
; :Description:
;     sort the angles (theta and twoTheta in increasing order)
;     and create arrays of increasing uniq list of angles (theat and twotheta)
;
; :Params:
;    event
;
; :Keywords:
;    file_angle
;
;-
function create_uniq_sort_list_of_angles, event, file_angle = file_angle
  compile_opt idl2
  
  list1 = sort(file_angle)
  _angles=file_angle[list1[uniq(file_angle[list1])]]
  
  return, _angles
end

;+
; :Description:
;    This function loops through all the theta and twotheta combinations
;    and count those that exist then make a list of unique angles geometries
;
; :Params:
;    event
;    file_angles
;    theta_angles
;    twotheta_angles
;
; :Returns:
;    unique list of angles geometries
;
;-
function make_unique_angle_geometries_list, event, file_angles,$
    theta_angles, $
    twotheta_angles
  compile_opt idl2
  
  si1=size(theta_angles,/dim)
  si2=size(twotheta_angles,/dim)
  
  ;loop through all theta and twotheta combinations and count those that exist
  count=0
  for loop1=0, si1[0]-1 do begin
    for loop2=0, si2[0]-1 do begin
      check=where((file_angles[1,*] eq theta_angles[loop1]) and $
        (file_angles[2,*] eq twotheta_angles[loop2]))
      if check[0] ne -1 then count++
    endfor
  endfor
  
  ;loop through again and make a list of unique angle geometries
  angles=make_array(4,count)
  count=0
  for loop1=0, si1[0]-1 do begin
    for loop2=0, si2[0]-1 do begin
      check=where((file_angles[1,*] eq theta_angles[loop1]) and $
        (file_angles[2,*] eq twotheta_angles[loop2]))
      if check[0] ne -1 then begin
        angles[0,count]=theta_angles[loop1]
        angles[1,count]=twotheta_angles[loop2]
        count++
      endif
    endfor
  endfor
  
  message = ['> Create unique angle geometries list:']
  message1 = '-> size(angles): [4,' + $
    strcompress((size(angles))[2],/remove_all) + ']'
  message2 = ['-> angles =']
  sz1 = (size(angles))[1]
  index1=0
  while (index1 lt sz1) do begin
    _message = '[' + $
      strcompress(strjoin(reform(angles[index1,*]),','),/remove_all) + $
      ']'
    message2 = [message2, _message]
    index1++
  endwhile
  message2[1] = '[' + message2[1]
  message2[-1] = message2[-1] + ']'
  message = [message, message1, message2]
  log_book_update, event, message=message
  
  return, angles
end

;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    data
;    SD_d
;    MD_d
;    cpix
;    pix_size
;
;-
function convert_THLAM, data, SD_d, MD_d, cpix, pix_size
  compile_opt idl2
  
  TOF=data.TOF
  MD_d = MD_d[0]
  vel=MD_d/TOF         ;mm/ms = m/s
  
  h=6.626e-34   ;m^2 kg s^-1
  m=1.675e-27     ;kg
  
  lambda=h/(m*vel)  ;m
  lambda=lambda*1e10  ;angstroms
  
  theta_val=data.twotheta-data.theta
  
  ;theta_val=data.theta
  theta_val=theta_val[0]
  d_vec=(data.pixels-cpix)*pix_size
  thetavec=(atan(d_vec/SD_d[0])/!DTOR)+theta_val
  
  THLAM={data:data.data, lambda:lambda, theta:thetavec}
  
  return, THLAM
  
end

;+
; :Description:
;   This create 3 arrays that hold the THLAM values
;
; INFOS
;   THLAM is an array containing all the data (for all angle measurements)
;   converted to THETA vs LAMBDA.
;   It is a 3-d array where the 1st dimension is the measurement #, 2nd
;   dimension is LAMBDA, and 3rd dimension is THETA.
;   Also, THLAM_lamvec and THLAM_thvec are 2-d arrays of the vectors to index
;   THLAM_array.
;
;   So the 5th angle can be plotted using :
;   'contour, THLAM_array[4,*,*], THLAM_lamvec[4,*], THLAM_thvec[4,*]'
;
;   THLAM is later converted to Qx vs Qz and is stored in a similar combination
;   of all measurement called QXQZ_array.
;
;   SNS_divide_spectrum was my method to normalize the data to the incident
;   beam spectrum. I know there already exists a way to do this but it was
;   easier for me to write my own quick-and-dirty code than find what already
;   exists.
;   Basically, I created a 2 column LAMBDA vs INTENSITY file for the direct
;   beam, load that in and then divide all the data by it.
;
; :Keywords:
;    event
;    DATA
;    spectrum
;    SD_d
;    MD_d
;    center_pixel
;    pixel_size
;    angles
;    THLAM_array
;    THLAM_lamvec
;    THLAM_thvec
;    processes
;    total_number_of_processes
;
;-
pro build_THLAM, event=event, $
    DATA=DATA, $
    spectrum = spectrum, $
    SD_d = SD_d, $
    MD_d = MD_d, $
    center_pixel = center_pixel, $
    pixel_size = pixel_size, $
    angles = angles, $
    THLAM_array = THLAM_array, $
    THLAM_lamvec = THLAM_lamvec, $
    THLAM_thvec = THLAM_thvec, $
    processes = processes, $
    total_number_of_processes = total_number_of_processes
    
  compile_opt idl2
  
  file_num = (size(DATA,/dim))[0]
  
  message = ['> Build THLAM (Theta-Lambda) arrays for all each loaded files']
  
  for read_loop=0,file_num-1 do begin
  
    RAW_DATA= *DATA[read_loop]
    ;{data, theta, twotheta, tof, pixels}
    
    NORM_DATA=SNS_divide_spectrum(RAW_DATA, spectrum)
    
    ;SD_d : sample to detector distance
    ;MD_d : moderator to detector
    THLAM=convert_THLAM(NORM_DATA, SD_d, MD_d, center_pixel, pixel_size)
    ;THLAM is a structure
    ;{ data, lambda, theta}  with lambda in Angstroms and theta in radians
    
    ;round the angles to the nearset 100th of a degree
    theta_val=round(RAW_DATA.theta[0]*100.0)/100.0
    twotheta_val=round(RAW_DATA.twotheta[0]*100.0)/100.0
    theta_val=theta_val[0]
    twotheta_val=twotheta_val[0]
    
    tilenum=where((angles[0,*] eq theta_val) and (angles[1,*] eq twotheta_val))
    
    THLAM_array[tilenum,*,*]=THLAM_array[tilenum,*,*]+THLAM.data
    THLAM_thvec[tilenum,*]=THLAM.theta
    THLAM_lamvec[tilenum,*]=THLAM.lambda
    
    ;    window,0, title = "Convertion: TOF->Lambda, Pixel->Theta"
    ;    shade_surf, smooth(thlam.data,3), thlam.lambda, thlam.theta, ax=70, $
    ;      charsi=2, xtitle='LAMBDA (' + string("305B) + ')', ytitle='THETA (rad)'
    ;    wait,.1
    ;    wshow
    
    message1 = ['-> Created THLAM array of file # ' + $
      strcompress(read_loop,/remove_all)]
    message2 = ['   theta: ' + strcompress(theta_val,/remove_all) + $
      ' degrees']
    message3 = ['   twotheta: ' + strcompress(twotheta_val,/remove_all) + $
      ' degrees']
    message = [message, message1, message2, message3]
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
  endfor
  
  log_book_update, event, message=message
  
end

;+
; :Description:
;    Convert the tof/pixel array into QxQz
;
; :Keywords:
;    event
;    num
;    lambda_step
;    qxbins
;    qzbins
;    qxrange
;    qzrange
;    THLAM_array
;    THLAM_thvec
;    THLAM_lamvec
;    angles
;    qxqz_array
;    qxvec
;    qzvec
;
;-
pro make_QxQz, event = event, $
    num = num, $
    lambda_step = lambda_step, $
    qxbins = qxbins, $
    qzbins = qzbins, $
    qxrange = qxrange, $
    qzrange = qzrange, $
    THLAM_array = THLAM_array, $
    THLAM_thvec = THLAM_thvec, $
    THLAM_lamvec = THLAM_lamvec, $
    angles = angles, $
    qxqz_array = qxqz_array, $
    qxvec = qxvec, $
    qzvec = qzvec
  compile_opt idl2
  
  message = ['> Building QxQz array: ']
  
  ;Initialize the range of steps for x and z axis
  ;will go from -0.004 to 0.004 with 500steps (qxbins)
  qxvec=(findgen(qxbins)/(qxbins-1))*(qxrange[1]-qxrange[0])+qxrange[0]
  ;will go from 0 to 0.3 with 500steps
  qzvec=(findgen(qzbins)/(qzbins-1))*(qzrange[1]-qzrange[0])+qzrange[0]
  
  ;SO FAR SO GOOD
  
  ;THLAM_array: 2D vector of data
  ;THLAM_thvec: theta vector axis
  ;THLAM_lamvec: lambda vector axis
  ;angles[theta,twotheta]
  for loop=0,num-1 do begin
    ;  help, where(thlam_array[loop,*,*] ne 0)
    QXQZ_array[loop,*,*] = convert_to_QxQz(THLAM_array[loop,*,*], $
      THLAM_thvec[loop,*], $
      THLAM_lamvec[loop,*], $
      angles[0,loop], $
      QXvec, $
      QZvec, $
      lambda_step)
  endfor
  
  
  message1 = '-> size(QXQZ_array) : [' + $
    strcompress(strjoin(size(QxQz_array,/dim),','),/remove_all) + ']'
  message = [message, message1]
  log_book_update, event, message=message
  
;  device, decomposed=0
;  loadct, 5
;
;  window, 0
;  contour, [[0,0],[100,0]], [qxrange[0],qxrange[1]], $
;    [qzrange[0],qzrange[1]],$
;    /nodata, charsi=1.5, $
;    xtitle='QX', ytitle='QZ'
;  for loop=0,num-1 do begin
;    contour, QXQZ_array[loop,*,*],Qxvec,Qzvec, /fill,nlev=200,/overplot
;    wait,.01
;  endfor
  
end

;+
; :Description:
;    calculate the lambda step (in angstroms)
;
; :Params:
;    event
;    tof
;
;-
function get_lambda_step, event, tof
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  d_SD_mm = (*global).SD_d
  d_MD_mm = (*global).MD_d
  
  d_SD_m = convert_distance( distance = d_SD_mm, $
    from_unit = 'mm', $
    to_unit = 'm')
    
  d_MD_m = convert_distance( distance = d_MD_mm, $
    from_unit = 'mm', $
    to_unit = 'm')
    
  d_MS_m = d_MD_m - d_SD_m
  
  tof0 = tof[0]
  tof1 = tof[1]
  tof = tof1 - tof0
  lambda = calculate_lambda (tof_value=tof, $
    tof_units = 'ms', $
    d_SD_m = d_SD_m, $
    d_MS_m = d_MS_m, $
    lambda_units = 'angstroms')
    
  message = ['> Calculate the lambda step: ' + $
    strcompress(lambda,/remove_all) + ' Angstroms']
  log_book_update, event, message=message
  
  return, lambda
end

;+
; :Description:
;    extract the specular peaks
;
; :Params:
;    datafile
;    qxvec
;    qxwidth
;
; :Author: j35
;-
function extract_specular, datafile, qxvec, qxwidth
  compile_opt idl2
  
  si=size(datafile,/dim)
  specular=make_array(si[1])
  pos2=max(where(Qxvec le qxwidth))
  pos1=min(where(Qxvec ge -qxwidth))
  
  for loop=pos1,pos2 do begin
    specular=specular+datafile[loop,*]
  endfor
  
  return, specular
end

;+
; :Description:
;    Create the specular scale
;
; :Keywords:
;    event
;    num
;    specular
;    scale
;    QxQz_array
;    qxvec
;    qzvec
;    qxwidth
;    tnum
;    time_stamp
;
; :Author: j35
;-
function get_specular_scale, event=event, $
    num = num, $
    specular = specular, $
    scale = scale, $
    QxQz_array = QxQz_array, $
    qxvec = qxvec, $
    qzvec = qzvec, $
    qxwidth = qxwidth, $
    tnum = tnum, $
    time_stamp = time_stamp
  compile_opt idl2
  
  message = ['> Isolate specular region and create scaling array']
  
  for loop=0,num-1 do begin
    data=reform(QXQZ_array[loop,*,*])
    result=extract_specular(data, qxvec, qxwidth)
    specular[loop,*]=result
    
    if loop eq 0 then scale[0]=1/max(result)
  endfor
  
  message1 = '-> size(specular) = [' + $
    strcompress(strjoin(size(specular,/dim),','),/remove_all) + ']'
    
  ;trimmer
  trim=specular*0.0
  for loop=0,num-1 do begin
    list=where(specular[loop,*] ne 0)
    si=size(list,/dim)
    si=si[0]
    cut=list[tnum:si-tnum]
    trim[loop,cut]=specular[loop,cut]
  endfor
  
  specular = trim
  ;autoscale
  step=0
  
  widget_control, event.top, get_uvalue=global
  style_plot_lines = (*(*global).style_plot_lines)
  
  time_stamp = GenerateReadableIsoTimeStamp()
  title = 'Specular plots [' + time_stamp + ']'
  
  _plot = plot(QZvec, $
    specular[0,*]*scale[0], $
    /ylog, $
    yrange=[1e-8,100], $
    psym=1, $
    window_title=title,$
    charsi=1.5, $
    style_plot_lines[0], $
    xtitle='Qz', $
    ytitle='R')
    
  for loop=1,num-1 do begin
  
    overlap=where(specular[loop-1,*] ne 0 and specular[loop,*] ne 0)
    si=size(overlap,/dim)
    si=si[0]
    ratio=specular[loop-1,overlap]/specular[loop,overlap]
    r2=total(specular[loop-1,overlap])/total(specular[loop,overlap])
    scale[loop]=(total(ratio)/si)*scale[loop-1]
    
    _oplot = plot(QZvec, specular[loop,*]*scale[loop],/overplot,$
      style_plot_lines[loop])
      
  endfor
  
  message2 = '-> Number of elements of scale: ' + $
    strcompress(n_elements(scale),/remove_all)
  message3 = '-> scale = [' + strcompress(strjoin(scale,','),/remove_all) + ']'
  message = [message, message1, message2, message3]
  log_book_update, event, message=message
  
  return, scale
end

;+
; :Description:
;    Create big scaled array
;
; :Keywords:
;    event
;    scale
;    QxQz_array
;    num
;    qxvec
;    qzvec
;    qxbins
;    qzbins
;
; :Author: j35
;-
function create_big_scaled_array, event=event, $
    scale = scale,$
    QxQz_array = QxQz_array, $
    num = num, $
    qxvec = qxvec, $
    qzvec = qzvec, $
    qxbins = qxbins, $
    qzbins = qzbins
  compile_opt idl2
  
  message = '> Create big scaled array'
  
  nscale=scale/min(scale)
  
  for loop=0,num-1 do begin
    QXQZ_array[loop,*,*]=QXQZ_array[loop,*,*]*nscale[loop]
  endfor
  
  skip1:
  ;print, 'skipped it'
  
  qxqz4=qxqz_array
  for loop1=0,num-1 do begin
    for loop2=0,qzbins-1 do begin
      qxqz4[loop1,*,loop2]=qxqz_array[loop1,*,loop2]*qzvec[loop2]^4
    endfor
  endfor
  
  ;  contour, [[0,0],[20000,0]], [qxrange[0],qxrange[1]], [qzrange[0],qzrange[1]],/nodata, charsi=1.5, xtitle='QX', ytitle='QZ'
  ;  for loop=0,num-1 do begin
  ;      contour, QXQZ_array[loop,*,*],Qxvec,Qzvec, /fill,nlev=200,/overplot
  ;      wait,.05
  ;  endfor
  
  countarray=make_array(qxbins,qzbins)
  ;count where the tiles have data
  for loop=0,num-1 do begin
    for xloop=0,qxbins-1 do begin
      for zloop=0,qzbins-1 do begin
        if qxqz_array[loop,xloop,zloop] ne 0 then countarray[xloop,zloop]=countarray[xloop,zloop]+1
      endfor
    endfor
  endfor
  
  totarray=make_array(qxbins,qzbins)
  totarray4=make_array(qxbins,qzbins)
  ;total up the tiles
  for loop=0,num-1 do begin
    totarray=QXQZ_array[loop,*,*]+totarray
    totarray4=QXQZ4[loop,*,*]+totarray4
  endfor
  
  totarray=reform(totarray)
  countarray=reform(countarray)
  
  ;this division leads to nans so clean them up
  divarray=totarray/countarray
  list=where(finite(divarray) ne 1)
  divarray[list]=0
  
  divarray4=totarray4/countarray
  list=where(finite(divarray4) ne 1)
  
  divarray4[list]=0
  
  ;  window, 1
  ;  contour, countarray,Qxvec,Qzvec,/fill, nlev=100
  ;  wait, 1
  ;
  ;    window, 1
  ;    contour, smooth(alog(divarray+1),5), $
  ;    Qxvec, $
  ;    Qzvec, $
  ;    /fill, $
  ;    nlev=200, $
  ;    charsi=1.5, $
  ;    xtitle='QX', $
  ;    ytitle='QZ'
  
  message1 = '-> divarray has been created'
  message2 = '-> size(divarray) = [' + $
    strcompress(strjoin(size(divarray,/dim),','),/remove_all) + ']'
  message = [message, message1, message2]
  log_book_update, event, message=message
  
  return, divarray
end

;+
; :Description:
;    Start the heart of the program
;
; :Params:
;    event
;
;-
pro go_reduction, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  catch,error
  if (error ne 0) then begin
    catch,/cancel
    
    message = '> Automatic stitching failed! ***'
    log_book_update, event, message=message
    
    title = 'Automatic stitching failed !'
    message_text = ['Please change the parameters defined',$
      'and try again.']
    widget_id = widget_info(event.top, find_by_uname='main_base')
    result = dialog_message(message_text,$
      title = title,$
      /error,$
      /center,$
      dialog_parent=widget_id)
      
    hide_progress_bar, event
    widget_control, hourglass=0
    
    return
  endif else begin
  
    message = ['> Running reduction: ']
    
    widget_control, /hourglass
    show_progress_bar, event
    processes = 0
    
    message = [message, '-> Retrieving parameters.']
    log_book_update, event, message=message
    
    ;number of steps is ----> 1
    
    ;Retrieve variables
    
    list_data_nexus = (*(*global).list_data_nexus)
    
    file_num = n_elements(list_data_nexus)
    total_number_of_processes = 7 + 2*file_num
    
    norm_nexus = (*global).norm_nexus
    
    full_check_message = !null
    QZmax = get_ranges_qz_max(event)
    QZmin = get_ranges_qz_min(event)
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
      
    QXmin = get_ranges_qx_min(event)
    check_input, value=QXmin, $
      label='Range Q: Qx min', $
      full_check_message = full_check_message
    QXmax = get_ranges_qx_max(event)
    check_input, value=QXmax, $
      label='Range Q: Qx max', $
      full_check_message = full_check_message
    QXrange = [QXmin, QXmax]
    
    TOFmin = get_tof_min(event)
    check_input, value=TOFmin, $
      label='from TOF (ms)', $
      full_check_message = full_check_message
    TOFmax = get_tof_max(event)
    check_input, value=TOFmax, $
      label='to TOF (ms)', $
      full_check_message = full_check_message
    TOFrange = [TOFmin, TOFmax]
    
    PIXmin = get_pixel_min(event)
    check_input, value=PIXmin, $
      label='from pixel', $
      full_check_message = full_check_message
    PIXmax = get_pixel_max(event)
    check_input, value=PIXmax, $
      label='to pixel', $
      full_check_message = full_check_message
      
    center_pixel = get_center_pixel(event)
    check_input, value=center_pixel, $
      label='center pixel', $
      full_check_message = full_check_message
    pixel_size = get_pixel_size(event)
    check_input, value=pixel_size, $
      label='pixel size', $
      full_check_message = full_check_message
      
    SD_d = get_d_sd(event) ;mm
    check_input, value=SD_d, $
      label='distance sample to detector (mm)', $
      full_check_message = full_check_message
      
    MD_d = get_d_md(event) ;mm
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
        
      _message = ['> Error while retrieving the parameters:']
      message = [_message, message]
      log_book_update, event, message=message
      
      hide_progress_bar, event
      
      return
    endif
    
    (*global).SD_d = SD_d
    (*global).MD_d = MD_d
    
    ;lambda step used in conversion to QxQz
    lambda_step = 0
    
    update_progress_bar_percentage, event, ++processes, total_number_of_processes
    
    ;number of steps is ----> 1
    
    ;create spectrum of normalization file
    if ((*global).debugger eq 'yes') then begin
      if (!version.os eq 'darwin') then begin
        path = '/Users/j35/IDLWorkspace80/SOS 1.0/'
      endif else begin
        path = '/SNS/users/j35/IDLWorkspace80/SOS 1.0/'
      endelse
      norm_file = path + 'Al_can_spectrum.dat'
      SPECTRUM=xcr_direct(norm_file, 2)
    endif else begin
      spectrum = get_normalization_spectrum(event, norm_nexus)
    endelse
    
    update_progress_bar_percentage, event, ++processes, total_number_of_processes
    
    ;number of steps is ----> 1
    
    ;trip the spectrum to the relevant tof ranges
    spectrum = trim_spectrum(event, spectrum, TOFrange=TOFrange)
    
    ;prepare array of data coming from the data Nexus files
    fdig=make_array(file_num)
    
    ;determine the Nexus file(s) which include(s) the critical reflection
    ;all other tiles will be normalized to these.
    file_angles=make_array(3,file_num) ;[file_index, theta, twotheta]
    ;Save big data structure into a array of pointers
    DATA = ptrarr(file_num, /allocate_heap)
    
    update_progress_bar_percentage, event, ++processes, total_number_of_processes
    
    ;number of steps is ----> file_num
    for read_loop=0,file_num-1 do begin
      ;check to see if the theta value is the same as CE_theta
      _DATA = read_nexus(event, $
        list_data_nexus[read_loop], $
        TOFmin, $
        TOFmax, $
        PIXmin, $
        PIXmax)
      ;round the angles to the nearset 100th of a degree
      file_angles[0,read_loop]=read_loop
      file_angles[1,read_loop]=round(_DATA.theta*100.0)/100.0
      file_angles[2,read_loop]=round(_DATA.twotheta*100.0)/100.0
      
      *DATA[read_loop] = _DATA
      
      ;calculate lambda step (using only the first file loaded)
      if (read_loop eq 0) then begin
        lambda_step = get_lambda_step(event, _DATA.tof)
      endif
      
      update_progress_bar_percentage, event, ++processes, $
        total_number_of_processes
        
    endfor
    
    ;number of steps is ----> 1
    
    ;create unique increasing list of angles (theta and twotheat)
    theta_angles = create_uniq_sort_list_of_angles(event, $
      file_angle = reform(file_angles[1,*]))
      
    twoTheta_angles = create_uniq_sort_list_of_angles(event, $
      file_angle = reform(file_angles[2,*]))
      
    si1=size(theta_angles,/dim)
    si2=size(twotheta_angles,/dim)
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    message = ['> Create unique list of theta and twotheta angles:']
    message1 = '-> size(theta_angles) = ' + strcompress(si1,/remove_all)
    message11 = '--> theta_angles = [' + $
      strcompress(strjoin(theta_angles,','),/remove_all) + ']'
    message2 = '-> size(twotheta_angles) = ' + strcompress(si2,/remove_all)
    message21 = '--> twotheta_angles = [' + $
      strcompress(strjoin(twotheta_angles,','),/remove_all) + ']'
    message = [message, message1, message11, message2, message21]
    log_book_update, event, message=message
    
    ;number of steps is ----> 1
    
    ;make a list of unique angle geometries
    angles = make_unique_angle_geometries_list(event, $
      file_angles,$
      theta_angles, $
      twotheta_angles)
      
    ;The number of tiles
    si = size(angles,/dim)
    num = si[1]
    
    ;Create an array that wil contain all the data (for all angle measurements)
    ;converted to THETA vs Lambda
    THLAM_array = make_array(num,floor((TOFmax-TOFmin)*5)+1,PIXmax-PIXmin+1)
    THLAM_lamvec= make_array(num,floor((TOFmax-TOFmin)*5)+1)
    THLAM_thvec = make_array(num,PIXmax-PIXmin+1)
    
    ;number of steps is ----> file_num
    build_THLAM, event=event, $
      DATA=DATA, $
      spectrum = spectrum, $
      SD_d = SD_d, $
      MD_d = MD_d, $
      center_pixel = center_pixel, $
      pixel_size = pixel_size, $
      angles = angles, $
      THLAM_array = THLAM_array, $
      THLAM_lamvec = THLAM_lamvec, $
      THLAM_thvec = THLAM_thvec, $
      processes = processes, $
      total_number_of_processes = total_number_of_processes
      
    ;number of steps is ----> 1
    QXQZ_array=make_array(num, qxbins, qzbins)
    ;now we need to convert to QxQz
    
    make_QxQz, event = event, $
      num = num, $
      lambda_step = lambda_step, $
      qxbins = qxbins, $
      qzbins = qzbins, $
      qxrange = qxrange, $
      qzrange = qzrange, $
      THLAM_array = THLAM_array, $
      THLAM_thvec = THLAM_thvec, $
      THLAM_lamvec = THLAM_lamvec, $
      angles = angles, $
      QxQz_array = QxQz_array, $
      qxvec = qxvec, $
      qzvec = qzvec
      
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    ;number of steps is ----> 1
    ;extract specular reflections
    ;qxwidth=0.00005
    specular=make_array(num, qxbins)
    scale=make_array(num)
    time_stamp = ''
    scale = get_specular_scale(event=event, $
      num = num, $
      specular = specular, $
      scale = scale, $
      QxQz_array = QxQz_array, $
      qxvec = qxvec, $
      qzvec = qzvec, $
      qxwidth = qxwidth, $
      tnum = tnum, $
      time_stamp = time_stamp)
      
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    ;scale big data
    divarray = create_big_scaled_array(event=event, $
      scale = scale,$
      QxQz_array = QxQz_array, $
      num = num, $
      qxvec = qxvec, $
      qzvec = qzvec, $
      qxbins = qxbins, $
      qzbins = qzbins)
      
    metadata = produce_metadata_structure(event, $
      time_stamp = time_stamp, $
      list_data_nexus = list_data_nexus, $
      norm_nexus = norm_nexus, $
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
    
  endelse ;end of catch statement
  
  final_plot, event=event, $
    offset = offset, $
    time_stamp = time_stamp, $
    data = divarray,$
    x_axis = qxvec,$
    y_axis = qzvec,$
    metadata = metadata, $
    default_loadct = 5, $
    ;    default_scale_settings = default_scale_settings, $
    ;    current_plot_setting = current_plot_setting, $
    ;    Data_x = Data_x, $
    ;    Data_y = Data_y, $ ;Data_y
    ;    start_pixel = start_pixel, $
    main_base_uname = 'main_base'
    
  ;  window, 1
  ;  contour, smooth(alog(divarray+1),5), $
  ;    Qxvec, $
  ;    Qzvec, $
  ;    /fill, $
  ;    nlev=200, $
  ;    charsi=1.5, $
  ;    xtitle='QX', $
  ;    ytitle='QZ'
    
  update_progress_bar_percentage, event, ++processes, $
    total_number_of_processes
    
  hide_progress_bar, event
  widget_control, hourglass=0
  
end
