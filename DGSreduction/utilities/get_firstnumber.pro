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
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION Get_FirstNumber, RunNumberString

  largeNumber = 9999999
  runNumber = '-1'
  fileGiven = 0
  runNumber_location = '/entry/entry_identifier'
  
  Catch, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /CANCEL
    IF !ERROR_STATE.CODE EQ -1008 THEN runNumber_location = '/entry/run_number'
  ENDIF
  
  ; The runs should be delimited by either a - or , (or even :)
  
  ; Lets find see if there are any commas
  commaPosition = STRPOS(RunNumberString, ',')
  IF commaPosition EQ -1 THEN commaPosition = largeNumber
  
  colonPosition = STRPOS(RunNumberString, ':')
  IF colonPosition EQ -1 THEN colonPosition = largeNumber
  
  hyphenPosition = STRPOS(RunNumberString, '-')
  IF hyphenPosition EQ -1 THEN hyphenPosition = largeNumber
  ; If we find a '-', we need to check that it is not part of the string IPTS-XXXX!
  ;print, STRMID(RunNumberString, hyphenPosition-4, 4)
  IF STRMID(RunNumberString, hyphenPosition-4, 4) EQ 'IPTS' THEN $
    hyphenPosition = largeNumber
    
  firstDelimiter = MIN([commaPosition, hyphenPosition, colonPosition])
  
  ; Let's get the string upto the first ',' or '-'
  firstString = STRMID(RunNumberString, 0, firstDelimiter)
  
  ; Now let's check to see if we have been given a set of numbers or filenames.
  ; for this I am going to check if the string contains either a '/' or a '.'
  slashPosition = STRPOS(firstString, '/')
  dotPosition = STRPOS(firstString, '.')
  IF (dotPosition NE -1) OR (slashPosition NE -1) THEN fileGiven = 1
  
  ;print, slashPosition, dotPosition, fileGiven
  
  ; Now lets get the run number for a filename.
  IF (fileGiven EQ 1) THEN BEGIN
  
    ; Let's check to see if the file exists.
    fileThere = FILE_TEST(firstString, /READ, /REGULAR)
    
    IF (fileThere) THEN BEGIN
    
      ; Let's first check to see if we are using a 'Live' NeXus file.
      ; Assuming that if the filename contains the path to a shared/live directory
      ; it is a live file!
      liveString = STRPOS(firstString, '/shared/live')
      IF liveString NE -1 THEN BEGIN
        runNumber = 'live'
      ENDIF ELSE BEGIN
        ; First lets open the file
        fileID = h5f_open(firstString)
        ; Now lets get the run number
        ;print, 'Getting run number from ', runNumber_location, ' in NeXus file.'
        fieldID = H5D_OPEN(FILEID, runNumber_location)
        runNumber_fromFile = H5D_READ(FIELDID)
        runNumber = STRING(runNumber_fromFile[0])
      ENDELSE
    ENDIF
    
  ENDIF ELSE BEGIN
    ; If it's not a file, then we must already have the run number.
    runNumber = firstString
  ENDELSE
  
  RETURN, runNumber
  
END