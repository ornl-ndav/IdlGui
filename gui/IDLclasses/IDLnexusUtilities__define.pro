;***** Class Constructor *****
FUNCTION IDLnexusUtilities::init, $
                          run_number,$
                          instrument = instrument

;store run number
IF (n_elements(run_number) EQ 0) THEN RETURN, 0
self.run_number = strcompress(run_number,/remove_all)

;get instrument
IF (n_elements(instrument) EQ 0) THEN BEGIN
    instrument = self->hostname()
    IF (instrument EQ '') THEN RETURN, 0
ENDIF
self.instrument = strcompress(instrument,/remove_all)

RETURN,1

END
                          

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
if (self.archived_nexus NE '') then begin
    cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number 
    cmd += ' --archive'
    spawn, cmd, listening
    RETURN, listening[0]
endif else begin
    print, 'here'
    RETURN, self.archived_nexus
endelse
END

;***** Get Full List of NeXus path *****
FUNCTION IDLnexusUtilities::getFullListNeXusPath
cmd = 'findnexus -i ' + self.instrument + ' ' + self.run_number
cmd += ' --listall'
spawn, cmd, listening
RETURN, listening
END

;***** Methods Use By the Class *****
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


;***** Class Define Method *****
PRO IDLnexusUtilities__define

define = {IDLnexusUtilities,$
          run_number        : '',$
          full_list_nexus   : ptr_new(),$
          archived_nexus    : '',$
          proposal_number   : '',$
          experiment_number : 0L,$
          instrument        : ''}
END

          
