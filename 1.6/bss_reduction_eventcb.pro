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

PRO BSSreduction_CountsVsTofTab, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

current_tab = getCurrentSelectedCountsVsTofTab(Event)
prev_tab = (*global).previous_counts_vs_tof_tab

IF ((*global).NeXusFound) THEN BEGIN
    IF (current_tab NE prev_tab) THEN BEGIN
        IF (current_tab EQ 0) THEN BEGIN
;plot counts vs tof            
;            BSSreduction_PlotCountsVsTofOfSelection, Event
    BSSreduction_DisplayLinLogFullCountsVsTof, Event
        ENDIF 
        (*global).previous_counts_vs_tof_tab = current_tab
    ENDIF
ENDIF
END

;------------------------------------------------------------------------------
PRO BSSreduction_TabRefresh, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

current_tab = getCurrentSelectedMainTab(Event)
prev_tab = (*global).previous_tab

IF (current_tab NE prev_tab) THEN BEGIN
    CASE (current_tab) OF
        0: BEGIN          ;plot bank1, bank2, grid and unselected data
            IF ((*global).NeXusFound AND $
               (*global).NeXusFormatWrong EQ 0) THEN BEGIN
                PlotIncludedPixels, Event
            ENDIF
        END
        1: BEGIN                ;Reduce tab
            BSSreduction_CommandLineGenerator, Event
        END
        2: BEGIN                ;job manager
            create_job_status, Event
        END
        3: BEGIN                ;output_tab
            
            BSSreduction_DisplayOutputFiles, Event 
;in bss_reduction_DisplayOutputFiles
        END
        ELSE:
    ENDCASE
    (*global).previous_tab = current_tab
ENDIF

END

;------------------------------------------------------------------------------
PRO define_default_output_file_name, Event, TYPE=type
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

instrument = 'BSS'
time_stamp = GenerateIsoTimeStamp()
file_name  = instrument + '_'

CASE (type) OF
    'live' : file_name += 'LiveNexus'
    'archive': file_name += STRCOMPRESS((*global).RunNumber)
    ELSE:
ENDCASE

file_name += '_' + time_stamp + '.txt'
putTextInTextField, Event, 'of_list_of_runs_text', file_name

END

;------------------------------------------------------------------------------
pro bss_reduction_eventcb, event
END

;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


