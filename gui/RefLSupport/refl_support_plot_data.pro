

;This function will retrieve the values of Xmin/max and Ymin/max
FUNCTION retrieveXYMinMax, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;min-xaxis
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
widget_control, XminId, get_value=Xmin

;max-xaxis
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
widget_control, XmaxId, get_value=Xmax

;min-yaxis
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
widget_control, YminId, get_value=Ymin

;max-yaxis
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
widget_control, YmaxId, get_value=Ymax

return_array = [Xmin,Xmax,Ymin,Ymax]
return, return_array
END

;This function creates the default xmin/max and ymin/max values
;that will be used if one of the input is invalid
PRO CreateDefaultXYMinMax, Event,$
                           min_xaxis,$
                           max_xaxis,$
                           min_yaxis,$
                           max_yaxis

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

XYMinMax = (*(*global).XYMinMax)
XYMinMax = strarr(4)

XYMinMax[0] = min_xaxis
XYMinMax[1] = max_xaxis
XYMinMax[2] = min_yaxis
XYMinMax[3] = max_yaxis

(*(*global).XYMinMax) = XYMinMax
END


;This function populates the x/y axis text boxes
PRO PopulateXYScaleAxis, Event, $
                         min_xaxis, $
                         max_xaxis, $
                         min_yaxis, $
                         max_yaxis

;min-xaxis
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
widget_control, XminId, set_value=strcompress(min_xaxis,/remove_all)

;max-xaxis
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
widget_control, XmaxId, set_value=strcompress(max_xaxis,/remove_all)

;min-yaxis
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
widget_control, YminId, set_value=strcompress(min_yaxis,/remove_all)

;max-yaxis
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
widget_control, YmaxId, set_value=strcompress(max_yaxis,/remove_all)

END





;This function plots the selected file
PRO plot_loaded_file, Event, index

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;0 means that the fitting plot won't be seen
;1 means that the fitting plot will be seen
show_error_plot=0

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

IsXlin = getScale(Event,'X')
IsYlin = getScale(Event,'Y')
ClearPlot = 0                   ;by default, the display does not have to be erased

CASE (index) OF
   'CE': begin                  ;plot CE
      index_to_plot = [0]
   end
   'all': begin                 ;plot all the plots
      nbr_elements = getNbrElementsInDropList(Event,'step3_work_on_file_droplist')
      index_to_plot = indgen(nbr_elements)
   end
   '2plots': begin              ;plot index and (index-1) in tab 3
      nbr_elements = getNbrElementsInDropList(Event,'step3_work_on_file_droplist')
      if (nbr_elements EQ 1) then begin ;if only 1 file, must be CE file
         index_to_plot = [0]
      endif else begin          ;more than 1 file
         index_to_plot = getSelectedIndex(Event, 'step3_work_on_file_droplist')
         if (index_to_plot EQ 0) then begin
            index_to_plot = [0]
         endif else begin
            index_to_plot = [index_to_plot-1,index_to_plot]
         endelse
      endelse
   end
   'clear': begin               ;no files to plot, just erase display
      ClearPlot = 1
   end
ENDCASE

DEVICE, DECOMPOSED = 0
loadct,5

;check if plot will be with error bars or not
ErrorBarStatus = getButtonValidated(Event, 'show_error_bar_group')

if (ClearPlot EQ 1) then begin  ;no plot to plot, erase display
   erase
endif else begin                ;at least one file has to be ploted
   
;retrieve flt0, flt1 and flt2
   flt0_ptr = (*global).flt0_rescale_ptr
   flt1_ptr = (*global).flt1_rescale_ptr
   flt2_ptr = (*global).flt2_rescale_ptr
   
   index_size = (size(index_to_plot))(1)
   for i=0,(index_size-1) do begin
      
                                ;retrieve particular flt0, flt1 and flt2
      flt0 = *flt0_ptr[index_to_plot[i]]
      flt1 = *flt1_ptr[index_to_plot[i]]
      flt2 = *flt2_ptr[index_to_plot[i]]
      
      color_array = (*(*global).color_array)
      colorIndex = color_array[index_to_plot[i]]
      
      XYMinMax = retrieveXYMinMax(Event)
      xmin = float(XYMinMax[0])
      xmax = float(XYMinMax[1])
      ymin = float(XYMinMax[2])
      ymax = float(XYMinMax[3])
      
      if (i EQ 0) Then begin
         
         case IsXlin of
            0:begin
               case IsYlin of
                  0: begin
                     plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax]
                  end
                  1: begin
                     plot,flt0,flt1,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
                  end
               endcase
            end
            1: begin
               case IsYlin of
                  0: begin
                     plot,flt0,flt1,/xlog,xrange=[xmin,xmax],yrange=[ymin,ymax]
                  end
                  1: begin
                     plot,flt0,flt1,/xlog,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
                  end
               endcase
            end
        endcase               
        
        if (ErrorBarStatus EQ 0) then begin
            errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
        endif

    endif else begin
        
        XYMinMax = retrieveXYMinMax(Event)
        xmin = float(XYMinMax[0])
        xmax = float(XYMinMax[1])
        ymin = float(XYMinMax[2])
        ymax = float(XYMinMax[3])
        
        case IsXlin of
            0:begin
                case IsYlin of
                    0: begin
                        plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax],/noerase
                    end
                    1: begin
                        plot,flt0,flt1,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax],/noerase
                    end
                endcase
            end
            1: begin
                case IsYlin of
                    0: begin
                        plot,flt0,flt1,/xlog,xrange=[xmin,xmax],yrange=[ymin,ymax],/noerase
                    end
                    1: begin
                        plot,flt0,flt1,/xlog,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax],/noerase
                    end
                endcase
            end
        endcase            
        
    endelse
    
    if (ErrorBarStatus EQ 0) then begin
        errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
    endif
    
                                ;fitting plots
       case (index) of
          'CE': begin            ;CE file only (linear fitting)
                                 ;polynome of degree 1 for CE 
             if ((*global).show_CE_fit EQ 1) then begin
                cooef = (*(*global).CEcooef)
                if (cooef[0] NE 0 AND $
                    cooef[1] NE 0) then begin
                   show_error_plot=1
                   flt0_new = (*(*global).flt0_CE_range)
                   y_new = cooef(1)*flt0_new + cooef(0)
                   oplot,flt0_new,y_new,color=400,thick=1.5
                endif
             endif
          end
          '2plots': begin
               if ((*global).show_other_fit EQ 1) then begin
                   cooef = (*global).fit_cooef_ptr
                   cooef_low_Q = *cooef[i]
                 
                                  ;retrieve flt0 between Q1 and Q2 for plotting only
                   flt0_range_ptr = (*global).flt0_range
                   flt0_new = *flt0_range_ptr[i]
                   if (cooef_low_Q[0] NE 0) then begin
                     
                       flt0_new_ptr = (*global).flt0_range
                       flt0_new = *flt0_new_ptr[i]
                      
                       y_new = 0
                       cooef_size = (size(cooef_low_Q))(2)
                       for k=0,(cooef_size-1) do begin
                           y_new += cooef_low_Q(k)*flt0_new^k
                       endfor
                       oplot,flt0_new,y_new,color=400,thick=1.5
                   endif
               endif
           end
           else:
      endcase
     
 endfor
 
endelse

END
