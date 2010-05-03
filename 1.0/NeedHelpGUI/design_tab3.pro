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

pro design_tab3, base3, global

  tab1_base = widget_base(base3,$
    /column)
    
  row1 = widget_base(tab1_base,$
    /row)
    
  col1 = widget_base(row1,$
    /column)
    
  xsize = 100
  ysize = 100
  
  col1_row1 = widget_base(col1,$
    /row)
  button1 = widget_draw(col1_row1,$
    uname = 'tab3_button1',$
    xsize = xsize,$
    ysize = ysize,$
    /button_events,$
    /tracking_events,$
    retain = 2)
  space = widget_label(col1_row1,$
    value = ' ')
  button2 = widget_draw(col1_row1,$
    uname = 'tab3_button2',$
    xsize = xsize,$
    ysize = ysize,$
    /button_events,$
    /tracking_events,$
    retain = 2)
  space = widget_label(col1_row1,$
    value = ' ')
  button3 = widget_draw(col1_row1,$
    uname = 'tab3_button3',$
    xsize = xsize,$
    ysize = ysize,$
    /button_events,$
    /tracking_events,$
    retain =2 )
  space = widget_label(col1_row1,$
    value = ' ')
  button4 = widget_draw(col1_row1,$
    uname = 'tab3_button4',$
    xsize = xsize,$
    ysize = ysize,$
    /button_events,$
    /tracking_events,$
    retain = 2)
;  space = widget_label(col1_row1,$
;    value = ' ')
;  button5 = widget_draw(col1_row1,$
;    uname = 'tab3_button5',$
;    xsize = xsize,$
;    ysize = ysize,$
;    /button_events,$
;    /tracking_events,$
;    retain = 2)
;  space = widget_label(col1_row1,$
;    value = ' ')
;  button6 = widget_draw(col1_row1,$
;    uname = 'tab3_button6',$
;    xsize = xsize,$
;    ysize = ysize,$
;    /button_events,$
;    /tracking_events,$
;    retain = 2)
 
  row2 = widget_base(tab1_base,$
    /row)
    
  preview = widget_text(row2,$
    value = 'Description of mouse over...',$
    xsize = 161,$
    ysize = 6,$
    uname = 'tab3_preview_button')
    
    
end