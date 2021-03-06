PRO ts_rebin_OutputPath, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).output_path
output_path = dialog_pickfile(path=path, /directory, title="Select the output file")

if (output_path EQ '') then begin
    output_path = (*global).output_path
endif

(*global).output_path = output_path

put_text_field_value, Event, 'output_path', output_path

END





PRO ts_rebin_StagingArea, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).staging_area
staging_area = dialog_pickfile(path=path, /directory, title="Select the staging area")

if (staging_area EQ '') then begin
    staging_area = (*global).staging_area
endif

(*global).staging_area = staging_area

put_text_field_value, Event, 'staging_area', staging_area

END




;This function checks if everything is there to validate the GO button
;GO can be validated only if:
; - 'runs' is not empty
; - 'instrument' is not empty
; - 'output_path' is not empty
; - 'bin_width' is not empty
PRO ts_rebin_ValidateGoButtonAndBuildCMD, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ValidateGo = 1

;get runs
runs_field = getTextFieldValue(Event, 'runs')
if (runs_field EQ '') then ValidateGo = 0

;get instrument
instrument_field = getTextFieldValue(Event, 'instrument')
if (instrument_field EQ '') then begin
    ValidateGo = 0
    instrument_field = '?'
endif

;get proposal
proposal_field = getTextFieldValue(Event, 'proposal_number')

;get bin_width
bin_width_field = getTextFieldValue(Event, 'bin_width')
if (bin_width_field EQ '') then begin
    ValidateGo = 0
    bin_width_field = '?'
endif

;get bin_type
bin_type = getBinType(Event)

;time_offset
time_offset_field = getTextFieldValue(Event, 'time_offset')

;max_time
max_time_field = getTextFieldValue(Event, 'max_time')

;output_path
output_path_field = getTextFieldValue(Event,'output_path')
if (output_path_field EQ '') then begin
    ValidateGo = 0
    output_path_field = '?'
endif

;staging_area
staging_area_field = getTextFieldValue(Event,'staging_area')
if (staging_area_field EQ '') then begin
    ValidateGo = 0
    staging_area_field = '?'
endif


;****Validate or not Go button****
id = widget_info(Event.top,find_by_uname='go')
widget_control, id, sensitive=ValidateGo


;****Build Command Line****
cmd = (*global).ts_rebin_batch
cmd += ' ' + strcompress(runs_field,/remove_all) ;runs
cmd += ' --inst=' + strcompress(instrument_field,/remove_all) ;instrument

if (proposal_field NE '') then begin
    cmd += ' --proposal=' + strcompress(proposal_field, /remove_all) ;proposal
endif

IF (time_offset_field NE '') THEN BEGIN
    cmd += ' --time-offset=' + STRCOMPRESS(time_offset_field,/REMOVE_ALL)
ENDIF

IF (max_time_field NE '') THEN BEGIN
    cmd += ' --max-time-bin=' + STRCOMPRESS(max_time_field,/REMOVE_ALL)
ENDIF

cmd += ' --time-width=' + strcompress(bin_width_field, /remove_all) ;bin_width
cmd += ' --hist-type=' + strcompress(bin_type,/remove_all) ;bin_type
cmd += ' --output-path=' + strcompress(output_path_field,/remove_all) ;output_path
cmd += ' --temp-dir=' + strcompress(staging_area_field,/remove_all) ;staging area

put_text_field_value, Event, 'log_book', cmd

END



;This procedure will run the command line
PRO ts_rebin_RunCMD, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).PROCESSING

;get the CMD
cmd = getTextFieldValue(Event, 'log_book')

add_text_field_value, Event, 'log_book', PROCESSING
;indicate initialization with hourglass icon
widget_control,/hourglass

;check hostname
spawn, 'hostname',listening
CASE (listening) OF
    'lrac': 
    'mrac': 
    'heater':
    'bac2':
    'bac.sns.gov':
    else: cmd = 'srun ' + cmd
ENDCASE

spawn, cmd, listening

;turn off hourglass
widget_control,hourglass=0

;remove PROCESSING word
InitialStrarr = getTextfieldValue(Event, 'log_book')
MessageToAdd  = 'DONE'
RemoveString  = PROCESSING
putTextAtEndOfLogBookLastLine, Event, InitialStrarr, MessageToAdd, RemoveString

;add Message
putTextFieldArray, Event, 'log_book', listening

END



PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END



PRO ts_rebin_eventcb
END


