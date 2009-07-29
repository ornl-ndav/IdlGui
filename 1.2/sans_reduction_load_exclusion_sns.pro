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

;This procedure takes a STRARR as input
; bank1_1_1
; bank1_2_1
; bank1_3_1
; ...
; and extract the bank number, the tube number and the pixel number
PRO  getBankTubePixelROI, StringArray, $
    BankArray, $
    TubeArray, $
    PixelArray
    
  NbrRow = N_ELEMENTS(StringArray)
  index = 0
  WHILE (index LT NbrRow) DO BEGIN
    ON_IOERROR, L1
    RoiStringArray = STRSPLIT(StringArray[index],'_',/EXTRACT)
    TubeArray[index] = FIX(RoiStringArray[1])
    PixelArray[index] = FIX(RoiStringArray[2])
    BankStringArray = STRSPLIT(RoiStringArray[0],'bank',/EXTRACT)
    BankArray[index] = FIX(BankStringArray[0])
    L1:
    index++
  ENDWHILE
  
END

;------------------------------------------------------------------------------
PRO load_exclusion_roi_for_sns, Event, FileStringArray

  NbrElements = N_ELEMENTS(FileStringArray)

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  IDLsendToGeek_addLogBookText, Event, '-> Retrieve list of banks, ' + $
    'tubes and pixels ... ' + PROCESSING
  BankArray  = INTARR(NbrElements)
  TubeArray  = INTARR(NbrElements)
  PixelArray = INTARR(NbrElements)
  getBankTubePixelROI, FileStringArray, $
    BankArray, $
    TubeArray, $
    PixelArray
    
  (*(*global).BankArray)  = BankArray
  (*(*global).TubeArray)  = TubeArray
  (*(*global).PixelArray) = PixelArray  
    
  plot_exclusion_roi_for_sns, Event     
    
END