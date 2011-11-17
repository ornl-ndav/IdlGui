;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO ref_off_spec_scaling_plot2d_event, Event
  COMPILE_OPT idl2, hidden
  IF (TAG_NAMES(Event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST') $
    THEN BEGIN
    WIDGET_CONTROL, Event.top, /DESTROY
    RETURN
  ENDIF
END

;------------------------------------------------------------------------------
PRO step4_step1_plot2d, Event, GROUP_LEADER=group
  WIDGET_CONTROL, Event.top,GET_UVALUE=global
  COMPILE_OPT idl2, hidden
  
  ; Check if already created.  If so, return.
  IF (WIDGET_INFO((*global).w_scaling_plot2d_id, /VALID_ID) NE 0) THEN BEGIN
    WIDGET_CONTROL,(*global).w_scaling_plot2d_id, /SHOW
    RETURN
  ENDIF

  xsize = 500
  ysize = 500
  
  ;Built base
  title = 'Counts vs Pixels for Selection'
  wBase = WIDGET_BASE(TITLE        = title,$
    XOFFSET      = 900,$
    YOFFSET      = 500,$
    GROUP_LEADER = group,$
    UNAME = 'plot_2d_scaling_base',$
    /TLB_KILL_REQUEST_EVENTS)
    
  wDraw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    RETAIN    = 2, $
    UNAME     = 'plot_2d_scaling_draw')
    
  (*global).w_scaling_plot2d_id = wBase
  uname = WIDGET_INFO(wDraw,/UNAME)
  (*global).w_scaling_plot2d_draw_uname = uname
  
  WIDGET_CONTROL, wBase, /REALIZE
  XMANAGER, "ref_off_spec_scaling_plot2d", wBase, /NO_BLOCK
END

;------------------------------------------------------------------------------
;This procedure show the plot2d (if not there already) and display
;counts vs wavelength for the given selection made  
PRO display_step4_step1_plot2d, Event
  WIDGET_CONTROL, Event.top,GET_UVALUE=global
  
  ;show plot2d base
  step4_step1_plot2d, $           ;scaling_step1_plot2d
    Event, $
    GROUP_LEADER=Event.top

  ; Code change RCW (Feb 8, 2010): Get Background color from XML file
  PlotBackground = (*global).BackgroundCurvePlot

  ;this is the x,y pixel selections for the user's selection window
  xy_selection = (*global).step4_step1_selection
  
  xmin = xy_selection[0]
  ymin = xy_selection[1]
  xmax = xy_selection[2]
  ymax = xy_selection[3]
  
  xmin = MIN([xmin,xmax],MAX=xmax)
  ymin = MIN([ymin,ymax],MAX=ymax)
 
  ymin = FIX(ymin/2)
  ymax = FIX(ymax/2)
  
  IF (xmin EQ xmax) THEN xmax += 1
  IF (ymin EQ ymax) THEN ymax += 1
   
  ;plot counts vs tof of region selected
  id_draw = WIDGET_INFO((*global).w_scaling_plot2d_id, $
    FIND_BY_UNAME=(*global).w_scaling_plot2d_draw_uname)
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  tfpData  = (*(*global).realign_pData_y)
  nbr_plot = getNbrFiles(Event)
  ;array that will contain the counts vs wavelength of each data file
  IvsLambda_selection        = PTRARR(nbr_plot,/ALLOCATE_HEAP)
  IvsLambda_selection_backup = PTRARR(nbr_plot,/ALLOCATE_HEAP)
  
  ;determine ymax
  index_ymax = 0
  ymax_value = 0

  WHILE (index_ymax LT nbr_plot) DO BEGIN
; Change code 9RC Ward, 29 April 2010): save value of xmax for the first dataset (xmax0) for computing xrange
    IF (index_ymax EQ 0) THEN BEGIN
       xmax0 = xmax       
    ENDIF
    local_tfpData       = *tfpData[index_ymax]
    
    sz = (size(local_tfpDAta))(1)
    xmin = (xmin GE sz) ? (sz-1) : xmin
    xmax = (xmax GE sz) ? (sz-1) : xmax  

    IF (index_ymax EQ 0) THEN BEGIN
      data_to_plot       = FLOAT(local_tfpData(xmin:xmax,ymin:ymax))
    ENDIF ELSE BEGIN
      data_to_plot       = FLOAT(local_tfpData(xmin:xmax, $
;        (304L+ymin):(304L+ymax)))
        ((*global).detector_pixels_y+ymin):((*global).detector_pixels_y+ymax)))
    ENDELSE
;*******************************************************************************
; Data to be plotted is summed over one dimension and divided by the number 
; of pixels in the selection window
;*******************************************************************************
    nbr_pixels = (size(data_to_plot))(2)
    t_data_to_plot = total(data_to_plot,2)/FLOAT(nbr_pixels)
    
    *IvsLambda_selection[index_ymax]        = t_data_to_plot
    *IvsLambda_selection_backup[index_ymax] = t_data_to_plot
    ymax_local     = MAX(t_data_to_plot)
    ymax_value     = (ymax_local GT ymax_value) ? ymax_local : ymax_value
    (*global).step4_step1_ymax_value = ymax_value
    
    index_ymax++
  ENDWHILE
  
  (*global).step4_step1_ymax_value        = ymax_value
  (*(*global).IvsLambda_selection)        = IvsLambda_selection
  (*(*global).IvsLambda_selection_backup) = IvsLambda_selection_backup
  
; Change code (RC Ward, 29 April 2010): The code below was changed to behave like that in 
; ref_off_spec_scaling_step2_step1.pro routine: display_step4_step2_step1_selection
; It obtains t_data_to_plot from IvsLambda_selection array, rather tahn recomputing this,
; since recomputing was causing problems with the function not being plotted over its entire range.
  index = 0
  box_color     = (*global).box_color
  WHILE (index LT nbr_plot) DO BEGIN
    color         = box_color[index]
    psym = getStep4Step2PSYMselected(Event)
    t_data_to_plot = *IvsLambda_selection[index]
 
    IF (index EQ 0) THEN BEGIN

; get delta_x
      xaxis = (*(*global).x_axis)
      delta_x = xaxis[1]-xaxis[0]
      (*global).step4_1_plot2d_delta_x = delta_x
      
; Change code (RC Ward, 29 April 2010): compute xrange from the value of xmax for the first dataset (xmax0)
      xrange = (FINDGEN(xmax0)+ xmin) * delta_x
;      sx = N_ELEMENTS(xrange)

      (*(*global).step4_step2_step1_xrange) = xrange
      xtitle = 'Wavelength'
      ytitle = 'Counts'
          
      ymin_local = (*global).step4_ymin_global_value
      ymin_value = (ymin_local LT ymax_value) ? ymin_local : (ymax_value/10.)   

      ymin_ymax = [ymin_value, ymax_value]
      (*global).scaling_step2_ymin_ymax = ymin_ymax         

      plot, xrange, $
        t_data_to_plot, $
        XTITLE = xtitle, $
        YTITLE = ytitle,$
        COLOR  = color,$
; Code change RCW (Feb 8, 2010): Get Background color from XML file
        BACKGROUND = FSC_COLOR(PlotBackground),$
        YRANGE = [ymin_value,ymax_value],$
        PSYM   = psym,$
        /YLOG,$
        XSTYLE = 1
    ENDIF ELSE BEGIN
      oplot, xrange, $
        t_data_to_plot, $
        COLOR  = color,$
        PSYM   = psym
    ENDELSE
    index++
  ENDWHILE
 
END

;------------------------------------------------------------------------------
PRO save_y_error_step4_step1_plot2d, Event
  WIDGET_CONTROL, Event.top,GET_UVALUE=global
  
  ;put value there
  xy_selection = (*global).step4_step1_selection
  
  xmin = xy_selection[0]
  ymin = xy_selection[1]
  xmax = xy_selection[2]
  ymax = xy_selection[3]
  
  xmin = MIN([xmin,xmax],MAX=xmax)
  ymin = MIN([ymin,ymax],MAX=ymax)
  
  ymin = FIX(ymin/2)
  ymax = FIX(ymax/2)
  
  IF (xmin EQ xmax) THEN xmax += 1
  IF (ymin EQ ymax) THEN ymax += 1
  
  tfpData_error = (*(*global).realign_pData_y_error)
  nbr_plot = getNbrFiles(Event)
  ;array that will contain the counts vs wavelenght of each data file
  IvsLambda_selection_error        = PTRARR(nbr_plot,/ALLOCATE_HEAP)
  IvsLambda_selection_error_backup = PTRARR(nbr_plot,/ALLOCATE_HEAP)
  
  ;determine ymax
  index      = 0
  ymax_value = 0
  WHILE (index LT nbr_plot) DO BEGIN
  
    local_tfpData_error = *tfpData_error[index]
    bLogPlot            = isLogZaxisScalingStep1Selected(Event)
    IF (bLogPlot) THEN BEGIN
      local_tfpData_error = ALOG10(local_tfpData_error)
      index_inf = WHERE(local_tfpData_error LT 0, nIndex)
      IF (nIndex GT 0) THEN BEGIN
        local_tfpData_error[index_inf] = 0
      ENDIF
    ENDIF
    
    sz = (size(local_tfpDAta_error))(1)
    xmin = (xmin GE sz) ? (sz-1) : xmin
    xmax = (xmax GE sz) ? (sz-1) : xmax
    
    IF (index EQ 0) THEN BEGIN
      data_to_plot_error = FLOAT(local_tfpData_error(xmin:xmax,ymin:ymax))
    ENDIF ELSE BEGIN
      data_to_plot_error = $
        FLOAT(local_tfpData_error(xmin:xmax, $
;        (304L+ymin):(304L+ymax)))
        ((*global).detector_pixels_y+ymin):((*global).detector_pixels_y+ymax)))
    ENDELSE
    t_data_to_plot_error = total(data_to_plot_error,2)
    *IvsLambda_selection_error[index]        = t_data_to_plot_error
    *IvsLambda_selection_error_backup[index] = t_data_to_plot_error
    index++
  ENDWHILE
  
  (*(*global).IvsLambda_selection_error)        = IvsLambda_selection_error
  (*(*global).IvsLambda_selection_error_backup) = $
    IvsLambda_selection_error_backup
    
END

