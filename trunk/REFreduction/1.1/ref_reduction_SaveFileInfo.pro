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

;This functions save the metadata of the files
PRO RefReduction_SaveFileInfo, Event, file_name, NbrLine
;get global structure
id = WIDGET_INFO(EVENT.TOP, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

fltPreview_ptr = (*(*global).fltPreview_ptr)

WriteError = 0
CATCH, WriteError ;remove_comments
IF (WriteError NE 0) THEN BEGIN
    ;did not work
    info_array = STRARR(1)
ENDIF ELSE BEGIN
    no_file = 0
    catch, no_file
    IF (no_file NE 0) THEN BEGIN
        CATCH,/CANCEL
        plot_file_found = 0    
    ENDIF ELSE BEGIN
        OPENR,u,file_name,/GET
        fs = FSTAT(u)
;define an empty string variable to hold results from reading the file
        tmp = ''
        info_array = STRARR(NbrLine)
        FOR i=0,((*global).PreviewFileNbrLine-1) DO BEGIN
            READF,u,tmp
            info_array[i] = tmp
        ENDFOR
        CLOSE,u
        FREE_LUN,u
    ENDELSE

ENDELSE                         ;end of Catch if statement
(*(*global).fltPreview_ptr) = info_array
END




;This functions save the metadata of the XML file
PRO RefReduction_SaveXmlInfo, Event, xmlFile
;get global structure
id = WIDGET_INFO(EVENT.TOP, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

fltPreview_xml_ptr = (*(*global).fltPreview_xml_ptr)

no_file = 0
CATCH, no_file ;remove_comments
info_array = STRARR(1) 
IF (no_file NE 0) THEN BEGIN
    CATCH,/CANCEL
    plot_file_found = 0    
ENDIF ELSE BEGIN
    OPENR,u,xmlFile,/GET
;define an empty string variable to hold results from reading the file
    tmp = ''

    WHILE (NOT EOF(u)) DO BEGIN
        READF,u,tmp
        info_array = [info_array,tmp]
    ENDWHILE
    CLOSE,u
    FREE_LUN,u
ENDELSE
(*(*global).fltPreview_xml_ptr) = info_array
END
