;This function plots the 2D view of the DATA file only
PRO REFreduction_Plot2DDataFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check instrument selected
instrument = (*global).instrument

if (instrument EQ (*global).REF_L) then begin
    Plot2DDataFileForRefL, Event ;REF_L
endif else begin
    Plot2DDataFileForRefM, EVENT ;REF_M
endelse

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
LogBookText = '----> Plotting 2D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

openr,u,tmp_file,/get
;find out file info
fs = fstat(u)
Nimg = long(Nx)*long(Ny)
Ntof = fs.size/(Nimg*4L)
(*global).Ntof_DATA = Ntof ;store Number of TOF for DATA file

;read data
data=lonarr(Ntof*Nimg)
readu,u,data

indx1 = where(data GT 0, Ngt0)
img = intarr(Ntof,Ny,Nx)
IF (Ngt0 GT 0) THEN BEGIN
    img(indx1)=data(indx1)
ENDIF 
;store big array that will be used by 1D plot
(*(*global).DATA_D_ptr) = img ;data(Ntof,Ny,Nx)
img = total(img,1)
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

close,u
free_lun,u

;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING

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
LogBookText = '----> Plotting 2D_3D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

DEVICE, DECOMPOSED = 0

id_draw = widget_info(Event.top, find_by_uname='load_data_dd_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

img = (*(*global).DATA_DD_ptr)

if (!VERSION.os EQ 'darwin') then begin
   img = swap_endian(img)
endif

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
