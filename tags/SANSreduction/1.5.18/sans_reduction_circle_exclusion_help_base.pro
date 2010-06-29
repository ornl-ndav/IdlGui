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

PRO sans_reduction_circle_exclusion_help_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_help
  global = (*global_help).global
  main_event = (*global_help).main_event
  
  CASE Event.id OF
  
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO sans_reduction_circle_exclusion_help, Event=Event

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset + 160
  
  ourGroup = WIDGET_BASE()
  
  title = 'How does it work ?'
  wBase = WIDGET_BASE(TITLE = title,$
    ;    UNAME        = 'fits_tools_tab1_plot_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = 229,$
    SCR_XSIZE    = 397,$
    MAP          = 1,$
    ;    /BASE_ALIGN_CENTER,$
    ;    /TLB_MOVE_EVENTS, $
    ;    /TLB_SIZE_EVENTS, $
    GROUP_LEADER = ourGroup)
    
  (*global).circle_exclusion_help_base = wBase
  
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  draw = WIDGET_DRAW(main_base,$
    SCR_XSIZE = 397,$
    SCR_YSIZE = 229,$
    ;    /BUTTON_EVENTS,$
    ;    /MOTION_EVENTS,$
    UNAME = 'circular_selection_help_draw')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
  global_help = PTR_NEW({ wbase: wbase,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_help
  
  XMANAGER, "sans_reduction_circle_exclusion_help", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  help_image = READ_PNG('SANSreduction_images/circular_selection_help.png')
  uname = 'circular_selection_help_draw'
  mode_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, help_image, 0, 0,/true
  
END
