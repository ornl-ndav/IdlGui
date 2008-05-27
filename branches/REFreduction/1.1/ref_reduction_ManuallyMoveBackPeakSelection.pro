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

PRO REFreduction_ManuallyMoveDataBackPeakUp, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveDataBackPeak, Event, coefficient
END

PRO REFreduction_ManuallyMoveDataBackPeakDown, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveDataBackPeak, Event, -coefficient
END

PRO REFreduction_ManuallyMoveNormBackPeakUp, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveNormBackPeak, Event, coefficient
END

PRO REFreduction_ManuallyMoveNormBackPeakDown, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveNormBackPeak, Event, -coefficient
END



;############# D A T A #########################################
PRO REFreduction_ManuallyMoveDataBackPeak, Event, coefficient
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

MiniVersion = (*global).miniVersion ;1 for miniVersion, 0 for normal version

if ((*global).DataNeXusFound) then begin ;only if there is a NeXus loaded
    
;check what we need to move

;Back or Peak
    BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
    CASE (BackSignalZoomStatus) OF
        0: begin                ;back
            type = 'back_'
        end
        1: begin                ;signal
            type = 'peak_'
        end
        2: begin                ;zoom
            type = 'zoom'
        end
        ELSE:
    ENDCASE
    
;Ymin or Ymax
    YminStatus = isDataYminSelected(Event)
    CASE (YminStatus) OF
        0: begin
            type += 'ymax'
        end
        1: begin
            type += 'ymin'
        end
    else:
    ENDCASE
    
;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'data_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'data_d_selection_background_ymax_cw_field')

    if (BackYmin EQ '') then begin
        BackYmin = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmin *= 2
        ENDIF
    endelse
    if (BackYmax EQ '') then begin
        BackYmax = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmax *= 2
        ENDIF
    endelse

;get Peak Ymin, Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextfieldValue(Event,'data_d_selection_peak_ymax_cw_field')
    
    if (PeakYmin EQ '') then begin
        PeakYmin = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmin *= 2
        ENDIF
    endelse

    if (PeakYmax EQ '') then begin
        PeakYmax = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmax *= 2
        ENDIF
    endelse

    CASE (TYPE) OF
        'back_ymin' : begin
            DataYMouseSelection = BackYmin
            BackYmin += coefficient
        end
        'back_ymax' : begin
            DataYMouseSelection = BackYmax
            BackYmax += coefficient
        end
        'peak_ymin' : begin
            DataYMouseSelection = PeakYmin
            PeakYmin += coefficient
        end
        'peak_ymax' : begin
            DataYMouseSelection = PeakYmax
            PeakYmax += coefficient
        end
        else        : DataYMouseSelection = 0
    ENDCASE

    BackSelection = [BackYmin,BackYmax]
    (*(*global).data_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).data_peak_selection) = PeakSelection

    putDataBackgroundPeakYMinMaxValueInTextFields, Event

    ReplotDataBackPeakSelection, Event, BackSelection, PeakSelection

;display zoom if zomm tab is selected
    if (isDataZoomTabSelected(Event)) then begin

        DataXMouseSelection = (*global).DataXMouseSelection
        
        RefReduction_zoom, $
          Event, $
          MouseX=DataXMouseSelection, $
          MouseY=DataYMouseSelection, $
          fact=(*global).DataZoomFactor,$
          uname='data_zoom_draw'

    endif
    
endif

END




;############# N O R M A L I Z A T I O N #########################
PRO REFreduction_ManuallyMoveNormBackPeak, Event, coefficient
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

MiniVersion = (*global).miniVersion ;1 for miniVersion, 0 for normal version

if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded

;check what we need to move

;Back or Peak
    BackSignalZoomStatus = isNormBackPeakZoomSelected(Event)
    CASE (BackSignalZoomStatus) OF
        0: begin                ;back
            type = 'back_'
        end
        1: begin                ;signal
            type = 'peak_'
        end
        2: begin                ;zoom
            type = 'zoom'
        end
        ELSE:
    ENDCASE
    
;Ymin or Ymax
    YminStatus = isNormYminSelected(Event)
    CASE (YminStatus) OF
        0: begin
            type += 'ymax'
        end
        1: begin
            type += 'ymin'
        end
    else:
    ENDCASE

;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'normalization_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'normalization_d_selection_background_ymax_cw_field')

    IF (BackYmin EQ '') THEN BEGIN
        BackYmin = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmin *= 2
        ENDIF
    ENDELSE

    IF (BackYmax EQ '') THEN BEGIN
        BackYmax = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmax *= 2
            ENDIF
    ENDELSE
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'normalization_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'normalization_d_selection_peak_ymax_cw_field')

    IF (PeakYmin EQ '') THEN BEGIN
        PeakYmin = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmin *= 2
        ENDIF
    ENDELSE

    IF (PeakYmax EQ '') THEN BEGIN
        PeakYmax = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmax *= 2
        ENDIF
    ENDELSE

    CASE (TYPE) OF
        'back_ymin' : begin
            NormYMouseSelection = BackYmin
            BackYmin += coefficient
        end
        'back_ymax' : begin
            NormYMouseSelection = BackYmax
            BackYmax += coefficient
        end
        'peak_ymin' : begin
            NormYMouseSelection = PeakYmin
            PeakYmin += coefficient
        end
        'peak_ymax' : begin
            NormYMouseSelection = PeakYmax
            PeakYmax += coefficient
        end
        else        : NormYMouseSelection = 0
    ENDCASE

    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
    ReplotNormBackPeakSelection, Event, BackSelection, PeakSelection

;display zoom if zomm tab is selected
    if (isNormZoomTabSelected(Event)) then begin

        NormXMouseSelection = (*global).NormXMouseSelection
                
        RefReduction_zoom, $
          Event, $
          MouseX=NormXMouseSelection, $
          MouseY=NormYMouseSelection, $
          fact=(*global).NormalizationZoomFactor,$
          uname='normalization_zoom_draw'
    endif

endif

END















