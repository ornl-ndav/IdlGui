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

PRO design_transmission_manual_mode_tab1, wBase, tab

  id = WIDGET_INFO(wBase, FIND_BY_UNAME='manual_transmission_tab')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
    
  base = WIDGET_BASE(tab,$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysizxe, $
    TITLE = 'Define Beam Stop Region')
    
  xoffset = 50 ;xoffset of scale widget_draw
  yoffset = 50 ;yoffset of scale widget_draw
  xsize_main = 450 ;size of main plot
  ysize_main = 400 ;size of main plot
  main_xoffset = xsize/2 - xsize_main/2 
  main_yoffset = yoffset
  
  scale_plot = WIDGET_DRAW(base,$
  XOFFSET = main_xoffset,$
  YOFFSET = main_yoffset,$
  SCR_XSIZE = xsize_main,$
  SCR_YSIZE = ysize_main,$
  FRAME = 5,$
  UNAME = 'manual_transmission_step1_draw')  

  scale_plot = WIDGET_DRAW(base,$
  XOFFSET = main_xoffset-xoffset,$
  YOFFSET = main_yoffset-yoffset,$
  SCR_XSIZE = xsize_main+2*xoffset,$
  SCR_YSIZE = ysize_main+2*yoffset,$
  UNAME = 'manual_transmission_step1_draw_scale')  
    
    
    
END