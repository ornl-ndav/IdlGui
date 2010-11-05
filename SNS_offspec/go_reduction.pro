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
;    norm_nexus   full path of the normalization nexus file
;
;-
function get_normalization_spectrum, norm_nexus
  compile_opt idl2
  
  iNorm = obj_new('IDLnexusUtilities', norm_nexus)
  spectrum = iNorm->get_TOF_counts_data()
  obj_destroy, iNorm
  
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
function trim_spectrum, spectrum, TOFrange=TOFrange
  compile_opt idl2
  
  _TOFmin = TOFrange[0]
  _TOFmax = TOFrange[1]
  
  list = where(spectrum[0,*] ge _TOFmin and spectrum[0,*] le _TOFmax)
  spectrum = spectrum[*,list]
  spectrum[1,*] = spectrum[1,*]/max(spectrum[1,*]) ;normalize spectrum to 1
  
  return, spectrum
end

;+
; :Description:
;    Retrieve all the important information from each data nexus files
;    and keep only the range desired
;
; :Params:
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
function read_nexus, filename, TOFmin, TOFmax, PIXmin, PIXmax
  compile_opt idl2
  
  iFile = obj_new('IDLnexusUtilities', filename)
  
  ;get data [tof, pixel_x, pixel_y]
  image = iFile->get_y_tof_data()
  print, 'file name is: ' , filename
  help, image
  
  ;get tof array only
  tof = iFile->get_TOF_data()
help, tof
  
  ;get angles
  Theta = iFile->get_theta()
  TwoTheta = iFile->get_twoTheta()
  
  theta = theta.value
  twotheta = twotheta.value

  obj_destroy, iFile
  
  Theta=theta+4.0
  TwoTheta=TwoTheta+4.0
  
  print, 'TOFmin: ', TOFmin
  print, 'TOFmax: ', TOFmax
  
  ;Determine where is the first and last tof in the range
  list=where(TOF ge TOFmin and TOF le TOFmax)
  t1=min(where(TOF ge TOFmin))
  t2=max(where(TOF le TOFmax))
  
  pixels=findgen(256)
  p1=min(where(pixels ge PIXmin))
  p2=max(where(pixels le PIXmax))
  
  TOF=TOF[t1:t2]
  PIXELS=pixels[p1:p2]
  
  print, 't1,t2,p1,p2: ' , t1,t2,p1,p2
  
  image=image[t1:t2,p1:p2]
  
  ;image -> data (counts)
  ;tof   -> tof axis
  ;pixels -> list of pixels to keep in calculation
  DATA={data:image, theta:theta, twotheta:twotheta, tof:tof, pixels:pixels}
  return, DATA
  
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
  
  widget_control, /hourglass
  device, decomposed = 0
  loadct, 5
  show_progress_bar, event
  
  ;Retrieve variables
  
  list_data_nexus = (*(*global).list_data_nexus)
  norm_nexus      = (*global).norm_nexus
  
  QZmax = get_ranges_qz_max(event)
  QZmin = get_ranges_qz_min(event)
  QZrange = [QZmin, QZmax]
  
  QXbins = get_bins_qx(event)
  QZbins = get_bins_qz(event)
  
  QXmin = get_ranges_qx_min(event)
  QXmax = get_ranges_qx_max(event)
  QXrange = [QXmin, QXmax]
  
  TOFmin = get_tof_min(event)
  TOFmax = get_tof_max(event)
  TOFrange = [TOFmin, TOFmax]
  
  PIXmin = get_pixel_min(event)
  PIXmax = get_pixel_max(event)
  
  center_pixel = get_center_pixel(event)
  pixel_size = get_pixel_size(event)
  
  SD_d = get_d_sd(event)
  MD_d = get_d_md(event)
  
  ;create spectrum of normalization file
  spectrum = get_normalization_spectrum(norm_nexus)
  
  ;trip the spectrum to the relevant tof ranges
  spectrum = trim_spectrum(spectrum, TOFrange=TOFrange)
  
  ;prepare array of data coming from the data Nexus files
  file_num = n_elements(list_data_nexus)
  fdig=make_array(file_num)
  
  ;determine the Nexus file(s) which include(s) the critical reflection
  ;all other tiles will be normalized to these.
  file_angles=make_array(3,file_num) ;[file_index, theta, twotheta]
  for read_loop=0,file_num-1 do begin
    ;check to see if the theta value is the same as CE_theta
    DATA = read_nexus(list_data_nexus[read_loop], TOFmin, TOFmax, PIXmin, PIXmax)
    ;round the angles to the nearset 100th of a degree
    file_angles[0,read_loop]=read_loop
    file_angles[1,read_loop]=round(DATA.theta*100.0)/100.0
    file_angles[2,read_loop]=round(DATA.twotheta*100.0)/100.0
  endfor
  
  
;  update_progress_bar_percentage, event, percentage=100
  
  
  
  
  
  
  
  
  
  
  
  hide_progress_bar, event
  widget_control, hourglass=0
  
end