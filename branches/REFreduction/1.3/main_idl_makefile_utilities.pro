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

spawn, 'pwd', CurrentFolder

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + '/utilities'

;Makefile that automatically compile the necessary modules
;and create the VM file.
.run nexus_utilities.pro
.run get.pro
.run system_utilities.pro
.run nexus_utilities.pro
.run math_conversion.pro
.run time.pro
.run list_of_proposal.pro
.run IDLxmlParser__define.pro
.run xmlParser__define.pro
.run logger.pro
.run file_utilities.pro
.run xdisplayfile.pro
.run fsc_color.pro
.run IDL3columnsASCIIparser__define.pro
.run NeXusMetadata__define.pro
.run is.pro

cd, CurrentFolder + 'TOFselectionBase'
.run tof_selection_input_base.pro
.run tof_selection_colorbar.pro
.run tof_selection_counts_vs_pixel_base.pro
.run tof_selection_eventcb.pro
.run tof_selection_base.pro