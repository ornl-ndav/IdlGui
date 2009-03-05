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

;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "/utilities"

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + IdlUtilitiesPath
.run system_utilities.pro

;Build REFscale GUI
cd, CurrentFolder + '/REFscaleGUI/'
.run make_gui_step1.pro
.run make_gui_step2.pro
.run make_gui_step3.pro
.run make_gui_output_file.pro
.run make_gui_batch.pro
.run make_gui_main_base_components.pro
.run make_gui_log_book.pro

;Build main procedures
cd, CurrentFolder
.run ref_scale_get.pro
.run procedure_array_delete.pro
.run procedure_ref_scale_arrays.pro
.run procedure_number_formatter.pro
.run procedure_get_numeric.pro
.run ref_scale_put.pro
.run ref_scale_is.pro
.run procedure_idl_send_to_geek.pro
.run idl_get_metadata__define.pro

.run ref_scale_utility.pro
.run procedure_ref_scale_gui.pro
.run ref_scale_fit.pro
.run procedure_ref_scale_step3.pro
.run ref_scale_math.pro
.run ref_scale_file_utility.pro
.run procedure_ref_scale_tof_to_q.pro

.run procedure_ref_scale_openfile.pro
.run procedure_ref_scale_plot.pro
.run procedure_ref_scale_load.pro
.run procedure_ref_scale_step2.pro
.run ref_scale_produce_output.pro
.run procedure_ref_scale_tabs.pro

;Batch
.run idl_load_batch_file__define.pro
.run idl_create_batch_file__define.pro
.run ref_scale_batch.pro
.run idl_parse_command_line__define.pro

.run procedure_main_base_event.pro
.run ref_scale_eventcb.pro
.run ref_scale.pro

