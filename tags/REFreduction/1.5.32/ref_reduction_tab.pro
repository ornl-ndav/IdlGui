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

;+
; :Description:
;    This function is reached by the Data background selection tab
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro greg_selection_tab_event, event
  compile_opt idl2
  
  tab_index = event.tab
  case (tab_index) of
    0: begin ;Peak is inside Back. ROI
      REFReduction_RescaleDataPlot, Event
      plot_data_peak_value, event
      plot_back_value, event
    end
    1: begin ;Peak is outside Back. ROIs
      refresh_greg_selection, event,  /refresh_peak, /refresh_main_plot
    end
  endcase
  
    widget_control, event.top, get_uvalue=global
  IF ((*global).DataNeXusFound) THEN BEGIN
    bring_to_life_or_refresh_counts_vs_pixel, event
  endif
  
end

;this function is trigerred each time the user changes tab (main tabs)
PRO tab_event, Event
  ;get global structure
  widget_control,Event.top,get_uvalue=global
  
  tab_id = widget_info(Event.top,find_by_uname='main_tab')
  CurrTabSelect = widget_info(tab_id,/tab_current)
  PrevTabSelect = (*global).PrevTabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
      0: BEGIN
      
      ;        tab_id = widget_info(Event.top, $
      ;          find_by_uname='data_normalization_tab')
      ;        CurrDNECtabSelect = widget_info(tab_id,/tab_current)
      ;        PrevDNECtabSelect = (*global).PrevDNECtabSelect
      ;        IF(CurrDNECtabSelect NE PrevDNECtabSelect) THEN BEGIN
      ;        endif
      
      END
      1: BEGIN                ;if REDUCE tab is now selected
        REFreduction_CommandLineGenerator, Event
      END
      2: BEGIN                ;if PLOTS tab is now selected
        IF ((*global).DataReductionStatus EQ 'OK' OR $
          (*global).ascii_file_load_status) THEN BEGIN
          ;data reduction was successful
          rePlotAsciiData, Event
        ENDIF
      END
      3: BEGIN                ;if BATCH tab is now selected
        ;retrieve info for batch mode
        IF ((*global).debugger) THEN BEGIN
          UpdateBatchTable, Event ;in ref_reduction_BatchTab.pro
        ENDIF
      END
      ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
  ENDIF
END
;==============================================================================

;This function is trigerred each time the user changes the NXsummary
;and zoom tab of the data tab
PRO REFreduction_DataNxsummaryZoomTab, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  tab_id = widget_info(Event.top,find_by_uname='data_nxsummary_zoom_tab')
  CurrTabSelect = widget_info(tab_id,/tab_current)
  PrevTabSelect = (*global).PrevDataZoomTabSelect
  
  if (PrevTabSelect NE CurrTabSelect) then begin
    CASE (CurrTabSelect) OF
      1: begin ;if Zoom tab selected
        putTextFieldValue,$
          Event,$
          'data_zoom_scale_cwfield',$
          (*global).DataZoomFactor,$
          0 ;do not append
          
        REFreduction_ZoomRescaleData, Event
        
      END
      else:
    ENDCASE
    (*global).PrevDataZoomTabSelect = CurrTabSelect
  endif
END

;==============================================================================
;This function is trigerred each time the user changes the NXsummary
;and zoom tab of the normalization tab
PRO REFreduction_NormNxsummaryZoomTab, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  tab_id = widget_info(Event.top, $
    find_by_uname='normalization_nxsummary_zoom_tab')
  CurrTabSelect = widget_info(tab_id,/tab_current)
  PrevTabSelect = (*global).PrevNormZoomTabSelect
  
  if (PrevTabSelect NE CurrTabSelect) then begin
    CASE (CurrTabSelect) OF
      1: begin ;if Zoom tab selected
        putTextFieldValue,$
          Event,$
          'normalization_zoom_scale_cwfield',$
          (*global).NormalizationZoomFactor,$
          0 ;do not append
          
        REFreduction_ZoomRescaleNormalization, Event
        
      END
      else:
    ENDCASE
    (*global).PrevNormZoomTabSelect = CurrTabSelect
  endif
END

;==============================================================================

;------------------------------------------------------------------------------
;This procedure is reached each time the user changed a tab of the
;plot in the data tab
PRO data_plots_tab_event, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  info_base_status = 0
  
  IF ((*global).DataNexusFound) THEN BEGIN
  
    tab_id = widget_info(Event.top,find_by_uname='load_data_d_dd_tab')
    CurrTabSelect = widget_info(tab_id,/tab_current)
    PrevTabSelect = (*global).PrevDataTabSelect
    
    CASE (CurrTabSelect) OF
      0: info_base_status = 1
      ELSE:
    ENDCASE
    
    IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
      CASE (CurrTabSelect) OF
        2: BEGIN            ;Y vs X (2D)
          IF ((*global).data_loadct_contrast_changed) THEN BEGIN
            refreshPlot2DDataFile, Event
            (*global).data_loadct_contrast_changed = 0
          ENDIF
        END
        ELSE:
      ENDCASE
      (*global).PrevDataTabSelect = CurrTabSelect
    ENDIF
    
  ENDIF
  
;MapBase, Event, 'info_data_base', info_base_status
  
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changed a tab of the
;plot in the normalization tab
PRO norm_plots_tab_event, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  info_base_status = 0
  
  IF ((*global).NormNexusFound EQ 1) THEN BEGIN
  
    tab_id = widget_info(Event.top,find_by_uname='load_normalization_d_dd_tab')
    CurrTabSelect = widget_info(tab_id,/tab_current)
    PrevTabSelect = (*global).PrevNormTabSelect
    
    CASE (CurrTabSelect) OF
      0: info_base_status = 1
      ELSE:
    ENDCASE
    
    IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
      CASE (CurrTabSelect) OF
        2: BEGIN            ;Y vs X (2D)
          IF ((*global).norm_loadct_contrast_changed) THEN BEGIN
            refresh_Plot2DNormalizationFile, Event
            (*global).norm_loadct_contrast_changed = 0
          ENDIF
        END
        ELSE:
      ENDCASE
      (*global).PrevNormTabSelect = CurrTabSelect
    ENDIF
    
  ENDIF
  
;MapBase, Event, 'info_norm_base', info_base_status
  
END

