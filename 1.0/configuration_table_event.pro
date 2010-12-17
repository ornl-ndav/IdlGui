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
    
    ;isolate file name from spin state
    row_array = strsplit(full_file_name_spin,'(',/extract)

    _file_name = row_array[0]
    _full_file_name = strtrim(_file_name,2)
    _short_file_name = file_basename(_file_name)
    _short_file_name = strtrim(_short_file_name,2)
    config_table[0,i] = _short_file_name ;add short file name
    
    spin_array = strsplit(row_array[1],')',/extract)
    _spin = spin_array[0]
    config_table[1,i] = _spin ;spin
    
    iNexus = obj_new('IDLnexusUtilities', _full_file_name, spin_state=_spin)
    _dirpix = iNexus->get_dirpix()
    config_table[2,i] = _dirpix ;dirpix
    
    _dangle_value_units = iNexus->get_dangle()
    ;dangle_structure = { value_degree: 0L, value_rad: 0L }
    dangle_structure = getAngleStructure(_dangle_value_units)
    dangle_string = strcompress(dangle_structure.value_degree,/remove_all) + $
    ' (' + strcompress(dangle_structure.value_rad,/remove_all) + ')'
    







    obj_destroy, iNexus
    
    
    
    
    
  endfor
  
  
  
  
  
  
end
