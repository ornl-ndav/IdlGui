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

  wWidget =  Event.top  ;widget id
  
  ON_IOERROR, alternate

  CASE Event.id OF

    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
       id = WIDGET_INFO(Event.top,find_by_Uname='x_field')
       WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(Event.x,/REMOVE_ALL)
       id = WIDGET_INFO(Event.top,find_by_Uname='y_field')
       WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(Event.y,/REMOVE_ALL)
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek'): BEGIN
       send_to_geek_email, Event ;_event
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='x_field'): BEGIN
       id = WIDGET_INFO(Event.top,find_by_Uname='x_field')
       WIDGET_CONTROL, id, GET_VALUE=new_width
       IF (new_width GT 300) THEN BEGIN
          id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
          WIDGET_CONTROL, id, SCR_XSIZE=new_width
       ENDIF
    END
   
    WIDGET_INFO(wWidget, FIND_BY_UNAME='y_field'): BEGIN
       id = WIDGET_INFO(Event.top,find_by_Uname='y_field')
       WIDGET_CONTROL, id, GET_VALUE=new_height
       IF (new_height GT 300) THEN BEGIN
          id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
          WIDGET_CONTROL, id, SCR_YSIZE=new_height
       ENDIF
    END
  
    ELSE:
  ENDCASE

alternate:  

END


PRO MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;define parameters
  scr_x 	= 1100				;main window width
  scr_y 	= 700				;main window height
  ctrl_x	= 1				;width of left box - control
  ctrl_y	= scr_y				;height of lect box - control
  draw_x 	= 304				;main width of draw area
  draw_y 	= 256				;main heigth of draw area
  draw_offset_x = 10			;draw x offset within widget
  draw_offset_y = 10			;draw y offset within widget
  plot_height = 150			;plot box height
  plot_length = 304			;plot box length
  
  APPLICATION = 'GUIdesigner'
  VERSION     = '1.0.0'
  
  Resolve_Routine, 'GUIdesigner_eventcb',/COMPILE_FULL_FILE
  ;Load event callback routines
  
  title = APPLICATION + ' - ' + VERSION
  
 ;define initial global values
  global = ptr_new({xoffset: 50,$
                    yoffset: 50,$
                    xsize: 300,$
                    ysize: 300})
 
  MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                           UNAME          = 'MAIN_BASE',$
                           XOFFSET        = (*global).xoffset,$
                           YOFFSET        = (*global).yoffset,$
                           SCR_XSIZE      = (*global).xsize,$
                           SCR_YSIZE      = (*global).ysize,$
                           TITLE          = title,$
                           SPACE          = 3,$
                           /TLB_SIZE_EVENTS,$
                           XPAD           = 3,$
                           YPAD           = 3)

;xsize cw_field
  Base1 = WIDGET_BASE(MAIN_BASE,$
                      XOFFSET = 0,$
                      YOFFSET = 0,$
                      XSIZE = 300,$
                      YSIZE = 40,$
                      FRAME = 0)

  wXsize = CW_FIELD(Base1,$
                    XSIZE = 5,$
                    UNAME = 'x_field',$
                    VALUE = '300',$
                    TITLE = 'Width of the application (pixels): ',$
                    /RETURN_EVENTS)

;ysize cw_field
  Base2 = WIDGET_BASE(MAIN_BASE,$
                      XOFFSET = 0,$
                      YOFFSET = 45,$
                      XSIZE = 300,$
                      YSIZE = 40,$
                      FRAME = 0)

  wYsize = CW_FIELD(Base2,$
                    XSIZE = 5,$
                    UNAME = 'y_field',$
                    VALUE = '300',$
                    TITLE = 'Height of the application (pixels):',$
                    /RETURN_EVENTS)

  text= ['1/ Enter the width and height you want for this application or ' + $
         ' increase the size of gui by dragging the bottom right corner, ' + $
         'then hit ENTER.',$
         '2/ Click SEND TO GEEK to let me ' + $
         'know ' + $
         'the size you want for your application.',$
         'TIPS: Make sure you try the size you want for all ' + $
         'the computers that will run this application (laptop, various ' + $
         'desktops ' + $
         'monitors....).']
  
  wText = WIDGET_TEXT (MAIN_BASE,$
                       VALUE   = text,$
                       XOFFSET = 0,$
                       YOFFSET = 90,$
                       XSIZE = 290,$
                       YSIZE = 10,$
                       UNAME = 'info_text',$
                       /WRAP)

  wComment = WIDGET_TEXT(MAIN_BASE,$
                         VALUE = '',$
                         XOFFSET = 0,$
                         YOFFSET = 240,$
                         XSIZE = 30,$
                         YSIZE = 3,$
                         UNAME = 'comment_text',$
                         /WRAP,$
                         /EDITABLE)

  wSEND = WIDGET_BUTTON (MAIN_BASE,$
                         VALUE = 'SEND TO GEEK',$
                         XOFFSET = 205,$
                         UNAME = 'send_to_geek',$
                         YOFFSET = 255,$
                         XSIZE = 90)
      
;attach global data structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
    
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
END

;
; Empty stub procedure used for autoloading.
;
pro GUIdesigner, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
