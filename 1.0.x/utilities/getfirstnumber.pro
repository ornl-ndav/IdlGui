;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Description:
; 
;    Returns the first run number from the RunNumbers variable.
;    This is used for naming files/directories/jobs when more than 
;    one file is specified.
;    
;    e.g. RunNumbers="1234-1250" would return "1234"
;         RunNumbers="1234,1235" would return "1234"
;         RunNumbers="1250,1243-1249" would return "1250"
;
; :Params:
;    RunNumbers - A string containing the run numbers.
;
; :Author: scu
;-
FUNCTION GetFirstNumber, RunNumbers

  largeNumber = 9999999
  
  ; The runs should be delimited by either a - or ,
  
  ; Lets find see if there are any commas
  commaPosition = STRPOS(RunNumbers, ',')
  IF commaPosition EQ -1 THEN commaPosition = largeNumber
  
  hyphenPosition = STRPOS(RunNumbers, '-')
  IF hyphenPosition EQ -1 THEN hyphenPosition = largeNumber
  
  firstDelimiter = MIN([commaPosition, hyphenPosition])
  
  RETURN, STRMID(RunNumbers, 0, firstDelimiter)
  
END