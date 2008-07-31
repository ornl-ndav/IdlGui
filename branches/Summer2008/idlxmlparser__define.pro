;---------------------------------------------------------------------------
PRO IDLXMLParser::startElement, URI, local, strName, attr, value
  IF (strName EQ (*self.tag)[self.count]) THEN BEGIN
    self.count++
    CASE (self.mode) OF
      0:
      1: BEGIN  ;search defined by tag and attribute
        attrValue = value[WHERE(STRMATCH(attr, self.attr) EQ 1)]
        IF (attrValue EQ self.attrValue) THEN self.flag = 1
      END
      2: BEGIN  ;search defined by tag, output is attribute value
        self.output = value[WHERE(STRMATCH(attr, self.attr) EQ 1)]
      END
    END
  ENDIF ELSE BEGIN
    self.buffer = ''
  ENDELSE
  print, strName
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::cleanup
PTR_FREE, self.tag
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::endElement, URI, local, strName
  IF (strName EQ (*self.tag)[self.elements]) THEN BEGIN
    CASE (self.mode) OF
      0: BEGIN  ;search defined by only tag
        self -> StopParsing
        print, '======== done'
        self.output = self.buffer
      END
      1: BEGIN  ;search defined by tag and attribute
        IF SELF.flag EQ 1 THEN self.output = self.buffer
      END
      2:
    END
    self.count = 0
    self.flag = 0
  ENDIF
  self.buffer = '' 
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::characters, char
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    self.buffer = self.buffer + char
  ENDIF
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::getValue, TAG = tag, ATTRIBUTE = attr
  self.elements = n_elements(tag)-1
  self.tag = ptr_new(tag)
  self.mode = 0
  
  IF N_ELEMENTS(attr) NE 0 THEN BEGIN
    self.mode = 2
    IF STRMATCH(attr, '*=*') THEN BEGIN
      attr = STRTRIM(STRSPLIT(attr, '*=*', /EXTRACT), 2)
      self.attr = attr[0]
      self.attrValue = attr[1]
      self.mode = 1
    ENDIF ELSE BEGIN
      self.attr = attr
    ENDELSE
  ENDIF
  self.count = 0
  self -> IDLffxmlsax::ParseFile, self.path, /URL
  RETURN, self.output
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::init, file_name
  self.path = file_name
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO IDLXMLParser__define
  void = {idlxmlParser, $
    INHERITS IDLffXMLSAX, $
    tag: ptr_new(), $
    attr: '', $
    attrValue: '', $
    path: '', $
    mode: 0, $
    count: 0, $
    elements: 0, $
    buffer: '', $
    flag: 0, $
    output: ''}
END



