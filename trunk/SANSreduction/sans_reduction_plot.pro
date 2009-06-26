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

FUNCTION retrieveData, Event, FullNexusName, DataArray
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  retrieve_error = 0
  ;CATCH, retrieve_error
  IF (retrieve_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    RETURN, 0
  ENDIF ELSE BEGIN
  
    IF ((*global).facility EQ 'LENS') THEN BEGIN
    
      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
        FullNexusName,$
        NbrBank = 1,$
        BankData = 'bank1')
      DataArray = *(sInstance->getData())
      
      OBJ_DESTROY, sInstance
      
    ENDIF ELSE BEGIN
    
      ;      DataArray1 = LINDGEN(10,192,256)
      ;      DataArray2 = LINDGEN(10,192,256)+300
      ;      (*(*global).bank1) = DataArray1
      ;      (*(*global).bank2) = DataArray2
    
      ;get first front rack
      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
        FullNexusName,$
        NbrBank = 1,$
        BankData = 'bank1')
      DataArray1 = *(sInstance->getData())
      OBJ_DESTROY, sInstance
      
      ;get size of array
      sz = size(DataArray1)
      nbr_tof   = sz[1]
      nbr_pixel = sz[2]
      nbr_tube  = 96
      
      front_bank = LONARR(nbr_tof, nbr_pixel, nbr_tube)
      back_bank  = LONARR(nbr_tof, nbr_pixel, nbr_tube)
      front_and_back_bank = LONARR(nbr_tof, nbr_pixel, 2*nbr_tube)
      
      front_bank[*,*,0:3] = DataArray1
      front_and_back_bank[*,*,0:3] = DataArray1
      
      ;get first rack
      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
        FullNexusName,$
        NbrBank = 1,$
        BankData = 'bank2')
      DataArray = *(sInstance->getData())
      OBJ_DESTROY, sInstance
      
      back_bank[*,*,0:3] = DataArray
      front_and_back_bank[*,*,4:7] = DataArray
      
      rack_index = 3
      tube_index = 1
      full_tube_index = 2
      WHILE(rack_index LT 48) DO BEGIN
      
        bank_name = 'bank' + strcompress(rack_index,/REMOVE_ALL)
        sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
          FullNexusName,$
          NbrBank = 1,$
          BankData = bank_name)
        DataArray = *(sInstance->getData())
        OBJ_DESTROY, sInstance
        
        start_index = tube_index * 4
        end_index   = tube_index * 4 + 3
        front_bank[*,*,start_index:end_index] = DataArray
        full_start_index = full_tube_index * 4
        full_end_index = full_tube_index * 4 + 3
        front_and_back_bank[*,*,full_start_index:full_end_index] = DataArray
        rack_index++
        full_tube_index++
        
        bank_name = 'bank' + strcompress(rack_index,/REMOVE_ALL)
        sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
          FullNexusName,$
          NbrBank = 1,$
          BankData = bank_name)
        DataArray = *(sInstance->getData())
        OBJ_DESTROY, sInstance
        
        start_index = tube_index * 4
        end_index   = tube_index * 4 + 3
        back_bank[*,*,start_index:end_index] = DataArray
        full_start_index = full_tube_index * 4
        full_end_index = full_tube_index * 4 + 3
        front_and_back_bank[*,*,full_start_index:full_end_index] = DataArray
        full_tube_index++
        rack_index++
        
        tube_index++
        
      ENDWHILE
      
      ;      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
      ;        FullNexusName,$
      ;        NbrBank = 1,$
      ;        BankData = 'bank2')
      ;      DataArray2 = *(sInstance->getData())
      ;      OBJ_DESTROY, sInstance
      ;      (*(*global).bank2) = DataArray2
      ;
      ;      help, DataArray2
      ;
      ;DataArray = DataArray1 + DataArray2
      DataArray = front_and_back_bank
      
    ENDELSE
    
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  ENDELSE
  RETURN,1
END

;------------------------------------------------------------------------------
;This function takes the histogram data from the NeXus file and plot it
FUNCTION plotData, Event, DataArray, X, Y
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  plotStatus = 1 ;by default, plot does work
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF ELSE BEGIN
    ;Integrate over TOF
    dataXY   = TOTAL(DataArray,1)
    tDataXY  = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    ;Check if rebin is necessary or not
    IF ((*global).facility EQ 'LENS') THEN BEGIN ;LENS
    
      IF (X EQ 80) THEN BEGIN
        xysize = 8
        Xpixel = 80L
      ENDIF ELSE BEGIN
        xysize = 2
        Xpixel = 320L
      ENDELSE
      (*global).Xpixel = Xpixel
      (*global).DrawXcoeff = xysize
      rtDataXY = REBIN(tDataXY, xysize*X, xysize*Y, /SAMPLE)
      
    ENDIF ELSE BEGIN ;SNS
    
      help, tDataXY
      x = (size(tDataXY))(1)
      y = (size(tDataXY))(2)
      
      draw_x = (*global).draw_x
      draw_y = (*global).draw_y
      
      rtDataXY = CONGRID(tDataXY, draw_x, draw_y)
      
      (*global).congrid_x_coeff = FLOAT(draw_x) / FLOAT(x)
      (*global).congrid_y_coeff = FLOAT(draw_y) / FLOAT(y)
      
    ENDELSE
    
    (*(*global).rtDataXY) = rtDataXY ;array plotted
    lin_or_log_plot, Event
    
    ;;plot data
    ;    DEVICE, DECOMPOSED = 0
    ;    LOADCT,5,/SILENT
    ;    id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
    ;    WIDGET_CONTROL, id, GET_VALUE = id_value
    ;    WSET, id_value
    ;    TVSCL, rtDataXY, /DEVICE
    ;    refresh_scale, Event         ;_plot
    
    RETURN, plotStatus
  ENDELSE
END

;------------------------------------------------------------------------------
PRO refresh_scale, Event

  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  facility = (*global).facility
  
  print, facility
  
  IF (facility EQ 'SNS') THEN RETURN
  
  ;change color of background
  id = WIDGET_INFO(EVENT.TOP,FIND_BY_UNAME='label_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  LOADCT,0,/SILENT
  
  IF ((*global).Xpixel  EQ 80L) THEN BEGIN
  
    xrange_max = 80
    plot, randomn(s,xrange_max), $
      XRANGE     = [0,xrange_max],$
      YRANGE     = [0,xrange_max],$
      COLOR      = convert_rgb([0B,0B,255B]), $
      BACKGROUND = convert_rgb((*global).sys_color_face_3d),$
      THICK      = 1, $
      TICKLEN    = -0.015, $
      XTICKLAYOUT = 0,$
      YTICKLAYOUT = 0,$
      XTICKS      = 8,$
      YTICKS      = 8,$
      XMARGIN     = [5,5],$
      /NODATA
      
  ENDIF ELSE BEGIN
  
    xrange_max = 320
    plot, randomn(s,xrange_max), $
      XRANGE        = [0,xrange_max],$
      YRANGE        = [0,xrange_max],$
      COLOR         = convert_rgb([0B,0B,255B]), $
      BACKGROUND    = convert_rgb((*global).sys_color_face_3d),$
      THICK         = 1, $
      TICKLEN       = -0.015, $
      XTICKLAYOUT   = 0,$
      YTICKLAYOUT   = 0,$
      XTICKS        = 8,$
      YTICKINTERVAL = 32,$
      XTICKINTERVAL = 32,$
      YSTYLE        = 1,$
      XSTYLE        = 1,$
      YTICKS        = 8,$
      XMARGIN       = [5,5],$
      /NODATA
      
  ENDELSE
END

;------------------------------------------------------------------------------
PRO refresh_plot, Event ;_plot
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;  IF ((*global).facility EQ 'LENS') THEN BEGIN
  ;
  ;    ;change color of background
  ;    id = WIDGET_INFO(EVENT.TOP,FIND_BY_UNAME='label_draw_uname')
  ;    WIDGET_CONTROL, id, GET_VALUE=id_value
  ;    WSET, id_value
  ;
  ;  ENDIF
  
  ;retrieve parameters from global pointer
  X         = (*global).X
  IF (X NE 0) THEN BEGIN
    DataArray = (*(*global).DataArray)
    Y         = (*global).Y
  ENDIF
  result = plotData(Event, DataArray, X, Y)
  ;turn off hourglass
  widget_control,hourglass=0
  
END

;------------------------------------------------------------------------------
PRO refresh_main_plot, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;clear previous selection
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  ;retrieve parameters from global pointer
  X         = (*global).X
  IF (X NE 0) THEN BEGIN
    DataArray = (*(*global).DataArray)
    Y         = (*global).Y
  ENDIF
  result = plotData(Event, DataArray, X, Y)
END

;------------------------------------------------------------------------------
PRO refreshROIExclusionPlot, Event
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;refresh_main_plot, Event
  IF ((*global).there_is_a_selection EQ 1) THEN BEGIN
    plotROI, Event ;_exclusion
  ENDIF
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END
