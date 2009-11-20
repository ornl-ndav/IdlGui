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

FUNCTION retrieveData, Event, FullNexusName, DataArrayResult

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  color = 50
  
  retrieve_error = 0
 ; CATCH, retrieve_error
  IF (retrieve_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    progressBar->Destroy
    widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    result = DIALOG_MESSAGE("Loading new NeXus file failed!",$
      /ERROR, TITLE='Loading Error!', $
      /CENTER, $
      DIALOG_PARENT=widget_id)
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    RETURN, 0
  ENDIF ELSE BEGIN
  
    IF ((*global).facility EQ 'LENS') THEN BEGIN
    
      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
        FullNexusName,$
        NbrBank = 1,$
        BankData = 'bank1')
      DataArray = *(sInstance->getData())
      DataArrayResult = DataArray
      
      OBJ_DESTROY, sInstance
      
    ENDIF ELSE BEGIN ;SNS
    
      Nstep  = FLOAT(48) ;number of steps
      step   = 0
      progressBarCancel = 0
      progressBar = OBJ_NEW("SHOWPROGRESS", $
        XOFFSET = 100, $
        YOFFSET = 50, $
        XSIZE   = 200,$
        TITLE   = 'Loading Data',$
        /CANCELBUTTON)
      progressBar->SetColor, color
      title = 'Retrieving Data ... '
      progressBar->SetLabel, title + '(bank 1/48)'
      progressBar->Start
      
      ;progressBarcancel = progressBar->CheckCancel()
      ;IF (progressBarCancel) THEN RETURN, 0
      IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
        progressBarCancel = 1
        progressBar->Destroy
        OBJ_DESTROY, progressBar
        RETURN, 0
      ENDIF
      
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
      
      front_bank = DBLARR(nbr_tof, nbr_pixel, nbr_tube)
      back_bank  = DBLARR(nbr_tof, nbr_pixel, nbr_tube)
      front_and_back_bank = DBLARR(nbr_tof, nbr_pixel, 2*nbr_tube)
      
      front_bank[*,*,0:3] = DataArray1
      
      ;progressBarcancel = progressBar->CheckCancel()
      ;IF (progressBarCancel) THEN RETURN, 0
      IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
        progressBarCancel = 1
        progressBar->Destroy
        OBJ_DESTROY, progressBar
        RETURN, 0
      ENDIF ELSE BEGIN
        progressBar->SetLabel, title + '(bank 2/48)'
      ENDELSE
      
      ;get first back rack
      sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
        FullNexusName,$
        NbrBank = 1,$
        BankData = 'bank25')
      DataArray = *(sInstance->getData())
      OBJ_DESTROY, sInstance
      
      back_bank[*,*,0:3] = DataArray
      
      rack_index_front = 2
      rack_back_offset = 24
      tube_index = 1
      WHILE(rack_index_front LT 25) DO BEGIN
      
        ;work with front banks
      
        bank_name = 'bank' + strcompress(rack_index_front,/REMOVE_ALL)
        ;progressBarcancel = progressBar->CheckCancel()
        ;IF (progressBarCancel) THEN RETURN, 0
        IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
          progressBarCancel = 1
          progressBar->Destroy
          OBJ_DESTROY, progressBar
          RETURN, 0
        ENDIF ELSE BEGIN
          bank_title = '(bank ' + strcompress(2*rack_index_front-1,/REMOVE_ALL) + $
            '/48)'
          progressBar->SetLabel, title + bank_title
        ENDELSE
        
        sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
          FullNexusName,$
          NbrBank = 1,$
          BankData = bank_name)
        DataArray = *(sInstance->getData())
        OBJ_DESTROY, sInstance
        
        start_index = tube_index * 4
        end_index   = tube_index * 4 + 3
        front_bank[*,*,start_index:end_index] = DataArray
        
        ;work with back banks
        
        bank_name = 'bank' + strcompress(rack_index_front+$
          rack_back_offset,/REMOVE_ALL)
        ;progressBarcancel = progressBar->CheckCancel()
        ;IF (progressBarCancel) THEN RETURN, 0
        IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
          progressBarCancel = 1
          progressBar->Destroy
          OBJ_DESTROY, progressBar
          RETURN, 0
        ENDIF ELSE BEGIN
          bank_title = '(bank ' + strcompress(2*rack_index_front,/REMOVE_ALL) + $
            '/48)'
          progressBar->SetLabel, title + bank_title
        ENDELSE
        
        sInstance  = OBJ_NEW('IDLgetNexusMetadata',$
          FullNexusName,$
          NbrBank = 1,$
          BankData = bank_name)
        DataArray = *(sInstance->getData())
        OBJ_DESTROY, sInstance
        
        back_bank[*,*,start_index:end_index] = DataArray
        
        rack_index_front++
        tube_index++
        
        color += 256/26
        progressBar->SetColor, color
        
      ENDWHILE
      
      progressBar->SetLabel, 'Stagging data ...'
      
      method = '' ;'debug' for debugging mode
      
      IF (method EQ 'debug') THEN BEGIN
        ;Create big array (new way to try to fix problem with mapping)
        ;tube 0,1,4,5 -> bank1....
        ;tube 2,3,6,7 -> bank25 ....
        index = 0L
        index_front = 0
        index_back = 0
        while (index LT 2L*4L*24L) DO BEGIN
          front_and_back_bank[*,*,index] = front_bank[*,*,index_front]
          index++
          index_front++
          index_front++
          front_and_back_bank[*,*,index] = front_bank[*,*,index_front]
          index++
          front_and_back_bank[*,*,index] = back_bank[*,*,index_back]
          index_back++
          index_back++
          index++
          front_and_back_bank[*,*,index] = back_bank[*,*,index_back]
          index++
          index_front--
          front_and_back_bank[*,*,index] = front_bank[*,*,index_front]
          index_front++
          index_front++
          index++
          front_and_back_bank[*,*,index] = front_bank[*,*,index_front]
          index++
          index_back--
          front_and_back_bank[*,*,index] = back_bank[*,*,index_back]
          index_back++
          index_back++
          index++
          front_and_back_bank[*,*,index] = back_bank[*,*,index_back]
          index_front++
          index_back++
          index++
        ENDWHILE
        
      ENDIF ELSE BEGIN
      
        ;create big array (front and back)
        index = 0L
        index_front = 0
        while (index LT 2L*4L*24L) DO BEGIN
          front_and_back_bank[*,*,index] = front_bank[*,*,index_front]
          index ++
          front_and_back_bank[*,*,index] = back_bank[*,*,index_front]
          index ++
          index_front++
        ENDWHILE
        
      ENDELSE
      
      (*(*global).back_bank) = back_bank
      (*(*global).front_bank) = front_bank
      (*(*global).both_banks) = front_and_back_bank
      
      DataArrayResult = front_and_back_bank
      
      progressBar->Destroy
      OBJ_DESTROY, progressBar
      
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
    
      x = (size(tDataXY))(1)
      y = (size(tDataXY))(2)
      
      draw_x = (*global).draw_x
      draw_y = (*global).draw_y
      
      rtDataXY = CONGRID(tDataXY, draw_x, draw_y)
      
      congrid_x_coeff = FLOAT(draw_x) / FLOAT(x)
      congrid_y_coeff = FLOAT(draw_y) / FLOAT(y)
      congrid_coeff = MIN([congrid_x_coeff,congrid_y_coeff])
      
      (*global).congrid_x_coeff = congrid_coeff
      (*global).congrid_y_coeff = congrid_coeff
      
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
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  ;retrieve parameters from global pointer
  IF ((*global).facility EQ 'LENS') THEN BEGIN
    X         = (*global).X
    IF (X NE 0) THEN BEGIN
      DataArray = (*(*global).DataArray)
      Y         = (*global).Y
    ENDIF
    result = plotData(Event, DataArray, X, Y)
    
  ENDIF ELSE BEGIN ;SNS
  
    DataArray = (*(*global).DataArray)
    result = plotData(Event, DataArray, 1, 1)
    
  ENDELSE
  
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
