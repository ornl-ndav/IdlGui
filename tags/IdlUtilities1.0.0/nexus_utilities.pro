
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
;if (local EQ 1) then begin
if (local) then begin
    cmd += " --prefix " + (*global).working_path
endif
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening

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




; \
; \defgroup find_full_prenexus_name
; \{
;;

;;
; \brief This function looks for a prenexus file
; using 'findnexus'
;
; \param event (INPUT) event structure
; \param run_number (INPUT) run number
; \param instrument (INPUT) instrument name
;
; \return full_nexus_name
; full nexus file name (with full path)
FUNCTION find_full_prenexus_name, Event, local, run_number, instrument

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus --prenexus -i " + instrument 
;if (local EQ 1) then begin
if (local) then begin
    cmd += " --prefix " + (*global).working_path
endif
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_prenexus_name, err_listening

;check if nexus exists
result = strmatch(full_prenexus_name,"ERROR*")

return, full_prenexus_name

end
; \}
;;     //end of find_full_prenexus_name





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








; \defgroup find_nexus_path
; \{
;;

;;
; \brief output array that tells if
; nexus has been found and if yes,
; gives its full path
;
; \param Nexus_runs_array (INPUT) array of NeXus runs
; \param length (INPUT) number of NeXus runs
; \param instrument (INPUT) name of the instrument
;
; \return [j,NeXus_path_array]
; j is the number of NeXus run found
; [NeXus_path_array] is the array of the full NeXus name
Function find_nexus_path, NeXus_runs_array, length, instrument

NeXus_path_array = strarr(length)
j=0

for i=0,length-1 do begin
     cmd = "findnexus -i" + instrument + " " + $
       strcompress(NeXus_runs_array[i],/remove_all)
     spawn, cmd, full_nexus_name
     
;check if nexus exist
     result = strmatch(full_nexus_name,"*ERROR*")
     
     if (result EQ 0) then begin
         NeXus_path_array[j] = full_nexus_name
         ++j
     endif
     
 endfor
 
 return, [j, NeXus_path_array] 
end
; \}
;;  //end of find_nexus_path






; \defgroup is_nexus_local
; \{
;;

;;
; \brief check for the presence of a *
; in the string to know if we are looking
; for a local file or not
;
; \param run_number (INPUT) run number
;
; \return result
; 1 for a local, 0 for an archive nexus file
function is_nexus_local, run_number_string

result = strmatch(run_number_string,'*\**')
return, result

end
; \
;;  //end of is_nexus_local





; \defgroup produce_array_of_tmp_event_file_name
; \{
;;

;;
; \brief produce array of neutron_event.dat file into
; new provided directory
;
; \param event (INPUT) event structure
; \param instrument (INPUT) name of instrument
; \param list_of_runs_check (INPUT) array of run number
; \param nbr_runs (INPUT) the number of runs to check
; \param full_tmp_nxdir_folder_path (INPUT) output folder
;
; \return array_of_full_tmp_event_file_name
; array of full prenexus neutron.event file name
function produce_array_of_tmp_event_file_name, event, $
                                               instrument, $
                                               list_of_runs_check, $
                                               nbr_runs, $
                                               full_tmp_nxdir_folder_path
          
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
  
for i=0,(nbr_runs-1) do begin

    full_tmp_event_file_name = full_tmp_nxdir_folder_path + '/' +instrument
    full_tmp_event_file_name += '_' + list_of_runs_check[i]
    full_tmp_event_file_name += '_neutron_event.dat'
    
    if (i EQ 0) then begin
        array_of_full_tmp_event_file_name = full_tmp_event_file_name
    endif else begin
        array_of_full_tmp_event_file_name = [array_of_full_tmp_event_file_name,full_tmp_event_file_name]
    endelse
endfor                                                              

return, array_of_full_tmp_event_file_name
end
; \
;;  //end of produce_array_of_tmp_event_file_name