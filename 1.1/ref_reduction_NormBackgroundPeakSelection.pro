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

;This functions retrieves the value of ymin, ymax of Back and peak
;text boxes and stores them in their global pointers
PRO REFreduction_NormBackgroundPeakSelection, Event, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset plot
REFReduction_RescaleNormalizationPlot,Event

if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded

    if ((*global).miniVersion) then begin
        coeff = 1
    endif else begin
        coeff = 2
    endelse
    
;get ROI Ymin, Ymax
    ROIYmin = getTextFieldValue(Event, $
                                 'norm_d_selection_roi_ymin_cw_field')
    ROIYmax = getTextFieldValue(Event, $
                                 'norm_d_selection_roi_ymax_cw_field')
    
    IF (ROIYmin EQ '') THEN BEGIN
        ROIYmin = -1
    ENDIF ELSE BEGIN
        ROIYmin *= coeff
    ENDELSE

    IF (ROIYmax EQ '') THEN BEGIN
        ROIYmax = -1
    ENDIF ELSE BEGIN
        ROIYmax *= coeff
    ENDELSE

    ROISelection = [ROIYmin,ROIYmax]
    (*(*global).norm_roi_selection) = ROISelection

;get Peak Ymin and Ymax
    PeakYmin = $
      getTextFieldValue(Event, $
                        'norm_d_selection_peak_ymin_cw_field')
    PeakYmax = $
      getTextFieldValue(Event, $
                        'norm_d_selection_peak_ymax_cw_field')

    if (PeakYmin EQ '') then begin
        PeakYmin = -1
    endif else begin
        PeakYmin *= coeff
    endelse

    if (PeakYmax EQ '') then begin
        PeakYmax = -1
    endif else begin
        PeakYmax *= coeff
    endelse

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
;get Background Ymin, Ymax
    BackYmin = $
      getTextFieldValue(Event, $
                        'norm_d_selection_background_ymin_cw_field')
    BackYmax = $
      getTextFieldValue(Event, $
                        'norm_d_selection_background_ymax_cw_field')

    if (BackYmin EQ '') then begin
        BackYmin = -1
    endif else begin
        BackYmin *= coeff
    endelse

    if (BackYmax EQ '') then begin
        BackYmax = -1
    endif else begin
        BackYmax *= coeff
    endelse

    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection
    
;refresh value of cw_fields
    putNormBackgroundPeakYMinMaxValueInTextFields, Event

;Replot selection selected
    ReplotNormAllSelection, Event

    if (n_elements(TYPE) EQ 1) then begin
        
        CASE (TYPE) OF
            'roi_ymin'  : NormYMouseSelection = ROIYmin
            'roi_ymax'  : NormYMouseSelection = ROIYmax
            'back_ymin' : NormYMouseSelection = BackYmin
            'back_ymax' : NormYMouseSelection = BackYmax
            'peak_ymin' : NormYMouseSelection = PeakYmin
            'peak_ymax' : NormYMouseSelection = PeakYmax
            ELSE        : NormYMouseSelection = 0
        ENDCASE
    ENDIF ELSE BEGIN
        NormYMouseSelection = 0
    ENDELSE

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
