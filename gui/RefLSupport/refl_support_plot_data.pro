;This function plots the selected file
PRO plot_loaded_file, Event, LongFileName

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument = (*global).instrument
first_time_plotting_data_reduction = (*global).first_time_plotting_data_reduction

tvscl_x_off = 42
tvscl_y_off = 21

catch, error_plot_status
if (error_plot_status NE 0) then begin
    text = 'Not enough data to plot'
    CATCH,/cancel
    
;log book ids (full and simple)
    view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
    full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
    output_into_text_box, event, 'log_book_text', text
    output_into_text_box, event, 'info_text', text

endif else begin
    
    Ntof = (*global).Ntof

    if (first_time_plotting_data_reduction EQ 1) then begin
            
        openr,u,plot_file_name,/get
        fs = fstat(u)
        
;define an empty string variable to hold results from reading the file
        tmp  = ''
        tmp0 = ''
        tmp1 = ''
        tmp2 = ''
        
        flt0 = -1.0
        flt1 = -1.0
        flt2 = -1.0
        
        Nelines = 0L ;number of lines that does not start with a number
        Nndlines = 0L
        Ndlines = 0L
        onebyte = 0b
        
        while (NOT eof(u)) do begin
            
            readu,u,onebyte     ;,format='(a1)'
            fs = fstat(u)
                                ;print,'onebyte: ',onebyte
                                ;rewinded file pointer one character
            
            if fs.cur_ptr EQ 0 then begin 
                point_lun,u,0
            endif else begin
                point_lun,u,fs.cur_ptr - 1
            endelse
            
            true = 1
            case true of
                
                ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                    Nelines = Nelines + 1
                    readf,u,tmp
                end
                
                else: begin
                                ;case where we (should) have data
                    Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                    
                    catch, Error_Status
                    if Error_status NE 0 then begin
                        
                                ;you're done now...
                        CATCH, /CANCEL
                        
                    endif else begin
                        
                        readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                        flt0 = [flt0,float(tmp0)] ;x axis
                        flt1 = [flt1,float(tmp1)] ;y axis
                        flt2 = [flt2,float(tmp2)] ;y_error axis
                        
                    endelse
                    
                end
            endcase
            
        endwhile
        
;strip -1 from beginning of each array
        flt0 = flt0[1:*]
        flt1 = flt1[1:*]
        flt2 = flt2[1:*]
        
;check if plot is main plot or intermediate plot
        other_plots_tab_id = widget_info(Event.top,find_by_uname='data_reduction_tab')
        value = widget_info(other_plots_tab_id, /tab_current)
        
        case value of
            
            0: n=0
            2: begin            ;intermediate plots
                
;get active tab
                other_plots_tab_id = widget_info(Event.top,find_by_uname='other_plots_tab')
                value_intermediate = widget_info(other_plots_tab_id, /tab_current)
                
                case value_intermediate of
                    
                    0: n=1
                    1: n=2
                    2: n=3
                    3: n=4
                    4: n=5
                    
                endcase
                
            end
            else:
        endcase
        
        first_time_plotting_n = (*(*global).first_time_plotting_n)
        first_time_plotting = first_time_plotting_n[n]
        
        if (first_time_plotting EQ 1) then begin
            
            first_time_plotting_n[n]=0
            REF_logo_base_id = widget_info(event.top,find_by_uname='REF_L_logo_base')
            
        endif
                    
        draw_id = widget_info(Event.top, find_by_uname=draw_uname)
        WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
        wset,view_plot_id
        
;x_axis
;        Ntof = 750L             ;remove_me
        x_axis=flt0[sort(flt0[0:(Ntof-1)])]
        tvscl_x_axis = lindgen(float(x_axis[Ntof-1]))
        (*(*global).tvscl_x_axis) = tvscl_x_axis
;y_axis
        flt0_size = size(flt0)
        number_of_row = fix(flt0_size[1]/Ntof)
        (*global).number_of_row_in_data_reduction_file = number_of_row
;define the final big array
        final_array = fltarr(Ntof,number_of_row)
        for i=0,(number_of_row-1) do begin
            final_array[0,i] = flt1[i*Ntof:i*Ntof+(Ntof-1)]
        endfor
        
        (*(*global).final_array) = final_array
        (*global).first_time_plotting_data_reduction = 0
        
        close,u
        free_lun,u

;plot of scale
        print, 'here'
        data_reduction_scale_id = widget_info(Event.top,FIND_BY_UNAME='data_reduction_scale')
        WIDGET_CONTROL, data_reduction_scale_id, GET_VALUE=id
        wset, id
        New_Ny = number_of_row * floor((393-tvscl_y_off)/number_of_row)
        cscl = lindgen(20,New_Ny)
        tvscl,cscl,25,10,/device
        
    endif else begin

        final_array = (*(*global).final_array)
        number_of_row = (*global).number_of_row_in_data_reduction_file 
        tvscl_x_axis = (*(*global).tvscl_x_axis)

    endelse

    if (instrument EQ 'REF_L') then begin

        data_reduction_scale_max_id = widget_info(event.top,find_by_uname='data_reduction_scale_max')
        data_reduction_scale_min_id = widget_info(event.top,find_by_uname='data_reduction_scale_min')
        
        if (first_time_plotting_data_reduction EQ 1) then begin
            
            max_top = max(final_array,/nan)
            min_top = min(final_array,/nan)
            widget_control, data_reduction_scale_max_id, set_value=strcompress(max_top)
            widget_control, data_reduction_scale_min_id, set_value=strcompress(min_top)
            
        endif
        
        if ((*global).reset_data_reduction EQ 0) then begin
            
;remove data outside the range selected in the text boxes
            widget_control, data_reduction_scale_max_id, get_value=max_value
            widget_control, data_reduction_scale_min_id, get_value=min_value
            
            if (max_value NE '') then begin
                max_value = float(max_value[0])
                indx_max = where(float(final_array) GT max_value, Nmax)
                if (Nmax NE 0) then begin
                    final_array(indx_max) = !Values.F_NAN
                endif
            endif
            
            if (min_value NE '') then begin
                min_value = float(min_value[0])
                indx_min = where(final_array LT min_value, Nmin)
                if (Nmin NE 0) then begin
                    final_array(indx_min) = !Values.F_NAN
                endif
            endif
            
        endif else begin

            max_top = max(final_array,/nan)
            min_top = min(final_array,/nan)
            widget_control, data_reduction_scale_max_id, set_value=strcompress(max_top)
            widget_control, data_reduction_scale_min_id, set_value=strcompress(min_top)
            (*global).reset_data_reduction = 0            

        endelse
        
    endif

;;remove -inf and inf
;    indx1 = where(final_array EQ !VALUES.F_INFINITY, ngt1)
;    if (ngt1 NE 0) then begin
;        final_array(indx1) = (*global).plus_inf
;    endif
;    
;    indx2 = where(final_array EQ -!VALUES.F_INFINITY, ngt2)
;    if (ngt2 NE 0) then begin
;        final_array(indx2) = (*global).minus_inf
;    endif
    
    uncombine_data_formula_id = widget_info(event.top,find_by_uname='uncombine_data_formula')
    widget_control, uncombine_data_formula_id, get_value=formula_list
    index = widget_info(uncombine_data_formula_id, /droplist_select)
    formula_selected = formula_list[index]
    
    if ( formula_selected EQ 'log10') then begin ;log10
        
;remove negative numbers and zeros too
        indx4 = where(final_array LE 0, ngt0)
        if (ngt0 NE 0) then begin
            final_array(indx4) = !values.F_NAN
        endif
        
        indx5 = where(final_array GT 0, ngt1) 
        if (ngt1 NE 0) then begin
            final_array(indx5) = alog10(final_array(indx5))
        endif
        
    endif
    
;;indx3 = where(final_array EQ strcompress(!values.F_NAN), ngt)
;nan = !VALUES.F_NAN
;nan_user = (*global).nan_user
;for i=0,(number_of_row*Ntof-1) do begin
;    if (strcompress(final_array[i]) EQ strcompress(nan)) then begin
;        final_array[i] = nan_user 
;    endif
;endfor
    
;tvscl, final_array, /NAN
    
    CATCH,/CANCEL
    
    DEVICE, DECOMPOSED = 0
;    loadct,5
    
    New_Ny = number_of_row * floor((393-tvscl_y_off)/number_of_row)

;comment out this part when using tmp button
;    y12=18
;    ymin=50

;comment this part when using tmp button
    y12=(*global).y12
    ymin=(*global).ymin


;    tvscl_y_axis = indgen(y12)

    data_reduction_id = widget_info(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, data_reduction_id, GET_VALUE=id
    wset, id
    
    if (y12 GE 30) then begin
        
        tvscl_y_axis = (indgen(y12)+ymin)

        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
        plot, tvscl_x_axis, tvscl_y_axis, $
          yrange=[tvscl_y_axis[0],$
                  tvscl_y_axis[y12-1]],yticklayout=0, $
;      ystyle=8, $
        ystyle=1,$
          xstyle=8, $
          /nodata, /device, $
          /noerase, $
          xmargin=[7,0], $
;      ymargin=[2,0]
        ymargin=[2,(393-New_Ny)/10],$
          title='x-axis: tof(s) / y-axis: pixels'

    endif else begin

        tvscl_y_axis = (indgen(y12)+ymin)*0.7
        tvscl_y_axis_string = string(tvscl_y_axis)
        
        tvimg = rebin(final_array, Ntof, New_Ny, /sample)
        tvscl, tvimg, tvscl_x_off, tvscl_y_off, /nan
        plot, tvscl_x_axis, tvscl_y_axis, $
          yrange=[tvscl_y_axis[0],$
                  tvscl_y_axis[y12-1]],yticklayout=0, $
          ytickname=tvscl_y_axis_string, $
;      ystyle=8, $
        ystyle=1,$
          xstyle=8, $
          /nodata, /device, $
          /noerase, $
          xmargin=[7,0], $
;      ymargin=[2,0]
        ymargin=[2,(393-New_Ny)/10],$
          title='x-axis: tof(s) / y-axis: distance (mm)'
            
    endelse

  endelse
END
