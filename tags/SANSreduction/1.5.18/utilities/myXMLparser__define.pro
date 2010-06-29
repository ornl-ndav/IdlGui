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

  IF (self.insideTag) THEN BEGIN
    CASE strName OF
      'units':self.charbuffer=''
      'floatvalue':self.charbuffer=''
      ELSE:
    ENDCASE
  ENDIF
  
  CASE strName OF
    'parameter': BEGIN
      IF (attrName[0] EQ 'name' AND attrValue[0] EQ 'detZoffset') THEN BEGIN
        self.insideTag = 1b
      ENDIF
    END
    ELSE:
  ENDCASE
  
END


PRO myXMLparser::EndElement, URI, Local, strName

  IF (self.insideTag) THEN BEGIN
  
    CASE strName OF
      'units':      self.Units = self.charbuffer
      'floatvalue': self.value = self.charbuffer
      'parameter':  self.insideTag = 0b
      ELSE:
    ENDCASE
    
  ENDIF

END


FUNCTION myXMLparser::Init
  RETURN, self->IDLffXMLSAX::Init()
END


FUNCTION myXMLparser::GetArray
  RETURN, [self.value, self.units]
END


PRO myXMLparser::characters, data
  self.charBuffer = self.charBuffer + data
END


PRO myXMLparser__define
  void = {myXMLparser, $
    INHERITS IDLffXMLSAX, $
    insideTag: 0b, $
    units: '',$
    value: '',$
    charbuffer: '',$
    myPtr: PTR_NEW(0L)}
    
END
