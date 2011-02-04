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
;    Generic function that retrieves the angle (dangle and dangle0)
;
; :Keywords:
;    event
;    angle_index
;    index
;
; :Returns:
;   {value:'',units:''}   units is either rad or degree
;
; :Author: j35
;-
function get_angle, event=event, angle_index=angle_index, index=index
  compile_opt idl2
  
  config_table = getValue(event=event, uname='ref_m_metadata_table')
  dangle = config_table[angle_index,index]
  
  ;keep only the rad value
  if (dangle eq '') then return, {value:'',units:''}
  dangle_rad_array = strsplit(dangle,'(',/extract)
  dangle_rad = strsplit(dangle_rad_array[1],')',/extract)
  
  return, {value:dangle_rad,units:'rad'}
end

;+
; :Description:
;    creates a strcture value/units of the dangle angle
;
; :Keywords:
;    event
;    file_index
;
; :Returns:
;   {value:'',units:''}   units is either rad or degree
;
; :Author: j35
;-
function get_dangle, event=event, file_index=file_index
  compile_opt idl2
  
  _angle_value_units = get_angle(event=event, angle_index=4, index=file_index)
  
  return, _angle_value_units
end

;+
; :Description:
;    creates a strcture value/units of the dangle0 angle
;
; :Keywords:
;    event
;    file_index
;
; :Returns:
;   {value:'',units:''}   units is either rad or degree
;
; :Author: j35
;-
function get_dangle0, event=event, file_index=file_index
  compile_opt idl2
  
  _angle_value_units = get_angle(event=event, angle_index=5, index=file_index)
  
  return, _angle_value_units
end

;+
; :Description:
;    retrieves the 2D spectrum of the normalization file
;    ex: Array[2,751]
;
; :Params:
;    event
;    list_norm_nexus   full path of all the normalization files
;    proceses
;    total_number_of_processes
;-
function get_normalization_spectrum, event, $
    list_norm_nexus, $
    processes, $
    total_number_of_processes
  compile_opt idl2
  
  nbr_files = n_elements(list_norm_nexus)
  spectrum = ptrarr(nbr_files, /allocate_heap)
  
  index = 0
  while (index lt nbr_files) do begin
  
    message = ['> Start retrieving normalization spectrum [tof,counts] ... ']
    message = [message, '-> NeXus file name: ' + list_norm_nexus[index]]
    log_book_update, event, message=message
    
    ;check if we already loaded this data set or not
    already_loaded_flag  = 0b
    already_loaded_index = 0
    if (index gt 0) then begin
      current_file = list_norm_nexus[index]
      _where_index = where(current_file eq list_norm_nexus)
      _first_index = _where_index[0]
      if (_first_index ne index) then begin
        already_loaded_index = _first_index
        already_loaded_flag = 1b
      endif
    endif
    
    if (already_loaded_flag) then begin
      _spectrum = *spectrum[already_loaded_index]
      message = ['> Copied already retrieved normalization ' + $
        'spectrum [tof,counts]']
    endif else begin
      iNorm = obj_new('IDLnexusUtilities', list_norm_nexus[index])
      _spectrum = iNorm->get_TOF_counts_data()
      obj_destroy, iNorm
      message = ['> Done with retrieving normalization spectrum [tof,counts]']
    endelse
    
    sz = size(_spectrum)
    message1 = '-> size(spectrum): [' + $
      strcompress(strjoin(sz,','),/remove_all) + ']'
    message = [message, message1]
    log_book_update, event, message=message
    
    *spectrum[index] = _spectrum
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    index++
  endwhile
  
  return, spectrum
end

;+
; :Description:
;    retrieves the 2D spectrum of the normalization file for REF_M instrument
;    ex: Array[2,751]
;
; :Keywords:
;    event
;    list_norm_nexus   full path of all the normalization files
;    list_norm_spin    list of spins for the normalization files
;    proceses
;    total_number_of_processes
;-
function get_ref_m_normalization_spectrum, event=event, $
    list_norm_nexus=list_norm_nexus, $
    list_norm_spin=list_norm_spin, $
    processes=processes, $
    total_number_of_processes=total_number_of_processes
  compile_opt idl2
  
  nbr_files = n_elements(list_norm_nexus)
  spectrum = ptrarr(nbr_files, /allocate_heap)
  
  index = 0
  while (index lt nbr_files) do begin
  
    message = ['> Start retrieving normalization spectrum [tof,counts] ... ']
    message = [message, '-> NeXus file name: ' + list_norm_nexus[index] + $
      ' (' + list_norm_spin[index] + ')']
    log_book_update, event, message=message
    
    ;check if we already loaded this data set or not with the same spin
    already_loaded_flag  = 0b
    already_loaded_index = 0
    current_file = list_norm_nexus[index]
    current_spin = list_norm_spin[index]
    if (index gt 0) then begin ;no need to look for first normalization file
      _where_same_file_index = where(current_file eq list_norm_nexus, $
      nbr_same_file)
      _where_same_spin_index = where(current_spin eq list_norm_spin, $
      nbr_same_spin)
      
      if (nbr_same_file gt 1 && nbr_same_spin gt 1) then begin
        _same_index = 0
        while (_same_index lt n_elements(_where_same_file_index)) do begin
          ;make sure we are not at the same index than the current working index
          if (_same_index ne index) then begin
            if (list_norm_nexus[_where_same_file_index[_same_index]] eq $
              current_file && $
              list_norm_spin[_where_same_spin_index[_same_index]] eq $
              current_spin) then begin
              already_loaded_index = _where_same_file_index[_same_index]
              already_loaded_flag = 1b
              break
            endif
          endif
          _same_index++
        endwhile
      endif ; no need to check if duplicated spin/files have the same index
    endif
    
    if (already_loaded_flag) then begin
    
      _spectrum = *spectrum[already_loaded_index]
      message = ['> Copied already retrieved normalization ' + $
        'spectrum [tof,counts]']
        
    endif else begin
    
      iNorm = obj_new('IDLnexusUtilities', current_file, $
        spin_state=current_spin )
      _spectrum = iNorm->get_TOF_counts_data()
      obj_destroy, iNorm
      message = ['> Done with retrieving normalization spectrum [tof,counts]']
    endelse
    
    sz = size(_spectrum)
    message1 = '-> size(spectrum): [' + $
      strcompress(strjoin(sz,','),/remove_all) + ']'
    message = [message, message1]
    log_book_update, event, message=message
    
    *spectrum[index] = _spectrum
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    index++
  endwhile
  
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
  
  sz = (size(spectrum,/dim))[0]
  
  _index = 0
  while (_index lt sz[0]) do begin
  
    _spectrum = *spectrum[_index]
    
    list = where(_spectrum[0,*] ge _TOFmin and _spectrum[0,*] le _TOFmax)
    _spectrum = _spectrum[*,list]
    _spectrum[1,*] = _spectrum[1,*]/max(_spectrum[1,*]) ;normalize spectrum to 1
    
    *spectrum[_index] = _spectrum
    
    _sz = size(_spectrum)
    message3 = '-> size(spectrum): [' + $
      strcompress(strjoin(_sz,','),/remove_all) + ']'
    log_book_update, event, message = [message, message1, message2, message3]
    
    _index++
  endwhile
  
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
  
  message = strarr(19)
  i=0
  
  ;isolate filename from spinstate
  filename_array = strsplit(filename,'(',/extract)
  filename = filename_array[0]
  if (n_elements(filename_array) gt 1) then begin
    spin_array = strmid(strsplit(filename_array[1],')',/extract),2)
    spin_state = spin_array[0]
  endif else begin
    spin_state = ''
  endelse
  
  message[i++] = '> Read data from NeXus ' + filename
  if (spin_state eq '') then begin
    message[i++] = '-> spin state: N/A'
  endif else begin
    message[i++] = '-> spin state: ' + spin_state
  endelse
  
  iFile = obj_new('IDLnexusUtilities', filename, spin_state=spin_state)
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
  _thi = iFile->get_thi()
  
  obj_destroy, iFile
  
  theta = _theta.value
  twotheta = _twotheta.value
  thi = _thi.value
  
  theta_units = _theta.units
  twotheta_units = _twotheta.units
  thi_units = _thi.units
  
  message[i++] = '-> retrieved theta: ' + strcompress(theta,/remove_all) + $
    ' ' + strcompress(theta_units,/remove_all)
  message[i++] = '-> retrieved twotheta: ' + $
  strcompress(twotheta,/remove_all) + $
    ' ' + strcompress(twotheta_units,/remove_all)
   message[i++] = '-> retrieved thi: ' + strcompress(thi,/remove_all) + $
    ' ' + strcompress(thi_units,/remove_all)
    
  ;make sure we are in degrees
  theta_value_degree = convert_angle(angle=theta,$
    from_unit=theta_units,$
    to_unit='degree')
  twotheta_value_degree = convert_angle(angle=twotheta,$
    from_unit=twotheta_units,$
    to_unit='degree')
  thi_value_degree = convert_angle(angle=thi,$
    from_unit=thi_units,$
    to_unit='degree')
  
   message[i++] = '-> Make sure we are in degrees:'
  message[i++] = '-> theta: ' + strcompress(theta_value_degree,/remove_all) + $
    ' degrees'
  message[i++] = '-> twotheta: ' + $
   strcompress(twotheta_value_degree,/remove_all) + $
    ' degrees'
  message[i++] = '-> thi: ' + strcompress(thi_value_degree,/remove_all) + $
    ' degrees'
        
  Theta = float(theta_value_degree) - float(thi_value_degree)
  TwoTheta = float(TwoTheta_value_degree) - float(thi_value_degree)
  
   message[i++] = '-> Adding thi to theta and twotheta'
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
;    Retrieve all the important information from each data nexus files
;    for REF_M and keep only the range desired
;
; :Params:
;    event
;    filename
;    spin_state       ;data spin
;    file_index
;    TOFmin
;    TOFmax
;    PIXmin
;    PIXmax
;
; :Returns:
;   data    structure {data:image, dangle:dangle, dangle0:dangle0,$
;                      tof:tof, pixels:pixel}
;-
function read_ref_m_nexus, event, $
filename, $
spin_state, $
file_index, $
TOFmin, $
TOFmax, $
PIXmin, $
PIXmax
  compile_opt idl2
  
  message = strarr(14)
  i=0
  
  message[i++] = '> Read data from NeXus ' + filename
  if (spin_state eq '') then begin
    message[i++] = '-> spin state: N/A'
  endif else begin
    message[i++] = '-> spin state: ' + spin_state
  endelse
  
  iFile = obj_new('IDLnexusUtilities', filename, spin_state=spin_state)
  
  ;get data [tof, pixel_x, pixel_y]
  image = iFile->get_y_tof_data()
  sz = size(image)
  message[i++] = '-> retrieved Y vs TOF data [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
  print, 'help, image'
  help, image  
    
    
  ;get tof array only
  tof = iFile->get_TOF_data()
  sz = size(tof)
  message[i++] = '-> retrived tof axis data [' + $
    strcompress(strjoin(sz,','),/remove_all) + ']'
    
  obj_destroy, iFile
  
  ;get angles (dangle and dangle0)
  _dangle = get_dangle(event=event, file_index=file_index)
  _dangle0 = get_dangle0(event=event, file_index=file_index)
  
  dangle  = _dangle.value
  dangle0 = _dangle0.value
  
  dangle_units  = _dangle.units
  dangle0_units = _dangle0.units
  
  message[i++] = '-> retrieved dangle: ' + strcompress(dangle,/remove_all) + $
    ' ' + strcompress(dangle_units,/remove_all)
  message[i++] = '-> retrieved dangle0: ' + $
  strcompress(dangle0,/remove_all) + $
    ' ' + strcompress(dangle0_units,/remove_all)
    
  ;  Theta=theta+4.0
  ;  TwoTheta=TwoTheta+4.0
    
  ;  message[i++] = '-> Adding 4.0 to theta and twotheta'
  ;  message[i++] = '  -> theta: ' + strcompress(theta,/remove_all) + $
  ;    ' ' + strcompress(theta_units,/remove_all)
  ;  message[i++] = '  -> twotheta: ' + strcompress(twotheta,/remove_all) + $
  ;    ' ' + strcompress(twotheta_units,/remove_all)
    
  ;Determine where is the first and last tof in the range
  list=where(TOF ge TOFmin and TOF le TOFmax)
  t1=min(where(TOF ge TOFmin))
  t2=max(where(TOF le TOFmax))
  
  message[i++] = '-> [t1,t2]=[' + strcompress(t1,/remove_all) + $
    ',' + strcompress(t2,/remove_all) + ']'
    
  pixels=findgen(304)  ;256 for REF_L
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
  DATA={data:image, dangle:dangle, dangle0:dangle0, tof:tof, pixels:pixels}
  
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
;    This function loops through all the theta and twotheta (for REF_L) or
;    dangle and dangle0 (for REF_M) combinations
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
;    convert to theta/lambda
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
;    convert to theta/lambda for REF_M instrument
;
; :Params:
;    data
;    SD_d
;    MD_d
;    cpix
;    pix_size
;
;-
function convert_ref_m_THLAM, data, SD_d, MD_d, cpix, pix_size
  compile_opt idl2
  
  print, 'in convert_ref_m_thlam'
  help, data
  print
  
  TOF=data.TOF
  MD_d = MD_d[0]
  vel=MD_d/TOF         ;mm/ms = m/s
  
  h=6.626e-34   ;m^2 kg s^-1
  m=1.675e-27     ;kg
  
  lambda=h/(m*vel)  ;m
  lambda=lambda*1e10  ;angstroms
  
  ;calculate angle
  term1 = (float(data.pixels) - float(cpix)) * float(pix_size)
  term1 /= 2.*SD_d
  
  term2 = (float(data.dangle) - float(data.dangle0))/2.
  
  sangle = term1 + term2
  
  THLAM={data:data.data, lambda:lambda, sangle:sangle}
  
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
    
    NORM_DATA=SNS_divide_spectrum(RAW_DATA, *spectrum[read_loop])
    
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
    
    print, 'angles[0,*]: ' , angles[0,*]
    print, 'theta_val: ' , theta_val
    print, 'where(angles[0,*] eq theta_val: ' , where(angles[0,*] eq theta_val)
    print
    print, 'angles[1,*]: ' , angles[1,*]
    print, 'twotheta_val: ' , twotheta_val
    print, 'where(angles[1,*] eq twotheta_val: ' , where(angles[1,*] eq twotheta_val)
    print
    
    tilenum=where((angles[0,*] eq theta_val) and (angles[1,*] eq twotheta_val))
    print, tilenum
    
    ;tilenum = tilenum[0]
    
    help, THLAM_array
    help, tilenum
    help, THLAM.data
    print
    
    THLAM_array[tilenum,*,*]=THLAM_array[tilenum,*,*]+THLAM.data
    THLAM_thvec[tilenum,*]=THLAM.theta
    THLAM_lamvec[tilenum,*]=THLAM.lambda
    
    
    ;window,0, title = "Convertion: TOF->Lambda, Pixel->Theta"
    ;shade_surf, smooth(thlam.data,3), thlam.lambda, thlam.theta, ax=70, $
    ;charsi=2, xtitle='LAMBDA (' + string("305B) + ')', ytitle='THETA (rad)'
    ;wait,.1
    ;wshow
    
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
;   This create 3 arrays that hold the THLAM values
;
; INFOS
;   THLAM is an array containing all the data (for all angle measurements)
;   converted to SANGLE vs LAMBDA.
;   It is a 3-d array where the 1st dimension is the measurement #, 2nd
;   dimension is LAMBDA, and 3rd dimension is SANGLE.
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
pro build_ref_m_THLAM, event=event, $
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
  
  message = ['> Build THLAM (Sangle-Lambda) arrays for all each loaded files']
  
  for read_loop=0,file_num-1 do begin
  
    RAW_DATA= *DATA[read_loop]
    ;{data, theta, twotheta, tof, pixels}
    
    print, 'help, raw_data'
    help, raw_data
    
    NORM_DATA=SNS_divide_spectrum(RAW_DATA, *spectrum[read_loop])
    
    ;SD_d : sample to detector distance
    ;MD_d : moderator to detector
    THLAM=convert_ref_m_THLAM(NORM_DATA, $
      SD_d, $
      MD_d, $
      center_pixel[read_loop], $
      pixel_size)
    ;THLAM is a structure
    ;{ data, lambda, sangle}  with lambda in Angstroms and theta in radians
      
    ;round the angles to the nearset 100th of a degree
    dangle_val=round(RAW_DATA.dangle[0]*10000.0)/10000.0
    dangle0_val=round(RAW_DATA.dangle0[0]*10000.0)/10000.0
    dangle_val=dangle_val[0]
    dangle0_val=dangle0_val[0]
    
    print, 'angles[0,*]: ' , angles[0,*]
    print, 'dangle_val: ' , dangle_val
    print, 'where(angles[0,*] eq dangle_val: ' , where(angles[0,*] eq dangle_val)
    print
    print, 'angles[1,*]: ' , angles[1,*]
    print, 'dangle0_val: ' , dangle0_val
    print, 'where(angles[1,*] eq dangle0_val: ' , where(angles[1,*] eq dangle0_val)
    print
    
    tilenum=where((angles[0,*] eq dangle_val) and (angles[1,*] eq dangle0_val))
    print, tilenum
    
    ;tilenum = tilenum[0]
    
    help, THLAM_array
    help, tilenum
    help, THLAM.data
    print
    
    THLAM_array[tilenum,*,*]=THLAM_array[tilenum,*,*]+THLAM.data
    THLAM_thvec[tilenum,*]=THLAM.sangle
    THLAM_lamvec[tilenum,*]=THLAM.lambda
    
    ;window,0, title = "Convertion: TOF->Lambda, Pixel->Theta"
    ;shade_surf, smooth(thlam.data,3), thlam.lambda, thlam.theta, ax=70, $
    ;charsi=2, xtitle='LAMBDA (' + string("305B) + ')', ytitle='THETA (rad)'
    ;wait,.1
    ;wshow
    
    message1 = ['-> Created THLAM array of file # ' + $
      strcompress(read_loop,/remove_all)]
    message2 = ['   dangle: ' + strcompress(dangle_val,/remove_all) + $
      ' degrees']
    message3 = ['   dangle0: ' + strcompress(dangle0_val,/remove_all) + $
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
  lambda = calculate_lambda(tof_value=tof, $
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
  
  widget_control, event.top, get_uvalue=global
  _scaled_specular = (*global).scaled_specular
  
  if (_scaled_specular eq 'yes') then begin
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
  endif
  
  for loop=1,num-1 do begin
  
    overlap=where(specular[loop-1,*] ne 0 and specular[loop,*] ne 0)
    si=size(overlap,/dim)
    si=si[0]
    ratio=specular[loop-1,overlap]/specular[loop,overlap]
    r2=total(specular[loop-1,overlap])/total(specular[loop,overlap])
    scale[loop]=(total(ratio)/si)*scale[loop-1]
    
    if (_scaled_specular eq 'yes') then begin
      _oplot = plot(QZvec, specular[loop,*]*scale[loop],/overplot,$
        style_plot_lines[loop])
    endif
    
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
  
  ;contour, [[0,0],[20000,0]], [qxrange[0],qxrange[1]], $
  ; [qzrange[0],qzrange[1]],/nodata, charsi=1.5, xtitle='QX', ytitle='QZ'
  ;for loop=0,num-1 do begin
  ;contour, QXQZ_array[loop,*,*],Qxvec,Qzvec, /fill,nlev=200,/overplot
  ;wait,.05
  ;endfor
  
  countarray=make_array(qxbins,qzbins)
  ;count where the tiles have data
  for loop=0,num-1 do begin
    for xloop=0,qxbins-1 do begin
      for zloop=0,qzbins-1 do begin
        if qxqz_array[loop,xloop,zloop] ne 0 then $
        countarray[xloop,zloop]=countarray[xloop,zloop]+1
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
