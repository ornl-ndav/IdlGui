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







