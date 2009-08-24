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

PRO getHistogramInfo, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

runinfoFileName = (*global).runinfoFileName
;look for info if file exist and end with .xml
result = strmatch(runinfoFileName,'*_runinfo.xml')
IF (result EQ 1 AND $
    FILE_TEST(runinfoFileName) EQ 1) THEN BEGIN
    min_time_bin = getBinOffsetFromDas(Event, runinfoFileName)
    putTextInTextField, Event, 'min_time_bin', strcompress(min_time_bin,/remove_all)
    max_time_bin = getBinMaxSetFromDas(Event, runinfoFileName)
    putTextInTextField, Event, 'max_time_bin', strcompress(max_time_bin,/remove_all)
;    bin_width    = getBinWidthSetFromDas(Event, runinfoFileName)
    bin_width = (*global).bin_width
    putTextInTextField, Event, 'bin_width', strcompress(bin_width,/remove_all)
    bin_type     = getBinTypeFromDas(Event, runinfoFileName)
    IF (bin_type EQ 'linear') THEN BEGIN
        setHistogrammingTypeValue, Event, 0
    ENDIF ELSE BEGIN
        setHistogrammingTypeValue, Event, 1
    ENDELSE
ENDIF
END
