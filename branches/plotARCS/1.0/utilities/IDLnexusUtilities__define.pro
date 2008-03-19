                          
;***** Class Destructor *****
PRO IDLnexusUtilities::cleanup
ptr_free, self.full_list_nexus
END

;***** Get Instrument *****
FUNCTION IDLnexusUtilities::getInstrument
RETURN, self.instrument
END

;***** Get RunNumber *****
FUNCTION IDLnexusUtilities::getRunNumber
RETURN, self.run_number
END

;***** Get Archived NeXus path *****
FUNCTION IDLnexusUtilities::getArchivedNeXusPath
cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number 
cmd += ' --archive'
IF (self.proposal NE '') THEN BEGIN
    cmd += ' --proposal=' + self.proposal
ENDIF
spawn, cmd, listening
self.archived_nexus = listening[0]
IF (STRMATCH(self.archived_nexus,'ERROR*')) THEN self.nexus_found = 0
RETURN, listening[0]
END

;***** Get Full List of NeXus path *****
FUNCTION IDLnexusUtilities::getFullListNeXusPath
cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number
cmd += ' --listall'
spawn, cmd, listening
self.full_list_nexus = ptr_new(listening)
RETURN, listening
END

;***** Get bank data *****
FUNCTION IDLnexusUtilties::getBankData, $
                         nexus_path = nexus_path, $
                         bank
if (n_elements(nexus_path) EQ 0) then begin
    nexus_file_name = self.archived_nexus
endif else begin
    nexus_file_name = nexus_path
endelse
fileID  = h5f_open(nexus_file_name)
bank_path = '/entry/' + bank + '/data'
fieldID = h5d_open(fileID,bank_path)
RETURN, h5d_read(fieldID)
END

;***** getNXsummary *****
FUNCTION IDLnexusUtilities::getNXsummary
RETURN,''
END

;***** getHDF5field *****
FUNCTION IDLnexusUtilities::getHDF5field, $
                          nexus_path = nexus_path, $
                          field
if (n_elements(nexus_path) EQ 0) then begin
    nexus_file_name = self.archived_nexus
endif else begin
    nexus_file_name = nexus_path
endelse
fileID  = h5f_open(nexus_file_name)
fieldID = h5d_open(fileID,field)
RETURN, h5d_read(fieldID)
END

;***** Methods Used By the Class *****
FUNCTION IDLnexusUtilities::hostname
spawn, 'hostname',listening
CASE (listening) OF
    'arcs1'      : return, 'ARCS'
    'arcs2'      : return, 'ARCS'
    'bac.sns.gov': return, 'BSS'
    'bac2'       : return, 'BSS'
    'heater'     : return, ''
    'lrac'       : return, 'REF_L'
    'mrac'       : return, 'REF_M'
    ELSE         : return, ''
ENDCASE
END

;* Does NeXus exist ************************************************************
FUNCTION IDLnexusUtilities::isNexusExist
RETURN, self.nexus_found
END

;***** Class Constructor *******************************************************
FUNCTION IDLnexusUtilities::init, $
                          run_number,$
                          proposal = proposal,$
                          instrument = instrument

;store run number
IF (N_ELEMENTS(run_number) EQ 0) THEN RETURN, 0
self.run_number = STRCOMPRESS(run_number,/REMOVE_ALL)

;get instrument
IF (N_ELEMENTS(instrument) EQ 0) THEN BEGIN
    instrument = self->hostname()
    IF (instrument EQ '') THEN RETURN, 0
ENDIF
self.instrument = STRCOMPRESS(instrument,/REMOVE_ALL)

;proposal number
IF (N_ELEMENTS(proposal) NE 0) THEN BEGIN
    self.proposal = proposal
ENDIF

self.nexus_found = 1

RETURN,1
END

;***** Class Define Method *****
PRO IDLnexusUtilities__define

define = {IDLnexusUtilities,$
          proposal          : '',$
          run_number        : '',$
          full_list_nexus   : ptr_new(),$
          archived_nexus    : '',$
          proposal_number   : '',$
          experiment_number : 0L,$
          instrument        : '',$
          nexus_found       : 0}
END

          
