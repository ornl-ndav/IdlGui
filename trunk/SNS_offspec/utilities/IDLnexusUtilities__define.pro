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
;   retrieve the value at the location defined in the path
;
; :Keywords:
;    file_name
;    path
;
; :Author: j35
;-
function retrieve_value, file_name=file_name, path=path
  compile_opt idl2
  
  fileID = h5f_open(file_name)
  value_id = h5d_open(fileID, path)
  value = h5d_read(value_id)
  h5d_close, value_id
  h5f_close, fileID
  
  return, value
end

;+
; :Description:
;    This local function returns the distance Sample-Detector
;    for the REF_M instrument (old and new format of NeXus files)

; :Keywords:
;    entry_spin_state
;    fileID
;
; :Returns;
;   [distance, units]
;
; :Author: j35
;-
function _get_d_SD_for_ref_m, entry_spin_state = entry_spin_state , fileID=fileID
  compile_opt idl2
  
  path_value = entry_spin_state + '/instrument/bank1/SampleDetDis/readback/'
  path_units = entry_spin_state + '/instrument/bank1/SampleDetDis/units'
  
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with new path_value (readback -> value)
    path_value = entry_spin_state + '/instrument/bank1/SampleDetDis/value/'
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      return, ['N/A','N/A']
    endif else begin
      pathID_value = h5d_open(fileID, path_value)
      dis_value = strcompress(h5d_read(pathID_value),/remove_all)
      
      pathID_units = h5a_open_name(pathID_value,'units')
      dis_units = strcompress(h5a_read(pathID_units),/remove_all)
      
      h5d_close, pathID_value
      return, [dis_value,dis_units]
    endelse
  endif else begin
    pathID_value = h5d_open(fileID, path_value)
    dis_value = strcompress(h5d_read(pathID_value),/remove_all)
    
    pathID_units = h5a_open_name(pathID_value,'units')
    dis_units = strcompress(h5a_read(pathID_units),/remove_all)
    
    h5d_close, pathID_value
    return, [dis_value,dis_units]
  endelse
  
end

;+
; :Description:
;    This local function returns the distance Sample-Detector
;    for the REF_L instrument
;
; :Keywords:
;    fileID
;
; :Returns;
;   [distance, units]
;
; :Author: j35
;-
function _get_d_SD_for_ref_l, fileID=fileID
  compile_opt idl2
  
  ;FIXME
  return, ['N/A','N/A']
  
end

;+
; :Description:
;    retrieves the distance Sample - Detector
;
; :Author: j35
;-
function IDLnexusUtilities::get_d_SD
  compile_opt idl2
  
  fileID = h5f_open(self.file_name)
  
  instrument = self.instrument
  case (strlowcase(self.instrument)) of
    'ref_l': value_units = _get_d_SD_for_ref_l(fileID=fileID)
    'ref_m': value_units = _get_d_SD_for_ref_m(entry_spin_state=self.entry_spin_state, fileID=fileID)
    else:
  endcase
  
  h5f_close, fileID
  
  return, value_units
  
end

;+
; :Description:
;    retrieves the distance Moderator - Sample
;
; :Author: j35
;-
function IDLnexusUtilities::get_d_MS
  compile_opt idl2
  
  
  
  
  
end

;+
; :Description:
;    Retrieve the 3D data set [tof, pixel_x, pixel_y]
;
; :Keywords:
;    spin_state
;
; :Author: j35
;-
function IDLnexusUtilities::get_full_data
  compile_opt idl2
  count_path = self.entry_spin_state + 'bank1/data/'
  count_data = retrieve_value(file_name=self.file_name, path=count_path)
  return, count_data
end

;+
; :Description:
;    Retrieve the data (tof and counts),
;    integrate the data over all the pixels and
;    produce 2 columns data set with first column
;    being the tof(ms) and second column the counts.
;
; :Author: j35
;-
function IDLnexusUtilities::get_TOF_counts_data
  compile_opt idl2
  
  fileID = h5f_open(self.file_name)
  
  tof_path   = self.entry_spin_state + '/bank1/time_of_flight/'
  count_path = self.entry_spin_state + '/bank1/data/'
  
  tof_id = h5d_open(fileID, tof_path)
  tof_data = h5d_read(tof_id)
  h5d_close, tof_id
  ;microS -> mS
  tof_data /= 1000.
  
  count_id = h5d_open(fileID, count_path)
  count_data = h5d_read(count_id)
  h5d_close, count_id
  
  ;close file
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
;    Retrieves the theta angle value
;
; :Returns:
;   theta value
;
; :Author: j35
;-
function IDLnexusUtilities::get_theta
  compile_opt idl2
  
  if (self.instrument eq 'REF_M') then return, ['']
  
  theta_path = self.entry_spin_state + '/sample/ths/average_value'
  theta_data = retrieve_value(file_name=self.file_name, path=theta_path)
  
  return, theta_data
end

;+
; :Description:
;   Retrieves the twoTheta angle value
;
; :Returns:
;   twoTheta value
;
; :Author: j35
;-
function IDLnexusUtilities::get_twoTheta
  compile_opt idl2
  
  if (self.instrument eq 'REF_M') then return, ['','']
  
  twotheta_path = self.entry_spin_state + '/instrument/bank1/tthd/average_value'
  twotheta_data = retrieve_value(file_name=self.file_name, path=twotheta_path)
  




  
  
  
  return, twotheta_data
end

;+
; :Description:
;    init procedure of the program that check if the
;    file exist
;
; :Params:
;    full_nexus_name
;
; :Keywords:
;   spin_state
;
; :Author: j35
;-
function IDLnexusUtilities::init, full_nexus_name, spin_state=spin_state
  compile_opt idl2
  
  ;check if nexus file exist
  if (file_test(full_nexus_name) ne 1) then return, 0
  self.file_name = full_nexus_name
  
  if (n_elements(spin_state) ne 0) then begin
    ;make sure the spin_state has the right format
    case (strlowcase(spin_state)) of
      'off_off' : spin_state = 'Off_Off'
      'off_on'  : spin_state = 'Off_On'
      'on_off'  : spin_state = 'On_Off'
      'on_on'   : spin_state = 'On_On'
    endcase
    self.spin_state = spin_state
    self.entry_spin_state = 'entry-' + spin_state
    self.instrument = 'REF_M'
  endif else begin
    self.instrument = 'REF_L'
    self.entry_spin_state = 'entry'
  endelse
  
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
    instrument: '',$
    entry_spin_state: '',$
    var: ''}
    
end

