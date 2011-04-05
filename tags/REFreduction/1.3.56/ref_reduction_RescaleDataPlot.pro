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

PRO REFReduction_RescaleDataPlot, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  if ((*global).DataNexusFound) then begin
  
    coeff_congrid_tof = (*global).congrid_x_coeff
    
    DataXYZminmaxArray = (*(*global).DataXYZminmaxArray)
    
    tvimg = (*(*global).tvimg_data_ptr)
    sz=size(tvimg)
    
;    ;####X-axis
;    xmin = getTextFieldValue(Event,'data_rescale_xmin_cwfield')
;    xmax = getTextfieldValue(Event,'data_rescale_xmax_cwfield')
;    new_tvimg = fltarr(sz[1],sz[2])
;    Xupdate = [0,0]
;    if (xmin GT xmax) then begin
;      tmp = xmax
;      xmax = xmin
;      xmin = tmp
;      Xupdate[0]=1
;      Xupdate[1]=1
;    endif
;    
;    if (xmin LT DataXYZminmaxArray[0]) then begin
;      xmin = DataXYZminmaxArray[0]
;      Xupdate[0]=1
;    endif
;    
;    if (xmax GT DataXYZminmaxArray[1]) then begin
;      xmax = DataXYZminmaxArray[1]
;      Xupdate[1]=1
;    endif
;    
;    if (Xupdate[0] EQ 1) then begin
;      putTextFieldValue, Event, 'data_rescale_xmin_cwfield', xmin, 0
;    endif
;    
;    if (Xupdate[1] EQ 1) then begin
;      putTextFieldValue, Event, 'data_rescale_xmax_cwfield', xmax, 0
;    endif
    
;    xmin *= coeff_congrid_tof
;    xmax *= coeff_congrid_tof
    
;    new_tvimg(xmin:xmax,*) = tvimg(xmin:xmax,*)
;    tvimg=new_tvimg
    
    ;####Y-axis
    ymin = getTextFieldValue(Event,'data_rescale_ymin_cwfield')
    ymax = getTextFieldValue(Event,'data_rescale_ymax_cwfield')
    new_tvimg = fltarr(sz[1],sz[2])
    Yupdate = [0,0]
    if (ymin GT ymax) then begin
      tmp = ymax
      ymax = ymin
      ymin = tmp
      Yupdate[0]=1            ;we need to update ymin
      Yupdate[1]=1            ;we need to update ymax
    endif
    
    if (ymin LT DataXYZminmaxArray[2]) then begin
      ymin = DataXYZminmaxArray[2]
      Yupdate[0]=1
    endif
    
    if (ymax GT DataXYZminmaxArray[3]) then begin
      ymax = DataXYZminmaxArray[3]
      Yupdate[1]=1
    endif
    
    if (Yupdate[0] EQ 1) then begin
      putTextFieldValue,Event, 'data_rescale_ymin_cwfield',ymin,0
    endif
    
    if (Yupdate[1] EQ 1) then begin
      putTextfieldValue,Event, 'data_rescale_ymax_cwfield',ymax,0
    endif
    
    if (~(*global).miniVersion) then begin
      ymin *= 2
      ymax *= 2
    endif
    
    new_tvimg(*,ymin:ymax) = tvimg(*,ymin:ymax)
    tvimg=new_tvimg
    
    ;####Z-axis
    zmin = getTextFieldValue(Event,'data_rescale_zmin_cwfield')
    zmax = getTextFieldValue(Event,'data_rescale_zmax_cwfield')
    new_tvimg = fltarr(sz[1],sz[2])
    index = where(tvimg Gt zmin AND tvimg Le (zmax+1),Nbr)
    if (Nbr GT 0) then begin
      new_tvimg(index) = tvimg(index)
      tvimg = new_tvimg
    endif
    
    ;plot only the range of tof selected
    new_rescaled_tvimg, event, tvimg
    
    IF (getDropListSelectedIndex(Event,'data_rescale_z_droplist') EQ 1) $
      THEN BEGIN                ;log
      
      ;remove 0 values and replace with NAN
      ;and calculate log
      index = where(tvimg eq 0, nbr)
      if (nbr GT 0) then begin
        tvimg[index] = !VALUES.D_NAN
      endif
      tvimg = ALOG10(tvimg)
      tvimg = BYTSCL(tvimg,/NAN)
      
    ENDIF
    
    REFreduction_Rescale_PlotData, Event, tvimg
    
  ;if Zoom window visible update zoom drawing
    
  endif ;end of if(DataNexusFound)
  
END





PRO REFreduction_ResetXDataPlot, Event
  REFreduction_Rescale_resetgui,Event,x=1,y=0,z=0
  REFReduction_RescaleDataPlot,Event
  ReplotAllSelection, Event
END




PRO REFreduction_ResetYDataPlot, Event
  REFreduction_Rescale_resetgui,Event,x=0,y=1,z=0
  REFReduction_RescaleDataPlot,Event
  ReplotAllSelection, Event
END




PRO REFreduction_ResetZDataPlot, Event
  REFreduction_Rescale_resetgui,Event,x=0,y=0,z=1
  REFReduction_RescaleDataPlot,Event
  ReplotAllSelection, Event
END




PRO REFreduction_ResetFullDataPlot, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  tvimg = (*(*global).tvimg_data_ptr)
  REFreduction_Rescale_PlotData, Event, tvimg
  ;reset Data Rescale Gui
  REFreduction_Rescale_resetgui,Event,x=1,y=1,z=1
  ReplotAllSelection, Event
END




PRO REFreduction_Rescale_resetgui, Event, x=x, y=y, z=z
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  DataXYZminmaxArray = (*(*global).DataXYZminmaxArray)
  
  if (x EQ 1) then begin ;reset x-axis
    REFreduction_Rescale_resetXaxis, Event, DataXYZminmaxARray
  endif
  
  if (y EQ 1) then begin ;reset y-axis
    REFreduction_Rescale_resetYaxis, Event, DataXYZminmaxARray
  endif
  
  if (z EQ 1) then begin ;reset z-axis
    REFreduction_Rescale_resetZaxis, Event, DataXYZminmaxARray
  endif
END



PRO REFreduction_Rescale_resetZaxis, Event, DataXYZminmaxARray
  ;reset z-droplist
  SetDropListValue, Event, 'data_rescale_z_droplist',0
  putTextfieldValue,Event, 'data_rescale_zmin_cwfield',DataXYZminmaxArray[4],0
  putTextfieldValue,Event, 'data_rescale_zmax_cwfield',DataXYZminmaxArray[5],0
END


PRO REFreduction_Rescale_resetYaxis, Event, DataXYZminmaxARray
  ;reset y-droplist
  putTextfieldValue,Event, 'data_rescale_ymin_cwfield',DataXYZminmaxArray[2],0
  putTextfieldValue,Event, 'data_rescale_ymax_cwfield',DataXYZminmaxArray[3],0
END


PRO REFreduction_Rescale_resetXaxis, Event, DataXYZminmaxARray
  ;reset x-droplist
  putTextfieldValue,Event, 'data_rescale_xmin_cwfield',DataXYZminmaxArray[0],0
  putTextfieldValue,Event, 'data_rescale_xmax_cwfield',DataXYZminmaxArray[1],0
END


;------------------------------------------------------------------------------
PRO REFreduction_Rescale_PlotData, Event, tvimg
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  ;Device, decomposed=0
  ;get droplist index
  LoadctIndex = getDropListSelectedIndex(Event,'data_contrast_droplist')
  ;get bottom value of color
  BottomColorValue = getSliderValue(Event,'data_contrast_bottom_slider')
  ;get number of color
  NumberColorValue = getSliderValue(Event,'data_contrast_number_slider')
  loadct,loadctIndex, Bottom=BottomColorValue,NColors=NumberColorValue,/SILENT
  
  tvscl, tvimg
  
END


