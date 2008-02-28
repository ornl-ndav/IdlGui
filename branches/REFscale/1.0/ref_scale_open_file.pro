


;This function plot all the files loaded
;This function is only reached by the LOAD button
PRO ReflSupportOpenFile_PlotLoadedFiles, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ListLongFileName = (*(*global).ListOfLongFileName)

;1 if first load, 0 otherwise
FirstTimePlotting = (*global).FirstTimePlotting

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

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

    flt0_ptr = (*global).flt0_ptr
    flt1_ptr = (*global).flt1_ptr
    flt2_ptr = (*global).flt2_ptr

    for i=0,(size-1) do begin

        error_plot_status = 0
        catch, error_plot_status
        if (error_plot_status NE 0) then begin

            CATCH,/cancel
            text = 'ERROR plotting data'
            displayErrorMessage, Event, text

        endif else begin
    
            flt0 = *flt0_ptr[i]
            flt1 = *flt1_ptr[i]
            flt2 = *flt2_ptr[i]
            
            CATCH,/CANCEL

            DEVICE, DECOMPOSED = 0
            loadct,5
            
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
;keep in global value of x and y min and max
                    (*(*global).XYMinMax) = [min_xaxis,max_xaxis,$
                                             min_yaxis,max_yaxis]

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

;determine Qmin and Qmax
        QminQmax = getQminQmaxValue(flt0, flt1)
        Qmin = QminQmax[0]
        Qmax = QminQmax[1]
        Qmin_array[i] = Qmin
        Qmax_array[i] = Qmax
 
    endfor
    
endelse

;store back the array of all the Qmin of the functions loaded
(*(*global).Qmin_array) = Qmin_array
(*(*global).Qmax_array) = Qmax_array

END









;
;This function load the file in the first step (first tab)
;
PRO ReflSupportOpenFile_LoadFile, Event
 id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
 widget_control,id,get_uvalue=global
 
;launch the program that open the OPEN IDL FILE window
 LongFileName=ReflSupportOpenFile_OPEN_FILE(Event) 

file_error = 0
CATCH, file_error
IF (file_error NE 0) THEN BEGIN
    CATCH,/cancel
;move Back the colorIndex slidebar
    ReflSupportOpenFile_MoveColorIndexBack,Event
ENDIF ELSE BEGIN
;continue only if a file has been selected
    if (LongfileName NE '') then begin
;get only the file name (without path) of file
        ShortFileName = get_file_name_only(LongFileName)    
;MoveColorIndex to new position 
        ReflSupportOpenFile_MoveColorIndex,Event
;get the value of the angle (in degree)
        angleValue = getCurrentAngleValue(Event)
        (*global).angleValue = angleValue
        get_angle_value_and_do_conversion, Event, angleValue
;store flt0, flt1 and flt2 of new files
        index = (*global).NbrFilesLoaded 
        SuccessStatus = ReflSupportOpenFile_Storeflts(Event, LongFileName, index)
        IF (SuccessStatus) THEN BEGIN
;add all files to step1 and step3 droplist
            ReflSupportOpenFile_AddNewFileToDroplist, Event, ShortFileName, LongFileName 
            display_info_about_selected_file, Event, LongFileName
            populateColorLabel, Event, LongFileName
;plot all loaded files
            ReflSupportOpenFile_PlotLoadedFiles, Event
        ENDIF
    ENDIF
ENDELSE

END

