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

;Only the sides of the excluded pixels are shown
PRO PlotExcludedBoxEmpty, x, y, x_coeff, y_coeff, color
  plots, x*x_coeff, y*y_coeff, /device, color=color
  plots, x*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
  plots, (x+1)*x_coeff, y*y_coeff, /device, color=color
  plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
  
  plots, x*x_coeff,y*y_coeff, /device,color=color
  plots, (x+1)*x_coeff, y*y_coeff, /device, /continue, color=color
  plots, x*x_coeff,(y+1)*y_coeff, /device,color=color
  plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
END

;------------------------------------------------------------------------------

;The excluded pixels are shown as a rectangle area
PRO PlotExcludedBoxFull, x, y, x_coeff, y_coeff, color
  FOR i=0,(x_coeff) do begin
    plots, x*x_coeff, y*y_coeff, /device, color=color
    plots, x*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
    plots, (x*x_coeff+i), y*y_coeff, /device, color=color
    plots, (x*x_coeff+i), (y+1)*y_coeff, /device, /continue, color=color
  endfor
  
END

;------------------------------------------------------------------------------

PRO PlotExcludedBox, Event, x, y, x_coeff, y_coeff, color
  ;check status of empty or full box
  IF (isPixelExcludedSymbolFull(Event)) THEN BEGIN
    PlotExcludedBoxFull, x, y, x_coeff, y_coeff, color
  ENDIF ELSE BEGIN
    PlotExcludedBoxEmpty, x, y, x_coeff, y_coeff, color
  ENDELSE
END

;------------------------------------------------------------------------------

PRO BSSreduction_IncludeExcludePixel, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;clear contain of message box
  putMessageBoxInfo, Event, ''
  
  ;retrieve bank, x and y infos
  bank    = getBankValue(Event)
  
  banks_displayed = (*global).banks_displayed
  if (banks_displayed eq 'north_3_4') then begin
  PixelID = getPixelIDvalue(Event) - 2*4096L
    pixel_excluded = (*(*global).pixel_excluded_bank3_4)
  endif else begin
    pixel_excluded = (*(*global).pixel_excluded)
  PixelID = getPixelIDvalue(Event)
  endelse
  
  IF (pixel_excluded[PixelID]) THEN BEGIN
    new_state = 0
  ENDIF ELSE BEGIN
    new_state = 1
  ENDELSE
  pixel_excluded[PixelID] = new_state
  
  banks_displayed = (*global).banks_displayed
  if (banks_displayed eq 'north_3_4') then begin
    (*(*global).pixel_excluded_bank3_4) = pixel_excluded
  endif else begin
    (*(*global).pixel_excluded) = pixel_excluded
  endelse
  
  case (strcompress(bank,/remove_all)) of
  '1': view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  '2': view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  '3': view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  '4': view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  endcase
  
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  color   = (*global).ColorExcludedPixels
  
  IF (new_state) THEN BEGIN ;exclude pixel
  
    x       = getXValue(Event)
    y       = getYValue(Event)
    PlotExcludedBox, Event, x, y, x_coeff, y_coeff, color
  
  ENDIF ELSE BEGIN                ;include pixel
  
    ;first replot bank + lines
    case (strcompress(bank,/remove_all)) of
      '1': begin
        bss_reduction_PlotBank1, Event
        PlotBank1Grid, Event
        pixelid_min = 0L
      end
      '2': begin
        bss_reduction_PlotBank2, Event
        PlotBank2Grid, Event
        pixelid_min = 4096L
      end
      '3': begin
        bss_reduction_PlotBank3, Event
        PlotBank1Grid, Event
        pixelid_min = 0L
      end
      '4': begin
        bss_reduction_PlotBank4, Event
        PlotBank2Grid, Event
        pixelid_min = 4096L
      end
    endcase
    
    ;replot all the pixelID excluded
    FOR i = 0, 3584L DO BEGIN
      pixel = pixelid_min + i
      IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
        ;plot lines around this pixel
        XY = getXYfromPixelID(Event, pixel)
        PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
      ENDIF
    ENDFOR
    
  ENDELSE
  
END

;------------------------------------------------------------------------------

PRO PlotExcludedPixels, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  color   = (*global).ColorExcludedPixels
  
  view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  pixel_excluded = (*(*global).pixel_excluded)
  FOR i=0,3584L DO BEGIN
    IF (pixel_excluded[i] EQ 1) THEN BEGIN
      XY = getXYfromPixelID(Event, i)
      PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
  ENDFOR
  
  view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  pixelid_min = 4096L
  FOR i=0,3584L DO BEGIN
    pixel = pixelid_min + i
    IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
      XY = getXYfromPixelID(Event, pixel)
      PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
  ENDFOR
END

;------------------------------------------------------------------------------

PRO PlotIncludedPixels, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  color   = (*global).ColorExcludedPixels
  
  DEVICE, DECOMPOSED = 0
  loadct, (*global).LoadctMainPlot,/SILENT
  
  ;plot main plots + grid
  ;bss_reduction_PlotBank1, Event
  ;DEVICE, DECOMPOSED = 0
  ;PlotBank1Grid, Event
  ;loadct, (*global).LoadctMainPlot, /SILENT
  ;bss_reduction_PlotBank2, Event
  ;DEVICE, DECOMPOSED = 0
  ;PlotBank2Grid, Event
  
  banks_displayed = (*global).banks_displayed
  if (banks_displayed eq 'north_3_4') then begin
  
    view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    pixel_excluded = (*(*global).pixel_excluded_bank3_4)
    FOR i=0,3584L DO BEGIN
      IF (pixel_excluded[i] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, i)
        PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
      ENDIF
    ENDFOR
    
    view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    pixelid_min = 4096L
    FOR i=0,3584L DO BEGIN
      pixel = pixelid_min + i
      IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, pixel)
        PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
      ENDIF
    ENDFOR
    
  endif else begin
  
    view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    pixel_excluded = (*(*global).pixel_excluded)
    FOR i=0,3584L DO BEGIN
      IF (pixel_excluded[i] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, i)
        PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
      ENDIF
    ENDFOR
    
    view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    pixelid_min = 4096L
    FOR i=0,3584L DO BEGIN
      pixel = pixelid_min + i
      IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, pixel)
        PlotExcludedBox, Event, XY[0], XY[1], x_coeff, y_coeff, color
      ENDIF
    ENDFOR
    
  endelse
  
END

;------------------------------------------------------------------------------

PRO BSSreduction_FullResetButton, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  pixel_excluded = (*(*global).default_pixel_excluded)
  (*(*global).pixel_excluded)      = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
  
  PlotIncludedPixels, Event
  
  LogBookText = '-> ROI has been fully reset.'
  AppendLogBookMessage, Event, LogBookText
  
  ;remove name of file loaded from Loaded ROI text
  putLoadedRoiFileName, Event, ''
  
END

;------------------------------------------------------------------------------

PRO BSSreduction_ExcludedPixelType, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  currentSelectedSymbol  = isPixelExcludedSymbolFull(Event)
  previousSelectedSymbol = (*global).PrevExcludedSymbol
  
  IF (currentSelectedSymbol NE previousSelectedSymbol) THEN BEGIN
  
    IF ((*global).NeXusFound) THEN BEGIN
      PlotIncludedPixels, Event
    ENDIF
    (*global).PrevExcludedSymbol = currentSelectedSymbol
  ENDIF
END

;------------------------------------------------------------------------------

PRO BSSreduction_ExcludeEverything, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF ((*global).NeXusFound) THEN BEGIN
  
    sz = (*global).pixel_excluded_size
    pixel_excluded = MAKE_ARRAY(sz,/INTEGER,VALUE=1)
    (*(*global).pixel_excluded) = pixel_excluded
    PlotExcludedPixels, Event
    
  ENDIF
END

;------------------------------------------------------------------------------
