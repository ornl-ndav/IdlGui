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
;  PRINT, '+++++++++++++'
;  print, 'start: ' + local
;  print, 'count: ' + string(self.count)
  
  
  IF self.mode THEN BEGIN
  
  
  ENDIF ELSE BEGIN
  
    IF (local EQ (*self.tag)[self.count]) THEN BEGIN
      IF ((*self.tagvalue)[self.count] EQ "%!!nothing!!%") THEN BEGIN
        IF (self.count EQ self.tagElements-1) THEN BEGIN
   ;       PRINT, "ENTERED MODE 1"
          self.mode = 1
        ENDIF ELSE BEGIN
     ;     print, 'NEXT TAG'
          ;go to next tag
          self.count++
        ENDELSE
      ENDIF ELSE BEGIN
        self.flag = 1
      ENDELSE
    ENDIF
    
  ENDELSE
  
  
  ;     ELSE BEGIN
  ;      self.flag = 0
  ;    ENDELSE
  
  
  
 ; print, 'flag: ' + string(self.flag)
  self.buffer = ''
  
  
END


;---------------------------------------------------------------------------
PRO IDLXMLParser::endElement, URI, local, strName

  self.buffer = STRCOMPRESS(self.buffer, /REMOVE_ALL)

  IF self.mode THEN BEGIN
    CASE local OF
      self.searchTag: BEGIN
      ;  print, 'SEARCH TAG MATCHES'
        *self.searchTagBuff = [*self.searchTagBuff, self.buffer]
     ;   print, *self.searchTagBuff
      END
      
      self.conditionTag: BEGIN
     ;   print, 'CONDITION TAG MATCHES'
        
        IF self.conditionValue EQ self.buffer THEN BEGIN
        
          self.allowOutput = 1
        ENDIF
        
     ;   print, self.allowOutput
      END
      
      (*self.tag)[self.tagElements-1]: BEGIN
      ;  PRINT, 'ELEMENT ENDED'
        self.mode = 0
        ;    IF self.count GT 0 THEN self.count--
        IF self.allowOutput THEN BEGIN
          *self.output = (*self.searchTagBuff)[1:*]
          IF self.conditionTag NE "" THEN self.allowOutput = 0
        ENDIF ELSE BEGIN
          *self.searchTagBuff = [""]
        ENDELSE
   ;     PRINT, *self.output
      END
      
      ELSE:
      
    ENDCASE
    
  ENDIF ELSE BEGIN
  
  
    IF self.flag EQ 1 THEN BEGIN ;when a tag found
      self.flag = 0 ;reset flag
  ;    print, '|||buffer: ' + self.buffer
      IF (self.buffer EQ (*self.tagvalue)[self.count]) THEN BEGIN
   ;     print, "CHECKING IF LAST ELEMENT"
        ;if this is the last tag, then switch mode
        IF (self.count EQ self.tagElements-1) THEN BEGIN
          self.mode = 1
    ;      PRINT, "ENTERED MODE 1"
        ENDIF ELSE BEGIN
     ;     print, 'NEXT TAG'
          ;go to next tag
          self.count++
        ENDELSE
      ENDIF
    ENDIF ELSE BEGIN
    
      IF self.count GT 0 THEN BEGIN
        IF (local EQ (*self.tag)[self.count - 1]) THEN BEGIN
      ;    print, 'LAST TAG'
          self.count--
          self.mode = 0
        ENDIF
      ENDIF
    ENDELSE
  ENDELSE
  
 
  self.buffer = ''
  
;  print, 'mode: ' + string(self.mode)
;  print, 'flag: ' + string(self.flag)
;  print, 'end: ' + local
;  print, '-------------'
  
END

;---------------------------------------------------------------------------
PRO IDLXMLParser::characters, char
  ; print, 'char: ' + char
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    self.buffer = self.buffer + STRTRIM(char, 2)
  ENDIF
END

;---------------------------------------------------------------------------
FUNCTION IDLXMLParser::getValue, location = location, searchTag = searchTag, condition = condition
  *self.output = [""]
  *self.searchTagBuff = [""]
  self.mode = 0
  self.count = 0
  self.flag = 0
  self.tagElements = n_elements(location)
  self.tag = ptr_new(location)
  self.tagValue = ptr_new(strarr(self.tagElements))
  self.searchTag = searchTag
  self.conditionTag = ""
  self.conditionValue = ""
  
  FOR i= 0, self.tagElements - 1 DO BEGIN
    IF STRMATCH((*self.tag)[i], '*=*') THEN BEGIN
      tag = STRTRIM(STRSPLIT((*self.tag)[i], '*=*', /EXTRACT), 2)
      (*self.tag)[i] = tag[0]
      (*self.tagValue)[i] = tag[1]
    ENDIF ELSE BEGIN
      (*self.tagvalue)[i] = "%!!nothing!!%"
    ENDELSE
  ENDFOR
  
  IF N_ELEMENTS(condition) NE 0 THEN BEGIN
    self.allowOutput = 0
    IF STRMATCH(condition, '*=*') THEN BEGIN
      tag = STRTRIM(STRSPLIT(condition, '*=*', /EXTRACT), 2)
      self.conditionTag = tag[0]
      self.conditionValue = tag[1]
    ENDIF
  ENDIF ELSE BEGIN
    self.allowOutput = 1
  ENDELSE
  
  self -> IDLffxmlsax::ParseFile, self.path
  
  ;  IF N_ELEMENTS(*self.output) GT 1 THEN BEGIN
  ;    *self.output = (*self.output)[1:*]
  ;  END
  
  
  RETURN, *self.output
END

;---------------------------------------------------------------------------
FUNCTION IDLxmlParser::init, file_name
  self.path = file_name
  self.output = ptr_new(strarr(1))
  self.searchTagBuff = ptr_new(strarr(1))
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO IDLxmlParser__define
  void = {IDLxmlParser, $
    INHERITS IDLffXMLSAX, $
    tag: ptr_new(), $
    tagValue: ptr_new(), $
    searchTag: '', $
    conditionTag: '', $
    conditionValue: '', $
    path: '', $
    mode: 0, $
    flag: 0, $
    count: 0, $
    allowOutput: 0, $
    tagElements: 0, $
    buffer: '', $
    output: ptr_new(), $
    searchTagBuff: ptr_new()}
END



