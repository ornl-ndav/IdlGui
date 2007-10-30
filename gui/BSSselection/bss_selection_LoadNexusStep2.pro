PRO BSSselection_CreateRoiFileName, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path = (*global).roi_path
first_part = '/BASIS_'
get_iso8601, second_part
ext_part = (*global).roi_ext

name = path + first_part + second_part + ext_part

;put new name into field
putRoiFileName, Event, name
print, name

END








PRO BSSselection_LoadNexus_step2, Event, NexusFullName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;display full name of nexus in his label
PutNexusNameInLabel, Event, NexusFullName

message = '  -> NeXus file location: ' + NexusFullName
AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
AppendLogBookMessage, Event, message
retrieveBanksData, Event, strcompress(NexusFullName,/remove_all)
putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot bank1 and bank2
message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
AppendLogBookMessage, Event, message

success = 0
bss_selection_PlotBanks, Event, success

if (success EQ 0) then begin
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
endif else begin
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
endelse

;populate ROI file name
BSSselection_CreateRoiFileName, Event

END    
