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

PRO plot_ascii_file, MAIN_BASE, global

  load_ascii_file, MAIN_BASE, global
  PlotAsciiData, MAIN_BASE, global
  
END

;==============================================================================
;This method parse the 1 column string array into 3 columns string array
PRO ParseDataStringArray, global, DataStringArray, Xarray, Yarray, SigmaYarray
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

  (*(*global).Xarray_untouched) = Xarray
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
END

;------------------------------------------------------------------------------
PRO CleanUpData, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END

;------------------------------------------------------------------------------
;Load data
PRO load_ascii_file, MAIN_BASE, global

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  file_name = (*global).input_ascii_file
  
  iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name[0])
  IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
    sAscii = iAsciiFile->getData()
    (*global).xaxis       = sAscii.xaxis
    (*global).xaxis_units = sAscii.xaxis_units
    (*global).yaxis       = sAscii.yaxis
    (*global).yaxis_units = sAscii.yaxis_units
    
    DataStringArray = *(*sAscii.data)[0].data
    ;this method will creates a 3 columns array (x,y,sigma_y)
    Nbr = N_ELEMENTS(DataStringArray)
    IF (Nbr GT 1) THEN BEGIN
      Xarray      = STRARR(1)
      Yarray      = STRARR(1)
      SigmaYarray = STRARR(1)
      ParseDataStringArray, global, $ 
        DataStringArray,$
        Xarray,$
        Yarray,$
        SigmaYarray
      ;Remove all rows with NaN, -inf, +inf ...
      CleanUpData, Xarray, Yarray, SigmaYarray
      ;Change format of array (string -> float)
      Xarray      = FLOAT(Xarray)
      Yarray      = FLOAT(Yarray)
      SigmaYarray = FLOAT(SigmaYarray)
      ;Store the data in the global structure
      (*(*global).Xarray)      = Xarray
      (*(*global).Yarray)      = Yarray
      (*(*global).SigmaYarray) = SigmaYarray
    ENDIF
  ENDIF
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END

;==============================================================================
;Plot Data in widget_draw
PRO plotAsciiData, MAIN_BASE, global

  draw_id = widget_info(MAIN_BASE, find_by_uname='main_draw')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  WSET,view_plot_id
  
  DEVICE, DECOMPOSED = 1
  loadct,5,/SILENT
  
  Xarray      = (*(*global).Xarray)
  Yarray      = (*(*global).Yarray)
  SigmaYarray = (*(*global).SigmaYarray)
  
  xaxis = (*global).xaxis
  yaxis = (*global).yaxis
  xaxis_units = (*global).xaxis_units
  yaxis_units = (*global).yaxis_units
  xLabel = xaxis + ' (' + xaxis_units + ')'
  yLabel = yaxis + ' (' + yaxis_units + ')'
  
  plot, Xarray, $
    Yarray, $
    color=FSC_COLOR('white'), $
    PSYM=2, $
    XTITLE=xLabel, $
    YTITLE=yLabel
    
  errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,$
    color=FSC_COLOR('yellow')
    
  DEVICE, DECOMPOSED = 0
  
END

