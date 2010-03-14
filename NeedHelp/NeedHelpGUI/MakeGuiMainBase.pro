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

PRO MakeGuiMainBase, MAIN_BASE, global

  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  base = widget_base(MAIN_BASE,$
    /COLUMN)
    
  ;row1
  row = widget_base(base,$
    /row)
  message = widget_text(row,$
    xsize = 80,$
    ysize = 5,$
    /editable,$
    uname = 'message')
    
  xsize = 480
  col2 = widget_base(row,$
    /column)
  add_file = widget_button(col2,$
    value = 'Browse for files to add...',$
    uname = 'add_file',$
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
    scr_xsize = xsize)
    
    
    
    
    
    
END