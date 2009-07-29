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

PRO plot_exclusion_roi_for_sns, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  BankArray  = (*(*global).BankArray)
  TubeArray  = (*(*global).TubeArray)
  PixelArray = (*(*global).PixelArray)
  
  sz = N_ELEMENTS(BankArray)
  FOR i=0,  sz-1 DO BEGIN
  
    local_continue = 0
    
;    print, 'Bank: ' + strcompress(BankArray[i],/remove_all) + $
;      ', Tube: ' + strcompress(TubeArray[i],/remove_all) + $
;      ', Pixel: ' + strcompress(PixelArray[i],/remove_all)
      
    Bank  = FIX(BankArray[i])
    Tube  = FIX(TubeArray[i])
    Pixel = FIX(PixelArray[i])
    
    ;go 2 by 2 for front and back panels only
    ;start at 1 if back panel
    panel_selected = getPanelSelected(Event)
    CASE (panel_selected) OF
      'front': BEGIN ;front
        IF (Bank GE 25) THEN local_continue = 1
        bank_local_data = bank - 1
        ;coeff_width = -2
      END
      'back': BEGIN ;back
        IF (Bank LT 25) THEN local_continue = 1
        bank_local_data = bank - 25
;        coeff_width = -2
      END
      ELSE: BEGIN ;Both
;        coeff_width = -1
        IF (Bank GE 25) THEN BEGIN ;back banks
          bank_local_data = (bank - 25) * 2 
        ENDIF ELSE BEGIN ;front banks
          bank_local_data = (bank - 1) * 2
        ENDELSE
      END
    ENDCASE
    coeff_height = +1
    coeff_width = +1
    
    IF (local_continue) THEN CONTINUE
    
    ;determine the real tube offset
    tube_local_data = getTubeGlobal(bank, tube)
    print, 'x0: ' + string(tube_local_data)
    print, 'y0: ' + string(Pixel)
    x0_device = convert_xdata_into_device(Event, tube_local_data)
    y0_device = convert_ydata_into_device(Event, Pixel)
    x1_data   =  tube_local_data + coeff_width
    y1_data   =  Pixel + coeff_height
    print, 'x1: ' + string(x1_data)
    print, 'y1: ' + string(y1_data)
    print
    x1_device = convert_xdata_into_device(Event, x1_data)
    y1_device = convert_ydata_into_device(Event, y1_data)
    
    display_loaded_selection, Event, x0=x0_device, y0=y0_device,$
      x1=x1_device, y1=y1_device
      
  ENDFOR
  
END

;------------------------------------------------------------------------------
PRO display_loaded_selection, Event, x0=x0, y0=y0, x1=x1, y1=y1

  id = WIDGET_INFO(Event.top,find_by_uname='draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  xmin = MIN([x0, x1],MAX=xmax)
  ymin = MIN([y0, y1],MAX=ymax)
  
;  print, 'xmin,xmax,ymin,ymax: ' + string(xmin) + ',' + string(xmax) + ',' + $
;  string(ymin) + ',' + string(ymax)
  
    PLOTS, xmin, ymin, /DEVICE, COLOR=200
    PLOTS, xmax, ymin, /DEVICE, /CONTINUE, COLOR=200
    PLOTS, xmax, ymax, /DEVICE, /CONTINUE, COLOR=200
    PLOTS, xmin, ymax, /DEVICE, /CONTINUE, COLOR=200
    PLOTS, xmin, ymin, /DEVICE, /CONTINUE, COLOR=200
  
;   PLOTS, [xmin, xmin, xmax, xmax, xmin],$
;    [ymin,ymax, ymax, ymin, ymin],$
;    /DEVICE,$
;;    LINESTYLE = 3,$
;    COLOR = 200
    
END