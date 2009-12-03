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
      WIDGET_CONTROL, id1, YSIZE= new_ysize+5
      
      id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_draw')
      WIDGET_CONTROL, id, DRAW_XSIZE= new_xsize-6
      WIDGET_CONTROL, id, DRAW_YSIZE= new_ysize-6-25
      
      plot_ascii_file, EVENT=event
      
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
