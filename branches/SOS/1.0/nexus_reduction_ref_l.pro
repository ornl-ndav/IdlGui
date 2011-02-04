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
;    NeXus reduction for REF_L instrument
;
; :Params:
;    event
;
; :Author: j35
;-
pro go_nexus_reduction_ref_l, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  error = 0
  ;catch,error
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
      
    ;reset structure data
    structure = (*global).structure_data_working_with_nexus
    create_structure_data, structure=structure, $
      data=!null, $
      xaxis=!null, $
      yaxis=!null
    (*global).structure_data_working_with_nexus = structure
    
    hide_progress_bar, event
    widget_control, hourglass=0
    
    return
  endif else begin
  
    message = ['> Running NeXus reduction: ']
    
    widget_control, /hourglass
    show_progress_bar, event
    processes = 0
    
    message = [message, '-> Retrieving parameters.']
    log_book_update, event, message=message
    
    ;number of steps is ----> 1
    
    ;Retrieve variables
    big_table = getValue(event=event,uname='tab1_table')
    list_data_nexus = big_table[0,*]
    list_data_nexus = reform(list_data_nexus)
    not_empty = where(list_data_nexus ne '')
    list_data_nexus = list_data_nexus[not_empty]
    file_num = n_elements(list_data_nexus)
    
    ;file_num -> for each normalization loading
    total_number_of_processes = 7 + 2*file_num + file_num
    
    list_norm_nexus = big_table[1,*]
    list_norm_nexus = reform(list_norm_nexus)
    not_empty = where(list_norm_nexus ne '')
    list_norm_nexus = list_norm_nexus[not_empty]
    
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
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    ;number of steps is ----> 1
      
    ;create spectrum of normalization file
    if ((*global).debugger eq 'yes') then begin
      if (!version.os eq 'darwin') then begin
        path = '/Users/j35/IDLWorkspace80/SOS 1.0/'
      endif else begin
        path = '/SNS/users/j35/IDLWorkspace80/SOS 1.0/'
      endelse
      norm_file = path + 'Al_can_spectrum.dat'
      spectrum=xcr_direct(norm_file, 2)
      _spectrum = ptrarr(file_num,/allocate_heap)
      
      ;copy the same spectrum for all data set
      _local_index = 0
      while (_local_index lt file_num) do begin
        *_spectrum[_local_index] = spectrum
        _local_index++
      endwhile
      spectrum = _spectrum
    endif else begin
      ;number_of_steps is ----> file_num
      spectrum = get_normalization_spectrum(event, list_norm_nexus, $
        processes, $
        total_number_of_processes)
    endelse
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
    ;number of steps is ----> 1
    ;trip the spectrum to the relevant tof ranges
    spectrum = trim_spectrum(event, spectrum, TOFrange=TOFrange)
    
    ;prepare array of data coming from the data Nexus files
    fdig=make_array(file_num)
    
    ;determine the Nexus file(s) which include(s) the critical reflection
    ;all other tiles will be normalized to these.
    file_angles=make_array(3,file_num) ;[file_index, theta, twotheta]
    ;file_angles=make_array(2,file_num) ;[file_index, twotheta]
    ;Save big data structure into a array of pointers
    DATA = ptrarr(file_num, /allocate_heap)
    
    update_progress_bar_percentage, event, ++processes, $
      total_number_of_processes
      
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
    
    ;create unique increasing list of angles (twotheta)
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
    message = [message, message2, message21]
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
    
    _data = *data[0]
    _tof = _data.tof
    range_TOFmin = where(_tof le TOFmin, nbr)
    if (nbr ne -1) then begin
      index_TOFmin = range_TOFmin[-1]
    endif else begin
      index_TOFmin = 0
    endelse
    
    range_TOFmax = where(_tof ge TOFmax, nbr)
    if (nbr ne -1) then begin
      index_TOFmax = range_TOFmax[0]
    endif else begin
      index_TOFmax = n_elements(_tof-1)
    endelse
    
;    print, 'index_TOFmin: ' , index_TOFmin
;    print, 'index_TOFmax: ' , index_TOFmax
;    print, 'index_TOFmax - index_TOFmin: ' , index_TOFmax - index_TOFmin
;    print, 'TOFmax*5: ', TOFmax*5
;    print, 'TOFmin*5: ', TOFmin*5
;    print, 'floor((TOFmax-TOFmin)*5+1): ' , floor((TOFmax-TOFmin)*5+1)
    
    ;Create an array that wil contain all the data (for all angle measurements)
    ;converted to THETA vs Lambda

;OLD WAY
;    THLAM_array = make_array(num,floor((TOFmax-TOFmin)*5)+1,PIXmax-PIXmin+1)
;NEW WAY
    THLAM_array = make_array(num, index_TOFmax - index_TOFmin, PIXmax-PIXmin+1)

;old way
;    THLAM_lamvec= make_array(num,floor((TOFmax-TOFmin)*5)+1)
;new way
    THLAM_lamvec= make_array(num,index_TOFmax - index_TOFmin)

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
      list_norm_nexus = list_norm_nexus, $
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
      
  endelse ;end of catch statement
  
  offset = 50
  
  structure = (*global).structure_data_working_with_nexus
  create_structure_data, structure=structure, $
    data=divarray, $
    xaxis=qxvec, $
    yaxis=qzvec
  (*global).structure_data_working_with_nexus = structure
  
  final_plot, event=event, $
    offset = offset, $
    time_stamp = time_stamp, $
    data = divarray,$
    x_axis = qxvec,$
    y_axis = qzvec,$
    metadata = metadata, $
    default_loadct = 5, $
    main_base_uname = 'main_base', $
    output_folder = (*global).output_path
    
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
    
  ;define a new default output file name in the Create output tab
  define_new_default_output_file_name, event
  
  hide_progress_bar, event
  widget_control, hourglass=0
  
end