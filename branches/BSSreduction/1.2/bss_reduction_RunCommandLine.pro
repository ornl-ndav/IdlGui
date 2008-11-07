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

PRO BSSreduction_RunCommandLine, Event

activate_button, event, 'submit_button', 0

;get global structure
widget_control,Event.top,get_uvalue=global

;;indicate initialization with hourglass icon
widget_control,/hourglass

PROCESSING = (*global).processing

;first check that the output folder exist if not, create it
output_path = (*global).default_output_path
ok_to_CONTINUE = 1
IF (FILE_TEST(output_path,/DIRECTORY) EQ 0) THEN BEGIN ;folder does not exist
    cmd_text = 'Check if output path (' + output_path + ') exists ... NO'
    AppendLogBookMessage, Event, cmd_text
    cmd_text = '-> Create output path ... ' + PROCESSING
    AppendLogBookMessage, Event, cmd_text
    spawn, 'mkdir ' + output_path, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        status_text = (*global).DRstatusFAILED
        putDRstatusInfo, Event, status_text
        ok_to_CONTINUE = 0
    ENDIF ELSE BEGIN
        cmd_text = 'Check if output path (' + output_path + ') exists ... YES'
        AppendLogBookMessage, Event, cmd_text
    ENDELSE
ENDIF

IF (ok_to_CONTINUE) THEN BEGIN
    
;check if use iterative background subtraction is active or not
    ibs_value = $
      getCWBgroupValue(Event, $
                       'use_iterative_background_subtraction_cw_bgroup')
    
;add called to SLURM
;check instrument here
    spawn, 'hostname',listening
    CASE (listening) OF
        'bac.sns.gov': srun = 'bac1q'
        'bac2':        srun = 'bac2q'
        ELSE:          srun = 'bss'
    ENDCASE
    
;get command line to generate
    cmd = getTextFieldValue(Event,'command_line_generator_text')
    
    IF (ibs_value EQ 1) THEN BEGIN ;if Iterative Background Subtraction is OFF
        
        cmd = 'srun -p ' + srun + ' ' + cmd
        
;display command line in log-book
        cmd_text = 'Running Command Line:'
        AppendLogBookMessage, Event, cmd_text
        cmd_text = ' -> ' + cmd
        AppendLogBookMessage, Event, cmd_text
        cmd_text = ' ... ' + PROCESSING
        AppendLogBookMessage, Event, cmd_text
        
        status_text = 'Data Reduction ... ' + PROCESSING
        putDRstatusInfo, Event, status_text
                
        spawn, cmd, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            
            MessageToAdd    = (*global).FAILED
            MessageToRemove = PROCESSING
            putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove
            
;display listening
            AppendLogBookMessage, Event, listening
            
;display err_listening
            AppendLogBookMessage, Event, err_listening
            
            status_text = (*global).DRstatusFAILED
            putDRstatusInfo, Event, status_text
            
        ENDIF ELSE BEGIN
            
            MessageToAdd = 'DONE'
            MessageToRemove = PROCESSING
            putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove
            
            status_text = (*global).DRstatusOK
            putDRstatusInfo, Event, status_text
            
            IF (isButtonSelected(Event,'verbose_button')) THEN BEGIN
;display listening
                AppendLogBookMessage, Event, listening
            ENDIF
            
            LogBookText = '>>>>>>>>>> Data Reduction Information <<<<<<<<<<<'
            AppendLogBookMessage, Event, LogBookText
            
;display xml config file
            xmlConfigFile = getXmlConfigFileName(Event)
            LogBookText = '  XML data reduction config file: ' + $
              strcompress(xmlConfigFile,/remove_all)
            AppendLogBookMessage, Event, LogBookText
            
            BSSreduction_DisplayXmlConfigFile, Event, xmlConfigFile
            
;update list of intermediate plots in OUTPUT tab droplist
            BSSreduction_IntermediatePlotsUpdateDroplist, Event
            
        ENDELSE
        
    ENDIF ELSE BEGIN ;Iterative background subtraction mode is ON
        
        nbr_jobs = N_ELEMENTS(cmd)
        cmd_text = 'BSSreduction is about to run ' + $
          STRCOMPRESS(nbr_jobs,/REMOVE_ALL) + ' jobs in the background'
        AppendLogBookMessage, Event, cmd_text
        index = 0

;add batch statement to all command lines
        cmd = 'srun --batch -o none -Q -p ' + srun + ' ' + cmd

        WHILE (index LT nbr_jobs) DO BEGIN
            cmd_text = '-> ' + cmd[index]
            spawn, cmd, listening, err_listening
            AppendLogBookMessage, Event, cmd_text
            index++
        ENDWHILE



    ENDELSE
    
ENDIF ELSE BEGIN 

    status_text = (*global).DRstatusFAILED
    putDRstatusInfo, Event, status_text
        
ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

activate_button, event, 'submit_button', 1

END
