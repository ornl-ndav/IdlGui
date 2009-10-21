;===============================================================================
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
;===============================================================================

PRO myXMLparser::StartElement, URI, Local, strName, attrName, attrValue

  ;Modify code here if the value of tags need to be saved
  IF (self.insideTag) THEN BEGIN
    CASE strName OF
      ;      'units':self.charbuffer=''
      ;      'floatvalue':self.charbuffer=''
      ELSE:
    ENDCASE
  ENDIF

  ;because right now we only care about CDATA, charbuffer is reset to empty
  ;string each time StartElement is reached
  self.charbuffer = ''

END


PRO myXMLparser::EndElement, URI, Local, strName

  ;record the contain of charbuffer when we leave the EndElement (which is
  ;our CDATA tag in our case
    IF (self.insideCDATA EQ 0) THEN BEGIN
    self.value[self.index] = self.charbuffer
    ENDIF
  
  ;edit to do something with value of tags
IF (self.insideTag) THEN BEGIN
    CASE strName OF
      ;      'units':      self.Units = self.charbuffer
      ;      'floatvalue': self.value = self.charbuffer
      ;      'parameter':  self.insideTag = 0b
      ELSE:
    ENDCASE
    
  ENDIF
  
END


PRO myXMLparser::StartCDATA
;  self.insideCDATA = 1b
END

PRO myXMLparser::EndCDATA
  self.index++
;  self.insideCDATA = 0b
END


FUNCTION myXMLparser::Init
  a = self->IDLffXMLSAX::Init()
  return, self->IDLffXMLDOMCDATASection::Init()
END


FUNCTION myXMLparser::GetArray
  RETURN, self.value
END


PRO myXMLparser::characters, data
  self.charBuffer = self.charBuffer + data
END


PRO myXMLparser__define
  void = {myXMLparser, $
    INHERITS IDLffXMLSAX, $
    INHERITS IDLffXMLDOMCDATASection, $
    insideTag: 0b, $
    insideCDATA: 0b, $
    units: '',$
    value: STRARR(20000),$ ;value hard coded but can be calculated ahead
    index: 0L,$
    charbuffer: '',$
    myPtr: PTR_NEW(0L)}
    
END
