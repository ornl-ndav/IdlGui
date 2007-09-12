;this function plots the 1D view (main view) of the DATA file only
PRO REFreduction_Plot1DDataFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;check instrument selected
instrument = (*global).instrument

if (instrument EQ (*global).REF_L) then begin
    Plot1DDataFileForRefL, Event ;REF_L
endif else begin
    Plot1DDataFileForRefM, EVENT ;REF_M
endelse

END



;**********************************************************************
;REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L - REF_L*
;**********************************************************************
;Plots the 1D view of the data file for the REF_L
PRO Plot1DDataFileForRefL, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

N = (*global).Ny_REF_L ; 304
img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
img = total(img,3)

Plot1DDataFile, Event, img, N
END



;**********************************************************************
;REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M - REF_M*
;**********************************************************************
;Plots the 1D view of the data file for the REF_M
PRO Plot1DDataFileForRefM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

N = (*global).Nx_REF_M ; 304
img = (*(*global).DATA_D_ptr) ;data(Ntof,Ny,Nx)
img = total(img,2)

Plot1DDataFile, Event, img, N

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
LogBookText = '----> Plotting 1D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

;transpose just for display purpose
;img=transpose(img)

DEVICE, DECOMPOSED = 0

id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

if (!VERSION.os EQ 'darwin') then begin
   img = swap_endian(img)
endif

;rebin data to fill up all graph
new_Ntof = (*global).Ntof_DATA
new_N = 2 * N
tvimg = rebin(img, new_Ntof, new_N,/sample)
(*(*global).tvimg_data_ptr) = tvimg
;shade_surf,tvimg
tvscl, tvimg, /device

;remove PROCESSING_message from logbook and say ok
LogBookText = getLogBookText(Event)
putTextAtEndOfLogBookLastLine, Event, LogBookText, 'OK', PROCESSING

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

tvscl, tvimg, /device

END
