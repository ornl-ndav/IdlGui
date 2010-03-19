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

PRO RefReduction_NXsummary, Event, $
                            FileName, $
                            TextFieldUname, $
                            POLA_STATE=pola_state
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing_message
OK         = (*global).ok
FAILED     = (*global).failed

;AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
return  ;we are not displaying the nxsummary any more

my_package = (*(*global).my_package)

IF (my_package[3].found EQ 0) THEN BEGIN ;nxsummary is missing
   LogText = '--> NXsummary can not be found, no information displayed!'
   putLogBookMessage,Event,LogText,Append=1
   text = 'NO INFORMATION !'
   putTextFieldArray, Event, TextFieldUname, text, 1,0
ENDIF ELSE BEGIN
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        cmd = 'head -n 22 ' + (*global).MacNXsummary
    ENDIF ELSE BEGIN
        cmd = 'nxsummary ' + FileName + ' --verbose '
    ENDELSE
    logText = '--> cmd : ' + cmd + ' ... ' + PROCESSING
    putLogBookMessage,Event,LogText,APPEND=1
    
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
    
;run nxsummary command
    SPAWN, cmd, listening, err_listening
    
    IF (err_listening[0] EQ '') THEN BEGIN
        listeningSize = (size(listening))(1)
        if (listeningSize GE 1) then begin
            putTextFieldArray, Event, $
              TextFieldUname, $
              listening, $
              listeningSize, $
              0
        ENDIF
        AppendReplaceLogBookMessage, Event, OK, PROCESSING
    ENDIF ELSE BEGIN
        AppendReplaceLogBookMessage, Event, FAILED, PROCESSING
    ENDELSE
ENDELSE                         ;end of debugging version
END

;------------------------------------------------------------------------------
PRO RefReduction_NXsummaryBatch, Event, FileName, TextFieldUname
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF (!VERSION.os EQ 'darwin') THEN BEGIN
    cmd = 'head -n 22 ' + (*global).MacNXsummary
ENDIF ELSE BEGIN
    cmd = 'nxsummary ' + FileName + ' --verbose '
ENDELSE

;run nxsummary command
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
ENDIF ELSE BEGIN
ENDELSE
END
