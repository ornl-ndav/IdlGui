;---------------------------------------------------------------------------
PRO IDLXMLParser::startElement, URI, local, strName, attr, value
  print, '---------------------'
  print,"startElement"
  print, strName
  help, (*self.tag)[self.count]
  IF (strName EQ (*self.tag)[self.count]) THEN BEGIN
    self.count++
  ENDIF ELSE BEGIN
    self.buffer = ''
  ENDELSE
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::endElement, URI, local, strName
  print,"endElement"
  help, strName
  IF (strName EQ (*self.tag)[self.elements]) THEN BEGIN
    self.count = 0
    self.output = self.buffer
  ENDIF
  self.buffer = ''
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::characters, char
  if char ne '' then begin
    self.buffer = self.buffer + char
  endif
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::getValue, path = file_name, TAG = tag
  self.elements = n_elements(tag)-1
  self.tag = ptr_new(tag)
  self.count = 0
  self -> IDLffxmlsax::ParseFile,file_name, /URL
  RETURN, self.output
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::init
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
pro IDLXMLParser__define
  void = {idlxmlParser, $
    INHERITS IDLffXMLSAX, $
    tag: ptr_new(), $
    count: 0, $
    elements: 0, $
    buffer: '', $
    output: ''}
END



