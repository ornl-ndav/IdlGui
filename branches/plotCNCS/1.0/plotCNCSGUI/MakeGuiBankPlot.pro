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

PRO MakeGuiBankPlot, wBase, Xfactor, Yfactor

  ourGroup = WIDGET_BASE()
  wBase = WIDGET_BASE(TITLE = 'Bank View',$
    UNAME        = 'bank_plot_base',$
    XOFFSET      = 50,$
    YOFFSET      = 50,$
    MAP          = 1,$
    GROUP_LEADER = ourGroup,$
    /BASE_ALIGN_CENTER,$
    /COLUMN)
  
  ;row11, tube and row ------------------------
  row11 = WIDGET_BASE(wBase,/ROW)
    
  row1 = WIDGET_BASE(row11,/ROW)
  x = CW_FIELD(row1,$
    XSIZE = 3,$
    UNAME = 'x_input',$
    TITLE = 'Tube:',$
    /ALL_EVENTS,$
    /ROW,$
    /INTEGER)
  
  ;space
  space = WIDGET_LABEL(row11,$
  VALUE = '  ')  
    
  row2 = WIDGET_BASE(row11,/ROW)
  x = CW_FIELD(row2,$
    XSIZE = 3,$
    UNAME = 'y_input',$
    TITLE = 'Row:',$
    /ALL_EVENTS,$
    /ROW,$
    /INTEGER)
    
  ;row3, pixelID --------------------------------
  row3 = WIDGET_BASE(wBase,/ROW)
  pixel =  CW_FIELD(row3,$
    XSIZE = 6,$
    UNAME = 'pixelid_input',$
    TITLE = 'PixelID:',$
    /ALL_EVENTS,$
    /ROW,$
    /LONG)
    
  ;row4, counts ----------------------------------
  row4 = WIDGET_BASE(wBase,/ROW)
  counts = WIDGET_LABEL(row4,$
    VALUE = 'Counts:')
  value = WIDGET_LABEL(row4,$
    VALUE = 'N/A',$
    UNAME = 'counts',$
    SCR_XSIZE = 50)
    
   ;row5, tube angle ------------------------------
   row5 = WIDGET_BASE(wBase,/ROW, FRAME=1)
   tube = WIDGET_LABEL(row5,$
   VALUE = 'Tube Angle:')
   value = WIDGET_LABEL(row5,$
   VALUE = 'N/A',$
   /ALIGN_LEFT,$
   UNAME = 'scattering_angle',$
   SCR_XSIZE = 50) 
   unit = WIDGET_LABEL(row5,$
   VALUE = 'degrees') 
    
  wBankDraw = WIDGET_DRAW(wBase,$ ;------------------
    SCR_XSIZE = 8L*Xfactor,$
    SCR_YSIZE = 128L*Yfactor,$
    UNAME     = 'bank_plot',$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

