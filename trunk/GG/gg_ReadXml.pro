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

;check if motors is structure or not
;if not, disable table and interactive part
type= (size(motors))(2)
IF (type EQ 8) THEN BEGIN
;activate gui
    activateTableGui, Event, 1
    activateTreeGui, Event, 1
    sensitive_widget, Event, 'create_geometry_file_button', 1
    sensitive_widget, Event, 'full_reset_button', 1
ENDIF ELSE BEGIN
    activateTableGui, Event, 0
    activateTreeGui, Event, 0
;disable button that creates geometry
    sensitive_widget, Event, 'create_geometry_file_button', 0
    sensitive_widget, Event, 'full_reset_button', 0
ENDELSE

;select first element in tree
selectTreeRoot, Event

;select first line in table
selectFirstTableLine, Event

END
