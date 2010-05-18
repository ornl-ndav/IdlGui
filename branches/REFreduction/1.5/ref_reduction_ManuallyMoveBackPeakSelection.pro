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

IF ((*global).DataNeXusFound) THEN BEGIN ;only if there is a NeXus loaded
    
;check what we need to move

;ROI, peak or back
    ROISignalBackZoomStatus = isDataBackPeakZoomSelected(Event)
    CASE (ROISignalBackZoomStatus) OF
        0: BEGIN                ;back or ROI
            type = 'roi_'
        END
        1: BEGIN                ;signal
            type = 'peak_'
        END
        2: BEGIN                ;back
            type = 'back_'
        END
        3: BEGIN                ;zoom
            type = 'zoom'
        END
    ENDCASE
    
;Ymin or Ymax
    YminStatus = isDataYminSelected(Event)
    CASE (YminStatus) OF
        0: BEGIN
            type += 'ymax'
        END
        1: BEGIN
            type += 'ymin'
        END
    ELSE:
    ENDCASE
    
;get ROI Ymin, Ymax
    ROIYmin = getTextFieldValue(Event,'data_d_selection_roi_ymin_cw_field')
    ROIYmax = getTextFieldValue(Event,'data_d_selection_roi_ymax_cw_field')
    IF (RoiYmin EQ '') THEN BEGIN
        RoiYmin = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            RoiYmin *= 2
        ENDIF
    ENDELSE
    IF (RoiYmax EQ '') THEN BEGIN
        RoiYmax = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            RoiYmax *= 2
        ENDIF
    ENDELSE

;get Peak Ymin, Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextfieldValue(Event,'data_d_selection_peak_ymax_cw_field')
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

;;get Background Ymin, Ymax
;    BackYmin = getTextFieldValue(Event, $
;                                 'data_d_selection_background_ymin_cw_field')
;    BackYmax = getTextFieldValue(Event, $
;                                 'data_d_selection_background_ymax_cw_field')
;    IF (BackYmin EQ '') THEN BEGIN
;        BackYmin = -1
;    ENDIF ELSE BEGIN
;        IF (MiniVersion EQ 0) THEN BEGIN
;            BackYmin *= 2
;        ENDIF
;    ENDELSE
;    IF (BackYmax EQ '') THEN BEGIN
;        BackYmax = -1
;    ENDIF ELSE BEGIN
;        IF (MiniVersion EQ 0) THEN BEGIN
;            BackYmax *= 2
;        ENDIF
;    ENDELSE

    CASE (TYPE) OF
        'roi_ymin' : BEGIN
            DataYMouseSelection = RoiYmin
            RoiYmin += coefficient
        END
        'roi_ymax' : BEGIN
            DataYMouseSelection = RoiYmax
            RoiYmax += coefficient
        END
        'back_ymin' : BEGIN
            DataYMouseSelection = BackYmin
            BackYmin += coefficient
        END
        'back_ymax' : BEGIN
            DataYMouseSelection = BackYmax
            BackYmax += coefficient
        END
        'peak_ymin' : BEGIN
            DataYMouseSelection = PeakYmin
            PeakYmin += coefficient
        END
        'peak_ymax' : BEGIN
            DataYMouseSelection = PeakYmax
            PeakYmax += coefficient
        END
        ELSE        : DataYMouseSelection = 0
    ENDCASE

    ROISelection = [ROIYmin,ROIYmax]
    (*(*global).data_roi_selection) = ROISelection

;    BackSelection = [BackYmin,BackYmax]
;    (*(*global).data_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).data_peak_selection) = PeakSelection

;refresh value of cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
;replot selection selected
    RePlot1DDataFile, Event
    ReplotAllSelection, Event

;display zoom if zomm tab is selected
    IF (isDataZoomTabSelected(Event)) THEN BEGIN
        DataXMouseSelection = (*global).DataXMouseSelection
        RefReduction_zoom, $
          Event, $
          MouseX = DataXMouseSelection, $
          MouseY = DataYMouseSelection, $
          fact   = (*global).DataZoomFactor,$
          uname  = 'data_zoom_draw'
    ENDIF
    
ENDIF

END




;############# N O R M A L I Z A T I O N #########################
PRO REFreduction_ManuallyMoveNormBackPeak, Event, coefficient
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

MiniVersion = (*global).miniVersion ;1 for miniVersion, 0 for normal version

if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded

;check what we need to move

;Back or Peak
    BackSignalZoomStatus = isNormBackPeakZoomSelected(Event)
    CASE (BackSignalZoomStatus) OF
        0: BEGIN                ;back or ROI
            type = 'roi_'
        END
        1: BEGIN                ;signal
            type = 'peak_'
        END
        2: BEGIN                ;back
            type = 'back_'
        END
        3: BEGIN                ;zoom
            type = 'zoom'
        END
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

;get ROI Ymin, Ymax
    ROIYmin = getTextFieldValue(Event,'norm_d_selection_roi_ymin_cw_field')
    ROIYmax = getTextFieldValue(Event,'norm_d_selection_roi_ymax_cw_field')
    IF (RoiYmin EQ '') THEN BEGIN
        RoiYmin = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            RoiYmin *= 2
        ENDIF
    ENDELSE
    IF (RoiYmax EQ '') THEN BEGIN
        RoiYmax = -1
    ENDIF ELSE BEGIN
        IF (MiniVersion EQ 0) THEN BEGIN
            RoiYmax *= 2
        ENDIF
    ENDELSE
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'norm_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'norm_d_selection_peak_ymax_cw_field')

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

;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'norm_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'norm_d_selection_background_ymax_cw_field')

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

    CASE (TYPE) OF
        'roi_ymin' : BEGIN
            NormYMouseSelection = RoiYmin
            RoiYmin += coefficient
        END
        'roi_ymax' : BEGIN
            NormYMouseSelection = RoiYmax
            RoiYmax += coefficient
        END
        'back_ymin' : BEGIN
            NormYMouseSelection = BackYmin
            BackYmin += coefficient
        END
        'back_ymax' : BEGIN
            NormYMouseSelection = BackYmax
            BackYmax += coefficient
        END
        'peak_ymin' : BEGIN
            NormYMouseSelection = PeakYmin
            PeakYmin += coefficient
        END
        'peak_ymax' : BEGIN
            NormYMouseSelection = PeakYmax
            PeakYmax += coefficient
        END
        ELSE        : NormYMouseSelection = 0
    ENDCASE

    ROISelection = [ROIYmin,ROIYmax]
    (*(*global).norm_roi_selection) = ROISelection

    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
;refresh value of cw_field
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
;replot selection selected
    Replot1DNormFile, event
    ReplotNormAllSelection, event

;display zoom if zomm tab is selected
    IF (isNormZoomTabSelected(Event)) THEN BEGIN
        NormXMouseSelection = (*global).NormXMouseSelection
        RefReduction_zoom, $
          Event, $
          MouseX = NormXMouseSelection, $
          MouseY = NormYMouseSelection, $
          fact   = (*global).NormalizationZoomFactor,$
          uname  = 'normalization_zoom_draw'
    ENDIF

ENDIF

END















