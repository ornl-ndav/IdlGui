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
self.instrument = instrument

RETURN,1

END
                          

;***** Class Destructor *****
PRO IDLnexusUtilities::cleanup
ptr_free, self.full_nexus_path
END


;***** Get Instrument *****
FUNCTION IDLnexusUtilities::getInstrument
RETURN, self.instrument
END

;***** Get RunNumber *****
FUNCTION IDLnexusUtilities::getRunNumber
RETURN, self.run_number
END







;***** Methods Use By the Class *****
FUNCTION IDLnexusUtilities::hostname
spawn, 'hostname',listening
CASE (listening) OF
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
          run_number        : 0L,$
          full_nexus_path   : ptr_new(),$
          proposal_number   : '',$
          experiment_number : 0L,$
          instrument        : ''}
END

          
