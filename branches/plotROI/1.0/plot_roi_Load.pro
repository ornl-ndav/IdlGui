;This function looks for the Nexus Run and populate the text field
;with the full path to the nexus file
PRO LoadRunNumber, Event

;get RunNumber
RunNumber = getRunNumber(Event)
;get Instrument
Instrument = getInstrument(Event)
print, RunNumber
print, Instrument

END
