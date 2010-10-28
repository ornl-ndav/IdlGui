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
;    Retrieve the 3D data set [tof, pixel_x, pixel_y]
;
; :Keywords:
;    spin_state
;
; :Author: j35
;-
function IDLnexusUtilities::get_full_data, spin_state=spin_state
compile_opt idl2

  if (n_elements(spin_state) eq 0) then spin_state=self.spin_state
  
  fileID = h5f_open(self.file_name)
  
  if (spin_state eq '') then begin
    count_path = 'entry/bank1/data/'
  endif else begin
    ;make sure the spin_state has the right format
    case (strlowcase(spin_state)) of
    'off_off' : spin_state = 'Off_Off'
    'off_on'  : spin_state = 'Off_On'
    'on_off'  : spin_state = 'On_Off'
    'on_on'   : spin_state = 'On_On'
    endcase
    count_path = 'entry-'+spin_state+'/bank1/data/'
  endelse
  
  count_id = h5d_open(fileID, count_path)
  count_data = h5d_read(count_id)
  h5d_close, count_id
  h5f_close, fileID

  return, count_data
end

;+
; :Description:
;    Retrieve the data (tof and counts),
;    integrate the data over all the pixels and
;    produce 2 columns data set with first column
;    being the tof(ms) and second column the counts.
;
; :Keywords:
;    spin_state
;
; :Author: j35
;-
function IDLnexusUtilities::get_TOF_counts_data, spin_state=spin_state
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state=self.spin_state
  
  fileID = h5f_open(self.file_name)
  
  if (spin_state eq '') then begin
    tof_path   = 'entry/bank1/time_of_flight/'
    count_path = 'entry/bank1/data/'
  endif else begin
    ;make sure the spin_state has the right format
    case (strlowcase(spin_state)) of
    'off_off' : spin_state = 'Off_Off'
    'off_on'  : spin_state = 'Off_On'
    'on_off'  : spin_state = 'On_Off'
    'on_on'   : spin_state = 'On_On'
    endcase
    tof_path   = 'entry-'+spin_state+'/bank1/time_of_flight/'
    count_path = 'entry-'+spin_state+'/bank1/data/'
  endelse
  
  tof_id = h5d_open(fileID, tof_path)
  tof_data = h5d_read(tof_id)
  h5d_close, tof_id
  ;microS -> mS
  tof_data /= 1000.
  
  count_id = h5d_open(fileID, count_path)
  count_data = h5d_read(count_id)
  h5d_close, count_id
  
  h5f_close, fileID
  
  ;integrated over all the pixels
  _count_data = total(count_data,2)
  _count_data = total(_count_data,2)
  ;get number of bins
  nbr_bin = n_elements(_count_data)
  
  ;initialize final array
  data = fltarr(2,nbr_bin)
  
  data[0,*] = tof_data[0:-2]
  data[1,*] = _count_data

  return, data
end

;+
; :Description:
;    init procedure of the program that check if the
;    file exist
;
; :Params:
;    full_nexus_name
;
; :Author: j35
;-
function IDLnexusUtilities::init, full_nexus_name
  compile_opt idl2
  
  ;check if nexus file exist
  if (file_test(full_nexus_name) ne 1) then return, 0
  self.file_name = full_nexus_name
  return, 1
  
end

;+
; :Description:
;    Declaration of the class that will retrieve data
;    from the NeXus file

; :Author: j35
;-
pro IDLnexusUtilities__define
  compile_opt idl2
  
  struct = { IDLnexusUtilities, $
    file_name: '',$
    spin_state: '',$
    var: ''}
    
end

