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
PRO  getBankTubePixelROI, Event, $
    StringArray, $
    BankArray, $
    TubeArray, $
    PixelArray
    
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF
  
  NbrRow = N_ELEMENTS(StringArray)
  index = 0L
  WHILE (index LT NbrRow) DO BEGIN
    ON_IOERROR, L1
    IF (StringArray[index] EQ '') THEN RETURN
    ;print, 'index: ' + string(index) + ' -> ' + StringArray[index]
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

  nbr_jk = 0 ;number of lines that starts with '#jk :'
  NbrElements = get_nbr_elements_except_jk_line(FileStringArray, nbr_jk)
  ;N_ELEMENTS(FileStringArray)
  IF (FileStringArray[0] EQ '') THEN RETURN
  
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
  getBankTubePixelROI, Event, $
    FileStringArray, $
    BankArray, $
    TubeArray, $
    PixelArray
    
  (*(*global).BankArray)  = BankArray
  (*(*global).TubeArray)  = TubeArray
  (*(*global).PixelArray) = PixelArray
  
  save_jk_selection_array, Event, FileStringArray, nbr_jk
  
  IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  
  plot_exclusion_roi_for_sns, Event
  
END

;------------------------------------------------------------------------------
PRO load_inclusion_roi_for_sns, Event, FileStringArray

  nbr_jk = 0 ;number of lines that starts with '#jk :'
  NbrElements = get_nbr_elements_except_jk_line(FileStringArray, nbr_jk)
  FileStringArray_untouched = FileStringArray
  IF (FileStringArray[0] EQ '') THEN RETURN
  
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
  
  getBankTubePixelROI, Event, $
    FileStringArray, $
    BankArray, $
    TubeArray, $
    PixelArray
    
  size_excluded = 4L * 256L * 48L - LONG(N_ELEMENTS(BankArray))+1 ;??????
  excluded_BankArray  = INTARR(size_excluded)
  excluded_TubeArray  = INTARR(size_excluded)
  excluded_PixelArray = INTARR(size_excluded)
  
  getInverseSelection, BankArray, TubeArray, PixelArray, $
    excluded_BankArray, Excluded_TubeArray, Excluded_PixelArray
    
  index=0L
  FileStringArray = STRARR(N_ELEMENTS(excluded_BankArray))
  WHILE (index LT N_ELEMENTS(excluded_BankArray)) DO BEGIN
    line = 'bank' + STRCOMPRESS(excluded_BankArray[index],/REMOVE_ALL)
    line += '_' + STRCOMPRESS(excluded_TubeArray[index],/REMOVE_ALL)
    line += '_' + STRCOMPRESS(excluded_PixelArray[index],/REMOVE_ALL)
    FileStringArray[index] = line
    index++
  ENDWHILE
  
  save_jk_selection_array, Event, FileStringArray_untouched, nbr_jk
  
  (*(*global).global_exclusion_array) = FileStringArray
  
  IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  
  (*(*global).BankArray)  = excluded_BankArray
  (*(*global).TubeArray)  = excluded_TubeArray
  (*(*global).PixelArray) = excluded_PixelArray
  
  ;plotting ROI
  plot_exclusion_roi_for_sns, Event
  
END

;------------------------------------------------------------------------------
PRO getInverseSelection, BankArray, TubeArray, PixelArray, $
    excluded_BankArray, Excluded_TubeArray, Excluded_PixelArray
    
  ;by default, we want to keep nothing
  full_detector_array = INTARR(48,4,256)
  index = 0L
  WHILE (index LT (N_ELEMENTS(BankArray)-1)) DO BEGIN
    bank  = BankArray[index] - 1
    Tube  = TubeArray[index]
    Pixel = PixelArray[index]
    full_detector_array[bank,tube,pixel] = 1
    index++
  ENDWHILE
  
  index = 0L
  FOR bank=0,47 DO BEGIN
    FOR tube=0,3 DO BEGIN
      FOR pixel=0,255 DO BEGIN
        IF (full_detector_array[bank,tube,pixel] EQ 0) THEN BEGIN
          excluded_BankArray[index] = bank + 1
          excluded_TubeArray[index] = tube
          excluded_PixelArray[index] = pixel
          index++
        ENDIF
      ENDFOR
    ENDFOR
  ENDFOR
  
END

;------------------------------------------------------------------------------
PRO save_jk_selection_array, Event, FileStringArray, nbr_jk

  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  nbr_lines = N_ELEMENTS(FileStringArray)
  jk_selection = STRARR(nbr_jk * 4)
  
  index = 0
  col_offset = 4
  WHILE (index LT nbr_jk) DO BEGIN
    line = FileStringArray[nbr_lines - index - 1]
    parse1 = STRSPLIT(line,' ',/REGEX,/EXTRACT)
    parse2 = STRSPLIT(parse1[1],',',/REGEX,/EXTRACT)
    jk_selection[index * col_offset] = parse2[0]
    jk_selection[index * col_offset + 1] = parse2[1]
    jk_selection[index * col_offset + 2] = parse2[2]
    jk_selection[index * col_offset + 3] = parse2[3]
    index++
  ENDWHILE
  
  (*(*global).jk_selection_x0y0x1y1) = jk_selection
  
END