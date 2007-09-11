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

Plot1DNormalizationFile, Event, img, N
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

Plot1DNormalizationFile, Event, img, N

END





;**********************************************************************
;Procedure that plots REF_L and REF_M 1D normalization plots          *
;**********************************************************************
PRO Plot1DNormalizationFile, Event, img, N

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve parameters
PROCESSING = (*global).processing_message
tmp_file = (*global).full_norm_tmp_dat_file

;tells user that we are now plotting the 2D data
LogBookText = '----> Plotting 1D view ...... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1

;transpose just for display purpose
;img=transpose(img)

DEVICE, DECOMPOSED = 0
;loadct,5

id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

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
