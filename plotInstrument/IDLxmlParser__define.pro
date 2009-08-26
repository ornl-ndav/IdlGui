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


;---------------------------------------------------------------------------
PRO IDLXMLParser::cleanup
  ;free the pointer
  PTR_FREE, self.tag
  PTR_FREE, self.output
  PTR_FREE, self.tagValue
END


;---------------------------------------------------------------------------
PRO IDLXMLParser::startElement, URI, local, strName, attr, value
  print, 'local: ' + local
  
  
  IF (local EQ (*self.tag)[self.count]) THEN BEGIN
    self.flag = 1
  ENDIF ELSE BEGIN
    self.flag = 0
  ENDELSE
  
  SELF.BUFFER = ""
  
  PRINT, '+++++++++++++'
  
END


;---------------------------------------------------------------------------
PRO IDLXMLParser::endElement, URI, local, strName
  print, 'local: ' + local
  
  
  
  self.buffer = STRCOMPRESS(self.buffer, /REMOVE_ALL)
  
  
  IF self.flag EQ 1 THEN BEGIN
    self.flag = 0
    IF (*self.tagvalue)[self.counT] NE "" THEN BEGIN
      print, "checking tagvalue"
      IF self.buffer NE (*self.tagvalue)[self.count] THEN BEGIN
        print, "wrong tagvalue"
      ENDIF ELSE BEGIN
        print, 'FOUND: ' + (*self.tagvalue)[self.count]
        self.count++
      ENDELSE
    ENDIF ELSE BEGIN
      PRINT, 'MATCH'
      IF self.buffer NE "" THEN BEGIN
        *self.output = [*self.output, self.buffer]
      ENDIF
      
    ENDELSE
  ENDIF ELSE BEGIN
    IF self.count GT 0 THEN BEGIN
      IF (local EQ (*self.tag)[self.count - 1]) THEN self.count--
    ENDIF
  ENDELSE
  
  
  
  self.buffer = ''
  print, '-------------'
  
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::characters, char
  print, 'flag: ' + string(self.flag)
  print, 'count: ' + string(self.count)
  
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    ; print, self.buffer
    self.buffer = self.buffer + STRTRIM(char, 2)
  ENDIF
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::getValue, TAG = tag



  self.count = 0
  self.flag = 0
  self.elements = n_elements(tag)-1
  self.tag = ptr_new(tag)
  self.tagvalue = ptr_new(strarr(self.elements + 1))
  
  
  FOR i= 0, self.elements DO BEGIN
    IF STRMATCH((*self.tag)[i], '*=*') THEN BEGIN
      tag = STRTRIM(STRSPLIT((*self.tag)[i], '*=*', /EXTRACT), 2)
      (*self.tag)[i] = tag[0]
      (*self.tagValue)[i] = tag[1]
    ENDIF ELSE BEGIN
      (*self.tagvalue)[i] = ""
    ENDELSE
  ENDFOR
  
  print, *self.tag
  print, *self.tagvalue
  
  
  self -> IDLffxmlsax::ParseFile, self.path
  
  *self.output = (*self.output)[1:*]
  
  RETURN, *self.output
END

;---------------------------------------------------------------------------
FUNCTION IDLxmlParser::init, file_name
  self.path = file_name
  self.output = ptr_new(strarr(1))
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO IDLxmlParser__define
  void = {IDLxmlParser, $
    INHERITS IDLffXMLSAX, $
    tag: ptr_new(), $
    tagValue: ptr_new(), $
    attr: '', $
    attrValue: '', $
    path: '', $
    mode: 0, $
    count: 0, $
    elements: 0, $
    buffer: '', $
    flag: 0, $
    output: ptr_new()}
END



