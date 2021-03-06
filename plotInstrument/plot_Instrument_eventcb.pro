PRO BrowseRoiFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Ext    = (*global).BrowseROIExt
Filter = (*global).BrowseROIFilter
Path   = (*global).BrowseROIPath

RoiFileName = DIALOG_PICKFILE(GET_PATH          = newPath,$
                              PATH              = Path,$
                              FILTER            = Filter,$
                              DEFAULT_EXTENSION = Ext,$
                              TITLE             = 'Select a ROI File ...',$
                              /MUST_EXIST)
IF (RoiFileName NE '') THEN BEGIN
    (*global).BrowseDefaultPath = newPath
    putRoiFileName, Event, RoiFileName
    message = 'Browsed for ROI file name: ' + RoiFileName
    IDLsendToGeek_AddLogBookText, Event, message
ENDIF ELSE BEGIN
    putRoiFileName, Event, ''
ENDELSE
END

;------------------------------------------------------------------------------
PRO BrowseNexusFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Ext    = (*global).BrowseNexusDefaultExt
Filter = (*global).BrowseFilter
Path   = (*global).BrowseDefaultPath

NexusFileName = DIALOG_PICKFILE(GET_PATH          = newPath,$
                                PATH              = Path,$
                                FILTER            = Filter,$
                                DEFAULT_EXTENSION = Ext,$
                                TITLE             = 'Select a Nexus File ...',$
                                /MUST_EXIST)
IF (NexusFileName NE '') THEN BEGIN
    (*global).BrowseDefaultPath = newPath
    putNexusFileName, Event, NexusFileName
    message = 'Browsed for NeXus file name: ' + NexusFileName
    IDLsendToGeek_putLogBookText, Event, message
ENDIF ELSE BEGIN
    putNexusFileName, Event, ''
ENDELSE
END

;------------------------------------------------------------------------------
PRO ListOfInstrument, Event
index = getDropListSelectedIndex(Event, 'list_of_instrument')
IF (index EQ 0) THEN BEGIN
    activateStatus = 0
ENDIF ELSE BEGIN
    activateStatus = 1
ENDELSE
MapBase, Event, 'nexus_run_number_base', activateStatus
END

;------------------------------------------------------------------------------
PRO PreviewRoiFile, Event 
;get RoiFileName
RoiFileName = getRoiFileName(Event) 
FileName    = RoiFileName[0]
title       = FileName
XDISPLAYFILE, FileName, TITLE = title
END

;------------------------------------------------------------------------------
PRO DisplayBankSelected, Event 
value = getDropListSelectedValue(Event, 'bank_droplist')
putTextFieldValue, Event, 'bank_text', value
END

;******************************************************************************

PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END

PRO plot_roi_eventcb, event
END

