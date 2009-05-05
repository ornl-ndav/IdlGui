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

PRO save_roi_base, Event, path=path, FILE_NAME=file_name

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  
  ;our_group = widget_base(
  roi_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    SCR_XSIZE = 400,$
    frame = 5,$
    title = 'Select name of ROI file name to create')
  
    ;path label
    label = WIDGET_LABEL(roi_base,$
    VALUE = 'PATH:')
    
  ;path button ................. first row ........................
    path = WIDGET_BUTTON(roi_base,$
    VALUE = path,$
    UNAME = 'reduce_step2_roi_path_button')
    
    ;vertical space
    space = WIDGET_LABEL(roi_base,$
    VALUE = ' ')
    
    ;path label
    label = WIDGET_LABEL(roi_base,$
    VALUE = 'FILE NAME:')

  ;File name frame ............ second row .....................
  file_base = WIDGET_BASE(roi_base,$
    FRAME = 1,$
    /COLUMN)
    
    ;browse file name button
    browse = WIDGET_BUTTON(file_base,$
    VALUE = 'B R O W S E  . . . ',$
    SCR_XSIZE = 390,$
    UNAME = 'reduce_step2_roi_file_name_browse')
    
    ;file name text field
    name = WIDGET_TEXT(file_base,$
    VALUE = file_name,$
    SCR_XSIZE = 390,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_roi_file_name_text')

  ;cancel and ok buttons .............. third row ................
    row3 = WIDGET_BASE(roi_base,$
    /ROW)
        
    cancel = WIDGET_BUTTON(row3,$
    VALUE = 'CANCEL',$
    SCR_XSIZE = 120,$
    UNAme = 'reduce_step2_roi_cancel_button')
    
    space = WIDGET_LABEL(row3,$
    VALUE = '                        ')
    
    ok = WIDGET_BUTTON(row3,$
    VALUE = 'SAVE ROI',$
    SCR_XSIZE = 120,$
    UNAME = 'reduce_step2_roi_save_roi_ok_button')
    
  WIDGET_CONTROL, roi_base, /realize
END