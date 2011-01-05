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
;    Checks if the file name of the row selected is empty or not
;
; :Params:
;    event
;    
; :Returns:
;   1 if file name cell of selected row is not empty
;   0 if file name cell of selected row is empty
;
; :Author: j35
;-
function isConfigurationRowNotEmpty, event
compile_opt idl2

  selection = get_table_lines_selected(event=event, $
  uname='ref_m_metadata_table')
  row_selected = selection[1]
  
  ;get big table
  big_table = getValue(event=event,base=base, uname='ref_m_metadata_table')
  if (big_table[0,row_selected] ne '') then return, 1
  
  return, 0
end

;+
; :Description:
;    Calculate sangle value
;
; :Parameters:
;   dangle
;   dangle0
;
; :Keywords:
;    dirpix
;    refpix
;    pixel_size_m
;    d_SD_m
;
; :Author: j35
;-
function calculate_sangle, dangle, dangle0, $
    dirpix=dirpix, $
    refpix=refpix, $
    pixel_size_m=pixel_size_m, $
    d_SD_m=d_SD_m
  compile_opt idl2
  
  part1 = (float(dangle) - float(dangle0)) /2.
  part2_num = (float(dirpix) - float(refpix)) /2.
  part2 = part2_num * float(pixel_size_m) / float(d_SD_m)
  
  return, part1 + part2
end

;+
; :Description:
;    This procedure populates the Configuration table for the REF_M instrument
;    with various infos retrieved in the NeXus files such as dirpix, dangle,
;    dangle0. Using these parameters as well as the refpix of the given
;    file, the sangle value is calculated
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro refresh_configuration_table, base=base, event=event
  compile_opt idl2
  
  if (keyword_set(base)) then begin
    widget_control, base, get_uvalue=global
  endif else begin
    widget_control, event.top, get_uvalue=global
  endelse
  
  instrument = (*global).instrument
  if (instrument eq 'REF_L') then return
  
  ;get big table
  big_table = getValue(event=event,base=base, uname='tab1_table')
  
  szTable = size(big_table,/dim)
  nbr_row = szTable[1]
  
  ;initialize configuration table
  config_table = strarr(7,nbr_row)
  
  for i=0,(nbr_row-1) do begin
  
    ;retrieve full file name
    full_file_name_spin = big_table[0,i]
    if (strcompress(full_file_name_spin,/remove_all) eq '') then break
    
    file_structure = get_file_structure(full_file_name_spin)
    _short_file_name = file_structure.short_file_name
    _spin = file_structure.spin
    _full_file_name = file_structure.full_file_name
    
    config_table[0,i] = _short_file_name ;add short file name
    config_table[1,i] = _spin ;spin
    
    iNexus = obj_new('IDLnexusUtilities', _full_file_name, spin_state=_spin)
    _dirpix = fix(iNexus->get_dirpix())
    config_table[2,i] = strcompress(_dirpix,/remove_all) ;dirpix
    
    _dangle_value_units = iNexus->get_dangle()
    ;dangle_structure = { value_degree: 0L, value_rad: 0L }
    dangle_structure = getAngleStructure(_dangle_value_units)
    dangle_string = strcompress(dangle_structure.value_degree,/remove_all) + $
      ' (' + strcompress(dangle_structure.value_rad,/remove_all) + ')'
    config_table[4,i] = dangle_string
    
    _dangle0_value_units = iNexus->get_dangle0()
    dangle0_structure = getAngleStructure(_dangle0_value_units)
    dangle0_string = strcompress(dangle0_structure.value_degree,/remove_all) + $
      ' (' + strcompress(dangle0_structure.value_rad,/remove_all) + ')'
    config_table[5,i] = dangle0_string
    
    obj_destroy, iNexus
    
  endfor
  
  ;calculate sangle
  calculate_configuration_sangle_values, $
    event=event, $
    base=base, $
    config_table=config_table
    
  putValue, event=event, base=base, 'ref_m_metadata_table', config_table
  
end

;+
; :Description:
;    parse the string (ex: '3.26339 (186.978)') and retrieve the second
;    part of it only -> 186.978
;
; :Params:
;    angle_deg_rad
;
; ;Returns:
;    return the angle in rad
;
; :Author: j35
;-
function retrieve_angle_in_rad, angle_deg_rad
  compile_opt idl2
  
  _angle_deg_rad = angle_deg_rad
  string_parse_left = strsplit(angle_deg_rad, '(', /extract, count=sz)
  if (sz ne 2) then return, ''
  
  string_parse_right = strsplit(string_parse_left[1], ')', /extract)
  
  return, string_parse_right[0]
end

;+
; :Description:
;    Calculates the sangle value
;
; :Keywords:
;    event
;    base
;    config_table
;
; :Author: j35
;-
pro calculate_configuration_sangle_values, $
    event=event, $
    base=base, $
    config_table=config_table
  compile_opt idl2
  
  szTable = size(config_table,/dim)
  nbr_row = szTable[1]
  
  _pixel_size_mm = float(getValue(event=event, $
    base=base, $
    uname='pixel_size'))
  if (_pixel_size_mm eq '') then return
  _pixel_size_m = convert_distance(distance=_pixel_size_mm, $
    from_unit = 'mm', $
    to_unit = 'm')
    
  _d_SD_mm = float(getValue(event=event, $
    base=base, $
    uname = 'd_sd_uname'))
  if (_d_SD_mm eq '') then return
  _d_SD_m = convert_distance(distance=_d_SD_mm, $
    from_unit = 'mm',$
    to_unit = 'm')
    
  for i=0,(nbr_row-1) do begin
  
    ;retrieve full file name
    file_name = config_table[0,i]
    if (strcompress(file_name,/remove_all) eq '') then break
    
    ;refpix value
    _refpix = fix(config_table[3,i])
    _refpix = 200
    if (_refpix lt 1) then continue
    
    ;dirpix value
    _dirpix = fix(config_table[2,i])
    
    ;dangle
    _dangle = retrieve_angle_in_rad(config_table[4,i])
    if (_dangle eq '') then continue
    
    ;dangle0
    _dangle0 = retrieve_angle_in_rad(config_table[5,i])
    if (_dangle0 eq '') then continue
    
    _sangle_rad = calculate_sangle(_dangle, $
      _dangle0, $
      dirpix=_dirpix, $
      refpix=_refpix, $
      pixel_size_m=_pixel_size_m, $
      d_SD_m=_d_SD_m)
      
    _sangle_deg = convert_angle(angle=_sangle_rad, $
      from_unit='rad',$
      to_unit='degree')
    _sangle_string = strcompress(_sangle_deg,/remove_all) + $
      ' (' + strcompress(_sangle_rad,/remove_all) + ')'
    config_table[6,i] = _sangle_string
    
  endfor
  
end