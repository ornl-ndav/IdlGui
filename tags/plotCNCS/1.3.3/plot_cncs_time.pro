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

;format date into ISO8601
PRO get_iso8601, second_part

dateUnformated = systime()      ;ex: Thu Aug 23 16:15:23 2007
DateArray = strsplit(dateUnformated,' ',/extract) 

;ISO8601 : 2007-08-23T12:20:34-04:00
DateIso = strcompress(DateArray[4]) + '-'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01'
    'Feb':month='02'
    'Mar':month='03'
    'Apr':month='04'
    'May':month='05'
    'Jun':month='06'
    'Jul':month='07'
    'Aug':month='08'
    'Sep':month='09'
    'Oct':month='10'
    'Nov':month='11'
    'Dec':month='12'
endcase

DateIso += strcompress(month,/remove_all) + '-'
DateIso += strcompress(DateArray[2],/remove_all) + 'T'
DateIso += strcompress(DateArray[3],/remove_all) + '-04:00'
second_part = DateIso
END






FUNCTION GenerateIsoTimeStamp

dateUnformated = systime()      ;ex: Thu Aug 23 16:15:23 2007
DateArray = strsplit(dateUnformated,' ',/extract) 

;ISO8601 : 2007-08-23T12:20:34-04:00
DateIso = strcompress(DateArray[4]) + '-'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01'
    'Feb':month='02'
    'Mar':month='03'
    'Apr':month='04'
    'May':month='05'
    'Jun':month='06'
    'Jul':month='07'
    'Aug':month='08'
    'Sep':month='09'
    'Oct':month='10'
    'Nov':month='11'
    'Dec':month='12'
endcase

DateIso += strcompress(month,/remove_all) + '-'
DateIso += strcompress(DateArray[2],/remove_all) + 'T'
DateIso += strcompress(DateArray[3],/remove_all) + '-04:00'

RETURN, DateIso
END