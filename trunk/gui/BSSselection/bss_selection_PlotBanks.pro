PRO PlotBank1Grid, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

x_coeff = (*global).Xfactor
y_coeff = (*global).Yfactor
colorY  = (*global).ColorVerticalGrid
colorX  = (*global).ColorHorizontalGrid

for i=1,56 do begin
  plots, i*x_coeff, 0, /device, color=colorY
  plots, i*x_coeff, 64*y_coeff, /device, /continue, color=colorY
endfor

for i=1,64 do begin
  plots, 0,i*y_coeff, /device,color=colorX
  plots, 64*x_coeff, i*y_coeff, /device, /continue, color=colorX
endfor

END




PRO PlotBank2Grid, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

x_coeff = (*global).Xfactor
y_coeff = (*global).Yfactor
colorY  = (*global).ColorVerticalGrid
colorX  = (*global).ColorHorizontalGrid

for i=1,56 do begin
  plots, i*x_coeff, 0, /device, color=colorY
  plots, i*x_coeff, 64*y_coeff, /device, /continue, color=colorY
endfor

for i=1,64 do begin
  plots, 0,i*y_coeff, /device,color=colorX
  plots, 64*x_coeff, i*y_coeff, /device, /continue, color=colorX
endfor

END




;This function will plot the bank1 and bank2 grids
PRO PlotBanksGrid, Event
PlotBank1Grid, Event
PlotBank2Grid, Event
END





PRO bss_selection_PlotBank1, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

bank1_sum = (*(*global).bank1_sum)

;transpose data
bank1_sum_transpose = transpose(bank1_sum)
    
;rebin data
Nx = (*global).Nx
Ny = (*global).Ny
    
Xfactor = (*global).Xfactor
Yfactor = (*global).Yfactor
    
tvimg_bank1 = rebin(bank1_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
    
;plot data
;top bank = bank1
view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
tvscl, tvimg_bank1
END



PRO bss_selection_PlotBank2, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

bank2_sum = (*(*global).bank2_sum)
    
;transpose data
bank2_sum_transpose = transpose(bank2_sum)
    
;rebin data
Nx = (*global).Nx
Ny = (*global).Ny

Xfactor = (*global).Xfactor
Yfactor = (*global).Yfactor

tvimg_bank2 = rebin(bank2_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
    
;bottom bank = bank2
    view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
    WIDGET_CONTROL, view_info, GET_VALUE=id
    wset, id
    tvscl, tvimg_bank2
END






PRO bss_selection_PlotBanks, Event, success

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

bank1 = (*(*global).bank1)
bank2 = (*(*global).bank2)

tof_array = bank1(*,0,0)
NbTOF = (size(tof_array))(1)
(*global).NBTOF = NbTOF

;error = 0
;CATCH, error
;if (error NE 0) then begin
;    CATCH,/cancel
;endif else begin

;sum over TOF
bank1_sum = total(bank1,1)
bank2_sum = total(bank2,1)

;remove useless last rack
bank1_sum = bank1_sum(0:63,0:55)
bank2_sum = bank2_sum(0:63,0:55)

;store banks sum
(*(*global).bank1_sum) = bank1_sum
(*(*global).bank2_sum) = bank2_sum

bss_selection_PlotBank1, Event
bss_selection_PlotBank2, Event

;plot grid
PlotBanksGrid, Event

success = 1
    
;endelse

END
