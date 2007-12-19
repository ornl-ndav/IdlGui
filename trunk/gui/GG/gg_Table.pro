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
