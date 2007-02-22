;
;                     SNS IDL GUI tools
;           A part of the SNS Analysis Software Suite.
;
;                  Spallation Neutron Source
;          Oak Ridge National Laboratory, Oak Ridge TN.
;
;
;                             NOTICE
;
; For this software and its associated documentation, permission is granted
; to reproduce, prepare derivative works, and distribute copies to the public
; for any purpose and without fee.
;
; This material was prepared as an account of work sponsored by an agency of
; the United States Government.  Neither the United States Government nor the
; United States Department of Energy, nor any of their employees, makes any
; warranty, express or implied, or assumes any legal liability or
; responsibility for the accuracy, completeness, or usefulness of any
; information, apparatus, product, or process disclosed, or represents that
; its use would not infringe privately owned rights.
;
;

;;
; $Id$
;
; \file /gui/utilities/system_utilities.pro


;;
; \defgroup get_ucams
; \{
;;

;;
; \brief This function outputs the ucams of the user by
; just parsing the home directory path
;
; \return ucams 
; ucams of the active account
function get_ucams

cd , "~/"
cmd_pwd = "pwd"
spawn, cmd_pwd, listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]

return, ucams

end
; \}
;;     //end of get_ucams group





;;
; \defgroup get_file_name_only
; \{
;;

;;
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
; \}
;;     //end of file_name_only group







;;
; \defgroup modified_string
; \{
;;

;;
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
; \}
;;     //end of modified_string






;;
; \defgroup output_into_text_box
; \{
;;

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

end
; \}
;;     //end of output_into_text_box






;;
; \defgroup output_error_into_text_box
; \{
;;

;;
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
endif

end
; \}
;;     //end of output_error






;;
; \defgroup check_access
; \{
;;

;;
; \brief This function check if the ucams
; given in the command line has access to 
; the instrument tool is requesting
;
; \param event (INPUT) event structure
; \param instrument (INPUT) name of the instrument
; \param ucams (INPUT) ucams of the user
function check_access, Event, instrument, ucams

list_of_instrument = ['REF_L', 'REF_M', 'BSS']

;0:j35:jean$
;1:pf9:pete
;2:2zr:michael
;3:mid:steve
;4:1qg:rick
;5:ha9:haile
;6:vyi:frank
;7:vuk:john 
;8:x4t:xiadong
;9:ele:eugene

list_of_ucams = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
ucams_index=-1
for i =0, 9 do begin
   if (ucams EQ list_of_ucams[i]) then begin
     ucams_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE  ucams_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: ucams_index=-1	;unauthorized
	5: ucams_index=-1	;unauthorized
	6: ucams_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: ucams_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE ucams_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
        6: 
	7: ucams_index=-1
        8: ucams_index=-1
        9: ucams_index=-1
    ENDCASE
    2: case ucams_index of
        -1:
        0:
        1:
        2:
        3:
        9:
    endcase
        ENDCASE	 
	
RETURN, ucams_index
 
end
; \}
;;     //end of check_access





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
; \}
;;     //end of remove_star_from_string






;;
; \defgroup produce_output_file_name
; \{
;;

;;
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
; \}
;;     //end of produce_output_file_name









; \defgroup output_into_log_book_file
; \{
;;

;;
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
; \}
;;     //end of output_into_log_book_file








; \defgroup create_tmp_folder
; \{
;;

;;
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
; \}
;;     //end of create_tmp_folder











