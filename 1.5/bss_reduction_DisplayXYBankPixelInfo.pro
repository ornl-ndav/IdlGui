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

FUNCTION RetrieveCounts, Event, bank, x, y

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  case (bank) of
    1: bank= (*(*global).bank1_raw_value)
    2: bank= (*(*global).bank2_raw_value)
    3: bank= (*(*global).bank3_raw_value)
    4: bank= (*(*global).bank4_raw_value)
  endcase
  
  RETURN, bank[y,x]
END



FUNCTION CalculatePixelID, Event, bank, x, y

  case (bank) of
    1: return, (x*64+y)
    2: return, (x*64+y) + 4096
    3: return, (x*64+y) + 2*4096
    4: return, (x*64+y) + 3*4096
  endcase
  
END




PRO BSSreduction_DisplayXYBankPixelInfo, Event, bank
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  x=(event.X)/(*global).Xfactor
  y=(event.y)/(*global).Yfactor
  
  IF (x GE 0 AND x LT 56 $
    AND $
    y GE 0 AND y LT 64) THEN BEGIN
    
    case (bank) of
      'bank1': bank=1
      'bank2': bank=2
      'bank3': bank=3
      'bank4': bank=4
    endcase
    
    ;display bank info
    PutBankValue, Event, bank
    
    ;display X info
    PutXValue, Event, x
    
    ;display Y info
    PutYValue, Event, y
    
    ;display Row info (Y*bank)
    row = y + (bank-1)*64
    PutRowValue, Event, row
    
    ;display Tube info
    tube = x + (bank-1)*64
    PutTubeValue, Event, tube
    
    ;calculate pixelid
    pixelid = CalculatePixelID(Event, bank, x, y)
    ;display pixelid info
    PutPixelIDValue, Event, pixelid
    
    ;get number of counts
    counts = RetrieveCounts(Event, bank, x, y)
    ;display counts
    PutCountsValue, Event, strcompress(counts,/remove_all)
    
  ENDIF
  
END





PRO BSSreduction_DisplaySelectedPixel, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  PlotIncludedPixels, Event
  
  ;plot selected pixel on top of it
  bank    = getBankValue(Event)
  
  IF (bank EQ 1) THEN BEGIN       ;bank 1
    view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  ENDIF ELSE BEGIN                ;bank 2
    view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  ENDELSE
  
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  color   = (*global).ColorSelectedPixel
  
  x       = getXValue(Event)
  y       = getYValue(Event)
  PlotExcludedBox, Event, x, y, x_coeff, y_coeff, color
  
END
