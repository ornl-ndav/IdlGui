PRO FitOrder_n_Function, Event, flt0, flt1, flt2, index, order_n

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(flt0, flt1, order_n, MEASURE_ERRORS=flt2, $
   SIGMA=sigma,/double)

fit_cooef_ptr = (*global).fit_cooef_ptr
*fit_cooef_ptr[index] = cooef
(*global).fit_cooef_ptr = fit_cooef_ptr
(*global).show_other_fit = 1

END




PRO FitCEFunction, Event, flt0, flt1, flt2

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(flt0, flt1, 1, MEASURE_ERRORS=flt2, $
   SIGMA=sigma)
(*(*global).CEcooef) = cooef
(*global).show_CE_fit = 1

;; Print the coefficients:
;PRINT, 'Coefficients: ', cooef
;PRINT, 'Standard errors: ', sigma

;;show original data
;loadct,3
;window,0
;plot,flt0,flt1

;;now calculate data on new coordinates
;N_new = 100
;x_new = findgen(N_new)/N_new
;y_new = cooef(2)*x_new^2 + cooef(1)*x_new + cooef(0)

;;overplot new data in red
;oplot,x_new,y_new,color=200,thick=1.5

END










