;*******************************************************************************
;***** UTILITIES ***************************************************************



;*******************************************************************************


PRO UpdateMainDataNexusFileName, Event, MainDataNexusFileName




END

;###############################################################################
;******  Class constructor *****************************************************
FUNCTION IDLupdateGui::init, structure

event = structure.Event

;work on MainDataNexusFileName
UpdateMainDataNexusFileName, Event, structure.MainDataNexusFileName

RETURN, 1
END

;******  Class Define **** *****************************************************

PRO IDLupdateGui__define
STRUCT = {IDLupdateGui,$
          var : ''}

END

;*******************************************************************************
;*******************************************************************************
