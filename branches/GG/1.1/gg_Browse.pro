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

PRO gg_Browse, Event, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CASE (type) OF
    'geometry':BEGIN
        filter = (*global).geometry_xml_filtering
        path   = (*global).geometry_default_path
        title  = 'Select a geometry.xml file'
    END
    'cvinfo':BEGIN
        filter = (*global).cvinfo_xml_filtering
        path   = (*global).cvinfo_default_path
        title  = 'Select a cvinfo.xml file'
    END
    ELSE:BEGIN
        filter = ''
    END
ENDCASE

IF (filter NE '') THEN BEGIN
    
    default_extension = (*global).default_extension
    full_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                     FILTER            = filter,$
                                     TITLE             = title,$
                                     PATH              = path,$
                                     /MUST_EXIST)
    
    IF (full_file_name NE '') THEN BEGIN ;we found a file
        putFileNameInTextField, Event, type, full_file_name

        IF (type EQ 'cvinfo') THEN BEGIN ;retrieve run number
            array1 = strsplit(full_file_name,'/',/extract)
            sz1    = (size(array1))(1)
            array2 = strsplit(array1[sz1-1],'_',/extract)
            sz2    = (size(array2))(1)
            (*global).RunNumber = array2[sz2-2]
        ENDIF

    ENDIF
    
ENDIF



END
