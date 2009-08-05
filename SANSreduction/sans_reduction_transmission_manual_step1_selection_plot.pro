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

PRO plot_selection, Event, mode=mode
  ;mode = 'x0y0' or 'x1y1'

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1
  color_non_working = 100
  color_working = 250
  
  IF (mode EQ 'x0y0') THEN BEGIN ;x0y0
    x0y0x1y1[0] = Event.X
    x0y0x1y1[1] = Event.Y
    color_0 = color_working
    color_1 = color_non_working
    linestyle_0 = 0
    linestyle_1 = 1
  ENDIF ELSE BEGIN ;x1y1
    x0y0x1y1[2] = Event.X
    x0y0x1y1[3] = Event.Y
    color_1 = color_working
    color_0 = color_non_working
    linestyle_0 = 1
    linestyle_1 = 0
  ENDELSE
  
  (*global).x0y0x1y1 = x0y0x1y1
  
  xmin = 0
  xmax = 450
  ymin = 0
  ymax = 400
  
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (x0 NE 0 AND y0 NE 0) THEN BEGIN
  
    PLOTS, x0, ymin, /DEVICE, COLOR=color_0
    PLOTS, x0, ymax, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    PLOTS, xmin, y0, /DEVICE, COLOR=color_0
    PLOTS, xmax, y0, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    
  ENDIF
  
  IF (x1 NE 0 AND y1 NE 0) THEN BEGIN
  
    PLOTS, x1, ymin, /DEVICE, COLOR=color_1
    PLOTS, x1, ymax, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    PLOTS, xmin, y1, /DEVICE, COLOR=color_1
    PLOTS, xmax, y1, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO refresh_plot_selection_trans_manual_step1, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  working_with = (*global).working_with_xy
  x0y0x1y1 = (*global).x0y0x1y1
  color_non_working = 100
  color_working = 250
  
  IF (working_with EQ 0) THEN BEGIN ;x0y0
    color_0 = color_working
    color_1 = color_non_working
    linestyle_0 = 0
    linestyle_1 = 1
  ENDIF ELSE BEGIN ;x1y1
    color_1 = color_working
    color_0 = color_non_working
    linestyle_0 = 1
    linestyle_1 = 0
  ENDELSE
  
  xmin = 0
  xmax = 450
  ymin = 0
  ymax = 400
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (x0 NE 0 AND y0 NE 0) THEN BEGIN
  
    PLOTS, x0, ymin, /DEVICE, COLOR=color_0
    PLOTS, x0, ymax, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    PLOTS, xmin, y0, /DEVICE, COLOR=color_0
    PLOTS, xmax, y0, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    
  ENDIF
  
  IF (x1 NE 0 AND y1 NE 0) THEN BEGIN
  
    PLOTS, x1, ymin, /DEVICE, COLOR=color_1
    PLOTS, x1, ymax, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    PLOTS, xmin, y1, /DEVICE, COLOR=color_1
    PLOTS, xmax, y1, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    
  ENDIF
  
END

