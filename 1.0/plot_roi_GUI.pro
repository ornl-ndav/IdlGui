PRO MapBase, Event, uname, MapStatus
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, MAP=MapStatus
END

;-------------------------------------------------------------------------------
PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END

;*******************************************************************************
;*******************************************************************************
PRO ValidatePlotButton, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;check first that the file exist
NexusFileName = getFullNexusFileName(Event)
IF (FILE_TEST(NexusFileName) AND $
    (*global).ValidNexus EQ 1) THEN BEGIN
                                ;is Full Nexus Name not empty
    IF (isFullNexusNameEmpty(Event) EQ 1) THEN BEGIN
        validateStatus = 0
    ENDIF ELSE BEGIN
        validateStatus = 1
    ENDELSE
ENDIF ELSE BEGIN
    validateStatus = 0
ENDELSE
ActivateWidget, Event, 'plot_button', validateStatus
ActivateWidget, Event, 'bank_droplist', validateStatus
END

;-------------------------------------------------------------------------------
PRO ValidatePreviewButton, Event 
;get Roi file name
RoiFileName = getRoiFileName(Event)
IF (FILE_TEST(RoiFileName)) THEN BEGIN
    activatePreviewButton = 1
ENDIF ELSE BEGIN
    activatePreviewButton = 0
ENDELSE
ActivateWidget, Event, 'preview_roi_button', activatePreviewButton
END

;-------------------------------------------------------------------------------
PRO setBankDroplistValue, Event, value
id = widget_info(Event.top,find_by_uname='bank_droplist')
widget_control, id, set_value=value
END

;-------------------------------------------------------------------------------
PRO PopulateBankDroplist, Event, NbrBank
NbrBank    = LONG(NbrBank)
prefix     = 'Bank'
BankArray  = strarr(NbrBank)
FOR i=0,(NbrBank-1) DO BEGIN
    BankArray[i] = prefix + STRCOMPRESS(i+1,/REMOVE_ALL)
ENDFOR
setBankDroplistValue, Event, BankArray
END

;^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^
PRO PopulateNumberOfBanks, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
FullNexusName = getFullNexusFileName(Event)
IF (FullNexusName NE '') THEN BEGIN
    NexusInstance = obj_new('IDLgetNexusMetadata', FullNexusName, NbrBank=1)
    IF (OBJ_VALID(NexusInstance)) THEN BEGIN
        NbrBank = NexusInstance->getNbrBank()
;activate NbrBank
        (*global).ValidNexus = 1
    ENDIF ELSE BEGIN
        NbrBank = 1
;desactivate NbrBank
        (*global).ValidNexus = 0
    ENDELSE
    PopulateBankDroplist, Event, NbrBank
ENDIF ELSE BEGIN
;desactivate NbrBank
    (*global).ValidNexus = 0
ENDELSE
END

;-------------------------------------------------------------------------------
PRO ClearTextField, Event, uname
putTextFieldValue, Event, uname, ''
END

;-------------------------------------------------------------------------------
