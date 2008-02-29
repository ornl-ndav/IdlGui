;###############################################################################
;*******************************************************************************

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
ClearPlot = 0      ;by default, the display does not have to be erased

CASE (index) OF

   'CE': BEGIN                  ;plot CE
       index_to_plot = [0]
   END

   'all': BEGIN                 ;plot all the plots
       nbr_elements = $
         getNbrElementsInDropList(Event,'step3_work_on_file_droplist') ;_get
       index_to_plot = indgen(nbr_elements)
   END
   
   '2plots': BEGIN              ;plot index and (index-1) in tab 3
       nbr_elements = $
         getNbrElementsInDropList(Event, $
                                  'step3_work_on_file_droplist') ;_get
       IF (nbr_elements EQ 1) THEN BEGIN ;if only 1 file, must be CE file
           index_to_plot = [0]
       ENDIF ELSE BEGIN         ;more than 1 file
           index_to_plot = $
             getSelectedIndex(Event, 'step3_work_on_file_droplist') ;_get
           IF (index_to_plot EQ 0) THEN BEGIN
               index_to_plot = [0]
           ENDIF ELSE BEGIN
               index_to_plot = [index_to_plot-1,index_to_plot]
           ENDELSE
       ENDELSE
   END
   
   'clear': BEGIN               ;no files to plot, just erase display
       ClearPlot = 1
   END
ENDCASE

DEVICE, DECOMPOSED = 0
loadct,5

;check if plot will be with error bars or not
ErrorBarStatus = getButtonValidated(Event, 'show_error_bar_group') ;_get

IF (ClearPlot EQ 1) THEN BEGIN  ;no plot to plot, erase display
    
   ERASE
   
ENDIF ELSE BEGIN                ;at least one file has to be ploted
    
;retrieve flt0, flt1 and flt2
    flt0_ptr = (*global).flt0_rescale_ptr
    flt1_ptr = (*global).flt1_rescale_ptr
    flt2_ptr = (*global).flt2_rescale_ptr
    
    index_size = (size(index_to_plot))(1)
    FOR i=0,(index_size-1) DO BEGIN
        
       ;color index of main plot
       IF (i EQ 0) THEN BEGIN
           MainPlotColor = 100
       ENDIF ELSE BEGIN
           MainPlotColor = 255
       ENDELSE
       
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
       
       IF (i EQ 0) THEN BEGIN
           
           CASE (IsXlin) OF

               0:BEGIN

                   CASE (IsYlin) OF

                       0: BEGIN
                           plot, $
                             flt0, $
                             flt1, $
                             xrange=[xmin,xmax], $
                             yrange=[ymin,ymax], $
                             color=MainPlotColor
                       END

                       1: BEGIN
                           plot, $
                             flt0, $
                             flt1, $
                             /ylog, $
                             xrange=[xmin,xmax], $
                             yrange=[ymin,ymax], $
                             color=MainPlotColor
                       END
                   ENDCASE

               END

               1: BEGIN

                   CASE (IsYlin) OF

                  0: BEGIN
                      plot, $
                        flt0, $
                        flt1, $
                        /xlog, $
                        xrange=[xmin,xmax], $
                        yrange=[ymin,ymax], $
                        color=MainPlotColor
                  END

                  1: BEGIN
                      plot, $
                        flt0, $
                        flt1, $
                        /xlog, $
                        /ylog, $
                        xrange=[xmin,xmax], $
                        yrange=[ymin,ymax], $
                        color=MainPlotColor
                  END
               ENDCASE
            END
        ENDCASE               
        
        IF (ErrorBarStatus EQ 0) THEN BEGIN
            errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
        ENDIF

    ENDIF ELSE BEGIN
        
        XYMinMax = retrieveXYMinMax(Event) ;_get
        xmin = float(XYMinMax[0])
        xmax = float(XYMinMax[1])
        ymin = float(XYMinMax[2])
        ymax = float(XYMinMax[3])
        
        CASE (IsXlin) OF

            0:BEGIN

                CASE (IsYlin) OF

                    0: BEGIN
                        plot, $
                          flt0, $
                          flt1, $
                          xrange=[xmin,xmax], $
                          yrange=[ymin,ymax], $
                          color=MainPlotColor, $
                          /noerase
                    END

                    1: BEGIN
                        plot, $
                          flt0, $
                          flt1, $
                          /ylog, $
                          xrange=[xmin,xmax], $
                          yrange=[ymin,ymax], $
                          /noerase, $
                          color=MainPlotColor
                    END
                ENDCASE
            END

            1: BEGIN
                CASE (IsYlin) OF

                    0: BEGIN
                        plot, $
                          flt0, $
                          flt1, $
                          /xlog, $
                          xrange=[xmin,xmax], $
                          yrange=[ymin,ymax], $
                          /noerase, $
                          color=MainPlotColor
                    END
                    1: BEGIN
                        plot, $
                          flt0, $
                          flt1, $
                          /xlog, $
                          /ylog, $
                          xrange=[xmin,xmax], $
                          yrange=[ymin,ymax], $
                          /noerase, $
                          color=MainPlotColor
                    END
                ENDCASE
            END
        ENDCASE            
        
    ENDELSE
    
    IF (ErrorBarStatus EQ 0) THEN BEGIN
        errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
    ENDIF

 ENDFOR
 
ENDELSE

END

;###############################################################################
;*******************************************************************************

;This function plot all the files loaded
;This function is only reached by the LOAD button
PRO PlotLoadedFiles, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ListLongFileName = (*(*global).ListOfLongFileName)

;1 if first load, 0 otherwise
FirstTimePlotting = (*global).FirstTimePlotting

Qmin_array = (*(*global).Qmin_array)
Qmax_array = (*(*global).Qmax_array)

size = getSizeOfArray(ListLongFileName) ;_get

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

IsXlin = getScale(Event,'X')
IsYlin = getScale(Event,'Y')

IF (size EQ 1 AND $
   ListLongFileName[0] EQ '') THEN BEGIN
   
   ;no more files loaded so erase plot
   ERASE

ENDIF ELSE BEGIN

    color_array = (*(*global).color_array)
    FirstPass = 1

    flt0_ptr = (*global).flt0_ptr
    flt1_ptr = (*global).flt1_ptr
    flt2_ptr = (*global).flt2_ptr

    for i=0,(size-1) do begin

        error_plot_status = 0
        CATCH, error_plot_status

        IF (error_plot_status NE 0) THEN BEGIN

            CATCH,/CANCEL
            text = 'ERROR plotting data'
            displayErrorMessage, Event, text

        ENDIF ELSE BEGIN
    
            flt0 = *flt0_ptr[i]
            flt1 = *flt1_ptr[i]
            flt2 = *flt2_ptr[i]
            
            DEVICE, DECOMPOSED = 0
            loadct,5
            
            colorIndex = color_array[i]
            IF (FirstPass EQ 1) THEN BEGIN
                
                flt1_first = flt1
                
                IF (FirstTimePlotting EQ 1) THEN BEGIN
                    
                    CASE (IsXlin) OF
                        0:BEGIN
                            CASE (IsYlin) OF
                                0: BEGIN
                                    plot,flt0,flt1
                                END
                                1: BEGIN
                                    plot,flt0,flt1,/ylog
                                END
                            ENDCASE
                        END
                        1: BEGIN
                            CASE (IsYlin) OF
                                0: BEGIN
                                    plot,flt0,flt1,/xlog
                                END
                                1: BEGIN
                                    plot,flt0,flt1,/xlog,/ylog
                                END
                            ENDCASE
                        END
                    ENDCASE

                    errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                    
;populate min/max x/y axis
                    min_xaxis = min(flt0,max=max_xaxis,/nan)
                    min_yaxis = min(flt1,max=max_yaxis,/nan)
;keep in global value of x and y min and max
                    (*(*global).XYMinMax) = [min_xaxis,max_xaxis,$
                                             min_yaxis,max_yaxis]

                    PopulateXYScaleAxis, Event, $ ;_put
                      min_xaxis, $
                      max_xaxis, $
                      min_yaxis, $
                      max_yaxis
                    CreateDefaultXYMinMax,Event,$ ;_gui
                      min_xaxis,$
                      max_xaxis,$
                      min_yaxis,$
                      max_yaxis
                    
                ENDIF ELSE BEGIN
                    
                    XYMinMax = retrieveXYMinMax(Event) ;_get
                    xmin = float(XYMinMax[0])
                    xmax = float(XYMinMax[1])
                    ymin = float(XYMinMax[2])
                    ymax = float(XYMinMax[3])
                    
                    CASE (IsXlin) OF
                        0:BEGIN
                            CASE (IsYlin) OF
                                0: BEGIN
                                    plot, $
                                      flt0, $
                                      flt1, $
                                      xrange=[xmin,xmax], $
                                      yrange=[ymin,ymax]
                                END
                                1: BEGIN
                                    plot, $
                                      flt0, $
                                      flt1, $
                                      /ylog, $
                                      xrange=[xmin,xmax], $
                                      yrange=[ymin,ymax]
                                END
                            ENDCASE
                        END
                        1: BEGIN
                            CASE (IsYlin) OF
                                0: BEGIN
                                    plot, $
                                      flt0, $
                                      flt1, $
                                      /xlog, $
                                      xrange=[xmin,xmax], $
                                      yrange=[ymin,ymax]
                                END
                                1: BEGIN
                                    plot, $
                                      flt0, $
                                      flt1, $
                                      /xlog, $
                                      /ylog, $
                                      xrange=[xmin,xmax], $
                                      yrange=[ymin,ymax]
                                END
                            ENDCASE
                        END
                    ENDCASE               
                    errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                    
                ENDELSE
                
                FirstPass = 0
                
            ENDIF ELSE BEGIN
                
                XYMinMax = retrieveXYMinMax(Event) ;_get
                xmin = float(XYMinMax[0])
                xmax = float(XYMinMax[1])
                ymin = float(XYMinMax[2])
                ymax = float(XYMinMax[3])
                
                CASE (IsXlin) OF
                    0:BEGIN
                        CASE (IsYlin) OF
                            0: BEGIN
                                plot, $
                                  flt0, $
                                  flt1, $
                                  xrange=[xmin,xmax], $
                                  yrange=[ymin,ymax], $
                                  /noerase
                            END
                            1: BEGIN
                                plot, $
                                  flt0, $
                                  flt1, $
                                  /ylog, $
                                  xrange=[xmin,xmax], $
                                  yrange=[ymin,ymax], $
                                  /noerase
                            END
                        ENDCASE
                    END
                    1: BEGIN
                        CASE (IsYlin) OF
                            0: BEGIN
                                plot, $
                                  flt0, $
                                  flt1, $
                                  /xlog, $
                                  xrange=[xmin,xmax], $
                                  yrange=[ymin,ymax], $
                                  /noerase
                            END
                            1: BEGIN
                                plot, $
                                  flt0, $
                                  flt1, $
                                  /xlog, $
                                  /ylog, $
                                  xrange=[xmin,xmax], $
                                  yrange=[ymin,ymax], $
                                  /noerase
                            END
                        ENDCASE
                    END
                ENDCASE            

                errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                
            ENDELSE
            
        ENDELSE

;determine Qmin and Qmax

        QminQmax = getQminQmaxValue(flt0, flt1) ;_get
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

;###############################################################################
;*******************************************************************************

PRO replot_main_plot, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF (((*global).replot_me) EQ 1) THEN BEGIN
    steps_tab, Event,1 ;_Tab
    (*global).replot_me = 0
ENDIF

end

;###############################################################################
;*******************************************************************************

;This function plots the selected file
PRO plot_rescale_CE_file, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

IsXlin = getScale(Event,'X') ;_get
IsYlin = getScale(Event,'Y') ;_get

color_array = (*(*global).color_array)

DEVICE, DECOMPOSED = 0
loadct,5
    
flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr
            
;retrieve particular flt0, flt1 and flt2
flt0 = *flt0_ptr[0]
flt1 = *flt1_ptr[0]
flt2 = *flt2_ptr[0]

;divide by scaling factor
CE_scaling_factor = (*global).CE_scaling_factor
flt1              = flt1/CE_scaling_factor
flt2              = flt2/CE_scaling_factor

cooef = (*(*global).CEcooef)
IF (cooef[0] NE 0 AND $
    cooef[1] NE 0) THEN BEGIN
    cooef[0] /= CE_scaling_factor
    Cooef[1] /= CE_scaling_Factor
ENDIF
(*(*global).CEcooef) = cooef

;save new values
flt0_rescale_ptr           = (*global).flt0_rescale_ptr
*flt0_rescale_ptr[0]       = flt0
(*global).flt0_rescale_ptr = flt0_rescale_ptr

flt1_rescale_ptr           = (*global).flt1_rescale_ptr
*flt1_rescale_ptr[0]       = flt1
(*global).flt1_rescale_ptr = flt1_rescale_ptr

flt2_rescale_ptr           = (*global).flt2_rescale_ptr
*flt2_rescale_ptr[0]       = flt2
(*global).flt2_rescale_ptr = flt2_rescale_ptr
;end of rescaling part

colorIndex = color_array[0]

XYMinMax = getXYMinMax(Event)
xmin     = float(XYMinMax[0])
xmax     = float(XYMinMax[1])
ymin     = float(XYMinMax[2])
ymax     = float(XYMinMax[3])

CASE (IsXlin) OF
    0:BEGIN
        CASE (IsYlin) OF
            0: BEGIN
                plot,flt0,flt1,xrange=[xmin,xmax],yrange=[ymin,ymax]
            END
            1: BEGIN
                plot,flt0,flt1,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            END
        ENDCASE
    END
    1: BEGIN
        CASE (IsYlin) OF
            0: BEGIN
                plot,flt0,flt1,/xlog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            END
            1: BEGIN
                plot,flt0,flt1,/xlog,/ylog,xrange=[xmin,xmax],yrange=[ymin,ymax]
            END
        ENDCASE
    END
ENDCASE            

errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex

;polynome of degree 1 for CE 
IF (cooef[0] NE 0 AND $
    cooef[1] NE 0) THEN BEGIN
    show_error_plot=1
    flt0_new = (*(*global).flt0_CE_range)
    y_new = cooef(1)*flt0_new + cooef(0)
    oplot,flt0_new,y_new,color=400,thick=1.5
ENDIF

END

;###############################################################################
;*******************************************************************************

