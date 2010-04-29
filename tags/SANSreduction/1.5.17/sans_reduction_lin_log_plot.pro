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

FUNCTION LinOrLog, Event
  value = getCWBgroupValue(Event,'z_axis_scale')
  RETURN, value
END

PRO lin_or_log_plot, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;linear or log
  plot_type = LinOrLog(Event)
  ;plot_type = Event.value ;0->linear, 1->log
  
  ;retrieve the value to plot
  DataXY = (*(*global).rtDataXY)
  
  IF (plot_type EQ 1) THEN BEGIN ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(DataXY EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      DataXY[index] = !VALUES.D_NAN
      DataXY = ALOG10(DataXY)
      DataXY = BYTSCL(DataXY,/NAN)
    ENDIF
    
  ENDIF
  
  DEVICE, DECOMPOSED = 0
  LOADCT,5,/SILENT
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  xmin = getTextFieldValue(Event,'min_counts_displayed')
  xmax = getTextFieldValue(Event,'max_counts_displayed')
  IF (xmin NE 'N/A') THEN BEGIN
    xmin = LONG(xmin)
    min_array = WHERE(DataXY LT xmin, nbr_min)
    if (nbr_min GT 0) THEN BEGIN
      DataXY[min_array] = 0
    ENDIF
    xmax = LONG(xmax)
    max_array = WHERE(DAtaXY GT xmax, nbr_max)
    IF (nbr_max GT 0) THEN BEGIN
      DataXY[max_array] = 0
    ENDIF
  ENDIF
  
  TVSCL, DataXY, /DEVICE
  
;refresh_scale, Event         ;_plot
  
END

;------------------------------------------------------------------------------
PRO save_background,  Event, MAIN_BASE=main_base, GLOBAL=global

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='draw_uname')
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global
    ;select plot area
    id = WIDGET_INFO(Event.top,find_by_uname='draw_uname')
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  (*(*global).background) = background
  
END