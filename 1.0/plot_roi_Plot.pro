PRO PlotData, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate initialization with hourglass icon
widget_control,/hourglass

;Display status message
PROCESSING = (*global).processing
message    = 'Plotting Data ... ' + PROCESSING
putStatusMessage, Event, message

;get Nexus File Name
NexusFileName = getFullNexusFileName(Event)
;get Bank#
BankNbr = getTextFieldValue(Event,'bank_text')

NexusDataInstance = obj_new('IDLgetNexusMetadata', $
                            NexusFileName, $
                            BankData = BankNbr)

IF (OBJ_VALID(NexusDataInstance)) THEN BEGIN
    BankData = NexusDataInstance->getData()
    Data     = (*BankData)
    sz_array = size(Data)
    Ntof     = (sz_array)(1)
    Y        = (sz_array)(2)
    X        = (sz_array)(3)
    
;get ROI file Name
    ROIfileName = getRoiFileName(Event)
    
;DisplayMainPlot and ROI
    instancePlot = OBJ_NEW('IDLplotData', $
                           XSIZE       = X, $
                           YSIZE       = Y, $
                           DATA        = data,$
                           RoiFileName = ROIfileName)
    
;Informs user that it's done
    message    = 'Plotting Data ... DONE'
    putStatusMessage, Event, message
    
ENDIF ELSE BEGIN

;Informs user that it's done
    message    = 'Plotting Data ... ERROR !'
    putStatusMessage, Event, message
    
ENDELSE

;turn off hourglass
widget_control,hourglass=0

END
