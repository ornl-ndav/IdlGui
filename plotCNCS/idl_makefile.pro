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

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run IDLnexusUtilities__define.pro
.run logger.pro
.run showprogress__define.pro
.run IDLxmlParser__define.pro
.run tube_angle.pro
.run colorbar.pro
.run fsc_color.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/plotCNCSGUI/'
.run MakeGuiInputBase.pro
.run IDLloadNexus__define.pro
.run MakeGuiMainPlot.pro
.run MakeGuiBankPlot.pro
.run MakeGuiTofBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run plot_cncs_get.pro
.run plot_cncs_time.pro
.run plot_cncs_put.pro
.run plot_cncs_is.pro

;procedures
;first base
.run plot_cncs_Input.pro
.run plot_cncs_Browse.pro
.run plot_cncs_PreviewRuninfoFile.pro
.run plot_cncs_CollectHistoInfo.pro
.run plot_cncs_GUIupdate.pro
.run plot_cncs_CreateHistoMapped.pro
.run plot_cncs_SaveAsHistoMapped.pro
.run plot_cncs_SendToGeek.pro
.run plot_cncs_counts_vs_tof_base.pro

;Nexus tab
.run plot_cncs_Nexus.pro

;main plot base
.run plot_cncs_counts_vs_tof_info_base.pro
.run plot_cncs_PlotMainPlot.pro
.run plot_cncs_MainPlot.pro
.run MakeGuiMainPlot_event.pro
.run plot_cncs_display_buttons_main_plot.pro
.run plot_cncs_update_selection_mode.pro
.run plot_cncs_plot_scale.pro
.run plot_cncs_play_tof.pro
.run plot_cncs_play_buttons.pro
.run plot_cncs_masking_region.pro

;mask base
.run plot_cncs_save_mask_base.pro
.run plot_cncs_load_mask_base.pro

;bank plot base
.run plot_cncs_PlotBank.pro
.run plot_cncs_PlotBankEventcb.pro

;tof plot base
.run plot_cncs_PlotTof.pro
.run plot_cncs_PlotTofEventcb.pro

;main functions
.run MainBaseEvent.pro
.run plot_cncs_eventcb.pro
.run plot_cncs.pro
