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
; \file /gui/utilities/nexus_utilities.pro

; \
; \defgroup find_full_nexus_name
; \{
;;

;;
; \brief This function looks for a nexus file
; using 'findnexus'
;
; \param event (INPUT) event structure
; \param run_number (INPUT) run number
; \param instrument (INPUT) instrument name
;
; \return full_nexus_name
; full nexus file name (with full path)
FUNCTION find_full_nexus_name, Event, local, run_number, instrument    

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument 
if (local EQ 1) then begin
    cmd += " --prefix " + (*global).working_path
endif
cmd += " " + strcompress(run_number,/remove_all)

spawn, cmd, full_nexus_name

;check if nexus exists
result = strmatch(full_nexus_name,"ERROR*")

if (result GE 1) then begin
    find_nexus = 0
endif else begin
    find_nexus = 1
endelse

(*global).find_nexus = find_nexus

return, full_nexus_name

end
; \}
;;     //end of find_full_nexus_name





; \defgroup get_path_to_prenexus
; \{
;;

;;
; \brief output cvinfo.xml full path
;
; \param run_number (INPUT) run number
;
; \return path
; full path to cvinfo prenexus file
function get_path_to_prenexus, run_number

cmd = "findnexus -iBSS " + $
  strcompress(run_number,/remove_all) + " --prenexus"                        
spawn, cmd, path

return, path

end
; \}
;;     //end of get_path_to_prenexus




