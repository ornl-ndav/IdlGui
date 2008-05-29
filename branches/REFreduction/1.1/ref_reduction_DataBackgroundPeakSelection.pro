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
;this function takes two arrays of 2 elements and replot the 
;Background and Peak selection on top of Data 1D
PRO ReplotDataBackPeakSelection, Event, BackArray, PeakArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear full draw window
id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

RePlot1DDataFile, Event

xsize_1d_draw = (*global).Ntof_DATA-1
;back
color = (*global).back_selection_color
y_array = (*(*global).data_back_selection)

if (y_array[0] NE -1) then begin
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
endif

if (y_array[1] NE -1) then begin
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif

;peak
color = (*global).peak_selection_color
y_array = (*(*global).data_peak_selection)
if (y_array[0] NE -1) then begin
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
endif

if (y_array[1] NE -1) then begin
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif

END





;This functions retrieves the value of ymin, ymax of Back and peak
;text boxes and stores them in their global pointers, and replot
;the background region and peak exclusion region
PRO REFreduction_DataBackgroundPeakSelection, Event, TYPE

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNeXusFound) then begin ;only if there is a NeXus loaded

    if ((*global).miniVersion) then begin
        coeff = 1
    endif else begin
        coeff = 2
    endelse

;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event, $
                                 'data_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event, $
                                 'data_d_selection_background_ymax_cw_field')
    
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
    (*(*global).data_back_selection) = BackSelection

;get Peak Ymin, Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextfieldValue(Event,'data_d_selection_peak_ymax_cw_field')

;update REDUCE tab
    putTextFieldValue, Event, $
      'data_exclusion_low_bin_text', $
      strcompress(PeakYmin),0
    putTextFieldValue, Event, $
      'data_exclusion_high_bin_text', $
      strcompress(PeakYmax),0

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
    (*(*global).data_peak_selection) = PeakSelection
    
    putDataBackgroundPeakYMinMaxValueInTextFields, Event
    ReplotDataBackPeakSelection, Event, BackSelection, PeakSelection

    if (n_elements(TYPE) EQ 1) then begin

        CASE (TYPE) OF
            'back_ymin' : DataYMouseSelection = BackYmin
            'back_ymax' : DataYMouseSelection = BackYmax
            'peak_ymin' : DataYMouseSelection = PeakYmin
            'peak_ymax' : DataYMouseSelection = PeakYmax
            else        : DataYMouseSelection = 0
        ENDCASE

    endif else begin

        DataYMouseSelection = 0

    endelse
        
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
