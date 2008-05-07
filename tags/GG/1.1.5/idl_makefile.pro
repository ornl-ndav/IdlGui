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

;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/ggGUI/'
.run MakeGuiConfirmationBase.pro
.run MakeGuiFinalResultBase.pro
.run MakeGuiLoadingGeometry.pro
.run MakeGuiInputGeometry.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run gg_get.pro
.run gg_put.pro
.run gg_is.pro
.run gg_GUIupdate.pro
.run gg_time.pro
.run xdisplayfile.pro

;procedures
.run gg_Preview.pro
.run gg_Browse.pro
.run gg_Table.pro
.run gg_ReadXml.pro
.run xmlParser__define.pro
;.run gg_ConfirmationBase.pro
.run gg_ErrorLogBook.pro

;main functions
.run gg_Cleanup.pro
.run MainBaseEvent.pro
.run gg_eventcb.pro
.run gg.pro
