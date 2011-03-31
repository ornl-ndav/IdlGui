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
;text boxes and stores them in their global pointers, and replot
;the background region and peak exclusion region
PRO REFreduction_DataBackgroundPeakSelection, Event, TYPE

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;  ;reset plot
  REFReduction_RescaleDataPlot, Event
  ;  ;RePlot1DDataFile, Event
  
  IF ((*global).DataNeXusFound) THEN BEGIN ;only if there is a NeXus loaded
  
    IF ((*global).miniVersion) THEN BEGIN
      coeff = 1
    ENDIF ELSE BEGIN
      coeff = 2
    ENDELSE
    
    ;get ROI Ymin, Ymax
    ROIYmin = getTextFieldValue(Event, $
      'data_d_selection_roi_ymin_cw_field')
    ROIYmax = getTextFieldValue(Event, $
      'data_d_selection_roi_ymax_cw_field')
      
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
    (*(*global).data_roi_selection) = ROISelection
    
    ;get Peak Ymin, Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextfieldValue(Event,'data_d_selection_peak_ymax_cw_field')
    
    IF (PeakYmin EQ '') THEN BEGIN
      PeakYmin = -1
    ENDIF ELSE BEGIN
      PeakYmin *= coeff
    ENDELSE
    
    IF (PeakYmax EQ '') THEN BEGIN
      PeakYmax = -1
    ENDIF ELSE BEGIN
      PeakYmax *= coeff
    ENDELSE
    
    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).data_peak_selection) = PeakSelection
    
    ;    ;get Background Ymin, Ymax
    ;    BackYmin = getTextFieldValue(Event, $
    ;      'data_d_selection_background_ymin_cw_field')
    ;    BackYmax = getTextFieldValue(Event, $
    ;      'data_d_selection_background_ymax_cw_field')
    ;
    ;    IF (BackYmin EQ '') THEN BEGIN
    ;      BackYmin = -1
    ;    ENDIF ELSE BEGIN
    ;      BackYmin *= coeff
    ;    ENDELSE
    ;
    ;    IF (BackYmax EQ '') THEN BEGIN
    ;      BackYmax = -1
    ;    ENDIF ELSE BEGIN
    ;      BackYmax *= coeff
    ;    ENDELSE
    ;
    ;    BackSelection = [BackYmin,BackYmax]
    ;    (*(*global).data_back_selection) = BackSelection
    
    ;refresh value of cw_fields
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
    
    REFReduction_RescaleDataPlot, Event
    
    ;Replot selection selected
    ReplotAllSelection, Event
    
    IF (N_ELEMENTS(TYPE) EQ 1) THEN BEGIN
      CASE (TYPE) OF
        'roi_ymin'  : DataYMouseSelection = ROIYmin
        'roi_ymax'  : DataYMouseSelection = ROIYmax
        'peak_ymin' : DataYMouseSelection = PeakYmin
        'peak_ymax' : DataYMouseSelection = PeakYmax
        'back_ymin' : DataYMouseSelection = BackYmin
        'back_ymax' : DataYMouseSelection = BackYmax
      ELSE        : DataYMouseSelection = 0
    ENDCASE
  ENDIF ELSE BEGIN
    DataYMouseSelection = 0
  ENDELSE
  
  ;display zoom if zoom tab is selected
  if (isDataZoomTabSelected(Event)) then begin
  
    DataXMouseSelection = (*global).DataXMouseSelection
    RefReduction_zoom, $
      Event, $
      MouseX = DataXMouseSelection, $
      MouseY = DataYMouseSelection, $
      fact   = (*global).DataZoomFactor,$
      uname  = 'data_zoom_draw'
      
  endif
  
endif

END
