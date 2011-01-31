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

;
;!!! IMPORTANT !!!
;
; Dependencies: configuration file (.cfg) defined in the header of this class
; This configuration file is used when some of the infos can not be found
; in the NeXus file, and provides default values for those.
;
;

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
;    return the value and the units at the given path
;
; :Keywords:
;    file_name
;    path
;
; :Returns:
;   [value, units]
;
; :Author: j35
;-
function retrieve_value_units, file_name=file_name, path=path
  compile_opt idl2
  
  fileID = h5f_open(file_name)
  value_id = h5d_open(fileID, path)
  value = strcompress(h5d_read(value_id),/remove_all)
  units_id = h5a_open_name(value_id, 'units')
  units = strcompress(h5a_read(units_id),/remove_all)
  h5d_close, value_id
  h5f_close, fileID
  return, [value, units]
  
end

;************** local functions ***********************************************

;+
; :Description:
;    General function that will returns the value/units array for the
;    old/new NeXus version or using the config file if none of the first
;    ones work.

; :Keywords:
;    fileID
;    entry_spin_state       ex:'' or 'entry-Off_Off'
;    old_file_path_value    ex:'/instrument/moderator/ModeratorSamDis/readback/'
;    old_file_path_units    ex:'/instrument/moderator/ModeratorSamDis/units'
;    new_file_path_value    ex:'/instrument/moderator/ModeratorSamDis/value/'
;    config_path_array      ex:['configuration','REF_L','d_MS']
;    configuration_file     ex:'SNS_offspec_instruments.cfg'
;
; :Author: j35
;-
function _get_value_units_from_old_new_cfg, fileID = fileID, $
    entry_spin_state = entry_spin_state, $
    old_file_path_value = old_file_path_value, $
    old_file_path_units = old_file_path_units, $
    new_file_path_value = new_file_path_value, $
    config_path_array = config_path_array, $
    configuration_file = configuration_file
    
  if (n_elements(entry_spin_state) eq 0) then entry_spin_state = ''
  
  path_value = entry_spin_state + old_file_path_value
  path_units = entry_spin_state + old_file_path_units
  
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with new path_value (readback -> value)
    path_value = entry_spin_state + new_file_path_value
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      
      catch, error2
      if (error2 ne 0) then begin
        catch,/cancel
        return, ['N/A','N/A']
      endif else begin
        ;retrieve value from configuration file
        iCfg = obj_new('idlxmlparser', configuration_file)
        value = iCfg->getValue(tag=config_path_array)
        units = iCfg->getValue(tag=config_path_array, attr='units')
        obj_destroy, iCfg
        return, [value,units]
      endelse
      
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
function _get_d_SD_for_ref_m, entry_spin_state = entry_spin_state , $
    fileID=fileID, $
    configuration_file = configuration_file
  compile_opt idl2
  
  old_file_path_value = '/instrument/bank1/SampleDetDis/readback/'
  old_file_path_units = '/instrument/bank1/SampleDetDis/units'
  new_file_path_value = '/instrument/bank1/SampleDetDis/value/'
  config_path_array   = ['config','instruments','REF_M','d_SD']
  
  value_units = _get_value_units_from_old_new_cfg (fileID = fileID, $
    entry_spin_state = entry_spin_state, $
    old_file_path_value = old_file_path_value, $
    old_file_path_units = old_file_path_units, $
    new_file_path_value = new_file_path_value, $
    config_path_array = config_path_array, $
    configuration_file = configuration_file)
    
  return, value_units
  
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
function _get_d_SD_for_ref_l, fileID=fileID, $
    configuration_file=configuration_file
    
  compile_opt idl2
  error = 0
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, ['N/A','N/A']
  endif else begin
    ;retrieve value from configuration file
    iCfg = obj_new('idlxmlparser', configuration_file)
    value = iCfg->getValue(tag=['config','instruments','REF_L','d_SD'])
    units = iCfg->getValue(tag=['config','instruments','REF_L','d_SD'], $
      attr='units')
    obj_destroy, iCfg
    return, [value,units]
  endelse
  
end

;+
; :Description:
;    This local function returns the distance Moderator-Sample
;    for the REF_L instrument
;
; :Keywords:
;    fileID
;    configuration_file
;
; :Returns;
;   [distance, units]
;
; :Author: j35
;-
function _get_d_MS_for_ref_l, fileID=fileID, $
    configuration_file=configuration_file
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, ['N/A','N/A']
  endif else begin
    ;retrieve value from configuration file
    iCfg = obj_new('idlxmlparser', configuration_file)
    value = iCfg->getValue(tag=['config','instruments','REF_L','d_MS'])
    units = iCfg->getValue(tag=['config','instruments','REF_L','d_MS'], $
      attr='units')
    obj_destroy, iCfg
    return, [value,units]
  endelse
  
end

;+
; :Description:
;    This local function returns the distance Moderator-Sample
;    for the REF_M instrument (old and new format of NeXus files)

; :Keywords:
;    entry_spin_state
;    fileID
;    configuration_file
;
; :Returns;
;   [distance, units]
;
; :Author: j35
;-
function _get_d_MS_for_ref_m, entry_spin_state = entry_spin_state , $
    fileID=fileID, configuration_file=configuration_file
  compile_opt idl2
  
  path_value = entry_spin_state + $
    '/instrument/moderator/ModeratorSamDis/readback/'
  path_units = entry_spin_state + $
    '/instrument/moderator/ModeratorSamDis/units'
    
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with new path_value (readback -> value)
    path_value = entry_spin_state + $
      '/instrument/moderator/ModeratorSamDis/value/'
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      
      catch, error2
      if (error2 ne 0) then begin
        catch,/cancel
        return, ['N/A','N/A']
      endif else begin
        ;retrieve value from configuration file
        iCfg = obj_new('idlxmlparser', configuration_file)
        value = iCfg->getValue(tag=['config','instruments','REF_M','d_MS'])
        units = iCfg->getValue(tag=['config','instruments','REF_M','d_MS'], $
          attr='units')
        obj_destroy, iCfg
        return, [value,units]
      endelse
      
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

;******************************************************************************

;+
; :Description:
;    Retrieve the 3D data set [tof, pixel_x, pixel_y]
;
; :Author: j35
;-
function IDLnexusUtilities::get_full_data
  compile_opt idl2
  count_path = self.entry_spin_state + '/bank1/data/'
  count_data = retrieve_value(file_name=self.file_name, path=count_path)
  return, count_data
end

;+
; :Description:
;    retrieve the [tof,pixel_x] data directly without the need to
;    get all the data
;
; :Author: j35
;-
function IDLnexusUtilities::get_y_tof_data
  compile_opt idl2
  count_path = self.entry_spin_state + '/bank1/data_y_time_of_flight/'
  count_data = retrieve_value(file_name=self.file_name, path=count_path)
  return, count_data
end

;+
; :Description:
;    retrieve only the tof axis in ms
;
; :Author: j35
;-
function IDLnexusUtilities::get_tof_data
  compile_opt idl2
  count_path = self.entry_spin_state + '/bank1/time_of_flight/'
  tof_data = retrieve_value(file_name=self.file_name, path=count_path)
  tof_data /= 1000.0 ;to get the tof in ms
  return, tof_data
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
;    Retrieves the thi angle for the REF_L instrument
;
; :Returns:
;    structure {value:'thi value', units:'thi units'}
;
; :Author: j35
;-
function IDLnexusUtilities::get_thi
compile_opt idl2

if (self.instrument eq 'REF_M') then return, {value:'', units:''}

thi_path = self.entry_spin_state + '/instrument/aperture1/thi/average_value'
value_units = retrieve_value_units(file_name=self.file_name, path=thi_path)

return, {value:value_units[0], units:value_units[1]}
end

;+
; :Description:
;    Retrieves the theta angle value and its units
;
; :Returns:
;   structure {value:'theta value', units:'theta units'
;
; :Author: j35
;-
function IDLnexusUtilities::get_theta
  compile_opt idl2
  
  if (self.instrument eq 'REF_M') then return, {value:'',units:''}
  
  theta_path = self.entry_spin_state + '/sample/ths/average_value'
  value_units = retrieve_value_units(file_name=self.file_name, path=theta_path)
  
  return, {value:value_units[0], units:value_units[1]}
end

;+
; :Description:
;   Retrieves the twoTheta angle value and units
;
; :Returns:
;   structure of twoTheta value and units {value:value, units:units}
;
; :Author: j35
;-
function IDLnexusUtilities::get_twoTheta
  compile_opt idl2
  
  if (self.instrument eq 'REF_M') then return, {value:'',units:''}
  
  twotheta_path = self.entry_spin_state + '/instrument/bank1/tthd/average_value'
  value_units = retrieve_value_units(file_name=self.file_name, $
    path=twotheta_path)
    
  return, {value:value_units[0], units:value_units[1]}
end

;+
; :Description:
;    retrieves the distance Moderator - Sample and its units
;
; :Returns:
;   structure {value:value, units:units}
;
; :Author: j35
;-
function IDLnexusUtilities::get_d_MS
  compile_opt idl2
  
  fileID = h5f_open(self.file_name)
  configuration_file = self.configuration_file
  
  instrument = self.instrument
  case (strlowcase(self.instrument)) of
    'ref_l': value_units = _get_d_MS_for_ref_l(fileID=fileID, $
      configuration_file = configuration_file)
    'ref_m': value_units = _get_d_MS_for_ref_m(entry_spin_state=$
      self.entry_spin_state, fileID=fileID, $
      configuration_file = configuration_file)
    else:
  endcase
  
  h5f_close, fileID
  
  return, {value:value_units[0], units:value_units[1]}
  
end

;+
; :Description:
;    retrieves the distance Sample - Detector and its units
;
; :Returns:
;   structure of {value:value, units:units}
;
; :Author: j35
;-
function IDLnexusUtilities::get_d_SD
  compile_opt idl2
  
  fileID = h5f_open(self.file_name)
  configuration_file = self.configuration_file
  
  instrument = self.instrument
  case (strlowcase(self.instrument)) of
    'ref_l': value_units = _get_d_SD_for_ref_l(fileID=fileID, $
      configuration_file=configuration_file)
    'ref_m': value_units = _get_d_SD_for_ref_m(entry_spin_state=$
      self.entry_spin_state, $
      fileID=fileID, $
      configuration_file = configuration_file)
    else:
  endcase
  
  h5f_close, fileID
  
  return, {value:value_units[0], units:value_units[1]}
end

;+
; :Description:
;    retrieves the DANGLE value and units
;
; :Returns:
;   structure of {value:value, units:units}
;
; :Author: j35
;-
function IDLnexusUtilities::get_dangle
  compile_opt idl2
  
  new_path_value = self.entry_spin_state + '/instrument/bank1/DANGLE/value'
  old_path_value = self.entry_spin_state + '/instrument/bank1/DANGLE/readback'
  
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with odl path_value (value -> readback)
    
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      return, {value:'N/A',units:'N/A'}
      
    endif else begin
    
      value_units = retrieve_value_units(file_name=self.file_name, $
        path=old_path_value)
      return, {value:value_units[0], units:value_units[1]}
      
    endelse
    
  endif else begin
  
    value_units = retrieve_value_units(file_name=self.file_name, $
      path=new_path_value)
    return, {value:value_units[0], units:value_units[1]}
    
  endelse
  
end

;+
; :Description:
;    retrieves the DANGLE0 value and units
;
; :Returns:
;   structure of {value:value, units:units}
;
; :Author: j35
;-
function IDLnexusUtilities::get_dangle0
  compile_opt idl2
  
  new_path_value = self.entry_spin_state + '/instrument/bank1/DANGLE0/value'
  old_path_value = self.entry_spin_state + '/instrument/bank1/DANGLE0/readback'
  
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with odl path_value (value -> readback)
    
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      return, {value:'N/A',units:'N/A'}
      
    endif else begin
    
      value_units = retrieve_value_units(file_name=self.file_name, $
        path=old_path_value)
      return, {value:value_units[0], units:value_units[1]}
      
    endelse
    
  endif else begin
  
    value_units = retrieve_value_units(file_name=self.file_name, $
      path=new_path_value)
    return, {value:value_units[0], units:value_units[1]}
    
  endelse
  
end

;+
; :Description:
;    retrieves the DIRPIX value
;
; :Returns:
;   value
;
; :Author: j35
;-
function IDLnexusUtilities::get_dirpix
  compile_opt idl2
  
  new_path = self.entry_spin_state + '/instrument/bank1/DIRPIX/value'
  old_path = self.entry_spin_state + '/instrument/bank1/DIRPIX/readback'
  
  catch, error_value
  if (error_value ne 0) then begin
    catch,/cancel
    ;we are dealing with a new NeXus with odl path_value (value -> readback)
    
    catch, error_value_2
    if (error_value_2 ne 0) then begin
      catch,/cancel
      return, 'N/A'
      
    endif else begin
    
      value = retrieve_value(file_name=self.file_name, path=old_path)
      return, value
      
    endelse
    
  endif else begin
  
    value = retrieve_value(file_name=self.file_name, path=new_path)
    return, value
    
  endelse
  
end

;+
; :Description:
;    Retrieves the size of the detector (number of pixels in x dimension
;    and y dimension)
;
; :Returns:
;   [x_dimension, y_dimension]
;
; :Author: j35
;-
function IDLnexusUtilities::get_detectorDimension
  compile_opt idl2
  
  if (self.instrument eq 'REF_L') then begin ;REF_L
  
    path = self.entry_spin_state + '/bank1/data_x_y'
    data_x_y = retrieve_value(file_name=self.file_name, path=path)
    return, size(data_x_y,/dim)
    
  endif else begin ;REF_M
  
    old_path = self.entry_spin_state + '/instrument/bank1/azimuthal_angle'
    new_path = self.entry_spin_state + '/bank1/data_x_y'
    
    ;try first with new format
    catch, error_format
    if (error_format ne 0) then begin
    
      catch,/cancel
      azimuthal_angle = retrieve_value(file_name=self.file_name, path=old_path)
      return, size(azimuthal_angle,/dim)
      
    endif else begin
    
      data_x_y = retrieve_value(file_name=self.file_name, path=path)
      return, size(data_x_y,/dim)
      
    endelse
    
  endelse
  
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
      'off_off': begin
        spin_state = 'Off_Off'
        self.entry_spin_state = 'entry-' + spin_state
        self.instrument = 'REF_M'
      end
      'off_on': begin
        spin_state = 'Off_On'
        self.entry_spin_state = 'entry-' + spin_state
        self.instrument = 'REF_M'
      end
      'on_off': begin
        spin_state = 'On_Off'
        self.entry_spin_state = 'entry-' + spin_state
        self.instrument = 'REF_M'
      end
      'on_on': begin
        spin_state = 'On_On'
        self.entry_spin_state = 'entry-' + spin_state
        self.instrument = 'REF_M'
      end
      else: begin
        spin_state = ''
        self.entry_spin_state = 'entry'
        self.instrument = 'REF_L'
      end
    endcase
    self.spin_state = spin_state
  endif else begin
    self.instrument = 'REF_L'
    self.entry_spin_state = 'entry'
  endelse
  
  self.configuration_file = 'SOS_instruments.cfg'
  
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
    configuration_file: '',$
    entry_spin_state: '',$
    var: ''}
    
end

