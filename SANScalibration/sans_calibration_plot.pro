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
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  retrieve_error = 0
  CATCH, retrieve_error
  IF (retrieve_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    RETURN, 0
  ENDIF ELSE BEGIN
    sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
      FullNexusName,$
      NbrBank = 1,$
      BankData = 'bank1')
    DataArray = *(sInstance->getData())
    TofArray  = *(sInstance->getTof())
    sz = N_ELEMENTS(TofArray)
    putTextFieldValue, Event, 'tof_max_value', $
      STRCOMPRESS(sz-2,/REMOVE_ALL)
    TofArray  = TofArray[0:sz-2]
    (*(*global).tof_array) = TofArray
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
    ;Integrate over TOF or get specified range of tof
    value = getCWBgroupValue(Event, 'tof_range_cwbgroup')
    
    IF (value EQ 1) THEN BEGIN ;user wants user_defined range of tof
      tof_min       = FLOAT(getTextFieldValue(Event, $
        'tof_range_min_cw_field'))
      tof_max       = FLOAT(getTextFieldValue(Event, $
        'tof_range_max_cw_field'))
      tof_array     = (*(*global).tof_array)
      tof_min_index = getIndexOfTof(tof_array, tof_min)
      tof_max_index = getIndexOfTof(tof_array, tof_max)
      DataArray     = DataArray[tof_min_index:tof_max_index,*,*]
    ENDIF
    dataXY           = TOTAL(DataArray,1)
    tDataXY          = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    ;check linear or log scale type
    ;     IF (getCWBgroupValue(Event,'z_axis_scale') EQ 1) THEN BEGIN ;log
    ;         index = WHERE(tDataXY GT 0, nbr)
    ;         help, index
    ;         sz = SIZE(tDataXY)
    ;         help, sz
    ;         new_tDataXY = FLTARR(sz[1],sz[2])
    ;         help, new_tdataxy
    ;         IF (nbr GT 0) THEN BEGIN
    ;             new_tDataXY(index) = tDataXY(index)
    ;             help, new_tdataxy
    ;         ENDIF
    ;         tDataXY = new_tDataXY
    ;         help, tdataxy
    ;         tDataXY = ALOG10(tDataXY)
    ;         help, tdataxy
    ;         print, max(tdataxy)
    ;     ENDIF
    
    ;Check if rebin is necessary or not
    IF (X EQ 80) THEN BEGIN
      xysize = 8
      Xpixel = 80L
    ENDIF ELSE BEGIN
      xysize = 2
      Xpixel = 320L
    ENDELSE
    (*global).Xpixel = Xpixel
    rtDataXY = REBIN(tDataXY, xysize*X, xysize*Y, /SAMPLE)
    (*(*global).rtDataXY) = rtDataXY
    
    lin_or_log_plot, Event
    
    ;;plot data
    ;    id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
    ;    WIDGET_CONTROL, id, GET_VALUE = id_value
    ;    WSET, id_value
    ;    DEVICE, DECOMPOSED = 0
    ;    LOADCT,5,/SILENT
    ;    TVSCL, rtDataXY, /DEVICE
    ;    refresh_scale, Event        ;_plot
    
    RETURN, plotStatus
    
  ENDELSE
END

;------------------------------------------------------------------------------
;function is reached when playing movie over range of tof
FUNCTION plot_range_OF_data, Event, tof_min_index, tof_max_index
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  DataArray = (*(*global).DataArray)
  
  plot_error = 0
  ;CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF ELSE BEGIN
    DataArray        = DataArray[tof_min_index:tof_max_index,*,*]
    dataXY           = TOTAL(DataArray,1)
    tDataXY          = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    
    ;;Check if rebin is necessary or not
    ;    IF (X EQ 80) THEN BEGIN
    X = 80L
    Y = 80L
    xysize = 8
    Xpixel = 80L
    ;    ENDIF ELSE BEGIN
    ;        xysize = 2
    ;        Xpixel = 320L
    ;    ENDELSE
    (*global).Xpixel = Xpixel
    DataXY = REBIN(tDataXY, xysize*X, xysize*Y, /SAMPLE)
    
    ;linear or log
    plot_type = LinOrLog(Event)
    ;plot_type = Event.value ;0->linear, 1->log
    
    IF (plot_type EQ 1) THEN BEGIN ;log
    
      ;remove 0 values and replace with NAN
      ;and calculate log
      index = WHERE(DataXY EQ 0, nbr)
      IF (nbr GT 0) THEN BEGIN
        DataXY[index] = !VALUES.D_NAN
        DataXY = ALOG10(DataXY)
        DataXY = BYTSCL(DataXY,/NAN)
      ENDIF
      
    ENDIF
    
    ;plot data
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
    WIDGET_CONTROL, id, GET_VALUE = id_value
    WSET, id_value
    DEVICE, DECOMPOSED = 0
    LOADCT,5,/SILENT
    TVSCL, DataXY, /DEVICE
    refresh_scale, Event        ;_plot
    RETURN, 1
    
    RefreshRoiExclusionPlot, Event   ;_selection
    
  ENDELSE
END

;------------------------------------------------------------------------------
PRO refresh_scale, Event
  ;indicate initialization with hourglass icon
  ;widget_control,/hourglass
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;change color of background
  id = WIDGET_INFO(EVENT.TOP,FIND_BY_UNAME='label_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  LOADCT,0,/SILENT
  
  IF ((*global).Xpixel  EQ 80L) THEN BEGIN
    xrange_max = 80
    PLOT, RANDOMN(s,xrange_max), $
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
    PLOT, RANDOMN(s,xrange_max), $
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
  WIDGET_CONTROL,/hourglass
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;change color of background
  id = WIDGET_INFO(EVENT.TOP,FIND_BY_UNAME='label_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  LOADCT,0,/SILENT
  
  PLOT, RANDOMN(s,80), $
    XRANGE     = [0,80],$
    YRANGE     = [0,80],$
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
    
  ;retrieve parameters from global pointer
  X         = (*global).X
  IF (X NE 0) THEN BEGIN
    DataArray = (*(*global).DataArray)
    Y         = (*global).Y
  ENDIF
  result = plotData(Event, DataArray, X, Y)
  ;turn off hourglass
  WIDGET_CONTROL,hourglass=0
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
    plotROI, Event
  ENDIF
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END
