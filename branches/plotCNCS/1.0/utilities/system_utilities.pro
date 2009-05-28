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

; This function outputs the ucams of the user by
; just parsing the home directory path
function get_ucams

cd , "~/", CURRENT=path
cmd_pwd = "pwd"
spawn, cmd_pwd, listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]
cd, path
return, ucams

end


; \brief This function parses the full path
; of the file and output the file name only
;
; \param file (INPUT) the full path name of the file
;
; \return file_name_only
; Only the file name (without the path)
function get_file_name_only, file

part_to_remove="/"
file_name = strsplit(file,part_to_remove,/extract,/regex,count=length) 
file_name_only = file_name[length-1]

return, file_name_only

end

;this function will remove the last part and will
;give back the path
function get_path_to_file_name, file

spliter='/'
path_tmp = strsplit(file,spliter,/extract,/regex,count=length)
path ='/'
for i=0,(length-2) do begin
  path += path_tmp[i] + '/'
endfor
return, path
end

; \brief This function will replace in the first
; string defined, the string given in second argument
; by the string given as the third argument
;
; \param event (INPUT) event structure
; \param input_string (INPUT) the string where the
; changes will occur
; \param old_string(INPUT) the string to be removed
; \param new_string (INPUT) the new string to attach
;
; \return output_string
; the new output string
function modified_string, event, input_sring, old_string, new_string

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

string_matrix = strsplit(input_string, $
                         old_string,$
                         /extract,$
                         /regex)

output_string = string_matrix[0] + new_string

return, output_file_name

end

;;
; \brief This function output into the 
; text box window the information given as an
; argument
;
; \param event (INPUT) event structure
; \param uname_destination (INPUT) uname of text box
; \param text (INPUT) text to display
; \param do_not_append_it (INPUT/OPTIONAL) if present
; text box is reset before adding the new text
pro output_into_text_box, event, $
                          uname_destination, $
                          text, $
                          do_not_append_it

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if (text NE '') then begin
;display what is going on
    full_view_info = widget_info(event.top,find_by_uname=uname_destination)
    if (n_elements(do_not_append_it) EQ 0) then begin
        widget_control, full_view_info, set_value=text,/append
    endif else begin
        widget_control, full_view_info, set_value=text
    endelse
endif

if ((*global).ucams EQ 'ceh' && uname_destination EQ 'log_book_text') then begin
    full_logbook_filename = "~/local/DataReduction_logbook.txt"
    openu, 6,full_logbook_filename, /append
    printf, 6, text
    close,6
    free_lun,6
endif

end

; \brief This function output into the 
; text box window the information given as an
; argument
;
; \param event (INPUT) event structure
; \param uname_destination (INPUT) uname of text box
; \param err_listening (INPUT) text to display
pro output_error, event, uname_destination, err_listening

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
full_view_info = widget_info(event.top,find_by_uname=uname_destination)

if (err_listening NE '' OR err_listening NE ['']) then begin
    full_text = 'ERROR: ' + err_listening
    widget_control, full_view_info, set_value=full_text,/append

;      if ((*global).ucams EQ 'ceh') then begin
;          full_logbook_filename = "~/local/DataReduction_logbook.txt"
;          openu, 3,full_logbook_filename,/append
;          nbr_lines_array = size(err_listening)
;          nbr_lines = nbr_lines_array[1]
;          for i=0,(nbr_lines-1) do begin
;              printf,3, err_listening[i]
;          endfor
        
;  ;close it up...
;          close,3
;          free_lun,3
;      endif
    
endif

end

;;
; \defgroup remove_star
; \{
;;

;;
; \brief This function remove the star
; from the string
;
; \param value (INPUT) text to parse
;
; \return new_value
; string without the star
function remove_star_from_string, value

new_value = strsplit(value,'\*',/extract,/regex)

return, new_value
end

; \brief This function produces the output
; file name
;
; \param Event (INPUT) event structure
; \param run_number (INPUT) run number
; \param extension (INPUT) the text to append
;
; \return output_file_name
; resulting output file name
function produce_output_file_name, Event, run_number, extension

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_folder = (*global).tmp_folder

output_file_name = tmp_folder + (*global).instrument 
output_file_name += "_" + run_number + extension

return, output_file_name 
end

;
; \brief This function output the string
; into a predefined file (just for debugging)
;
; \param Event (INPUT) event structure
; \param string (INPUT) string to output
pro output_into_log_book_file, Event, string

full_logbook_filename = "~/local/MakeNeXus_logbook.txt"

openu, 1,full_logbook_filename,/append
printf, 1, string

; for i=0,(nbr_lines-1) do begin
;     printf,1, lines[i]
; endfor

;close it up...
close,1
free_lun,1

end

; \brief This function creates the temporary
; folder
;
; \param Event (INPUT) event structure
; \param tmp_folder (INPUT) temporary folder name
function create_tmp_folder, event, tmp_folder

cmd_mkdir = 'mkdir ' + tmp_folder
spawn, cmd_mkdir, listening, err_listening

return, [listening, err_listening]
end

; \brief This function replace in the string provided
; the first string by the second
; folder
;
; \param Event (INPUT) event structure
; \param full_prenexus_name (INPUT) initial string
; \param string_1 (INPUT) string to replace
; \param string_2 (INPUT) string to replace with
;
; \return full_neutron_event_file_name
; new string
function replace_string, full_prenexus_name, string_1, string_2

full_neutron_event_file_name = strsplit(full_prenexus_name,string_1,/extract,/regex)
full_neutron_event_file_name += string_2

return, full_neutron_event_file_name 
end

; \brief This function output the minimum
; run number from the list
;
; \param runs_and_full_path (INPUT) list of run numbers and their full path
;
; \return run_number_min
; the minimum run_number
function  get_min_run_number, runs_and_full_path

run_number_min = MIN(runs_and_full_path[*,0])

return, strcompress(run_number_min,/remove_all)
end
