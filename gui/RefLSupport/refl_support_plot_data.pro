;This function returns 1 if the specified axis scale is linear
;and 0 if it's logarithmic
FUNCTION getScale, Event, axis
if (axis EQ 'X') then begin
   uname = 'XaxisLinLog' 
endif else begin
   uname = 'YaxisLinLog'
endelse
axis_id = widget_info(Event.top,find_by_uname=uname)
widget_control, axis_id, get_value=value
return, value
END


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
PRO plot_loaded_file, Event, ListLongFileName

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;1 if first load, 0 otherwise
FirstTimePlotting = (*global).FirstTimePlotting

size = getSizeOfArray(ListLongFileName)

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

IsXlin = getScale(Event,'X')
IsYlin = getScale(Event,'Y')

if (size EQ 1 AND $
   ListLongFileName[0] EQ '') then begin
   
   ;no more files loaded so erase plot
   erase

endif else begin

    color_array = (*(*global).color_array)
    FirstPass = 1
    for i=0,(size-1) do begin

        error_plot_status = 0
        catch, error_plot_status
        if (error_plot_status NE 0) then begin
            text = 'Not enough data to plot'
            CATCH,/cancel
        endif else begin
    
            openr,u,ListLongFileName[i],/get
            fs = fstat(u)
        
;define an empty string variable to hold results from reading the file
            tmp  = ''
            tmp0 = ''
            tmp1 = ''
            tmp2 = ''
            
            flt0 = -1.0
            flt1 = -1.
            flt2 = -1.0
            
            Nelines = 0L ;number of lines that does not start with a number
            Nndlines = 0L
            Ndlines = 0L
            onebyte = 0b
            
            while (NOT eof(u)) do begin
                
                readu,u,onebyte ;,format='(a1)'
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
            
            close,u
            free_lun,u
            
            CATCH,/CANCEL
            DEVICE, DECOMPOSED = 0
            loadct,5
            
;check if input is TOF or Q
            isTOFvalidated = getButtonValidated(Event,'InputFileFormat')
            if(isTOFvalidated eq '0') then begin ;input file is in TOF

;Converts the data from TOF to Q
                (*(*global).flt0_xaxis) = flt0
                convert_TOF_to_Q, Event
                flt0 = (*(*global).flt0_xaxis)
;                flt1 = (*(*global).flt1_yaxis)
;                flt2 = (*(*global).flt2_yaxis_err)

            endif

            colorIndex = color_array[i]
            if (FirstPass EQ 1) then begin
                
                flt1_first = flt1
                
                if (FirstTimePlotting EQ 1) then begin
                    
                    case IsXlin of
                        0:begin
                            case IsYlin of
                                0: begin
                                    plot,flt0,flt1
                                end
                                1: begin
                                    plot,flt0,flt1,/ylog
                                end
                            endcase
                        end
                        1: begin
                            case IsYlin of
                                0: begin
                                    plot,flt0,flt1,/xlog
                                end
                                1: begin
                                    plot,flt0,flt1,/xlog,/ylog
                                end
                            endcase
                        end
                    endcase
                    errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                    
;populate min/max x/y axis
                    min_xaxis = min(flt0,max=max_xaxis,/nan)
                    min_yaxis = min(flt1,max=max_yaxis,/nan)
                    PopulateXYScaleAxis, Event, $
                      min_xaxis, $
                      max_xaxis, $
                      min_yaxis, $
                      max_yaxis
                    CreateDefaultXYMinMax,Event,$
                      min_xaxis,$
                      max_xaxis,$
                      min_yaxis,$
                      max_yaxis
                    
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
                    errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                    
                endelse
                
                FirstPass = 0
                
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
                errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                
            endelse
            
        endelse
        
    endfor
    
endelse

END
