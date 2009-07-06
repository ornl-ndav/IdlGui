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

PRO ReleaseMouseInTof, Event
  ;get global structure
  WIDGET_CONTROL, event.top, GET_UVALUE=global3
  
  ;plot data (counts vs tof)
  view_info = widget_info(Event.top,FIND_BY_UNAME='tof_plot_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  data = (*(*global3).IvsTOF)
  ;get type desired
  type = getTypeDesired(Event)
  
  x0 = (*global3).x0_data
  y0 = (*global3).y0_data
  x1 = (*global3).x1_data
  y1 = (*global3).y1_data
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)

  IF (xmax EQ 0. OR $
  xmin EQ 0.) THEN BEGIN
  
    IF (type EQ 'log') THEN BEGIN ;log
      plot, data, XSTYLE=1, /YLOG, MIN_VALUE=1 ,$
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDIF ELSE BEGIN
      plot, data, XSTYLE=1, $
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDELSE
    
  ENDIF ELSE BEGIN
  
    IF (type EQ 'log') THEN BEGIN ;log
      plot, data, xrange=[xmin,xmax], $
        yrange = [ymin,ymax], XSTYLE=1, /YLOG, MIN_VALUE=1 ,$
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDIF ELSE BEGIN
      plot, data, xrange=[xmin,xmax], $
        yrange = [ymin,ymax], XSTYLE=1, $
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDELSE
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO MovingMouseInTof, Event
  ;get global structure
  WIDGET_CONTROL, event.top, GET_UVALUE=global3
  
  ;plot data (counts vs tof)
  view_info = widget_info(Event.top,FIND_BY_UNAME='tof_plot_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  data = (*(*global3).IvsTOF)
  ;get type desired
  type = getTypeDesired(Event)
  
  x0 = (*global3).x0_data_backup
  y0 = (*global3).y0_data_backup
  x1 = (*global3).x1_data_backup
  y1 = (*global3).y1_data_backup
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  
  IF (xmax EQ 0. OR $
  xmin EQ 0.) THEN BEGIN
  
    IF (type EQ 'log') THEN BEGIN ;log
      plot, data, XSTYLE=1, /YLOG, MIN_VALUE=1 ,$
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDIF ELSE BEGIN
      plot, data, XSTYLE=1, $
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDELSE
    
  ENDIF ELSE BEGIN
  
    IF (type EQ 'log') THEN BEGIN ;log
      plot, data, xrange=[xmin,xmax], $
        yrange = [ymin,ymax], XSTYLE=1, /YLOG, MIN_VALUE=1 ,$
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDIF ELSE BEGIN
      plot, data, xrange=[xmin,xmax], $
        yrange = [ymin,ymax], XSTYLE=1, $
        FONT='8x13', $
        XTITLE = 'Bins #', $
        YTITLE = 'Counts'
    ENDELSE
    
  ENDELSE
  
END

;-======-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=----------------------------------------
PRO RefreshPlotInTof, Event
  ;get global structure
  WIDGET_CONTROL, event.top, GET_UVALUE=global3
  
  ;plot data (counts vs tof)
  view_info = widget_info(Event.top,FIND_BY_UNAME='tof_plot_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  data = (*(*global3).IvsTOF)
  ;get type desired
  type = getTypeDesired(Event)
  
  xmin = (*global3).xmin_for_refresh
  xmax = (*global3).xmax_for_refresh
  
  IF (type EQ 'log') THEN BEGIN ;log
    plot, data, xrange=[xmin,xmax], XSTYLE=1, /YLOG, MIN_VALUE=1, $
      FONT='8x13'
  ENDIF ELSE BEGIN
    plot, data, xrange=[xmin,xmax], XSTYLE=1, $
      FONT='8x13'
  ENDELSE
  
END
