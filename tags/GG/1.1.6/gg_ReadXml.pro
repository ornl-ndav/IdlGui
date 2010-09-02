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

PRO ReadXmlFile, Event  ;full reset of intput file
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file = (*global).tmp_xml_file

xmlFile = OBJ_NEW('xmlParser')
xmlFile->ParseFile, file

motors = xmlFile->GetArray()

;help, motors
(*(*global).motors)           = motors
(*(*global).motor_group)      = motors
(*(*global).untouched_motors) = motors
sz = (size(motors))(1)

;create table
FinalArray = gg_createTableArray(Event, motors)
;populate Table array
populateTable, Event, FinalArray

;nbr of lines
sz = (size(FinalArray))(2)
;reset nbr of lines
TableNbrLines, Event, sz

;display data of first element selected (top one)
displayDataOfFirstElement, Event, motors

;check if motors is structure or not
;if not, disable table and interactive part
type= (size(motors))(2)
IF (type EQ 8) THEN BEGIN
;activate gui
    activateTableGui, Event, 1
    activateTreeGui, Event, 1
;    sensitive_widget, Event, 'create_geometry_file_button', 1
    sensitive_widget, Event, 'full_reset_button', 1
ENDIF ELSE BEGIN
    activateTableGui, Event, 0
    activateTreeGui, Event, 0
;disable button that creates geometry
;    sensitive_widget, Event, 'create_geometry_file_button', 0
    sensitive_widget, Event, 'full_reset_button', 0
ENDELSE

;select first element in tree
selectTreeRoot, Event

;select first line in table
selectFirstTableLine, Event

END
