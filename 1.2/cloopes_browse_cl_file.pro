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

PRO browse_cl_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF ((*global).debugging EQ 'yes') THEN BEGIN
    sDebugging = (*global).debugging_structure
    path = sDebugging.path
  ENDIF ElSE BEGIN
    path = (*global).path
  ENDELSE
  
  title = 'Select a Command Line File to Load'
  filter = '*.txt'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  file_name = DIALOG_PICKFILE(FILTER=filter,$
    GET_PATH=new_path,$
    /MUST_EXIST,$
    PATH=path,$
    TITLE=title,$
    /READ,$
    DIALOG_PARENT=id)
    
  IF (file_name NE '') THEN BEGIN
    (*global).path = new_path
    ;display name of file loaded
    putValue, Event, 'cl_file_name_label', file_name
    ;display contain of file loaded
    displayCLfile, Event, file_name
    
    ;reset tab2_table
    (*(*global).tab2_table) = PTR_NEW(0L)
    
  ENDIF
  
END

;+
; :Description:
;   this function takes the arg and remove it from the command line
;
; :Params:
;    cdl
;
; :Keywords:
;    arg
;
; :Author: j35
;-
function cleanup_cl, cdl, arg=arg
  compile_opt idl2
  
  cdl_array = strsplit(cdl,arg,/extract,/regex,count=nbr)
  cdl_local = ''
  if (nbr eq 1) then cdl_local = cdl_array[0]
  if (nbr gt 1) then cdl_local = cdl_array[0] + cdl_array[1]
  if (nbr eq -1) then cld_local = cdl
  
  return, cdl_local
end

;-------------------------------------------------------------------------------
;This function read the file passed as an argument and display its contain in
;the preview text field
PRO displayCLfile, Event, file_name
  OPENR, 1, file_name
  nbr_lines = FILE_LINES(file_name)
  ;WHILE (~EOF(1)) DO BEGIN
  file_array = STRARR(nbr_lines)
  READF,1, file_array
  CLOSE,1
  
  cdl = file_array[0]
  
  widget_control, event.top, get_uvalue=global
  if ((*global).with_batch eq 'yes') then begin
    command_line = cdl
  endif else begin
    command_line = cleanup_cl(cdl, arg=' --batch')
  endelse
   
  putValue, Event, 'preview_cl_file_text_field', command_line
END

