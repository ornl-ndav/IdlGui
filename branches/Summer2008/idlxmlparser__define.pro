PRO IDLXMLParser::cycleTag, i

end


PRO IDLXMLParser::startElement, URI, local, strName, attr, value
  print,"Found something"
  CASE (strName) OF
    self.tag: BEGIN
    
    END
    
  ENDCASE
END


PRO IDLXMLParser::characters, char
  self.saveto = self.saveto + char
END


FUNCTION IDLXMLParser::getValue, TAG=tag
  self.elements = n_elements(tag)
  self.tag = ptr_new(tag)
  self.count = 0
  print, SELF->ParseFile, 
  RETURN, 'bonjour'
END

FUNCTION IDLXMLParser::init
  RETURN, self -> IDLffxmlsax::Init()
END

pro IDLXMLParser__define
  void = {idlxmlParser, $
    INHERITS IDLffXMLSAX, $
    tag: ptr_new(), $
    count: 0, $
    elements: 0, $
    saveto: ''}
END



