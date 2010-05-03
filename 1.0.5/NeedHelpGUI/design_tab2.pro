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

pro design_tab2, base2, global

  ;row1
  row = widget_base(base2,$
    /row)
  col1 = widget_base(row,$
    /column)
  label = widget_label(col1,$
    value = 'Ask your question / Describe your problem / Give your feedback')
  message = widget_text(col1,$
    xsize = 80,$
    ysize = 17,$
    /editable,$
    value = "<Your message here>",$
    uname = 'message')
    
  xsize = 480
  col2 = widget_base(row,$
    /column)
  add_file = widget_button(col2,$
    value = 'Browse for files you want to attach to your message...',$
    uname = 'add_file',$
    event_pro = 'browse_files',$
    scr_xsize = xsize)
  Table = WIDGET_TABLE(col2,$
    UNAME = 'table_uname',$
    XSIZE = 1,$
    YSIZE = 10,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = 200,$
    ;    /SCROLL,$
    EDITABLE = [0],$
    COLUMN_WIDTHS = [xsize],$
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Files'])
    
  remove_file = widget_button(col2,$
    value = 'Remove files selected',$
    uname = 'remove_file',$
    event_pro = 'remove_files',$
    sensitive = 0,$
    scr_xsize = xsize)
    
  ;row 2
  row2 = widget_base(base2,$
    /row)
  label = widget_label(row2,$
    value = 'Who are you and how can we contact you (ex: (865) 123-456, ' + $
    'my_email@gmail.com) ?')
  text = widget_text(row2,$
    value = '',$
    /editable,$
    uname = 'contact_uname',$
    /align_left,$
    scr_xsize = 505)
    
  ;space
  space = widget_label(base2,$
    value = ' ')
    
  ;new row
  row3 = widget_base(base2,$
    /row)
  close = widget_button(row3,$
    value = 'CLOSE',$
    event_pro = 'close_button',$
    xsize = 150,$
    uname = 'close')
  space = widget_label(row3,$
    value = '                                                   ' + $
    '                   ')
  send = widget_button(row3,$
    value = 'SEND YOUR MESSAGE',$
    xsize = 200,$
    event_pro = 'send_your_message',$
    uname = 'send_message')
  list = ['low','medium','high']
  label = widget_label(row3,$
    value = '        Priority:')
  priority = widget_droplist(row3,$
    value=list,$
    uname = 'priority_list')
  widget_control, priority, set_droplist_select=1
  
end