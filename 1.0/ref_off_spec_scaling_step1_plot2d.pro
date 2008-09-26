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

PRO ref_off_spec_scaling_plot2d_event, Event
COMPILE_OPT idl2, hidden
IF (TAG_NAMES(Event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST') $
  THEN BEGIN
    WIDGET_CONTROL, Event.top, /DESTROY
    RETURN
ENDIF
END

;------------------------------------------------------------------------------
PRO step4_step1_plot2d, Event, GROUP_LEADER=group
WIDGET_CONTROL, Event.top,GET_UVALUE=global
COMPILE_OPT idl2, hidden

; Check if already created.  If so, return.
IF (WIDGET_INFO((*global).w_scaling_plot2d_id, /VALID_ID) NE 0) THEN BEGIN
    WIDGET_CONTROL,(*global).w_scaling_plot2d_id, /SHOW
    RETURN
ENDIF

xsize = 500
ysize = 500

;Built base
title = 'Counts vs Pixels of Selection'
wBase = WIDGET_BASE(TITLE        = title,$
                    XOFFSET      = 900,$
                    YOFFSET      = 500,$
                    GROUP_LEADER = group,$
                    UNAME = 'plot_2d_scaling_base',$
                    /TLB_KILL_REQUEST_EVENTS)

wDraw = WIDGET_DRAW(wBase,$
                    SCR_XSIZE = xsize,$
                    SCR_YSIZE = ysize,$
                    UNAME     = 'plot_2d_scaling_draw')

(*global).w_scaling_plot2d_id = wBase
uname = WIDGET_INFO(wDraw,/UNAME)
(*global).w_scaling_plot2d_draw_uname = uname

WIDGET_CONTROL, wBase, /REALIZE
XMANAGER, "ref_off_spec_scaling_plot2d", wBase, /NO_BLOCK
END


