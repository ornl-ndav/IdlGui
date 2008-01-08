PRO xmlParser::StartElement, URI, Local, strName, attrName, attrValue
CASE strName OF
    'parameters': self.charbuffer=''
    'inputs'    : self.charbuffer=''
    'group'     : begin
        self.charbuffer=''
        self.Group = attrValue[0]
    end
    'motor'     : self.charbuffer=''
    'name'      : begin
        self.charbuffer=''
        self.currentMotor={MOTOR,"",0ull,'',0.0,'',0,'',self.Group}
    end
    'setpoint'  : begin
        self.charbuffer=''
        no_error = 0
        catch, no_error
        if (no_error NE 0) THEN BEGIN
            catch,/cancel
            self.currentMotor.setpointUnits = ''
        endif else begin
            self.currentMotor.setpointUnits = attrValue[0]
        endelse
    end
    'readback':begin
        self.charbuffer=''
        no_error = 0
        catch, no_error
        if (no_error NE 0) THEN BEGIN
            catch,/cancel
            self.currentMotor.readbackUnits = ''
        endif else begin
            self.currentMotor.readbackUnits = attrValue[0]
        endelse
    end
    'value':begin
        self.charbuffer=''
        no_error = 0
        catch, no_error
        if (no_error NE 0) THEN BEGIN
            catch,/cancel
            self.currentMotor.valueUnits = ''
        endif else begin
            self.currentMotor.valueUnits = attrValue[0]
        endelse
    end
ENDCASE
END


PRO xmlParser::EndElement, URI, Local, strName
CASE strName OF
    'parameters': 
    'inputs'    :
    'group'     :
    'motor'     : begin
        self.motors(self.MotorNum) = self.currentMotor
        self.MotorNum              = self.MotorNum + 1
    end
    'name'      : self.currentMotor.name     = self.charbuffer
    'setpoint'  : self.currentMotor.setpoint = self.charBuffer
    'readback'  : self.currentMotor.readback = self.charBuffer
    'value'     : self.currentMotor.value    = self.charBuffer
ENDCASE
END


FUNCTION xmlParser::Init
self.MotorNum = 0
RETURN, self->IDLffXMLSAX::Init()
END


FUNCTION xmlParser::GetArray
;IF (self.MotorNum EQ 0) THEN return, -1 $
;ELSE RETURN, self.Motors[0:self.MotorNum-1]
IF (self.MotorNum EQ 0) THEN BEGIN
    RETURN, -1
;     self.Motors.name           = ''
;     self.Motors.setpoint       = 0.0
;     self.Motors.setpointUnits  = ''
;     self.Motors.readback       = 0.0
;     self.Motors.readbackUnits  = ''
;     self.Motors.value          = 0.0
;     self.Motors.valueUnits     = ''
;     self.Motors.group          = ''
;     RETURN, self.Motors
ENDIF ELSE BEGIN
    RETURN, self.Motors[0:self.MotorNum-1]
ENDELSE
END


PRO xmlParser::characters, data
self.charBuffer = self.charBuffer + data
END



PRO xmlParser__define
void = {MOTOR, name   : '', $
        setpoint      : double(0.0), $
        setpointUnits : '', $
        readback      : double(0.0), $
        readbackUnits : '',$
        value         : double(0.0),$
        valueUnits    : '',$
        group         : ''}
void = {xmlParser, $
        INHERITS IDLffXMLSAX, $
        CharBuffer   : "",$
        MotorNum     : 0L,$
        Group        : '',$
        currentMotor :{MOTOR},$
        Motors       : Make_array(50,value={MOTOR})}

END
