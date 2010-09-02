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

;**************** Generic Functions ********************
PRO putInTextField, Event, uname, file_name
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=strcompress(file_name)
END

PRO appendInTextField, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text,/append
END


;*************** Particular Functions ********************

;Put the file_name given in the text_fiels specified by the type
;(geometry,cvinfo)
PRO putFileNameInTextField, Event, type, file_name
uname = type + '_text_field'
putInTextField, Event, uname, file_name
END

;name of output geometry file name
PRO putGeometryFileNameInTextField, Event, file_name
uname = 'geo_name_text_field'
putInTextField, Event, uname, file_name
END

PRO putGeometryFileInDroplist, Event
instrument = getInstrument(Event)
GeoArray = getGeometryList(instrument)
id = widget_info(Event.top, find_by_uname='geometry_droplist')
widget_control, id, set_value=GeoArray
id = widget_info(Event.top, find_by_uname='geometry_text_field')
widget_control, id, set_value=GeoArray[0]
END

;name of input xml geometry file
PRO putXmlGeometryFileInTextField, Event, file_name
uname = 'geometry_text_field'
putInTextField, Event, uname, file_name
END
