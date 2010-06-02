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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Author: scu (campbellsi@ornl.gov)
;
;
;==============================================================================

;define path to dependencies and current folder
CD,CURRENT=thisDirectory

; Add all subdirectories onto the path
newPath = EXPAND_PATH('+./') + PATH_SEP(/SEARCH_PATH) + !PATH
;PREF_SET, 'IDL_PATH', newPath, /COMMIT

!PATH = newPath

; Now we can just compile!
.compile get_build_time

.compile logger
.compile error_message
.compile showprogress__define
.compile get_ucams
.compile formatbanknumber
.compile construct_datapaths
.compile get_ideal_elastic_tof
.compile getdetectorbankrange
.compile getcornergeometryfile
.compile getcwpdetectorrange
.compile getdefaultslurmqueue
.compile getfirstnumber
.compile get_seblock_value
.compile expandrunnumbers
.compile expandindividualrunnumbers
.compile gettzero
.compile calcei
.compile getei
.compile calcei_python
.compile getmintimefromprenexus
.compile getmaxtimefromprenexus
.compile getsteptimefromprenexus
.compile getproposalfromprenexus
.compile getentryidentifier
.compile get_runinfo_filename
.compile get_prenexus_directory
.compile get_output_directory
.compile get_maskfile
.compile get_event_filename
.compile get_cwpcache_directory
.compile get_cvinfo_filename
.compile get_beamtimeinfo_filename
.compile calcmslicepsi
.compile getcwpspectrum

.compile monitorjob_events
.compile monitorjob

.compile load_parameters
.compile save_parameters
.compile dgsreduction_updategui
.compile dgsr_updategui
.compile dgsn_updategui
.compile dgsreduction_save_defaults

.compile dgsnorm_launchcollector
.compile dgsnorm_events
.compile dgsreduction_events
.compile dgsreduction_tlb_events
.compile dgsreduction_launchcollector
.compile dgsreduction_launchjobmonitor
.compile dgsreduction_saveparameters
.compile dgsreduction_loadparameters
.compile dgsreduction_exportscript
.compile make_reduction_tab
.compile make_vanmask_tab
.compile dgsreduction
.compile reductioncmd__define
.compile normcmd__define

resolve_all


