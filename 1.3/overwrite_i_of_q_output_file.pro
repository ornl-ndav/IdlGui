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
;    This procedures creates the new .txt reduced file
;
; :Params:
;    event
;
; :Keywords:
;    file_name
;    metadata
;    x
;    y
;    sigmaY
;
; :Author: j35
;-
pro create_new_reduces_output_file, event, file_name=file_name,$
    metadata=metadata, x=x, y=y, sigmaY=sigmaY
  compile_opt idl2
  
  error_file = 0
  catch, error_file
  if (error_file ne 0) then begin
    catch,/cancel
    return
  endif else begin
    openw, 1, file_name
    ;write metadata
    sz = n_elements(metadata)
    for i=0L,(sz-1) do begin
      printf, 1, metadata[i]
    endfor
    ;write data
    sz = n_elements(x)
    for i=0L,(sz-1) do begin
      line = strcompress(x[i],/remove_all)
      line += ' ' + strcompress(y[i],/remove_all)
      line += ' ' + strcompress(sigmaY[i],/remove_all)
      printf, 1, line
    endfor
  endelse
  close, 1
  free_lun, 1
end

;+
; :Description:
;    Does the conversion from tof to Q
;
; :Params:
;    xarray
;    yarray
;    SigmaYarray
;
; :Author: j35
;-
pro convert_tof_to_q, event, xarray
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;4Pi -> term1
  term1 = float(4.* !PI)
  ;252.78 * L(m) -> term2 (where L(m) is 21.043)
  term2 = float(252.78 * 21.043)
  ;sin(sangle) -> term3
  rad_sangle = (*global).rad_sangle
  term3 = sin(float(rad_sangle))
  ;term4 = term1 * term2 * term3
  term4 = term1 * term2 * term3
  
  sz = n_elements(xarray)
  for i=0,(sz-1) do begin
    xarray[i] = term4 / float(xarray[i])
  endfor
  
end

;+
; :Description:
;    Parse the string data into 3 data arrays
;
; :Params:
;    Event
;    DataStringArray
;    Xarray
;    Yarray
;    SigmaYarray
;
; :Author: j35
;-
pro parse_data_string_array, Event, $
    DataStringArray, $
    Xarray, $
    Yarray, $
    SigmaYarray
  compile_opt idl2
  
  Nbr = N_ELEMENTS(DataStringArray)
  j=0
  i=0
  WHILE (i LE Nbr-1) DO BEGIN
    CASE j OF
      0: BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
      END
      ELSE: BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
      END
    ENDCASE
    j++
  ENDWHILE
  
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
  
end

;+
; :Description:
;    remove NAN, negative values, -INF and INF
;
; :Params:
;    Xarray
;    Yarray
;    SigmaYarray
;
; :Author: j35
;-
pro cleanup_data, Xarray, Yarray, SigmaYarray
  compile_opt idl2
  
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  if (nbr GT 0) then begin
    Xarray = Xarray[RealMinIndex]
    Yarray = Yarray[RealMinIndex]
    SigmaYarray = SigmaYarray[RealMinIndex]
  endif
end

;+
; :Description:
;   This procedures takes the name of the output file,
;    replaces the extension with the extension of
;    the crtof output file (.crtof) and uses that file to calculate I(Q)
;    and then replaces the output file.
;
; :Params:
;    event
;
; :Keywords:
;    cmd
;    output_file_name
;
; :Author: j35
;-
pro overwritting_i_of_q_output_file, event, $
    cmd=cmd_index, $
    output_file_name=output_file_name
  compile_opt idl2
  
  ;get name of crtof file
  file_array = strsplit(output_file_name,'.txt',/extract,/regex)
  crtof_ext = '.crtof'
  crtof_output_file_name = file_array[0] + crtof_ext
  
  ;get metadata of output_file_name up to the data
  openr, 1, output_file_name
  file_length = file_lines(output_file_name)
  all_data_file = strarr(file_length)
  readf, 1, all_data_file
  close, 1
  ;keep everyting up to 3 lines after first blank
  blk_line = where(all_data_file eq '')
  metadata = all_data_file[0:blk_line[0]+3]
  
  ;get data (tof, I, sigmaI) of crtof
  iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', crtof_output_file_name)
  if (OBJ_VALID(iAsciiFile)) then begin
    no_error = 0
    ;CATCH,no_error
    if (no_error NE 0) then begin
      CATCH,/CANCEL
    ;return
    endif else begin
      sAscii = iAsciiFile->getData()
      DataStringArray = *(*sAscii.data)[0].data
      obj_destroy, iAsciiFile ;cleanup object
      ;this method will creates a 3 columns array (x,y,sigma_y)
      Nbr = N_ELEMENTS(DataStringArray)
      if (Nbr GT 1) then begin
        Xarray      = STRARR(1)
        Yarray      = STRARR(1)
        SigmaYarray = STRARR(1)
        parse_data_string_array, Event, $
          DataStringArray, $
          Xarray, $
          Yarray, $
          SigmaYarray
          
        ;Remove all rows with NaN, -inf, +inf ...
        cleanup_data, Xarray, Yarray, SigmaYarray
        ;Change format of array (string -> float)
        Xarray      = FLOAT(Xarray)
        Yarray      = FLOAT(Yarray)
        SigmaYarray = FLOAT(SigmaYarray)
      endif
    endelse
  endif
  
  convert_tof_to_q, event, xarray
  
  ;produces output file
  create_new_reduces_output_file, event, file_name=output_file_name,$
    metadata = metadata, x=Xarray, y=Yarray, sigmaY=SigmaYarray
    
end

