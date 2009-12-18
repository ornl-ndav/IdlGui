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

PRO MAIN_BASE_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    
      id1 = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
      WIDGET_CONTROL, id1, /REALIZE
      geometry = WIDGET_INFO(id1, /GEOMETRY)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      WIDGET_CONTROL, id1, XSIZE= new_xsize-6
      WIDGET_CONTROL, id1, YSIZE= new_ysize-6
      
      id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_draw')
      WIDGET_CONTROL, id, DRAW_XSIZE= new_xsize-6
      WIDGET_CONTROL, id, DRAW_YSIZE= new_ysize-6-25-11
      
      PlotAsciiData, main_event = Event
      
    END
    
    ;main plot
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_draw'): BEGIN
    
      IF (Event.press EQ 1) THEN BEGIN ;left click
        (*global).left_click = 1b
        CURSOR, x, y, /NOWAIT
        x0y0x1y1 = FLTARR(4)
        x0y0x1y1[0] = x
        x0y0x1y1[1] = y
        (*global).x0y0x1y1 = x0y0x1y1
        populate_tools_zoom, Event, x1=x, y1=y
      ENDIF
      
      IF (Event.press EQ 0) THEN BEGIN ;move mouse with left click
        IF ((*global).left_click) THEN BEGIN
          CURSOR, x, y, /NOWAIT
          x0y0x1y1 = (*global).x0y0x1y1
          x0y0x1y1[2] = x
          x0y0x1y1[3] = y
          (*global).x0y0x1y1 = x0y0x1y1
          populate_tools_zoom, Event, x2=x, y2=y
          PlotAsciiData, main_event = Event
          plot_zoom_selection, Event
        ENDIF
      ENDIF
      
      IF (Event.release EQ 1) THEN BEGIN ;release left click
        sort_x0y0x1y1, Event
        populate_tools_zoom, Event, ALL=1
        (*global).left_click = 0b
        IF (isZoomReset(Event)) THEN BEGIN
          plot_ascii_file, main_event=event
        ENDIF ELSE BEGIN
          (*global).xyminmax = (*global).xyminmax
          PlotAsciiData, main_event = Event
        ENDELSE
;        xyminmax = (*global).xyminmax
;        xmin = xyminmax[0]
;        ymin = xyminmax[1]
;        xmax = xyminmax[2]
;        ymax = xyminmax[3]
;        populate_tools_zoom, Event, x1=xmin, y1=ymin, x2=xmax, y2=ymax
      ENDIF
      
    END
    
    ;load button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_button_uname'): BEGIN
      id = (*global).load_base
      IF (WIDGET_INFO(id, /VALID_ID) EQ 0) THEN BEGIN
        plot_ascii_load_base, Event
      ENDIF
    END
    
    ;tools button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tools_button_uname'): BEGIN
      id = (*global).tools_base
      IF (WIDGET_INFO(id, /VALID_ID) EQ 0) THEN BEGIN
        plot_ascii_tools_base, Event
      ENDIF
    END
    
    ELSE:
    
  ENDCASE
  
END
