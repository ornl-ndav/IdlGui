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
;Populate an array that list the intermediate plots the user wants to see
PRO PopulateIntermPLotsArray, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IntermPlots = (*global).IntermPlots

;get status of all buttons
InterPlotsStatus = getCWBgroupValue(Event, 'intermediate_plot_list')

;Data Specular Intermediate Plot
if (InterPlotsStatus[0] EQ 1) then begin
    IntermPlots[0] = 1
endif else begin
    IntermPlots[0] = 0
endelse

;Data Background Plot
if (isBaseMap(Event,'reduce_plot2_base') EQ 0 AND $
    InterPlotsStatus[1] EQ 1) then begin
    IntermPlots[1] = 1
endif else begin
    IntermPlots[1] = 0
endelse

;Data Sub Plot
if (isBaseMap(Event,'reduce_plot3_base') EQ 0 AND $
    InterPlotsStatus[2] EQ 1) then begin
    IntermPlots[2] = 1
endif else begin
    IntermPlots[2] = 0
endelse

;Normalization Specular Intermediate Plot
if (isBaseMap(Event,'reduce_plot4_base') EQ 0 AND $
    InterPlotsStatus[3] EQ 1) then begin
    IntermPlots[3] = 1
endif else begin
    IntermPlots[3] = 0
endelse

;Normalization Background Plot
if (isBaseMap(Event,'reduce_plot5_base') EQ 0 AND $
    InterPlotsStatus[4] EQ 1) then begin
    IntermPlots[4] = 1
endif else begin
    IntermPlots[4] = 0
endelse

;Normalization Sub Plot
if (isBaseMap(Event,'reduce_plot6_base') EQ 0 AND $
    InterPlotsStatus[5] EQ 1) then begin
    IntermPlots[5] = 1
endif else begin
    IntermPlots[5] = 0
endelse

;rtof uncombined
if (InterPlotsStatus[6] EQ 1) then begin
    IntermPlots[6] = 1
endif else begin
    IntermPlots[6] = 0
endelse

;rtof_combined plot
if (InterPlotsStatus[7] EQ 1) then begin
    IntermPlots[7] = 1
endif else begin
    IntermPlots[7] = 0
endelse

;Emtpy cell R vs TOF plot
IF (isBaseMap(Event,'reduce_plot8_base') EQ 0 AND $
    InterPlotsStatus[8] EQ 1) THEN BEGIN
   IntermPlots[8] = 1
ENDIF ELSE BEGIN
   IntermPlots[8] = 0
ENDELSE

(*global).IntermPlots = IntermPlots

END

;------------------------------------------------------------------------------
;This function creates the Intermediate Plots part of the command line
FUNCTION RefReduction_CommandLineIntermediatePlotsGenerator, Event

;get status of all buttons
InterPlotsStatus = getCWBgroupValue(Event, 'intermediate_plot_list')

IP_cmd = ''
;Data and Normalization Specular Intermediate Plot
IF (InterPlotsStatus[0] EQ 1 OR $
    ((isBaseMap(Event,'reduce_plot4_base') EQ 0) AND $
     InterPlotsStatus[3] EQ 1)) then begin
    IP_cmd += ' --dump-specular'
endif 

;Data and Normalization Background Plot
if (isBaseMap(Event,'reduce_plot2_base') EQ 0 OR $
    isBaseMap(Event,'reduce_plot5_base') EQ 0) then begin ;plot available
    if (InterPlotsStatus[1] EQ 1 OR $
        InterPlotsStatus[4] EQ 1) then begin
        IP_cmd += ' --dump-bkg'
    endif
endif

;Data and Normalization Sub Plot
if (isBaseMap(Event,'reduce_plot3_base') EQ 0 OR $
    isBaseMap(Event,'reduce_plot6_base') EQ 0) then begin ;plot available
    if (InterPlotsStatus[2] EQ 1 OR $
        InterPlotsStatus[5] EQ 1) then begin
        IP_cmd += ' --dump-sub'
    endif
endif

;rtof plot
if (InterPlotsStatus[6] EQ 1) then begin
    IP_cmd += ' --dump-rtof'
endif

;rtof combined plot
if (InterPlotsStatus[7] EQ 1) then begin
    IP_cmd += ' --dump-rtof-comb'
endif

;empty cell R vs TOF plot
IF (InterPlotsStatus[8] EQ 1) THEN BEGIN
   IP_cmd += ' --dump-ecell-rtof'
ENDIF

;create array of Intermediate files to plot
PopulateIntermPLotsArray, Event

;refresh PLOTS drop list
;RefReduction_updatePlotsDropList, Event

return, IP_cmd
END

