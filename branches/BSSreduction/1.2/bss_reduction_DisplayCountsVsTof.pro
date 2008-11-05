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

PRO BSSreduction_DisplayCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF ((*global).NeXusFound) THEN BEGIN
    
;retrieve bank, x and y infos
    bank    = getBankValue(Event)
    X       = getXValue(Event)
    Y       = getYValue(Event)
    PixelID = getPixelIDvalue(Event)
    
;display X, Y, Bank and pixelID value in counts vs tof info box
    putCountsVsTofBankValue, Event, bank[0]
    putCountsVsTofXValue, Event, X[0]
    putCountsVsTofYValue, Event, Y[0]
    putCountsVsTofPixelIDValue, Event, PixelID[0]
    
    (*global).counts_vs_tof_x = X
    (*global).counts_vs_tof_y = Y
    (*global).counts_vs_tof_bank = bank
    
    IF (bank EQ 1) THEN BEGIN   ;bank1
        bank = (*(*global).bank1)
    ENDIF ELSE BEGIN            ;bank2
        bank = (*(*global).bank2)
    ENDELSE
    
    data = bank(*,Y,X)
    
;plot data (counts vs tof)
    view_info = widget_info(Event.top,FIND_BY_UNAME='counts_vs_tof_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    IF ((*global).PrevLinLogValue) THEN BEGIN ;log
        plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
    ENDIF ELSE BEGIN
        plot, data, POSITION=[0.1,0.1,0.95,0.99]
    ENDELSE
    
ENDIF

END
