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
BankNbr       = getDroplistSelectedIndex(Event,'bank_droplist')

NexusDataInstance = obj_new('IDLgetNexusMetadata', $
                            NexusFileName, $
                            BankData = BankNbr+1)

BankData = NexusDataInstance->getData()
Data     = (*BankData)
sz_array = size(Data)
Ntof     = (sz_array)(1)
Y        = (sz_array)(2)
X        = (sz_array)(3)

;Informs user that it's done
message    = 'Plotting Data ... DONE'
putStatusMessage, Event, message

;DisplayMainPlot
instancePlot = OBJ_NEW('IDLplotData', $
                       XSIZE=X, $
                       YSIZE=Y, $
                       DATA=data)


;turn off hourglass
widget_control,hourglass=0

END
