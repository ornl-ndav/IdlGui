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
;    Parse the ROI selection and make a strarr(2,n) of pixel_from and
;    pixel_to
;
; :Params:
;    roi_selection
;
; :Returns:
;    strarr(2,n) where   [0,*] are the from pixels and [1,*] are the to pixels
;
; :Author: j35
;-
function parse_discrete_roi_selection, roi_selection
  compile_opt idl2
  
  sz = size(roi_selection)
  if (sz[0] eq 0) then return, ['',''] ;no selection
  
  nbr_lines = sz[1]
  _pixel_list = strarr(2,nbr_lines)
  
  _index_source=0
  _index_final=0
  while (_index_source lt nbr_lines) do begin
  
    _line = roi_selection[_index_source]
    if (strcompress(_line,/remove_all) eq '') then begin
      _index_source++
      continue
    endif
    _line_parsed = strsplit(_line,'->',/extract,/regex)
    _from_px = fix(_line_parsed[0])
    _to_px   = fix(_line_parsed[1])
    
    _from_px = min([_from_px,_to_px],max=_to_px)
    
    _pixel_list[0,_index_final] = _from_px
    _pixel_list[1,_index_final] = _to_px
    
    _index_source++
    _index_final++
  endwhile
  
  return, _pixel_list
  
end