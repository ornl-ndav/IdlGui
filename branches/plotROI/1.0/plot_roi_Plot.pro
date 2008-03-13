PRO PlotData, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Nexus File Name
NexusFileName = getFullNexusFileName(Event)
;get Bank#
BankNbr       = getDroplistSelectedIndex(Event,'bank_droplist')




END
