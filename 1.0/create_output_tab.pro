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

;+
; :Description:
;    Send by email the file created
;
; :Keywords:
;    event
;
; :Author: j35
;-
function send_file_by_email, event=event, $
    nexus_filename = nexus_filename, $
    rtof_filename = rtof_filename
    
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  date = GenerateIsoTimeStamp()
  
  email_subject = 'File created with SOS ' + $
    (*global).version + '; '
  _subject = getValue(event=event, 'email_subject_uname')
  email_subject += _subject
  email = getValue(event=event, 'email_to_uname')
  
  ;send email for file created with nexus
  if (nexus_filename ne '') then begin
    email_message = 'File attached: ' + nexus_filename
    cmd_email = 'echo "' + email_message + '" | mutt -s " ' + $
      email_subject + '"' + ' -a ' + nexus_filename
    cmd_email += ' ' + email
    spawn, cmd_email, listening, err_listening
  endif
  
  ;send email for file created with rtof
  if (rtof_filename ne '') then begin
    email_message = 'File attached: ' + rtof_filename
    cmd_email = 'echo "' + email_message + '" | mutt -s " ' + $
      email_subject + '"' + ' -a ' + rtof_filename
    cmd_email += ' ' + email
    spawn, cmd_email, listening, err_listening
  endif
  
  return, 1
end


;+
; :Description:
;    Create the output file
;
; :Keywords:
;    event
;    filename
;    file_ext
;    structure
;
; :Author: j35
;-
function create_general_file, event=event, $
    filename=filename, $
    file_ext=file_ext, $
    structure=structure
  compile_opt idl2
  _status = 1
  
  widget_control, event.top, get_uvalue=global
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 0
  endif
  
  _filename = getValue(event=event, uname='output_file_name')
  _path = (*global).output_path
  
  ;full file name
  output_file_name = _path + _filename + file_ext
  filename = output_file_name ;use by the calling functions
  
  data  = (*(*structure).data)
  Qx = (*(*structure).xaxis)
  Qz = (*(*structure).yaxis)
  
  sz_x = n_elements(Qx)
  sz_z = n_elements(Qz)
  
  ;create ascii array
  output_array = strarr(max([sz_x,sz_z]))
  index = 0
  while (index lt max([sz_x,sz_z])) do begin
  
    if (index ge sz_x) then begin
      x = ''
    endif else begin
      x = strcompress(Qx[index],/remove_all)
    endelse
    
    if (index ge sz_z) then begin
      z = ''
    endif else begin
      z = strcompress(Qz[index],/remove_all)
    endelse
    
    if (index ge sz_x) then begin
      data_part = ''
    endif else begin
      data_part = strjoin(strcompress(reform(data[index,*]),/remove_all),' ')
    endelse
    
    output_array[index] = x + ' ' + z + ' ' + data_part
    
    index++
  endwhile
  
  ;prepare file to write in
  openw, 1, output_file_name
  
  sz = n_elements(output_array)
  _index = 0
  while (_index lt sz) do begin
    printf, 1, output_array[_index]
    _index++
  endwhile
  
  close, 1
  free_lun, 1
  
  return, _status
end

;+
; :Description:
;    Create output nexus file
;
; :Keywords:
;    event
;
; :Returns:
;    status of process (1 for success and 0 for failure)
;
; :Author: j35
;-
function create_nexus_output_file, event=event, filename=filename
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  status = 1
  file_ext = (*global).nexus_ext
  structure = (*global).structure_data_working_with_nexus
  status = create_general_file(event=event, $
    filename=filename, $
    file_ext=file_ext, $
    structure=structure)
    
  return, status
end

;+
; :Description:
;    Create output RTOF file
;
; :Keywords:
;    event
;
; :Returns:
;   status of process (1 for success and 0 for failure)
;
; :Author: j35
;-
function create_rtof_output_file, event=event, filename=filename
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  file_ext = (*global).rtof_ext
  structure = (*global).structure_data_working_with_rtof
  status = create_general_file(event=event, $
    filename=filename, $
    file_ext=file_ext, $
    structure=structure)
    
  return, status
end

;+
; :Description:
;    Create the output files
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_output_files, event
  compile_opt idl2
  
  ;nexus output
  nexus_output_status = isButtonSelected(event=event, $
    uname='output_working_with_nexus_plot')
  status_nexus = 1b
  message_nexus = ''
  nexus_filename = ''
  if (nexus_output_status) then begin
    status_nexus = create_nexus_output_file(event=event, filename=nexus_filename)
    message_nexus = 'Created file ' + nexus_filename + ' ... '
    if (status_nexus) then begin
      message_nexus += 'OK'
    endif else begin
      message_nexus += 'FAILED!'
    endelse
    log_book_update, event, message='> ' + message_nexus
  endif
  
  ;rtof ouput
  rtof_output_status = isButtonSelected(event=event, $
    uname='output_working_with_rtof_plot')
  status_rtof = 1b
  message_rtof = ''
  rtof_filename = ''
  if (rtof_output_status) then begin
    status_rtof = create_rtof_output_file(event=event, filename=rtof_filename)
    message_rtof = 'Created file ' + rtof_filename + ' ... '
    if (status_rtof) then begin
      message_rtof += 'OK'
    endif else begin
      message_rtof += 'FAILED!'
    endelse
    log_book_update, event, message='> ' + message_rtof
  endif
  
  ;send by email
  email_status = isButtonSelected(event=event, uname='email_switch_uname')
  if (email_status) then begin
    status_email = send_file_by_email(event=event, $
      nexus_filename = nexus_filename, $
      rtof_filename = rtof_filename)
      
  endif
  
  widget_id = widget_info(event.top, find_by_uname='main_base')
  result = dialog_message([message_nexus,message_rtof], $
    /information, $
    dialog_parent=widget_id, $
    /center, $
    title = 'Status of file(s) created')
    
end

;+
; :Description:
;    Update the label of the create output file button relative to the status
;    of all the widgets of the same tab.
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro update_create_file_button_label, event
  compile_opt idl2
  
  ;get output format selected
  index_value =  getDroplistIndexValue(event=event, uname='output_format')
  
  ;nexus output
  nexus_output_status = isButtonSelected(event=event, $
    uname='output_working_with_nexus_plot')
    
  ;rtof ouput
  rtof_output_status = isButtonSelected(event=event, $
    uname='output_working_with_rtof_plot')
    
  label =  ''
  file = ''
  case (nexus_output_status + rtof_output_status) of
    2: begin
      label = 'Create NeXus and RTOF files '
      file = 'files '
    end
    0: begin
      label = 'No file to be created '
      file = 'file '
    end
    1: begin
      if (nexus_output_status) then begin
        label = 'Create NeXus file '
      endif else begin
        label = 'Create RTOF file '
      endelse
      file = 'file '
    end
    else:
  endcase
  
  ;check email status
  email_status = isButtonSelected(event=event, $
    uname='email_switch_uname')
  if (email_status) then begin
    email = getValue(event=event, uname='email_to_uname')
    if (strcompress(email,/remove_all) eq '') then email = 'N/A'
    label += 'and send ' + file + 'to ' + email + ' '
  endif
  
  label += '(format: ' + index_value + ')'
  putValue, event=event, 'create_output_button', label[0]
  
end

;+
; :Description:
;    Create a default output file name
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro define_new_default_output_file_name, event
  compile_opt idl2
  
  time_stamp = GenerateIsoTimeStamp()
  
  file_name = 'SOS_IvsQxQz_'
  file_name += time_stamp
  putValue, event=event, 'output_file_name', file_name
  
end

;+
; :Description:
;    where to create the output file button
;
; :Params:
;    event
;
; :Author: j35
;-
pro where_create_output_file, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  output_path = (*global).output_path
  id = widget_info(event.top, find_by_uname='main_base')
  result = dialog_pickfile(/directory,$
    dialog_parent=id, $
    get_path=path, $
    title = 'Select output folder')
    
  if (path[0] ne '') then begin
    (*global).output_path = path[0]
    putValue, event=event, 'output_path_button', path[0]
  endif
  
  return
end

;+
; :Description:
;    This routine checks which buttons/base should be enabled or not, according
;    to the status of the main application.
;    ex: Working with NeXus ran with sucess -> enabled "last data set created
;    in WORKING WITH NEXUS"
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_creat_output_widgets, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;check "last data set created in working with nexus"
  structure_data_working_with_nexus = (*global).structure_data_working_with_nexus
  data = (*(*structure_data_working_with_nexus).data)
  if (data eq !null) then begin
    status_nexus = 0
    reverse_set_button = 1
  endif else begin
    status_nexus = 1
    reverse_set_button = 0
  endelse
  (*global).create_output_status_nexus = status_nexus
  activate_button, event=event, status=status_nexus, $
    uname='output_working_with_nexus_plot'
  setButton, event=event, $
    uname='output_working_with_nexus_plot', $
    reverse_flag=reverse_set_button
    
  ;check "last data set created in working with rtof"
  structure_data_working_with_rtof = (*global).structure_data_working_with_rtof
  data = (*(*structure_data_working_with_rtof).data)
  if (data eq !null) then begin
    status_rtof = 0
    reverse_set_button = 1
  endif else begin
    status_rtof = 1
    reverse_set_button = 0
  endelse
  (*global).create_output_status_rtof = status_rtof
  activate_button, event=event, status=status_rtof, $
    uname='output_working_with_rtof_plot'
  setButton, event=event, $
    uname='output_working_with_rtof_plot', $
    reverse_flag=reverse_set_button
    
  check_create_output_file_button, event
end

;+
; :Description:
;    This procedure checks the status of the various widgets inside the
;    tab and enabled or not the CREATE FILE button
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_create_output_file_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  button_status = 1b
  
  ;nexus output
  status_nexus = isButtonSelected(event=event, $
    uname='output_working_with_nexus_plot')
    
  ;rtof ouput
  status_rtof = isButtonSelected(event=event, $
    uname='output_working_with_rtof_plot')
    
  if (status_rtof+status_nexus eq 0) then button_status=0b
  
  activate_button, event=event, $
    status=button_status, $
    uname='create_output_button'
    
end