; =============================================================================
; NAME:
;    IDLSXMLParser
;
; PURPOSE:
;    Parses a given XML file.
;
; CATEGORY:
;    XML parser
;
; USING CLASS:
;    To make an instance of the class:
;      file = OBJ_NEW('idlxmlparser', file_name)
;    file_name hols the location of the XML file
;
;    To get the text under a certain tag:
;      text = file -> getValue(tag = ['tag1', 'tag2'])
;    To get the text under a tag with a certain attribute:
;      text = file -> getValue(tag = ['cvlog'], ATTRIBUTE = 'name = THE_NAME')
;    To get the value of an attribute of a tag:
;      text = file -> getValue(tag = ['cvlog'], ATTRIBUTE = 'name')
;
;  OUTPUT:
;    STRING format
;
; Author:
;           dfp <prakapenkadv@ornl.gov>
;           j35 <bilheuxjm@ornl.gov>
;
; =============================================================================

;remove string(10b) from the string (string(10b) = new line)
FUNCTION reformat_output, output
  ;try to find if there are new lines
  location = STREGEX(output,STRING(10b))
  WHILE (location NE -1) DO BEGIN ;loop as long as there is another string(10b)
    output = STRMID(output,location[0]+1,STRLEN(output)-1)
    location = STREGEX(output,STRING(10b))
  ENDWHILE
  RETURN, output
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::startElement, URI, local, strName, attr, value

  ;Whenever an elemnt is found check against the given tag and
  ;based on mode check for matching attribute or attribute value
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
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::cleanup
  ;free the pointer
  PTR_FREE, self.tag
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::endElement, URI, local, strName
  ;if the tag is the last on the list then set the buffer to output
  IF (strName EQ (*self.tag)[self.elements]) THEN BEGIN
    CASE (self.mode) OF
      0: BEGIN  ;search defined by only tag
        self -> IDLffxmlsax::StopParsing
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
  
  ;Set the mode and seperate attribute and value
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
  
  ;start parsing
  ;  self -> IDLffxmlsax::ParseFile, self.path, /URL
  self -> IDLffxmlsax::ParseFile, self.path
  
  ;reformat output
  self.output = reformat_output(self.output)
  
  RETURN, STRCOMPRESS(self.output,/REMOVE_ALL)
END

;---------------------------------------------------------------------------
FUNCTION IDLxmlParser::init, file_name
  self.path = file_name
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO IDLxmlParser__define
  void = {IDLxmlParser, $
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



