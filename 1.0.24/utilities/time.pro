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

;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn_23s
Function GenerateIsoTimeStamp

dateUnformated = SYSTIME()    
DateArray      = STRSPLIT(dateUnformated,' ',/EXTRACT) 
DateIso        = STRCOMPRESS(DateArray[4]) + 'y '

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
ENDCASE

DateIso += STRCOMPRESS(month,/REMOVE_ALL) + ' '
DateIso += STRCOMPRESS(DateArray[2],/REMOVE_ALL) + 'd '

;change format of time
time     = STRSPLIT(DateArray[3],' : ',/EXTRACT)
DateIso += ' : '
DateIso += STRCOMPRESS(time[0],/REMOVE_ALL) + 'h '
DateIso += STRCOMPRESS(time[1],/REMOVE_ALL) + 'mn '
DateIso += STRCOMPRESS(time[2],/REMOVE_ALL) + 's'

RETURN, DateIso
END
