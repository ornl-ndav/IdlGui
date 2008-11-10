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

PRO refresh_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

iJob = OBJ_NEW('IDLreadLogFile',Event)
IF (OBJ_VALID(iJob)) THEN BEGIN
    pMetadata = iJob->getStructure()
    nbr_jobs = (size(*pMetadata))(1)

    iDesign = OBJ_NEW('IDLmakeTree', Event, TYPE='tree')
    OBJ_DESTROY, iDesign

    index = 0
    WHILE (index LT nbr_jobs) DO BEGIN
        
;date[0] = (*pMetadata)[0].date
;date[1] = (*pMetadata)[1].date
;list_of_files = (*(*pMetadata)[0].files)
        
        iDesign = OBJ_NEW('IDLmakeTree', $
                          Event, $
                          TYPE='root', $
                          VALUE=(*pMetadata)[index].date)
        OBJ_DESTROY, iDesign
       
;create a leaf for each file
        nbr_files = size((*(*pMetadata)[index].files))
        i = 0
        WHILE (i LT nbr_files) DO BEGIN
;            iDesign = OBJ_NEW('IDLmakeTree', $
;                              Event, $
;                              TYPE='leaf',$
;                              VALUE=(*(*pMetadata)[index].files[i]))
            

;            OBJ_DESTROY, iDesign
            i++
        ENDWHILE
        
        index++
    ENDWHILE
    
    WIDGET_CONTROL, /REALIZE, Event.top
    
ENDIF ELSE BEGIN ;error refreshing the config file

ENDELSE

END
