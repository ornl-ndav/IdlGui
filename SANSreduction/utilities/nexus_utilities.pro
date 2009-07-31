;
;                        SNS IDL GUI tools
;             A part of the SNS Analysis Software Suite.
;
;                    Spallation Neutron Source
;            Oak Ridge National Laboratory, Oak Ridge TN.
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

;when we want only the archived one
FUNCTION find_full_nexus_name, Event, $
                               run_number, $
                               isNexusExist, $
                               proposal_index,$
                               proposal,$
                               FACILITY=facility

IF (facility EQ 'LENS') THEN BEGIN
instrument = 'SANS'
ENDIF ELSE BEGIN
instrument = 'EQSANS'
ENDELSE

;cmd = "findnexus --archive -i" + instrument 
cmd  = 'findnexus --facility=' + facility + ' '
;cmd  = '~/SVN/ASGIntegration/trunk/python/findnexus '
cmd += '--archive -i ' + instrument
IF (proposal_index NE 0) THEN BEGIN
    cmd += ' --proposal=' + proposal
ENDIF
cmd += ' ' + strcompress(run_number,/remove_all)
cmd_txt = '-> cmd: ' + cmd
IDLsendToGeek_addLogBookText, Event, cmd_txt
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")
    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
    return, full_nexus_name
endif else begin
    isNeXusExist = 1
    return, full_nexus_name[0]
endelse

end




FUNCTION find_list_nexus_name, Event, run_number, instrument, isNexusExist

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument 
cmd += " " + strcompress(run_number,/remove_all)
cmd += " --listall"

spawn, 'hostname',listening
CASE (listening) OF
    'lrac': 
    'mrac': 
    else: BEGIN
        if ((*global).instrument EQ (*global).REF_L) then begin
            cmd = 'srun -p lracq ' + cmd
        endif else begin
            cmd = 'srun -p mracq ' + cmd
        endelse
    END
ENDCASE

spawn, cmd, full_nexus_name, err_listening

;get size of result
sz = (size(full_nexus_name))(1)

;check if nexus exists
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")

    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
endif else begin
    isNeXusExist = 1
endelse

return, full_nexus_name
end

