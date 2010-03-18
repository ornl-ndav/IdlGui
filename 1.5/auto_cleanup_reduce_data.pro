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
;   This function is going to retrieve the first line of the input file
;   and check if that line starts with '#auto cleaned up: '.
;
; :Params:
;    file_name
;
; @returns 1 if the file has already beeen cleaned up, 0 otherwise
;
; :Author: j35
;-
function cleaned_up_performed_already, file_name
  compile_opt idl2
  
  openr, 1, file_name
  first_line = ''
  readf, 1, first_line
  close, 1
  
  search_string = '#auto cleaned up'
  split_line = strsplit(first_line,':',/extract)
  result = strmatch(split_line[0],search_string)
  
  return, result
end

;+
; :Description:
;   This routine will read the reduce file, takes the argument from the
;   auto cleanup configure base and will cleanup the data
;
; :Params:
;    event
;
; :Keywords:
;    file_name
;
; :Author: j35
;-
pro cleanup_reduce_data, event, file_name = file_name
  compile_opt idl2
  
  ;check that the input file does not start with the autocleanup
  ;line
  ;#auto cleaned up: 10%
  if (cleaned_up_performed_already(file_name)) then return
  
  ;retrieve values from the file_name file
  retrieve_data, file_name, x_array, y_array, y_erro_array
  help, x_array
  
  
  
  
  
  
end


;+
; :Description:
;   this procedure parse the array and divides the data into 3 arrays
;   x, y and y_error
;
; :Params:
;    DataStringArray
;    Xarray
;    Yarray
;    SigmaYarray
;
;
;
; :Author: j35
;-
pro parse_data_array, DataStringArray, Xarray, Yarray, SigmaYarray
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
END


;+
; :Description:
;   this procedure removes all the inf and nan values from the array
;
; :Params:
;    Xarray
;    Yarray
;    SigmaYarray
;
;
;
; :Author: j35
;-
pro remove_inf_nan, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END


;+
; :Description:
;   This routine parses the ascii file and retrieves the data and 
;   save them into the x_array, y_array and y_error_array
;
; :Params:
;    file_name
;    x_array
;    y_array
;    y_error_array
;
;
;
; :Author: j35
;-
pro retrieve_data, file_name, x_array, y_array, y_error_array
  iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name)
  sAscii = iAsciiFile->getData()
  DataStringArray = *(*sAscii.data)[0].data
  obj_destroy, iAsciiFile
  ;this method will creates a 3 columns array (x,y,sigma_y)
  Nbr = N_ELEMENTS(DataStringArray)
  x_array      = STRARR(1)
  y_array      = STRARR(1)
  y_error_array = STRARR(1)
  IF (Nbr GT 1) THEN BEGIN
    parse_data_array, $
      DataStringArray,$
      x_array,$
      y_array,$
      y_error_array
    ;Remove all rows with NaN, -inf, +inf ...
    remove_inf_nan, x_array, y_array, y_error_array
    ;Change format of array (string -> float)
    x_array       = FLOAT(temporary(x_array))
    y_array       = FLOAT(temporary(y_array))
    y_error_array = FLOAT(temporary(y_error_array))
  endif
end



;main test
file_name = '~/results/REF_L_20927,20935_2009y_06m_18d_00h_32mn.txt'
cleanup_reduce_data, '', file_name = file_name

end

