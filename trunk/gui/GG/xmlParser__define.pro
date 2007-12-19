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
        self.currentMotor.setpointUnits = attrValue[0]
    end
    'readback':begin
        self.charbuffer=''
        self.currentMotor.readbackUnits = attrValue[0]
    end
    'value':begin
        self.charbuffer=''
        self.currentMotor.valueUnits = attrValue[0]
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
IF (self.MotorNum EQ 0) THEN RETURN, -1 $
ELSE RETURN, self.Motors[0:self.MotorNum-1]
END


PRO xmlParser::characters, data
self.charBuffer = self.charBuffer + data
END



PRO xmlParser__define
void = {MOTOR, name   : '', $
        setpoint      : 0.0, $
        setpointUnits : '', $
        readback      : 0.0, $
        readbackUnits : '',$
        value         : 0.0,$
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
