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

;tube that have intensity below average 8 first and last tubes, or total
;insensity of 0 are automatically considered as dead tubes

PRO auto_exclude_dead_tubes, Event

  ;get global structurea
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).facility EQ 'LENS') THEN RETURN
  
  ;check if user wants to exclude dead tubes or not
  IF (~isAutoExcludeDeadTubeSelected(Event)) THEN RETURN
  
  ;retrieve data array
  DataArray = (*(*global).DataArray)
  nbr_tubes = (size(DataArray))(3)
  
  ;get average value of first 8 and last 8 tubes
  first_tubes = DataArray[*,*,0:7]
  last_tubes = DataArray[*,*,nbr_tubes-8:nbr_tubes-1]
  mean_first_tubes = MEAN(first_tubes)
  mean_last_tubes  = MEAN(last_tubes)
  mean_tubes = MEAN([mean_first_tubes, mean_last_tubes])
  
  DeadTubeNbr = ''
  FOR i=0,(nbr_tubes-1) DO BEGIN
    current_tube = DataArray[*,*,i]
    total_tube = TOTAL(current_tube)
    
    IF ((total_tube LE $
    mean_tubes / (*global).dead_tube_coeff_ratio) OR $
    total_tube LT 256L) THEN BEGIN
      DeadTubeNbr += STRCOMPRESS(i,/REMOVE_ALL) + ','
    ENDIF
    
  ENDFOR
  
  IF (DeadTubeNbr NE '') THEN BEGIN
  
    ;go 2 by 2 for front and back panels only
    ;start at 1 if back panel
    panel_selected = getPanelSelected(Event)
    message = '> List of dead tubes (or 0 total counts) for ' + $
      panel_selected + ' panel(s):'
    array = STRSPLIT(DeadTubeNbr,',',/EXTRACT)
    list = STRJOIN(array,',')
    message += list
    IDLsendToGeek_addLogBookText, Event, message
    
    (*(*global).dead_tube_nbr) = array
    plot_exclusion_of_dead_tubes, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_exclusion_of_dead_tubes, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  dead_tube_nbr = (*(*global).dead_tube_nbr)
  sz = N_ELEMENTS(dead_tube_nbr)
  BankArray = STRARR(sz)
  
  ;get bank of dead tubes
  index = 0
  WHILE (index LT sz) DO BEGIN
    ;+1 as getBankNumber start at tube 1
    BankNumber = getBankNumber(FIX(dead_tube_nbr[index]+1))
    BankArray[index] = STRCOMPRESS(BankNumber,/REMOVE_ALL)
    ;    print, 'dead_tube_nbr: ' + string(dead_tube_nbr[index]) + $
    ;    ', bank: ' + string(bankNumber)
    index++
  ENDWHILE
  
  TubeArray = dead_tube_nbr
  FOR i=0, sz-1 DO BEGIN
  
    local_continue = 0
    
    Bank  = FIX(BankArray[i])
    tube  = FIX(TubeArray[i]) - 1
    
    ;go 2 by 2 for front and back panels only
    ;start at 1 if back panel
    panel_selected = getPanelSelected(Event)
    CASE (panel_selected) OF
      'front': BEGIN ;front
        coeff_width = +2
        IF (Bank GE 25) THEN local_continue = 1
        bank_local_data = bank - 1
        tube_coeff = 2
      ;coeff_width = -2
      END
      'back': BEGIN ;back
        coeff_width = +2
        IF (Bank LT 25) THEN local_continue = 1
        bank_local_data = bank - 25
        tube_coeff = 2
      ;        coeff_width = -2
      END
      ELSE: BEGIN ;Both
        coeff_width = +1
        tube_coeff = 2
        IF (Bank GE 25) THEN BEGIN ;back banks
          bank_local_data = (bank - 25) * 2
        ENDIF ELSE BEGIN ;front banks
          bank_local_data = (bank - 1) * 2
        ENDELSE
      END
    ENDCASE
    coeff_height = +1
    
    IF (local_continue) THEN CONTINUE
    
    tube += tube_coeff
    x0_device = convert_xdata_into_device(Event, tube)
    x1_data   =  tube + coeff_width
    x1_device = convert_xdata_into_device(Event, x1_data)
    
    FOR pixel=0,255 DO BEGIN
    
      y0_device = convert_ydata_into_device(Event, pixel)
      y1_data   =  Pixel + coeff_height
      y1_device = convert_ydata_into_device(Event, y1_data)
      
      display_loaded_selection, Event, $
        x0=x0_device, $
        y0=y0_device,$
        x1=x1_device, $
        y1=y1_device, $
        COLOR= 100
        
    ENDFOR
    
  ENDFOR
  
END



