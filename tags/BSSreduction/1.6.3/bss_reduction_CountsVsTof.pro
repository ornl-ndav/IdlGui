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

PRO BSSreduction_LinLogCountsVsTof, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get current selected value (lin or log)
  CurrentValueSelected = getLinLogValue(Event)
  PrevValueSelected = (*global).PrevLinLogValue
  
  IF (CurrentValueSelected NE PrevValueSelected) THEN BEGIN
    (*global).PrevLinLogValue = CurrentValueSelected
    
    ;replot counts vs tof
    BSSreduction_DisplayCountsVsTof, Event
    
  ENDIF
END


PRO BSSreduction_LinLogFullCountsVsTof, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get current selected value (lin or log)
  CurrentValueSelected = getFullLinLogValue(Event)
  PrevValueSelected = (*global).PrevFullLinLogValue
  
  IF (CurrentValueSelected NE PrevValueSelected) THEN BEGIN
    (*global).PrevFullLinLogValue = CurrentValueSelected
    
    ;replot counts vs tof
    BSSreduction_DisplayLinLogFullCountsVsTof, Event
    
  ENDIF
END



;type=0 -> linear | type=1 -> log
PRO BSSreduction_DisplayFullCountsVsTof, Event, type

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF ((*global).NeXusFound) THEN BEGIN
  
    data = (*(*global).full_counts_vs_tof_data)
    
    view_info = widget_info(Event.top,FIND_BY_UNAME='full_counts_vs_tof_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    IF (type EQ 0) THEN BEGIN
      plot, data, POSITION=[0.1,0.1,0.95,0.99]
    ENDIF ELSE BEGIN
      plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
    ENDELSE
  ENDIF
  
END



PRO BSSreduction_PlotCountsVsTofOfSelection, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF ((*global).NeXusFound) THEN BEGIN
  
    banks_displayed = (*global).banks_displayed
    if (banks_displayed eq 'north_3_4') then begin
      bank1 = (*(*global).bank3)
      bank2 = (*(*global).bank4)
      pixel_excluded = (*(*global).pixel_excluded)
    endif else begin
      bank1 = (*(*global).bank1)
      bank2 = (*(*global).bank2)
      pixel_excluded = (*(*global).pixel_excluded)
    endelse
    
    sz = size(bank1,/dim)
    NX = sz[2]
    NY = sz[1]
    
    ;initialize counts vs tof array
    TOF_sz = (size(bank1))(1)
    data = lonarr(TOF_sz)
    
    sz = (size(pixel_excluded))(1)
    total_pixel_excluded = total(pixel_excluded) ;number of pixel excluded
    
    IF (total_pixel_excluded GE 4096) THEN BEGIN ;less pixel excluded than included
      data = lonarr(TOF_sz)
    END
    
    FOR i=0,(sz-1) DO BEGIN
      IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
        IF (pixel_excluded[i] EQ 1) THEN BEGIN ;add data to final array
          XY = getXYfromPixelID_Untouched(i)
          if (XY[1] lt NY and XY[0] lt NX) then begin
            IF (i LT 4096) THEN BEGIN
              bank1[*,XY[1],XY[0]]=0
            ENDIF ELSE BEGIN
              bank2[*,XY[1],XY[0]]=0
            ENDELSE
          endif
        ENDIF
      ENDIF ELSE BEGIN        ;more pixel excluded than included
        IF (pixel_excluded[i] EQ 0) THEN BEGIN
          XY = getXYfromPixelID_Untouched(i)
          if (XY[1] lt NY and XY[0] lt NX) then begin
            IF (i LT 4096) THEN BEGIN
              data += bank1[*,XY[1],XY[0]]
            ENDIF ELSE BEGIN
              data += bank2[*,XY[1],XY[0]]
            ENDELSE
          endif
        ENDIF
      ENDELSE
    ENDFOR
    
    IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
      data1 = total(bank1,2)
      data1 = total(data1,2)
      
      data2 = total(bank2,2)
      data2 = total(data2,2)
      
      data = data1 + data2
    ENDIF
    
    (*(*global).full_counts_vs_tof_data) = data
    
    view_info = widget_info(Event.top,FIND_BY_UNAME='full_counts_vs_tof_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    
    ;check status of lin/log
    CurrentValueSelected = getFullLinLogValue(Event)
    IF (CurrentValueSelected EQ 0) THEN BEGIN ;lin
      plot, data, POSITION=[0.1,0.1,0.95,0.99]
    ENDIF ELSE BEGIN
      plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
    ENDELSE
    
  ENDIF
  
END





PRO BSSreduction_PlotCountsVsTofOfSelection_light, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF ((*global).NeXusFound) THEN BEGIN
  
    banks_displayed = (*global).banks_displayed
    if (banks_displayed eq 'north_3_4') then begin
      bank1 = (*(*global).bank3)
      bank2 = (*(*global).bank4)
      pixel_excluded = (*(*global).pixel_excluded)
    endif else begin
      bank1 = (*(*global).bank1)
      bank2 = (*(*global).bank2)
      pixel_excluded = (*(*global).pixel_excluded)
    endelse
    
    sz = size(bank1,/dim)
    NX = sz[2]
    NY = sz[1]
    
    ;initialize counts vs tof array
    TOF_sz = (size(bank1))(1)
    data = lonarr(TOF_sz)
    
    sz = (size(pixel_excluded))(1)
    total_pixel_excluded = total(pixel_excluded) ;number of pixel excluded
    
    IF (total_pixel_excluded GE 4096) THEN BEGIN ;less pixel excluded than included
      data = lonarr(TOF_sz)
    END
    
    FOR i=0,(sz-1) DO BEGIN
      IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
        IF (pixel_excluded[i] EQ 1) THEN BEGIN ;add data to final array
          XY = getXYfromPixelID_Untouched(i)
          if (XY[1] lt NY and XY[0] lt NX) then begin
            IF (i LT 4096) THEN BEGIN
              bank1[*,XY[1],XY[0]]=0
            ENDIF ELSE BEGIN
              bank2[*,XY[1],XY[0]]=0
            ENDELSE
          endif
        ENDIF
      ENDIF ELSE BEGIN        ;more pixel excluded than included
        IF (pixel_excluded[i] EQ 0) THEN BEGIN
          XY = getXYfromPixelID_Untouched(i)
          if (XY[1] lt NY and XY[0] lt NX) then begin
            IF (i LT 4096) THEN BEGIN
              data += bank1[*,XY[1],XY[0]]
            ENDIF ELSE BEGIN
              data += bank2[*,XY[1],XY[0]]
            ENDELSE
          endif
        ENDIF
      ENDELSE
    ENDFOR
    
    IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
      data1 = total(bank1,2)
      data1 = total(data1,2)
      
      data2 = total(bank2,2)
      data2 = total(data2,2)
      
      data = data1 + data2
    ENDIF
    
    (*(*global).full_counts_vs_tof_data) = data
    
  ENDIF
  
END





;plot full counts_vs_tof
PRO BSSreduction_PlotFullCountsVsTof, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  IF ((*global).NeXusFound) THEN BEGIN
  
    ;disable refresh button
    ActivateRefreshButton, event, 0
    ;inform user that full counts vs tof is refreshing
    MessageBox = 'Refreshing Full Counts vs TOF ... ' + (*global).processing
    putMessageBoxInfo, Event, MessageBox
    
    BSSreduction_PlotCountsVsTofOfSelection, Event
    
    MessageBox = 'Refreshing Full Counts vs TOF ... DONE'
    putMessageBoxInfo, Event, MessageBox
    
    ;enable refresh button
    ActivateRefreshButton, event, 1
    
  ENDIF
END




PRO BSSreduction_DisplayLinLogFullCountsVsTof, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;find out in which bin we clicked
  xmin = (*global).true_full_x_min
  xmax = (*global).true_full_x_max
  
  ;get true xmin and xmax
  xmin = min([xmin,xmax],max=xmax)
  
  ;plot data (counts vs tof)
  view_info = widget_info(Event.top,FIND_BY_UNAME='full_counts_vs_tof_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  no_error = 0
  catch, no_error
  if (no_error NE 0) then begin
    catch,/cancel
    BSSreduction_PlotFullCountsVsTof, Event
  endif else begin
  
    data = (*(*global).full_counts_vs_tof_data)
    IF ((*global).PrevFullLinLogValue) THEN BEGIN ;log
      plot, data, xrange=[xmin,xmax],POSITION=[0.1,0.1,0.95,0.99], XSTYLE=1, $
        /YLOG, $
        MIN_VALUE=1
    ENDIF ELSE BEGIN
      plot, data, xrange=[xmin,xmax],POSITION=[0.1,0.1,0.95,0.99], XSTYLE=1
    ENDELSE
    
  endelse
END

