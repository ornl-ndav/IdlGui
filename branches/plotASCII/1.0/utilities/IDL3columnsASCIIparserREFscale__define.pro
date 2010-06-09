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

FUNCTION read_data_multi, file

  ;Open the data file.
  OPENR, 1, file
  
  ;Set up variables
  line = STRARR(1)
  tmp = ''
  i = 0
  
  WHILE (~EOF(1)) DO BEGIN
    nbr_lines = FILE_LINES(file)
    my_array = STRARR(1,nbr_lines)
    READF,1, my_array
  ENDWHILE
  close,1
  RETURN, my_array
  
END

FUNCTIon getDataQuicklyCombined, data, nLines, index, path

  pArray      = PTRARR(1,/ALLOCATE_HEAP)
  ArrayTitle  = STRARR(2,1) ;name of file and incident angle
  pXaxis      = PTRARR(1,/ALLOCATE_HEAP)
  pYaxis      = PTRARR(1,/ALLOCATE_HEAP)
  pSigmaYaxis = PTRARR(1,/ALLOCATE_HEAP)
  
  ;retrieve data
  *pArray[0] = data[index[1]+1:index[1+1]-1]
  
  nbr_line = N_ELEMENTS(*pArray[0])
  local_Xaxis= STRARR(nbr_line)
  local_Yaxis= STRARR(nbr_line)
  local_SigmaYaxis = STRARR(nbr_line)
  array = *pArray[0]
  FOR j=0L,(nbr_line-1) DO BEGIN
    line_split = STRSPLIT(array[j],' ',/EXTRACT)
    local_Xaxis[j] = line_split[0]
    local_Yaxis[j] = line_split[1]
    local_SigmaYaxis[j] = line_split[2]
  ENDFOR
  *pXaxis[0] = FLOAT(local_Xaxis)
  *pYaxis[0] = FLOAT(local_Yaxis)
  *pSigmaYaxis[0] = FLOAT(local_SigmaYaxis)
  
  big_structure = { ArrayTitle: ArrayTitle,$
    filename: path, $
    xaxis: 'scalar wavevector transfer',$
    xaxis_units: '1/Angstroms',$
    yaxis: 'Intensity',$
    yaxis_units: 'counts',$
    sigma_yaxis: 'sigma',$
    sigma_yaxis_units: '',$
    pXaxis: pXaxis,$
    pYaxis: pYaxis, $
    pSigmaYaxis: pSigmaYaxis}
    
  RETURN, big_structure
  
END


;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparserREFscale::getDataQuickly
  data   = read_data_multi(self.path)
  nLines = FILE_LINES(self.path)
  index  = WHERE(data EQ '',nbr) ;nbr is the number of arrays in that file
  ;add last line
  index = [index,nLines]
  
  catch, error
  if (error ne 0) then begin ;we are working with a combined ascii file
    catch,/cancel
    
    catch, error2
    if (error2 ne 0) then begin
      catch,/cancel
      return, ''
    endif else begin
      big_structure = $
        getDataQuicklyCombined(data, nLines, index, self.path)
    endelse
  
  endif else begin
  
    pArray      = PTRARR(nbr,/ALLOCATE_HEAP)
    ArrayTitle  = STRARR(2,nbr) ;name of file and incident angle
    pXaxis      = PTRARR(nbr,/ALLOCATE_HEAP)
    pYaxis      = PTRARR(nbr,/ALLOCATE_HEAP)
    pSigmaYaxis = PTRARR(nbr,/ALLOCATE_HEAP)
    
    ;retrieve data
    FOR i=0,(nbr-1) DO BEGIN
      ArrayTitle[0,i] = data[index[i]+1]
      ArrayTitle[1,i] = data[index[i]+2]
      *pArray[i] = data[index[i]+3:index[i+1]-1]
    ENDFOR
    
    ;parse the various arrays
    FOR i=0,(nbr-1) DO BEGIN
      nbr_line = N_ELEMENTS(*pArray[i])
      local_Xaxis= STRARR(nbr_line)
      local_Yaxis= STRARR(nbr_line)
      local_SigmaYaxis = STRARR(nbr_line)
      array = *pArray[i]
      FOR j=0,(nbr_line-1) DO BEGIN
        line_split = STRSPLIT(array[j],' ',/EXTRACT)
        local_Xaxis[j] = line_split[0]
        local_Yaxis[j] = line_split[1]
        local_SigmaYaxis[j] = line_split[2]
      ENDFOR
      *pXaxis[i] = FLOAT(local_Xaxis)
      *pYaxis[i] = FLOAT(local_Yaxis)
      *pSigmaYaxis[i] = FLOAT(local_SigmaYaxis)
    ENDFOR
    
    big_structure = { ArrayTitle: ArrayTitle,$
      filename: self.path, $
      xaxis: 'scalar wavevector transfer',$
      xaxis_units: '1/Angstroms',$
      yaxis: 'Intensity',$
      yaxis_units: 'counts',$
      sigma_yaxis: 'sigma',$
      sigma_yaxis_units: '',$
      pXaxis: pXaxis,$
      pYaxis: pYaxis, $
      pSigmaYaxis: pSigmaYaxis}
      
  endelse
  
  RETURN, big_structure
  
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparserREFscale::init, location
  ;set up the path
  self.path = location
  RETURN, FILE_TEST(location, /READ)
END

;------------------------------------------------------------------------------
PRO IDL3columnsASCIIparserREFscale__define
  struct = {IDL3columnsASCIIparserREFscale,$
    data: ptr_new(),$
    path: ''}
END

;------------------------------------------------------------------------------




