FUNCTION gg_createTableArray, Event, motors

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;size of motors array
sz = (size(motors))(1)

S = (*global).setpointStatus
U = (*global).userStatus
R = (*global).readbackStatus

status     = strarr(sz)
name       = strarr(sz)
value      = strarr(sz)
units      = strarr(sz)
FinalArray = strarr(4,sz)


FOR i=0,(sz-1) DO BEGIN
    name[i]  = strcompress(motors[i].name,/remove_all)
    value[i] = strcompress(motors[i].value,/remove_all)
    units[i] = motors[i].valueUnits
    status1  = ''
    status2  = ''
    IF (units[i] EQ motors[i].setpointUnits AND $
        value[i] EQ motors[i].setpoint) THEN status1 = 'S'
    IF (units[i] EQ motors[i].readbackUnits AND $
        value[i] EQ motors[i].readback) THEN status2 = 'R'
    CASE (status1) OF
        'S': CASE (status2) OF 
            'R': stat = 'S/R'
            '' : stat = 'S'
        ENDCASE
        '' : CASE (status2) OF
            'R' : stat = 'R'
            ''  : stat = 'U'
        ENDCASE
    ENDCASE
    status[i] = stat
    
    Array = [status[i],name[i],value[i],units[i]]
    FinalArray[*,i] = Array

ENDFOR

RETURN, FinalArray
END




FUNCTION gg_createTableArrayOfSelectedGroup, Event, group

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;size of motors array
motors       = (*(*global).motors)
sz           = (size(motors))(1)

IF (group EQ 'root') THEN BEGIN
    array = gg_createTableArray(Event, motors)
    return, array
ENDIF

;make tmp structure of only group values
void = {motor, $
        name : '',$
        setpoint      : 0.0, $
        setpointUnits : '', $
        readback      : 0.0, $
        readbackUnits : '',$
        value         : 0.0,$
        valueUnits    : '',$
        group         : ''}
motor_group = make_array(50,value={motor})

S = (*global).setpointStatus
U = (*global).userStatus
R = (*global).readbackStatus

status     = strarr(sz)
name       = strarr(sz)
value      = strarr(sz)
units      = strarr(sz)
FinalArray = strarr(4,sz)
j=0

FOR i=0,(sz-1) DO BEGIN
    IF (motors[i].group EQ group) THEN BEGIN
        motor_group[j] = motors[i]
        name[i]  = strcompress(motors[i].name,/remove_all)
        value[i] = strcompress(motors[i].value,/remove_all)
        units[i] = motors[i].valueUnits
        status1  = ''
        status2  = ''
        IF (units[i] EQ motors[i].setpointUnits AND $
            value[i] EQ motors[i].setpoint) THEN status1 = 'S'
        IF (units[i] EQ motors[i].readbackUnits AND $
            value[i] EQ motors[i].readback) THEN status2 = 'R'
        CASE (status1) OF
            'S': CASE (status2) OF 
                'R': stat = 'S/R'
                '' : stat = 'S'
            ENDCASE
            '' : CASE (status2) OF
                'R' : stat = 'R'
                ''  : stat = 'U'
            ENDCASE
        ENDCASE
        status[i] = stat
        
        IF (j EQ 0) THEN BEGIN ;display datat of first element
            ;get index in motors structure of first element
            DisplayGivenElement, Event, $
              name[i],$
              motors[i].setpoint,$
              motors[i].setpointUnits,$
              motors[i].readback,$
              motors[i].readbackUnits,$
              motors[i].value,$
              motors[i].valueUnits              
        ENDIF
        Array = [status[i],name[i],value[i],units[i]]
        FinalArray[*,j++] = Array
    ENDIF
        
ENDFOR
TableNbrLines, Event, j

;if no data, reset dislplay
IF (j EQ 0) THEN BEGIN
    DisplayGivenElement, Event, $
      '',$
      '',$
      '',$
      '',$
      '',$
      '',$
      ''
;desactivate table and widgets gui
    activateTableGui, Event, 0
ENDIF ELSE BEGIN
;activate table and widgets gui
    activateTableGui, Event, 1
ENDELSE

(*(*global).motor_group) = motor_group

RETURN, FinalArray
END




FUNCTION gg_createTableArrayOfSelectedGroup_validate_reset, Event, group
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;size of motors array
motors       = (*(*global).motors)
sz           = (size(motors))(1)

IF (group EQ 'root') THEN BEGIN
    array = gg_createTableArray(Event, motors)
    return, array
ENDIF

;make tmp structure of only group values
void = {motor, $
        name : '',$
        setpoint      : 0.0, $
        setpointUnits : '', $
        readback      : 0.0, $
        readbackUnits : '',$
        value         : 0.0,$
        valueUnits    : '',$
        group         : ''}
motor_group = make_array(50,value={motor})

S = (*global).setpointStatus
U = (*global).userStatus
R = (*global).readbackStatus

status     = strarr(sz)
name       = strarr(sz)
value      = strarr(sz)
units      = strarr(sz)
FinalArray = strarr(4,sz)
j=0

FOR i=0,(sz-1) DO BEGIN
    IF (motors[i].group EQ group) THEN BEGIN
        motor_group[j] = motors[i]
        name[i]  = strcompress(motors[i].name,/remove_all)
        value[i] = strcompress(motors[i].value,/remove_all)
        units[i] = motors[i].valueUnits
        status1  = ''
        status2  = ''
        IF (units[i] EQ motors[i].setpointUnits AND $
            value[i] EQ motors[i].setpoint) THEN status1 = 'S'
        IF (units[i] EQ motors[i].readbackUnits AND $
            value[i] EQ motors[i].readback) THEN status2 = 'R'
        CASE (status1) OF
            'S': CASE (status2) OF 
                'R': stat = 'S/R'
                '' : stat = 'S'
            ENDCASE
            '' : CASE (status2) OF
                'R' : stat = 'R'
                ''  : stat = 'U'
            ENDCASE
        ENDCASE
        status[i] = stat
        
        Array = [status[i],name[i],value[i],units[i]]
        FinalArray[*,j++] = Array
    ENDIF
        
ENDFOR
TableNbrLines, Event, j

(*(*global).motor_group) = motor_group

RETURN, FinalArray
END














;reach when root is selected
PRO root_selected, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;make tmp structure of only group values
void = {motor, $
        name : '',$
        setpoint      : 0.0, $
        setpointUnits : '', $
        readback      : 0.0, $
        readbackUnits : '',$
        value         : 0.0,$
        valueUnits    : '',$
        group         : ''}
motor_group = make_array(50,value={motor})
motor_group = (*(*global).motors)
(*(*global).motor_group) = motor_group

array = gg_createTableArray(Event, (*(*global).motors))
TableNbrLines, Event, (size(array))(2)
populateTable, Event, array
END



PRO leaf_selected, Event, leaf
CASE (leaf) of
    'leaf1': begin
       array = gg_createTableArrayOfSelectedGroup(Event, 'number')
   end
   'leaf2': begin
       array = gg_createTableArrayOfSelectedGroup(Event, 'angle')
   end
   'leaf3': begin
       array = gg_createTableArrayOfSelectedGroup(Event, 'length')
   end
   'leaf4': begin
       array = gg_createTableArrayOfSelectedGroup(Event, 'wavelength')
   end
else:
ENDCASE
populateTable, Event, array
END


PRO changeValue, Event
;get new value
value = getTextFieldValue(Event, 'current_value_text_field')
;get motors structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
motors      = (*(*global).motors)
motor_group = (*(*global).motor_group)
;get name of variable to change
name = getTextFieldValue(Event, 'name_value')
;find out where this name is in the motors structure
index      = getMotorsIndexOfName(Event, name, motors)
indexGroup = getMotorsIndexOfName(Event, name, motor_group)
;put new value of value and units
motors[index].value           = value
motor_group[indexGroup].value = value
;save new motors array
(*(*global).motors)      = motors
(*(*global).motor_group) = motor_group
;and refresh table
;get group selected 
index1 = treeGroupSelected(Event)
array  = gg_createTableArrayOfSelectedGroup_validate_reset(Event, index1)
populateTable, Event, Array
END


PRO changeUnits, Event
;get new units
units = getTextFieldValue(Event, 'current_units_text_field')
;get motors structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
motors      = (*(*global).motors)
motor_group = (*(*global).motor_group)
;get name of variable to change
name = getTextFieldValue(Event, 'name_value')
;find out where this name is in the motors structure
index      = getMotorsIndexOfName(Event, name, motors)
indexGroup = getMotorsIndexOfName(Event, name, motor_group)
;put new value of value and units
motors[index].valueUnits           = units
motor_group[indexGroup].valueUnits = units
;save new motors array
(*(*global).motors)      = motors
(*(*global).motor_group) = motor_group
;and refresh table
;get group selected 
index1 = treeGroupSelected(Event)
array = gg_createTableArrayOfSelectedGroup_validate_reset(Event, index1)
populateTable, Event, Array
END


PRO changeValueAndUnits, Event
;get new value
value = getTextFieldValue(Event, 'current_value_text_field')
units = getTextFieldValue(Event, 'current_units_text_field')
;get motors structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
motors      = (*(*global).motors)
motor_group = (*(*global).motor_group)
;get name of variable to change
name   = getTextFieldValue(Event, 'name_value')
;find out where this name is in the motors structure
index      = getMotorsIndexOfName(Event, name, motors)
indexGroup = getMotorsIndexOfName(Event, name, motor_group)
;put new value of value and units
motors[index].value                = value
motors[index].valueUnits           = units
motor_group[indexGroup].value      = value
motor_group[indexGroup].valueUnits = units
;save new motors array
(*(*global).motors)      = motors
(*(*global).motor_group) = motor_group
;and refresh table
;get group selected 
index1 = treeGroupSelected(Event)
array = gg_createTableArrayOfSelectedGroup_validate_reset(Event, index1)
populateTable, Event, Array
END


PRO resetValueAndUnits, Event
;get motors structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
motors           = (*(*global).motors)
untouched_motors = (*(*global).untouched_motors)
motor_group      = (*(*global).motor_group)
;get name of variable to change
name   = getTextFieldValue(Event, 'name_value')
;find out where this name is in the motors structure
index      = getMotorsIndexOfName(Event, name, motors)
indexGroup = getMotorsIndexOfName(Event, name, motor_group)
;put new value of value and units
motors[index].value                = untouched_motors[index].value
motors[index].valueUnits           = untouched_motors[index].valueUnits
motor_group[indexGroup].value      = untouched_motors[index].value
motor_group[indexGroup].valueUnits = untouched_motors[index].valueUnits
;save new motors array
(*(*global).motors)      = motors
(*(*global).motor_group) = motor_group
;and refresh table
;get group selected 
index1 = treeGroupSelected(Event)
array = gg_createTableArrayOfSelectedGroup_validate_reset(Event, index1)
populateTable, Event, Array
;reinitialize input gui
DisplaySelectedElement, Event
END
