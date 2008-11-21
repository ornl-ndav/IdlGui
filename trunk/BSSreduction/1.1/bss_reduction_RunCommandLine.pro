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
putDRstatusInfo, Event, status_text

;;add called to SLURM
cmd = 'srun -p bss ' + cmd
;;indicate initialization with hourglass icon
widget_control,/hourglass

spawn, cmd, listening, err_listening
;spawn, cmd, unit=unit
;(*global).unit = unit
;print, 'unit is: ' + strcompress(unit)
;err_listening = '' ;remove_me

IF (err_listening[0] NE '') THEN BEGIN
    
    MessageToAdd = (*global).FAILED
    MessageToRemove = PROCESSING
    putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove

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

;turn off hourglass
widget_control,hourglass=0

END
