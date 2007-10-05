;this function plots the 1D view (main view) of the NORMALIZATION file only
PRO REFreduction_Plot1DNormalizationFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check instrument selected
instrument = (*global).instrument

if (instrument EQ (*global).REF_L) then begin
    Plot1DNormalizationFileForRefL, Event ;REF_L
endif else begin
    Plot1DNormalizationFileForRefM, EVENT ;REF_M
endelse

END



;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 1D view of the normalization file for the REF_L
PRO Plot1DNormalizationFileForRefL, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

N = (*global).Ny_REF_L ; 304
img = (*(*global).NORM_D_ptr) ;data(Ntof,Ny,Nx)
img = total(img,3)
(*(*global).NORM_D_Total_ptr) = img

Plot1DNormalizationFile, Event, img, N
Plot1DNormalization_3D_File, Event, img

END



;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 1D view of the normalization file for the REF_M
PRO Plot1DNormalizationFileForRefM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

N = (*global).Nx_REF_M ; 304
img = (*(*global).NORM_D_ptr) ;data(Ntof,Ny,Nx)
img = total(img,2)
(*(*global).NORM_D_Total_ptr) = img

Plot1DNormalizationFile, Event, img, N
Plot1DNormalization_3D_File, Event, img

END





;**********************************************************************
;Procedure that plots REF_L and REF_M 1D normalization plots          *
;**********************************************************************
PRO Plot1DNormalizationFile, Event, img, N

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get size of img
sz=size(img)
zmin=min(img,max=zmax)
;populate rescale 1D data
putTextFieldValue,Event, 'normalization_rescale_xmin_cwfield',0,0
putTextFieldValue,Event, 'normalization_rescale_xmax_cwfield',sz[1]-1,0
putTextFieldValue,Event, 'normalization_rescale_ymin_cwfield',0,0
putTextfieldValue,Event, 'normalization_rescale_ymax_cwfield',sz[2]-1,0
putTextFieldValue,Event, 'normalization_rescale_zmin_cwfield',zmin,0
putTextFieldValue,Event, 'normalization_rescale_zmax_cwfield',zmax-1,0
(*(*global).NormXYZminmaxArray) = [0,sz[1]-1,$
                                   0,sz[2]-1,$
                                   zmin,zmax-1]

;retrieve parameters
PROCESSING = (*global).processing_message
tmp_file = (*global).full_norm_tmp_dat_file

;tells user that we are now plotting the 2D data
LogBookText = '----> Plotting 1D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

;transpose just for display purpose
;img=transpose(img)

DEVICE, DECOMPOSED = 0

id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

if (!VERSION.os EQ 'darwin') then begin
   img = swap_endian(img)
endif

;rebin data to fill up all graph
new_Ntof = (*global).Ntof_NORM
new_N = 2 * N
tvimg = rebin(img, new_Ntof, new_N,/sample)
(*(*global).tvimg_norm_ptr) = tvimg
tvscl, tvimg, /device

;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING

END



;**********************************************************************
PRO Plot1DNormalization_3D_File, Event, img

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve parameters
PROCESSING = (*global).processing_message

;tells user that we are now plotting the 2D data
LogBookText = '----> Plotting 1D_3D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

DEVICE, DECOMPOSED = 0

id_draw = widget_info(Event.top, find_by_uname='load_normalization_d_3d_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

if (!VERSION.os EQ 'darwin') then begin
   img = swap_endian(img)
endif

XYangle = (*global).PrevNorm1D3DAx
ZZangle = (*global).PrevNorm1D3DAz

shade_surf,img, Ax=XYangle, Az=ZZangle

;put various info in 1D_3D tab
zmin = MIN(img,MAX=zmax)
(*(*global).Normalization_1d_3d_min_max) = [zmin,zmax]
REFreduction_UpdateNorm1D3DTabGui, Event, zmin, zmax, XYangle, ZZangle

;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING

END



;**********************************************************************
;Procedure that replots                                               *
;**********************************************************************
PRO RePlot1DNormFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tvimg = (*(*global).tvimg_norm_ptr)

DEVICE, DECOMPOSED = 0

id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
tvscl, tvimg, /device

END
