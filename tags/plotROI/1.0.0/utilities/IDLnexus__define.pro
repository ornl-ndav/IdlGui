;*******************************************************************************
FUNCTION getFullNexusName, instrument , RunNumber, isNexusExist

cmd = "findnexus --archive -i" + instrument 
cmd += " " + strcompress(RunNumber,/REMOVE_ALL)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
IF (sz EQ 1) then begin
    result = STRMATCH(full_nexus_name,"ERROR*")
    IF (result GE 1) THEN BEGIN
        isNeXusExist = 0
    ENDIF ELSE BEGIN
        isNeXusExist = 1
    ENDELSE
    RETURN, full_nexus_name
ENDIF ELSE BEGIN
    isNeXusExist = 1
    RETURN, full_nexus_name[0]
ENDELSE
isNexusExist = 0
RETURN, 0
END

;*******************************************************************************
;Get full nexus name
FUNCTION IDLnexus::getFullNexusName
RETURN, self.FullNexusName
END

;*******************************************************************************
;Is nexus exist
FUNCTION IDLnexus::isNexusExist
RETURN, self.isNexusExist
END

;*******************************************************************************
FUNCTION IDLnexus::init, $
                 INSTRUMENT=instrument, $
                 RunNumber=RunNumber, $
                 ARCHIVED=archived
                 
IF (n_elements(ARCHIVED) EQ 0) THEN ARCHIVED = 1

self.FullNexusName = getFullNexusName(instrument, RunNumber, isNexusExist)
self.isNexusExist = isNexusExist
RETURN, 1
END

;*******************************************************************************
;******  Class Define **********************************************************
;*******************************************************************************
PRO IDLnexus__define
STRUCT = { IDLnexus,$
           FullNexusName : '',$
           isNexusExist  : 0}
END
;*******************************************************************************
;*******************************************************************************
