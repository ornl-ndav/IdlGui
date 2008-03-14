;This function looks for the Nexus Run and populate the text field
;with the full path to the nexus file
PRO LoadRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset text_field of full nexus file name
putNexusFileName, Event, ''

;get RunNumber
RunNumber = getRunNumber(Event)
RunNumber = RunNumber[0]

;get Instrument
Instrument = getInstrument(Event)

;indicate initialization with hourglass icon
widget_control,/hourglass
;display processing message in status box
PROCESSING = (*global).processing
message    = 'Searching for Run Number ' + strcompress(RunNumber) 
message   += ' of ' + Instrument + ' ... ' + PROCESSING
putStatusMessage, Event, message

;find nexus full name
isNexusExist = 0 ;by default, NeXus does not exist
NexusInstance = obj_new('IDLnexus',INSTRUMENT=Instrument, RunNumber=RunNUmber)

;Inform user of result
IF (NexusInstance->isNexusExist() EQ 0) THEN BEGIN
    message = 'Archived NeXus File Does Not Exist !'
    nexus   = ''
ENDIF ELSE BEGIN
    message = 'Archived NeXus Has Been Localized !'
    nexus   = NexusInstance->getFullNexusName()
ENDELSE
putStatusMessage, Event, message
putNexusFileName, Event, nexus

;turn off hourglass
widget_control,hourglass=0
END

