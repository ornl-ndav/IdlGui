PRO BSSreduction_RunCommandLine, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing

;get command line to generate
cmd = getTextFieldValue(Event,'command_line_generator_text')

;display command line in log-book
cmd_text = 'Running Command Line:'
AppendLogBookMessage, Event, cmd_text
cmd_text = ' -> ' + cmd
AppendLogBookMessage, Event, cmd_text
cmd_text = ' ... ' + PROCESSING
AppendLogBookMessage, Event, cmd_text

status_text = 'Data Reduction ... ' + PROCESSING
putMessageBoxInfo, Event, status_text

;add called to SLURM
cmd = 'srun -p bss ' + cmd

;spawn, cmd, listening, err_listening
err_listening = '' ;remove_me

IF (err_listening[0] NE '') THEN BEGIN

    MessageToAdd = (*global).FAILED
    MessageToRemove = PROCESSING
    putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove
    
    status_text = 'Data Reduction ... ERROR! (-> Check Log Book)'
    putMessageBoxInfo, Event, status_text

ENDIF ELSE BEGIN

    MessageToAdd = 'DONE'
    MessageToRemove = PROCESSING
    putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove

    status_text = 'Data Reduction ... DONE'
    putMessageBoxInfo, Event, status_text

;update list of intermediate plots in OUTPUT tab droplist
    BSSreduction_IntermediatePlotsUpdateDroplist, Event

ENDELSE


END
