PRO ReadXmlFile, Event  ;full reset of intput file
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file = (*global).tmp_xml_file

xmlFile = OBJ_NEW('xmlParser')
xmlFile->ParseFile, file

motors = xmlFile->GetArray()
;help, motors
(*(*global).motors)           = motors
(*(*global).motor_group)      = motors
(*(*global).untouched_motors) = motors
sz = (size(motors))(1)

;create table
FinalArray = gg_createTableArray(Event, motors)
;populate Table array
populateTable, Event, FinalArray

;nbr of lines
sz = (size(FinalArray))(2)
;reset nbr of lines
TableNbrLines, Event, sz

;display data of first element selected (top one)
displayDataOfFirstElement, Event, motors

;activate gui
activateTableGui, Event, 1
activateTreeGui, Event, 1

;select first element in tree
selectTreeRoot, Event

;select first line in table
selectFirstTableLine, Event

END