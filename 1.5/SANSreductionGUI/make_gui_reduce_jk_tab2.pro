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

PRO make_gui_reduce_jk_tab2, REDUCE_TAB, tab_size, tab_title

  ;= Build Widgets ==============================================================
  BaseTab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = 'reduce_jk_tab2_base_uname',$
    XOFFSET   = tab_size[0],$
    YOFFSET   = tab_size[1],$
    SCR_XSIZE = tab_size[2],$
    SCR_YSIZE = tab_size[3],$
    TITLE     = tab_title)
       
  base = WIDGET_BASE(BaseTab,$
  /BASE_ALIGN_CENTER,$
  SCR_XSIZE = tab_size[2],$
    /COLUMN)
       
 row1 = WIDGET_BASE(base,$
 /ROW)
 label = WIDGET_LABEL(row1,$
 VALUE = 'Root name of output file: ')
 value = WIDGET_TEXT(row1,$
 VALUE = ' ',$
 XSIZE = 40,$
 /EDITABLE)
 label = WIDGET_LABEL(row1,$
 VALUE = '(no extension)')
 
 ;space
 space = WIDGET_LABEL(base,$
 VALUE = ' ')
 
 row2 = WIDGET_BASE(base,$
 /NONEXCLUSIVE)
 output1 = WIDGET_BUTTON(row2,$
 VALUE = 'Iq: I(Q)')
 output2 = WIDGET_BUTTON(row2,$
 VALUE = 'IvQxQy: 2D I(Qx,Qy)')
 output3 = WIDGET_BUTTON(row2,$
 VALUE = 'IvXY: 2D Counts(x,y) integrated over TOF')
 output4 = WIDGET_BUTTON(row2,$
 VALUE = 'tof2D: 2D counts(x,y) for each TOF slice')
 output5 = WIDGET_BUTTON(row2,$
 VALUE = 'tofIq: I(Q) for each time bin')
 output6 = WIDGET_BUTTON(row2,$
 VALUE = 'IvTof: Counts vs TOF')
 output7 = WIDGET_BUTTON(row2,$
 VALUE = 'IvWl: Counts vs Wavelength')
 output9 = WIDGET_BUTTON(row2,$
 VALUE = 'TvsTof: Transmission vs TOF')
 output10 = WIDGET_BUTTON(row2,$
 VALUE = 'TvsWl: Transmsission vs Wavelength')
 output11 = WIDGET_BUTTON(row2,$
 VALUE = 'MvsTof: Monitor vs TOF')
 output12 = WIDGET_BUTTON(row2,$
 VALUE = 'MvsWl: Monitor vs Wavelength')
 WIDGET_CONTROL, output1, /SET_BUTTON
       
       
       
END
