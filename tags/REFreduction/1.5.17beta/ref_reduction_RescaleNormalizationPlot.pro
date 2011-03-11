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

PRO REFReduction_RescaleNormalizationPlot,Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  if ((*global).NormNexusFound) then begin
  
    NormXYZminmaxArray = (*(*global).NormXYZminmaxArray)
    
    tvimg = (*(*global).tvimg_norm_ptr)
    sz=size(tvimg)
    
    REFreduction_Rescale_PlotNorm, Event, tvimg
    
  endif ;end of if(NormNexusFound)
  
END





PRO REFreduction_ResetXNormPlot, Event
  REFreduction_Rescale_ResetNormGui,Event,x=1,y=0,z=0
  REFReduction_RescaleNormalizationPlot,Event
  ;Replot all selection if any
  ReplotNormAllSelection, Event
END




PRO REFreduction_ResetYNormPlot, Event
  REFreduction_Rescale_ResetNormGui,Event,x=0,y=1,z=0
  REFReduction_RescaleNormalizationPlot,Event
  ;Replot all selection if any
  ReplotNormAllSelection, Event
END




PRO REFreduction_ResetZNormPlot, Event
  REFreduction_Rescale_ResetNormGui,Event,x=0,y=0,z=1
  REFReduction_RescaleNormalizationPlot,Event
  ;Replot all selection if any
  ReplotNormAllSelection, Event
END




PRO REFreduction_ResetFullNormPlot, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  tvimg = (*(*global).tvimg_norm_ptr)
  REFreduction_Rescale_PlotNorm, Event, tvimg
  ;reset Data Rescale Gui
  REFreduction_Rescale_ResetNormGui,Event,x=1,y=1,z=1
  ;Replot all selection if any
  ReplotNormAllSelection, Event
END




PRO REFreduction_Rescale_ResetNormGui, Event, x=x, y=y, z=z
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  NormXYZminmaxArray = (*(*global).NormXYZminmaxArray)
  
  if (x EQ 1) then begin ;reset x-axis
    REFreduction_Rescale_resetNormXaxis, Event, NormXYZminmaxARray
  endif
  
  if (y EQ 1) then begin ;reset y-axis
    REFreduction_Rescale_resetNormYaxis, Event, NormXYZminmaxARray
  endif
  
  if (z EQ 1) then begin ;reset z-axis
    REFreduction_Rescale_resetNormZaxis, Event, NormXYZminmaxARray
  endif
END



PRO REFreduction_Rescale_resetNormZaxis, Event, NormXYZminmaxARray
  ;reset z-droplist
  SetDropListValue, Event, 'normalization_rescale_z_droplist',0
  putTextfieldValue,Event, 'normalization_rescale_zmin_cwfield', $
    NormXYZminmaxArray[4],0
  putTextfieldValue,Event, 'normalization_rescale_zmax_cwfield', $
    NormXYZminmaxArray[5],0
END


PRO REFreduction_Rescale_resetNormYaxis, Event, NormXYZminmaxArray
  ;reset y-droplist
  putTextfieldValue,Event, 'normalization_rescale_ymin_cwfield', $
    NormXYZminmaxArray[2],0
  putTextfieldValue,Event, 'normalization_rescale_ymax_cwfield', $
    NormXYZminmaxArray[3],0
END


PRO REFreduction_Rescale_resetNormXaxis, Event, NormXYZminmaxARray
  ;reset x-droplist
  putTextfieldValue,Event, 'normalization_rescale_xmin_cwfield', $
    NormXYZminmaxArray[0],0
  putTextfieldValue,Event, 'normalization_rescale_xmax_cwfield', $
    NormXYZminmaxArray[1],0
END


PRO REFreduction_Rescale_PlotNorm, Event, tvimg
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  ;Device, decomposed=0
  ;get droplist index
  LoadctIndex = getDropListSelectedIndex(Event,'normalization_contrast_droplist')
  ;get bottom value of color
  BottomColorValue = getSliderValue(Event,'normalization_contrast_bottom_slider')
  ;get number of color
  NumberColorValue = getSliderValue(Event,'normalization_contrast_number_slider')
  loadct,loadctIndex, Bottom=BottomColorValue,NColors=NumberColorValue,/SILENT
  
  IF (getDropListSelectedIndex(Event,'normalization_rescale_z_droplist') EQ 1) $
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
  
  tvscl, tvimg
  
END

