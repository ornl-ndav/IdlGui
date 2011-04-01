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

;this function plots the 1D view (main view) of the DATA file only
FUNCTION REFreduction_Plot1DDataFile, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;check instrument selected
  instrument = (*global).instrument
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      (*global).processing_message, $
      (*global).failed
    RETURN, 0
  ENDIF ELSE BEGIN
    IF (instrument EQ (*global).REF_L) then begin
      Plot1DDataFileForRefL, Event ;REF_L
    ENDIF ELSE BEGIN
      Plot1DDataFileForRefM, EVENT ;REF_M
    ENDELSE
  ENDELSE
  RETURN, 1
END

;------------------------------------------------------------------------------
;this function plots the 1D view (main view) of the DATA file only for
;the batch run only
FUNCTION REFreduction_Plot1DDataFile_batch, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;check instrument selected
  instrument = (*global).instrument
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      (*global).processing_message, $
      (*global).failed
    RETURN, 0
  ENDIF ELSE BEGIN
    IF (instrument EQ (*global).REF_L) THEN BEGIN
      Plot1DDataFileForRefL_batch, Event ;REF_L
    ENDIF ELSE BEGIN
      Plot1DDataFileForRefM_batch, EVENT ;REF_M
    ENDELSE
  ENDELSE
  RETURN, 1
END

;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 1D view of the data file for the REF_L
PRO Plot1DDataFileForRefL, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  N   = (*global).Ny_REF_L ; 304
  img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
  img = total(img,3) ;data(Ntof,Ny)
  (*(*global).DATA_D_TOTAL_ptr) = img
  Plot1DDataFile, Event, img, N
  Plot1DData_3D_File, Event, img
END

;same function but for batch run only
PRO Plot1DDataFileForRefL_batch, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  N   = (*global).Ny_REF_L ; 304
  img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
  img = total(img,3) ;data(Ntof,Ny)
  (*(*global).DATA_D_TOTAL_ptr) = img
  Plot1DDataFile_batch, Event, img, N
  Plot1DData_3D_File_batch, Event, img
END

;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 1D view of the data file for the REF_M
PRO Plot1DDataFileForRefM, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  N   = (*global).Nx_REF_M ; 304
  img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
  img = total(img,2)
  (*(*global).DATA_D_TOTAL_ptr) = img
  Plot1DDataFile, Event, img, N
  Plot1DData_3D_File, Event, img
END

;Plots the 1D view of the data file for the REF_M for batch run only
PRO Plot1DDataFileForRefM_batch, Event
  ;get global structure
  widget_control,event.top,get_uvalue=global
  N   = (*global).Nx_REF_M ; 304
  img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
  img = total(img,2)
  (*(*global).DATA_D_TOTAL_ptr) = img
  Plot1DDataFile_batch, Event, img, N
  Plot1DData_3D_File_batch, Event, img
END

;**********************************************************************
;Procedure that plots REF_L and REF_M 1D data plots                   *
;**********************************************************************
PRO Plot1DDataFile, Event, img, N
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;get size of img
  sz=size(img)
  zmin=min(img,max=zmax)
  ;populate rescale 1D data
  putTextFieldValue,Event, 'data_rescale_xmin_cwfield',0,0
  putTextFieldValue,Event, 'data_rescale_xmax_cwfield',sz[1]-1,0
  putTextFieldValue,Event, 'data_rescale_ymin_cwfield',0,0
  putTextfieldValue,Event, 'data_rescale_ymax_cwfield',sz[2]-1,0
  putTextFieldValue,Event, 'data_rescale_zmin_cwfield',zmin,0
  putTextFieldValue,Event, 'data_rescale_zmax_cwfield',zmax-1,0
  (*(*global).DataXYZminmaxArray) = [0,sz[1]-1,$
    0,sz[2]-1,$
    zmin,zmax-1]
  ;retrieve parameters
  PROCESSING = (*global).processing_message
  tmp_file = (*global).full_data_tmp_dat_file
  ;tells user that we are now plotting the 2D data
  LogBookText = '--> Plotting 1D view ... ' + PROCESSING
  putLogBookMessage, Event, LogBookText, Append=1
  DEVICE, DECOMPOSED = 0
  id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  ;rebin data to fill up all graph
  display_Ntof = (*global).Ntof_DATA
  file_Ntof    = (size(img))(1)
  if ((*global).miniVersion) then begin
    new_N = N
    xsize = 304.
  endif else begin
    new_N = 2 * N
    xsize = 608.
  endelse
  
  IF (file_Ntof LT xsize) THEN BEGIN
    coeff_congrid_tof = xsize / FLOAT(file_Ntof)
  ENDIF ELSE BEGIN
    coeff_congrid_tof = 1
  ENDELSE
  
  (*global).congrid_x_coeff = coeff_congrid_tof
  
  ;change the size of the data draw true plotting area
  ;widget_control, id_draw, DRAW_XSIZE=file_Ntof
  ;tvimg = rebin(img, file_Ntof, new_N,/sample)
;  tvimg = CONGRID(img,file_Ntof * coeff_congrid_tof, new_N)
  
   id = widget_info(event.top, find_by_uname='load_data_D_draw')
  geometry = widget_info(id,/geometry)
  new_xsize = geometry.scr_xsize
  new_ysize = geometry.scr_ysize
  
  tvimg = congrid(img, new_xsize, new_ysize)
    
  (*(*global).tvimg_data_ptr) = tvimg
  
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
  
  tvscl, tvimg, /device
  ;remove PROCESSING_message from logbook and say ok
  LogBookText = getLogBookText(Event)
  putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
END

;Batch run only
PRO Plot1DDataFile_batch, Event, img, N
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;get size of img
  sz=size(img)
  zmin=min(img,max=zmax)
  ;populate rescale 1D data
  putTextFieldValue,Event, 'data_rescale_xmin_cwfield',0,0
  putTextFieldValue,Event, 'data_rescale_xmax_cwfield',sz[1]-1,0
  putTextFieldValue,Event, 'data_rescale_ymin_cwfield',0,0
  putTextfieldValue,Event, 'data_rescale_ymax_cwfield',sz[2]-1,0
  putTextFieldValue,Event, 'data_rescale_zmin_cwfield',zmin,0
  putTextFieldValue,Event, 'data_rescale_zmax_cwfield',zmax-1,0
  (*(*global).DataXYZminmaxArray) = [0,sz[1]-1,$
    0,sz[2]-1,$
    zmin,zmax-1]
  ;retrieve parameters
  PROCESSING = (*global).processing_message
  tmp_file = (*global).full_data_tmp_dat_file
  DEVICE, DECOMPOSED = 0
  id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  ;if (!VERSION.os EQ 'darwin') then begin
  ;   img = swap_endian(img)
  ;endif
  ;rebin data to fill up all graph
  display_Ntof = (*global).Ntof_DATA
  file_Ntof    = (size(img))(1)
  if ((*global).miniVersion) then begin
    new_N = N
    xsize = 304.
  endif else begin
    new_N = 2 * N
    xsize = 608.
  endelse
  
  IF (file_Ntof LT xsize) THEN BEGIN
    coeff_congrid_tof = xsize / FLOAT(file_Ntof)
  ENDIF ELSE BEGIN
    coeff_congrid_tof = 1
  ENDELSE
  
  (*global).congrid_x_coeff = coeff_congrid_tof
  
  ;change the size of the data draw true plotting area
  ;widget_control, id_draw, DRAW_XSIZE=file_Ntof
  ;tvimg = rebin(img, file_Ntof, new_N,/sample)
 id = widget_info(event.top, find_by_uname='load_data_D_draw')
  geometry = widget_info(id,/geometry)
  new_xsize = geometry.scr_xsize
  new_ysize = geometry.scr_ysize
  
  tvimg = congrid(img, new_xsize, new_ysize)
    
  (*(*global).tvimg_data_ptr) = tvimg
  
  ; tvimg = CONGRID(img,file_Ntof * coeff_congrid_tof, new_N)
  
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
  
  tvscl, tvimg, /device
END

;**********************************************************************
;Procedure that plots REF_L and REF_M 1D 3D data plots                *
;**********************************************************************
PRO Plot1DData_3D_File, Event, img
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;retrieve parameters
  PROCESSING = (*global).processing_message
  ;tells user that we are now plotting the 2D data
  LogBookText = '--> Plotting 1D_3D view ... ' + PROCESSING
  putLogBookMessage, Event, LogBookText, Append=1
  DEVICE, DECOMPOSED = 0
  id_draw = widget_info(Event.top, find_by_uname='load_data_d_3d_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  ;if (!VERSION.os EQ 'darwin') then begin
  ;   img = swap_endian(img)
  ;endif
  XYangle = (*global).PrevData1D3DAx
  ZZangle = (*global).PrevData1D3DAz
  shade_surf,img, Ax=XYangle, Az=ZZangle
  ;put various info in 1D_3D tab
  zmin = MIN(img,MAX=zmax)
  (*(*global).Data_1d_3D_min_max) = [zmin,zmax]
  REFreduction_UpdateData1D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
  ;remove PROCESSING_message from logbook and say ok
  LogBookText = getLogBookText(Event)
  putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
END

;Batch run only
PRO Plot1DData_3D_File_batch, Event, img
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  DEVICE, DECOMPOSED = 0
  id_draw = widget_info(Event.top, find_by_uname='load_data_d_3d_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  ;if (!VERSION.os EQ 'darwin') then begin
  ;   img = swap_endian(img)
  ;endif
  XYangle = (*global).PrevData1D3DAx
  ZZangle = (*global).PrevData1D3DAz
  shade_surf,img, Ax=XYangle, Az=ZZangle
  ;put various info in 1D_3D tab
  zmin = MIN(img,MAX=zmax)
  (*(*global).Data_1d_3D_min_max) = [zmin,zmax]
  REFreduction_UpdateData1D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
END

;**********************************************************************
;Procedure that replots                                               *
;**********************************************************************
PRO RePlot1DDataFile, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  tvimg = (*(*global).tvimg_data_ptr)
  Device, decomposed=0
  id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  tvimg = new_rescaled_tvimg(event)
  
  tvscl, tvimg, /device
END
