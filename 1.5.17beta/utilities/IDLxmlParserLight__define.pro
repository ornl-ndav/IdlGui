;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

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
PRO IDLxmlParserLight::startElement, URI, local, strName, attr, value

  if (value ne !null) then begin
  
    if (where(self.attr eq value) ne -1) then begin
      self.flag=1
    endif
  endif
  
END

;---------------------------------------------------------------------------
PRO IDLxmlParserLight::endElement, URI, local, strName

  if (self.flag && (local eq 'floatvalue')) then begin
    self->IDLffxmlsax::stopParsing
    self.output=self.buffer
;    print, 'self.output: ' , self.output
  endif
  
  self.buffer=''
  
END

;---------------------------------------------------------------------------
PRO IDLxmlParserLight::characters, char
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    self.buffer = self.buffer + char
  ENDIF
END

;---------------------------------------------------------------------------
FUNCTION IDLxmlParserLight::getValue, TAG = tag, ATTRIBUTE = attr

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
PRO IDLxmlParserLight::cleanup
  ;free the pointer
  PTR_FREE, self.tag
END

;---------------------------------------------------------------------------
FUNCTION IDLxmlParserLight::init, file_name
  self.path = file_name
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO IDLxmlParserLight__define
  void = {IDLxmlParserLight, $
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



