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
.run put.pro
.run get.pro
.run set.pro
.run is.pro
;.run gui.pro
.run get_ucams.pro
.run IDLxmlParser__define.pro
.run logger.pro
.run IDL3columnsASCIIparser__define.pro
.run xdisplayfile.pro
.run convert.pro
.run colorbar.pro
.run fsc_color.pro

;Build REFscale GUI
cd, CurrentFolder + '/REFscaleOFFGUI/'
.run tab_designer.pro
.run menu_designer.pro

;Build main procedures
cd, CurrentFolder

;functions (tab#1)
.run load_rtof_file.pro
;procedures (tab#1)
.run load_files_button.pro
.run load_files.pro
.run delete_data_set.pro
.run preview_files.pro
.run plot_rtof_files.pro
.run pixel_vs_tof_individual_plots_base.pro
.run cursor_info_base.pro
.run counts_vs_axis_base.pro
.run individual_plot_eventcb.pro
.run menu_eventcb.pro
.run plot_colorbar.pro
.run auto_scale.pro
.run manual_scale.pro
.run create_scaled_big_array.pro
.run save_background.pro
.run check_status_buttons.pro
.run create_output.pro

;output tab
.run output_tab_event.pro

.run ref_off_scale_cleanup.pro
.run main_base_event.pro
.run ref_scale_off.pro

