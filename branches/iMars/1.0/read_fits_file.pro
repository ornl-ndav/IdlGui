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
;    This routine read the fits files and return the data and the metadata
;
; :Keywords:
;    event
;    file_name
;    data
;    metadata
;
; :Author: j35
;-
pro read_fits_file, event=event, $
    file_name=file_name, $
    data=data, $
    metadata=metadata
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  multi_selection = (*global).multi_selection
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    data=!null
    metadata=['']
    
    message = ['Error loading files: ']
    file_name = ' -> ' + file_name
    message = [message, file_name]
    log_book_update, event, message=message
    
  endif else begin
  
    sz = n_elements(file_name)
    _index = 0
    while (_index lt sz) do begin
    
      if (~file_test(file_name[_index])) then begin
        data=!null
        return
      endif
      
      ;_data = mrdfits(file_name[_index], 0, header, /fscale, /silent)
      _data = mrdfits(file_name[_index], 0, header, /silent)
      
      ;this step is necessary because we are reading 16bits long fits [0,66535]
      ;that are translated into 16bits long idl [-32768,32767]
      ;so to stay between [0,65535] we need to add the 32768 factor to it
      ;_data += 32768

      if (_index eq 0) then begin
        data = _data
        metadata = header
      endif else begin
      
        if (multi_selection eq 1) then begin ;minimum
          index = where(data gt _data)
          data[index] = _data[index]
        endif else begin
          data += _data
        endelse
        
      endelse
      
      _index++
    endwhile
    
    if (multi_selection eq 0) then begin ;mean
      data /= sz
    endif
    
  endelse
  
end