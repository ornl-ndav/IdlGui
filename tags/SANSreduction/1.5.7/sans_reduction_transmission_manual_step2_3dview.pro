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

PRO show_trans_manual_step2_3dview, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    result = DIALOG_MESSAGE('3d View Plot can not be rendered',$
      TITLE='ERROR while ploating 3d view !', $
      /ERROR)
    RETURN
  ENDIF
  
  trans_manual_step2 = (*global).trans_manual_step2
  ptr_user_counts_vs_xy = trans_manual_step2.user_counts_vs_xy
  user_counts_vs_xy = *ptr_user_counts_vs_xy
  
  ptr_xaxis = trans_manual_step2.xaxis
  xaxis = *ptr_xaxis
  
  ptr_yaxis = trans_manual_step2.yaxis
  yaxis = *ptr_yaxis
  
  average_value = trans_manual_step2.average_value
  
  iSurface, user_counts_vs_xy ,xaxis, yaxis, $
    BOTTOM=[0,0,0], $
    /NO_SAVEPROMPT, $
    BACKGROUND = [50,50,50], $
    COLOR= [250, 250, 0], $
    /DISABLE_SPLASH_SCREEN, $
    IDENTIFIER = iToolID, $
    STYLE=6, $
    TITLE = '3D view of selection (yellow) with background calculated (pink)', $
    VIEW_TITLE = 'Counts vs Tube and Pixel',$
    XTITLE = 'Tube #', $
    YTITLE = 'Pixel #', $
    ZTITLE = 'Counts', $
    XMAJOR = N_ELEMENTS(xaxis)-1, $
    YMAJOR = N_ELEMENTS(yaxis)-1
    
  average_plot = user_counts_vs_xy * 0 + average_value
  iSurface, average_plot, xaxis, yaxis, $
    overplot=iToolID, COLOR=[250, 0, 250] ;pink
    
END