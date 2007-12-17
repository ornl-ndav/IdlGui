PRO xmlParser::StartElement, URI, Local, strName, attrName, attrValue
CASE strName OF
    'Solar_System': 
    'inputs':
    'group' : self.Group = attrValue[0]
    'Planet': begin
        self.currentPlanet={PLANET,"",0ull,'',0.0,'',0,'',self.Group}
        self.currentPlanet.Name = attrValue[0]
    end
    'Orbit': begin
        self.charbuffer=''
        self.currentPlanet.OrbitUnits = attrValue[0]
    end
    'Period':begin
        self.charbuffer=''
        self.currentPlanet.PeriodUnits = attrValue[0]
    end
    'Moons':begin
        self.charbuffer=''
        self.currentPlanet.MoonsUnits = attrValue[0]
    end
ENDCASE
END


PRO xmlParser::EndElement, URI, Local, strName
CASE strName OF
    'Solar_System': 
    'inputs':
    'group' :
    'Planet': begin
        self.Planets(self.planetNum)=self.currentPlanet
        self.planetNum = self.planetNum + 1
    end
    'Orbit': self.currentPlanet.Orbit = self.charBuffer
    'Period': self.currentPlanet.Period = self.charBuffer
    'Moons': self.currentPlanet.Moons = self.charBuffer
ENDCASE
END


FUNCTION xmlParser::Init
self.PlanetNum = 0
RETURN, self->IDLffXMLSAX::Init()
END


FUNCTION xmlParser::GetArray
IF (self.planetNum EQ 0) THEN RETURN, -1 $
ELSE RETURN, self.Planets[0:self.planetNum-1]
END


PRO xmlParser::characters, data
self.charBuffer = self.charBuffer + data
END







PRO xmlParser__define
void = {PLANET, name: '', $
        Orbit       : 0ull, $
        OrbitUnits  : '', $
        Period      : 0.0, $
        PeriodUnits : '',$
        Moons       : 0,$
        MoonsUnits  : '',$
        group       : ''}
void = {xmlParser, $
        INHERITS IDLffXMLSAX, $
        CharBuffer   : "",$
        PlanetNum    :0,$
        Group        : '',$
        currentPlanet:{PLANET},$
        Planets      : Make_array(5,value={PLANET})}

END
