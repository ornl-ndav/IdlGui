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

;This function plots the 2D view of the DATA file only
FUNCTION REFreduction_Plot2DDataFile, Event
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
        Plot2DDataFileForRefL, Event ;REF_L
    endif else begin
        Plot2DDataFileForRefM, EVENT ;REF_M
    ENDELSE
ENDELSE
RETURN, 1
END

;This function plots the 2D view of the DATA file only and is only
;reached by the IDLupateGUI class
FUNCTION REFreduction_Plot2DDataFile_batch, Event
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
        Plot2DDataFileForRefL_batch, Event ;REF_L
    endif else begin
        Plot2DDataFileForRefM_batch, EVENT ;REF_M
    ENDELSE
ENDELSE
RETURN, 1
END

;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 2D view of the data file for the REF_L
PRO Plot2DDataFileForRefL, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_L ;256
Ny         = (*global).Ny_REF_L ;304
Plot2DDataFile, Event, Nx, Ny
Plot2DData_3D_File, Event
END

;Plots the 2D view of the data file for the REF_L for batch run
PRO Plot2DDataFileForRefL_batch, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_L ;256
Ny         = (*global).Ny_REF_L ;304
Plot2DDataFile_batch, Event, Nx, Ny
Plot2DData_3D_File_batch, Event
END

;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 2D view of the data file for the REF_M
PRO Plot2DDataFileForRefM, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_M ;304
Ny         = (*global).Ny_REF_M ;256
Plot2DDataFile, Event, Nx, Ny
Plot2DData_3D_File, Event
END

;Plots the 2D view of the data file for the REF_M for batch run
PRO Plot2DDataFileForRefM_batch, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_M ;304
Ny         = (*global).Ny_REF_M ;256
Plot2DDataFile_batch, Event, Nx, Ny
Plot2DData_3D_File_batch, Event
END

;**********************************************************************
;Procedure that plots REF_L and REF_M 2D data plots                   *
;**********************************************************************
PRO Plot2DDataFile, Event, Nx, Ny
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
PROCESSING = (*global).processing_message
tmp_file = (*global).full_data_tmp_dat_file
;tells user that we are now plotting the 2D data
LogBookText = '--> Plotting 2D view ... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1
img = (*(*global).bank1_data)
(*global).Ntof_DATA = (size(img))(1)
;store big array that will be used by 1D plot
(*(*global).DATA_D_ptr) = img ;data(Ntof,Ny,Nx)
img = total(img,1) ; data(Ntof,Nx)
;load data up in global ptr array
(*(*global).DATA_DD_ptr) = img
;transpose just for display purpose
img=transpose(img)
DEVICE, DECOMPOSED = 0
id_draw = widget_info(Event.top, find_by_uname='load_data_DD_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase
if ((*global).miniVersion) then begin
    New_Ny = Ny
    New_Nx = Nx
endif else begin
    New_Ny = 2*Ny
    New_Nx = 2*Nx
endelse
tvimg = rebin(img, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device
;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
END

;Batch mode of the same function
PRO Plot2DDataFile_batch, Event, Nx, Ny
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
tmp_file = (*global).full_data_tmp_dat_file
img = (*(*global).bank1_data)
(*global).Ntof_DATA = (size(img))(1)
;store big array that will be used by 1D plot
(*(*global).DATA_D_ptr) = img ;data(Ntof,Ny,Nx)
img = total(img,1) ; data(Ntof,Nx)
;load data up in global ptr array
(*(*global).DATA_DD_ptr) = img
;transpose just for display purpose
img=transpose(img)
DEVICE, DECOMPOSED = 0
id_draw = widget_info(Event.top, find_by_uname='load_data_DD_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase
if ((*global).miniVersion) then begin
    New_Ny = Ny
    New_Nx = Nx
endif else begin
    New_Ny = 2*Ny
    New_Nx = 2*Nx
endelse
tvimg = rebin(img, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device
END

;**********************************************************************
;Procedure that plots REF_L and REF_M 2D 3D data plots                *
;**********************************************************************
PRO Plot2DData_3D_File, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
PROCESSING = (*global).processing_message
;tells user that we are now plotting the 2D_3D data
LogBookText = '--> Plotting 2D_3D view ... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1
DEVICE, DECOMPOSED = 0
id_draw = widget_info(Event.top, find_by_uname='load_data_dd_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase
img = (*(*global).DATA_DD_ptr)
;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif
XYangle = (*global).PrevData2D3DAx
ZZangle = (*global).PrevData2D3DAz
shade_surf,img, Ax=XYangle, Az=ZZangle
;put various info in 1D_3D tab
zmin = MIN(img,MAX=zmax)
(*(*global).Data_2d_3D_min_max) = [zmin,zmax]
REFreduction_UpdateData2D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING
END

;Batch mode of the same function
PRO Plot2DData_3D_File_batch, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
DEVICE, DECOMPOSED = 0
id_draw = widget_info(Event.top, find_by_uname='load_data_dd_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase
img = (*(*global).DATA_DD_ptr)
;if (!VERSION.os EQ 'darwin') then begin
;   img = swap_endian(img)
;endif
XYangle = (*global).PrevData2D3DAx
ZZangle = (*global).PrevData2D3DAz
shade_surf,img, Ax=XYangle, Az=ZZangle
;put various info in 1D_3D tab
zmin = MIN(img,MAX=zmax)
(*(*global).Data_2d_3D_min_max) = [zmin,zmax]
REFreduction_UpdateData2D3DTabGui, Event, zmin, zmax, XYangle, ZZangle
END

;==============================================================================
;REFRESH of plots

;This function plots the 2D view of the DATA file only
PRO refreshPlot2DDataFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;check instrument selected
instrument = (*global).instrument

;retrieve loadct parameters
LoadctIndex = getDropListSelectedIndex(Event,'data_contrast_droplist')
;get bottom value of color
BottomColorValue = getSliderValue(Event,'data_contrast_bottom_slider')
;get number of color
NumberColorValue = getSliderValue(Event,'data_contrast_number_slider')
loadct,loadctIndex, Bottom=BottomColorValue,NColors=NumberColorValue,/SILENT

if (instrument EQ (*global).REF_L) then begin
    refresh_Plot2DDataFileForRefL, Event ;REF_L
endif else begin
    refresh_Plot2DDataFileForRefM, EVENT ;REF_M
endelse
END

;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 2D view of the data file for the REF_L
PRO refresh_Plot2DDataFileForRefL, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_L ;256
Ny         = (*global).Ny_REF_L ;304
Plot2DDataFile, Event, Nx, Ny
END

;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 2D view of the data file for the REF_M
PRO refresh_Plot2DDataFileForRefM, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve parameters
Nx         = (*global).Nx_REF_M ;304
Ny         = (*global).Ny_REF_M ;256
Plot2DDataFile, Event, Nx, Ny
END

