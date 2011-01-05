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
;    retrieve the parameters necessary to launch the refpix base
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
pro set_refpix_base, event=event, base=base
  compile_opt idl2
  
  selection = get_table_lines_selected(event=event, base=base, $
    uname='ref_m_metadata_table')
  from_row_selected = selection[1]
  to_row_selected = selection[3]
  nbr_file_selected = to_row_selected - from_row_selected + 1
  index = 0
  while (index lt nbr_file_selected) do begin
  
    table = getValue(event=event,uname='tab1_table')
    ;get file name of line selected
    full_file_name_spin = table[0,index]
    file_structure = get_file_structure(full_file_name_spin)
    _short_file_name = file_structure.short_file_name
    _spin = file_structure.spin
    _full_file_name = file_structure.full_file_name
    
    iNexus = obj_new('IDLnexusUtilities', _full_file_name, spin_state=_spin)
    _data = iNexus->get_full_data()  ;[tof, x, y]
    _tof_axis = iNexus->get_tof_data() ;tof axis in ms
    obj_destroy, iNexus
    
    sz = size(_data,/dim)
    _pixel_axis = indgen(sz[2])
    
    refpix_base, main_base=base, $
      event=event, $
      offset = 10, $
      x_axis = _tof_axis, $
      y_axis = _pixel_axis, $
      data = _data, $
      file_name = _short_file_name
      
    index++
  endwhile
  
  
  
  
  
  
  
  
end