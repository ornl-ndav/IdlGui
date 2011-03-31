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

FUNCTION REFreduction_PlotEmptyCellFile, Event

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
    if (instrument EQ (*global).REF_L) then begin
      PlotEmptyCellForRefL, Event ;REF_L
    endif else begin
      PlotEmptyCellForRefM, EVENT ;REF_M
    ENDELSE
  ENDELSE
  RETURN, 1
END

;-----------------------------------------------------------------------
FUNCTION REFreduction_PlotEmptyCellFile_from_repopulate, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;check instrument selected
  instrument = (*global).instrument
  no_error = 0
  ;CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF ELSE BEGIN
    if (instrument EQ (*global).REF_L) then begin
      PlotEmptyCellForRefL_from_repopulate, Event ;REF_L
    endif else begin
      PlotEmptyCellForRefM_from_repopulate, EVENT ;REF_M
    ENDELSE
  ENDELSE
  RETURN, 1
END

;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 2D view of the data file for the REF_L
PRO PlotEmptyCellForRefL, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;retrieve parameters
  Nx         = (*global).Nx_REF_L ;256
  Ny         = (*global).Ny_REF_L ;304
  
  PlotEmptyCell, Event, Nx, Ny
  
END

PRO PlotEmptyCellForRefL_from_repopulate, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;retrieve parameters
  Nx         = (*global).Nx_REF_L ;256
  Ny         = (*global).Ny_REF_L ;304
  
  PlotEmptyCell_from_repopulate, Event, Nx, Ny
END

;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 2D view of the data file for the REF_M
PRO PlotEmptyCellForRefM, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;retrieve parameters
  Nx         = (*global).Nx_REF_M ;304
  Ny         = (*global).Ny_REF_M ;256
  
  PlotEmptyCell, Event, Nx, Ny
  
END

PRO PlotEmptyCellForRefM_from_repopulate, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;retrieve parameters
  Nx         = (*global).Nx_REF_M ;304
  Ny         = (*global).Ny_REF_M ;256
  
  PlotEmptyCell_from_repopulate, Event, Nx, Ny
  
END

;**********************************************************************
;Procedure that plots REF_L and REF_M 2D data plots                   *
;**********************************************************************
PRO PlotEmptyCell, Event, Nx, Ny

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;retrieve parameters
  PROCESSING = (*global).processing_message
  
  ;tells user that we are now plotting the 2D data
  LogBookText = '--> Plotting Y vs X view ... ' + PROCESSING
  putLogBookMessage, Event, LogBookText, Append=1
  img = (*(*global).bank1_empty_cell)
  
  file_Ntof = (size(img))(1)
  (*global).Ntof_empty_cell = file_Ntof
  
  ;plot y vs x ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ;store big array that will be used by 1D plot
  (*(*global).empty_cell_D_ptr) = img ;data(Ntof,Ny,Nx)
  img = total(img,1) ; data(Ntof,Nx)
  ;load data up in global ptr array
  (*(*global).empty_cell_DD_ptr) = img
  
  ;transpose just for display purpose
  img = TRANSPOSE(img)
  DEVICE, DECOMPOSED = 0
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='empty_cell_draw2_uname')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ERASE
  
  IF ((*global).miniVersion) THEN BEGIN
    New_Ny = Ny
    New_Nx = Nx
    xsize = 304.
  ENDIF ELSE BEGIN
    New_Ny = 2*Ny
    New_Nx = 2*Nx
    xsize = 608.
  ENDELSE
  
  tvimg = REBIN(img, New_Nx, New_Ny,/SAMPLE)
  TVSCL, tvimg, /DEVICE
  
  ;remove PROCESSING_message from logbook and say ok
  LogBookText = getLogBookText(Event)
  putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
  
  ;plot y vs tof ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  N   = (*global).Ny_REF_L ; 304
  img = (*(*global).empty_cell_D_ptr) ;data(Ntof,Ny,Nx)
  
  IF ((*global).instrument EQ 'REF_L') THEN BEGIN
    img = TOTAL(img,3)          ;data(Ntof,Ny)
  ENDIF ELSE BEGIN
    img = TOTAL(img,2)          ;data(Ntof,Ny)
  ENDELSE
  (*(*global).empty_cell_D_TOTAL_ptr) = img
  
  LogBookText = '--> Plotting Y vs TOF view ... ' + PROCESSING
  putLogBookMessage, Event, LogBookText, Append=1
  DEVICE, DECOMPOSED = 0
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='empty_cell_draw1_uname')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ERASE
  
  ;IF (!VERSION.os EQ 'darwin') THEN BEGIN
  ;   img = SWAP_ENDIAN(img)
  ;ENDIF
  
  ;rebin data to fill up all graph
  display_Ntof = (*global).Ntof_empty_cell
  file_Ntof    = (SIZE(img))(1)
  if ((*global).miniVersion) then begin
    new_N = N
  endif else begin
    new_N = 2 * N
  endelse
  
  IF ((*global).Ntof_empty_cell LT xsize) THEN BEGIN
    coeff_congrid_tof = xsize / FLOAT((*global).Ntof_empty_cell)
  ENDIF ELSE BEGIN
    coeff_congrid_tof = 1
  ENDELSE
  
  (*global).congrid_empty_cell_x_coeff = coeff_congrid_tof
  
  ;change the size of the data draw true plotting area
  ;widget_control, id_draw, DRAW_XSIZE=file_Ntof
  tvimg = CONGRID(img,file_Ntof * coeff_congrid_tof, new_N)
  (*(*global).tvimg_empty_cell_ptr) = tvimg
  TVSCL, tvimg, /DEVICE
  
  ;remove PROCESSING_message from logbook and say ok
  LogBookText = getLogBookText(Event)
  putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
  
  ;bring to life the Substrate Transmission Equation
  ActivateWidget, Event, 'empty_cell_substrate_base', 1
  
END


PRO PlotEmptyCell_from_repopulate, Event, Nx, Ny

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  img = (*(*global).bank1_empty_cell)
  
  (*global).Ntof_empty_cell = (size(img))(1)
  
  ;plot y vs x ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ;store big array that will be used by 1D plot
  (*(*global).empty_cell_D_ptr) = img ;data(Ntof,Ny,Nx)
  img = total(img,1) ; data(Ntof,Nx)
  ;load data up in global ptr array
  (*(*global).empty_cell_DD_ptr) = img
  
  ;transpose just for display purpose
  img = TRANSPOSE(img)
  DEVICE, DECOMPOSED = 0
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='empty_cell_draw2_uname')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ERASE
  
  IF ((*global).miniVersion) THEN BEGIN
    New_Ny = Ny
    New_Nx = Nx
  ENDIF ELSE BEGIN
    New_Ny = 2*Ny
    New_Nx = 2*Nx
  ENDELSE
  
  tvimg = REBIN(img, New_Nx, New_Ny,/SAMPLE)
  
  TVSCL, tvimg, /DEVICE
  
  ;plot y vs tof ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  N   = (*global).Ny_REF_L ; 304
  img = (*(*global).empty_cell_D_ptr) ;data(Ntof,Ny,Nx)
  
  IF ((*global).instrument EQ 'REF_L') THEN BEGIN
    img = TOTAL(img,3)          ;data(Ntof,Ny)
  ENDIF ELSE BEGIN
    img = TOTAL(img,2)          ;data(Ntof,Ny)
  ENDELSE
  (*(*global).empty_cell_D_TOTAL_ptr) = img
  
  DEVICE, DECOMPOSED = 0
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='empty_cell_draw1_uname')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  ERASE
  ;IF (!VERSION.os EQ 'darwin') THEN BEGIN
  ;   img = SWAP_ENDIAN(img)
  ;ENDIF
  
  IF ((*global).miniVersion) THEN BEGIN
    xsize = (*global).empty_cell_draw_xsize_mini_version
  ENDIF ELSE BEGIN
    xsize = (*global).empty_cell_draw_xsize_big_version
  ENDELSE
  
  file_Ntof = (size(img))(1)
  IF (file_Ntof LT xsize) THEN BEGIN
    coeff_congrid_tof = xsize / FLOAT(file_Ntof)
  ENDIF ELSE BEGIN
    coeff_congrid_tof = 1
  ENDELSE
  
  (*global).congrid_x_coeff_empty_cell_sf = coeff_congrid_tof
  
  ;change the size of the data draw true plotting area
  ;widget_control, id_draw, DRAW_XSIZE=file_Ntof
  ;tvimg = rebin(img, file_Ntof, new_N,/sample)
  new_N = (size(img))(2)
  tvimg = CONGRID(img, file_Ntof * coeff_congrid_tof, new_N)
  
  (*(*global).tvimg_empty_cell_ptr) = tvimg
  TVSCL, tvimg, /DEVICE
  
  ;bring to life the Substrate Transmission Equation
  ActivateWidget, Event, 'empty_cell_substrate_base', 1
  
END

