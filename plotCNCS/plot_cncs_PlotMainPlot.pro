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

FUNCTION retrieveFirstBankData, NexusFileName, $
    BankNumber
  path    = '/entry/bank' + STRCOMPRESS(BankNumber,/REMOVE_ALL) + '/data'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  data    = H5D_READ(fieldID)
  RETURN, data
END

;-------------------------------------------------------------------------------
FUNCTION retrieveBottomBankData, NexusFileName, $
    Ntof, $
    progressBar, $
    Nstep, $
    step, $
    progressBarCancel
    
  fileID  = H5F_OPEN(NexusFileName)
  result  = LONARR(Ntof,128,50*8)
  FOR i=0,49 DO BEGIN
    path          = '/entry/bank' + STRCOMPRESS(i+1,/REMOVE_ALL) + '/data'
    fieldID       = H5D_OPEN(fileID, path)
    data          = H5D_READ(fieldID)
    result[0,0,i*8] = data
    IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
      progressBarCancel = 1
      RETURN,result
    ENDIF
  ENDFOR
  H5F_CLOSE, fileID
  RETURN, result
END

;-------------------------------------------------------------------------------
FUNCTION getIMGfromNexus, NexusFileName, progressBar, Nstep, progressBarCancel

  ;retrieve bank1 data
  step       = FLOAT(0)           ;0 step so far
  bank1      = retrieveFirstBankData(NexusFileName, 1)
  Ntof       = (SIZE(bank1))(1)
  img        = LONARR(Ntof,128,50*8)
  IF (progressBarCancel) THEN RETURN, img
  ;progressBar->Update,(++step/Nstep)*100
  IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
    progressBarCancel = 1
    RETURN, img
  ENDIF
  
  ;retrieve data from Bottom Bank
  progressBar->SetLabel, 'Retrieving Data ...'
  BottomBank = retrieveBottomBankData(NexusFileName, $
    Ntof, $
    progressBar, $
    Nstep, $
    step,$
    progressBarCancel)
  IF (progressBarCancel) THEN RETURN, img
  img = BottomBank
  IF (UpdateProgressBar(progressBar,(FLOAT(++step)/Nstep)*100)) THEN BEGIN
    progressBarCancel = 1
    RETURN, img
  ENDIF
  
  RETURN, img
END

;-------------------------------------------------------------------------------
PRO MakeGuiMainPLot_Event, event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  CASE event.id OF
  
    ;Counts min value
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_min_value'): BEGIN
      replot_main_plot_with_scale, Event
      plot_selection_box, Event
    END
    
    ;Counts max value
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_max_value'): BEGIN
      replot_main_plot_with_scale, Event
      plot_selection_box, Event
    END
    
    ;reset scale
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_scale'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event, reset_z_scale=1
      ;replot_main_plot, Event
      plot_selection_box, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;linear plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_linear_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      ;replot_main_plot_with_scale, Event
      plot_selection_box, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;log plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_log_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      ;replot_main_plot_with_scale, Event
      plot_selection_box, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;counts vs tof of full detector
    WIDGET_INFO(event.top, FIND_BY_UNAME='counts_vs_tof_full_detector'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      job_base = counts_vs_tof_info_base(Event)
      plot_counts_vs_tof_of_full_detector, Event
      WIDGET_CONTROL, HOURGLASS=0
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;Main plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot'): begin
      MainPlotInteraction, Event
      
      id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 31
      DEVICE, CURSOR_STANDARD=standard
      
      IF (Event.press EQ 1) THEN BEGIN ;press left button
        (*global1).left_pressed = 1
        (*global1).X1 = Event.x
        (*global1).Y1 = Event.y
      ENDIF
      
      IF (Event.type EQ 1 AND $
        (*global1).left_pressed EQ 1) THEN BEGIN ;release of left button only
        (*global1).left_pressed = 0
        message_text = ['Are you sure you want to plot Counts vs TOF of ' + $
          'selection?','','This may take a while!']
        title = 'Plot Counts vs TOF ?'
        id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_plot_base')
        result = DIALOG_MESSAGE(message_text,$
          /QUESTION,$
          /CENTER,$
          DIALOG_PARENT=id,$
          TITLE=title)
        IF (result EQ 'Yes') THEN BEGIN
          WIDGET_CONTROL, /HOURGLASS
          job_base = counts_vs_tof_info_base(Event)
          plot_counts_vs_tof_of_selection, Event
          WIDGET_CONTROL, HOURGLASS=0
          WIDGET_CONTROL, job_base,/DESTROY
        ENDIF
      ENDIF
      
      IF (Event.type EQ 2 AND $
        (*global1).left_pressed EQ 1) THEN BEGIN ;move
        (*global1).X2 = Event.x
        (*global1).Y2 = Event.y
        replot_main_plot_with_scale, Event, without_scale=1
        plot_selection_box, Event
      ENDIF
      
      IF (Event.press EQ 4) THEN BEGIN ;right mouse pressed
        WIDGET_CONTROL,/HOURGLASS
        X = Event.X
        Y = Event.Y
        index = getBankIndex(Event, X, Y)
        IF (index NE -1) THEN BEGIN
          bankName = getBank(Event)
          PlotBank, (*(*global1).img), $ ;launch the bank view
            index, $
            bankName, $
            (*global1).real_or_tof,$
            (*global1).TubeAngle
        ENDIF
        WIDGET_CONTROL, HOURGLASS=0
      ENDIF
    END
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;play button
    WIDGET_INFO(event.top, FIND_BY_UNAME='play_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='play'
          check_from_to_bin_input, Event
          change_from_and_to_bins, Event
          play_tof, Event
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='play_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;next button
    WIDGET_INFO(event.top, FIND_BY_UNAME='next_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='next'
          play_next, Event
          play_buttons_activation, event, activate_button='all
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='next_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;stop button
    WIDGET_INFO(event.top, FIND_BY_UNAME='stop_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='stop'
          stop_play, Event
          play_buttons_activation, event, activate_button='raw'
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='stop_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;pause button
    WIDGET_INFO(event.top, FIND_BY_UNAME='pause_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='pause'
        ENDIF
      ENDIF ELSE BEGIN
        id = WIDGET_INFO(Event.top,find_by_uname='pause_button')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        standard = 58
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;previous button
    WIDGET_INFO(event.top, FIND_BY_UNAME='previous_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='previous'
          play_previous, Event
          play_buttons_activation, event, activate_button='all
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='previous_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;play/pause.... buttons
    WIDGET_INFO(event.top, FIND_BY_UNAME='play_buttons'): BEGIN
    END
    
    ;View full TOF axis
    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_preview'): BEGIN
      preview_of_tof, Event
    END
    
    ;from_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='from_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      check_from_to_bin_input, Event
      change_from_and_to_bins, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;reset from_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_from_bin'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='from_bin')
      WIDGET_CONTROL, /HOURGLASS
      WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(1)
      change_from_and_to_bins, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;to_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='to_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      check_from_to_bin_input, Event
      change_from_and_to_bins, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;reset to_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_to_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      IF ((*global1).nexus_file_name NE '') THEN BEGIN
        bin_max = N_ELEMENTS((*(*global1).tof_array))
      ENDIF ELSE BEGIN
        img = (*(*global1).img)
        bin_max = (SIZE(img))(1)
      ENDELSE
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='to_bin')
      WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(bin_max-1,/REMOVE_ALL)
      change_from_and_to_bins, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ELSE:
  ENDCASE
  
END

;==============================================================================
PRO plot_counts_vs_tof_of_selection, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  nexus_file_name = (*global1).nexus_file_name
  
  x1 = (*global1).X1/4
  x2 = (*global1).X2/4
  y1 = FIX((*global1).Y1/4)
  y2 = FIX((*global1).Y2/4)
  
  xmin = MIN([x1,x2],MAX=xmax)
  ymin = MIN([y1,y2],MAX=ymax)
  
  img     = (*(*global1).img)
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  
  t_img = TRANSPOSE(img)
  N_tof = LONG((SIZE(t_img))(3))
  ysize = (SIZE(t_img))(2)
  
  xsize       = 8L
  xsize_space = 1L
  xsize_total = xsize * 52L + xsize_space * 51L
  big_array = LONARR(xsize_total, ysize, N_tof)
  
  ;put left part in big array
  FOR i=0L,(36L-1) DO BEGIN
    bank = t_img[i*8:(i+1)*8L-1,*,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*,*] = bank
  ENDFOR
  ;put right part in big array
  FOR i=38L,(52L-2L) DO BEGIN
    bank = t_img[(i-2L)*8L:(i-1L)*8L-1,*,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*,*] = bank
  ENDFOR
  
  counts_vs_tof = big_array[xmin:xmax,ymin:ymax,*]
  title = 'Counts vs TOF of selection'
  Launch_counts_vs_tof_base, counts_vs_tof, nexus_file_name, title=title
  
END

;==============================================================================
PRO plot_counts_vs_tof_of_full_detector, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  nexus_file_name = (*global1).nexus_file_name
  
  img     = (*(*global1).img)
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  
  t_img = TRANSPOSE(img)
  N_tof = LONG((SIZE(t_img))(3))
  ysize = (SIZE(t_img))(2)
  
  counts_vs_tof = t_img
  title = 'Counts vs TOF of Full Detector'
  Launch_counts_vs_tof_base, counts_vs_tof, nexus_file_name, title=title
  
END

;==============================================================================
PRO plotGridMainPlot, global1

  ;retrieve values from inside structure
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  
  yoff = 0
  
  ;##########################################
  ;PLOT BANKS GRID ##########################
  ;##########################################
  ;;plot grid of bottom bank
  color  = 100
  FOR i=0,(52-1) DO BEGIN
    xmin = i*(Xcoeff)+i*off+xoff-i
    xmax = (i+1)*(Xcoeff)+i*off+xoff-i
    ymin = yoff
    ymax = yoff+Ycoeff
    PLOTS, [xmin, xmin, xmax, xmax, xmin],$
      [ymin,ymax, ymax, ymin, ymin],$
      /DEVICE,$
      LINESTYLE = 0,$
      COLOR =color
  ENDFOR
  
END

;==============================================================================
PRO plotDASviewFullInstrument, global1

  ;retrieve values from inside structure
  img     = (*(*global1).img)
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  wbase   = (*global1).wBase
  
  ;main data array
  tvimg = TOTAL(img,1)
  tvimg = TRANSPOSE(tvimg)
  
  ;change title
  id = WIDGET_INFO(wBase,find_by_uname='main_plot_base')
  WIDGET_CONTROL, id, base_set_title= (*global1).main_plot_real_title
  
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ERASE
  
  ;Create big array (before rebining)
  xsize       = 8L
  xsize_space = 1L
  xsize_total = xsize * 52L + xsize_space * 51L
  ysize = 128L
  big_array = LONARR(xsize_total, ysize)
  ;put left part in big array
  FOR i=0L,(36L-1) DO BEGIN
    bank = tvimg[i*8:(i+1)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  ;put right part in big array
  FOR i=38L,(52L-2L) DO BEGIN
    bank = tvimg[(i-2L)*8L:(i-1L)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  
  min = MIN(big_array,MAX=max)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='main_base_min_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(min,/REMOVE_ALL)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='main_base_max_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(max,/REMOVE_ALL)
  
  ;rebin big array
  big_array_rebin = REBIN(big_array, xsize_total*Xfactor, ysize*Yfactor,/SAMPLE)
  
  yoff = 0
  TVSCL, big_array_rebin, /DEVICE, xoff, yoff
  (*(*global1).big_array_rebin) = big_array_rebin
  (*(*global1).big_array_rebin_rescale) = big_array_rebin
  
  ;plot grid
  plotGridMainPlot, global1
  
  ;plot scale
  plot_scale, global1, min, max
  
END

;==============================================================================
PRO plot_selection_box, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  x1 = (*global1).X1
  y1 = (*global1).Y1
  x2 = (*global1).X2
  y2 = (*global1).Y2
  
  IF (x1 EQ 0L AND $
    x2 EQ 0L) THEN RETURN
    
  xmin = MIN([x1,x2], MAX=xmax)
  ymin = MIN([y1,y2], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  IF (lin_status EQ 1) THEN BEGIN
    color = 150
  ENDIF ELSE BEGIN
    color = FSC_COLOR('white')
  ENDELSE
  
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR =color
    
END

;==============================================================================
PRO replot_main_plot_with_scale, Event, without_scale=without_scale

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;retrieve values from inside structure
  off     = (*global1).off
  xoff    = (*global1).xoff
  wbase   = (*global1).wBase
  big_array_rebin = (*(*global1).big_array_rebin)
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ;ERASE
  
  ;min value and max value
  min = getCWFieldValue(Event,'main_base_min_value')
  max = getCWFieldValue(Event,'main_base_max_value')
  
  index_min = WHERE(big_array_rebin LT MIN, nbr)
  IF (nbr GT 0) THEN BEGIN
    big_array_rebin[index_min] = 0
  ENDIF
  
  index_max = WHERE(big_array_rebin GT MAX, nbr)
  IF (nbr GT 0) THEN BEGIN
    big_array_rebin[index_max] = 0
  ENDIF
  
  (*(*global1).big_array_rebin_rescale) = big_array_rebin
  
  IF (lin_status EQ 0) THEN BEGIN ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(big_array_rebin EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      big_array_rebin[index] = !VALUES.D_NAN
      big_array_rebin = ALOG10(big_array_rebin)
      big_array_rebin = BYTSCL(big_array_rebin,/NAN)
    ENDIF
    
  ENDIF
  
  ;  (*(*global1).big_array_rebin_rescale) = big_array_rebin
  
  TVSCL, big_array_rebin, /DEVICE, xoff, off
  
  ;plot grid
  plotGridMainPlot, global1
  
  IF (N_ELEMENTS(without_scale) EQ 0) THEN BEGIN
  
    ;plot scale
    plot_scale, global1, min, max, lin_status=lin_status
    
  ENDIF
  
END

;==============================================================================
PRO replot_main_plot, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;retrieve values from inside structure
  off     = (*global1).off
  xoff    = (*global1).xoff
  wbase   = (*global1).wBase
  big_array_rebin = (*(*global1).big_array_rebin)
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  min = MIN(big_array_rebin,MAX=max)
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base_min_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(min,/REMOVE_ALL)
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base_max_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(max,/REMOVE_ALL)
  
  IF (lin_status EQ 0) THEN BEGIN ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(big_array_rebin EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      big_array_rebin[index] = !VALUES.D_NAN
      big_array_rebin = ALOG10(big_array_rebin)
      big_array_rebin = BYTSCL(big_array_rebin,/NAN)
    ENDIF
    
  ENDIF
  
  TVSCL, big_array_rebin, /DEVICE, 0, 0
  
  ;plot grid
  plotGridMainPlot, global1
  
  ;plot scale
  plot_scale, global1, min, max, lin_status=lin_status
  
END

;==============================================================================
PRO plotTOFviewFullInstrument, global1

  ;##########################################################
  ;############# Plot x,tof integrated over y ###############
  ;##########################################################

  ;retrieve values from inside structure
  img     = (*(*global1).img)
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  img     = (*(*global1).img)
  wBase   = (*global1).wBase
  Ytof    = (*global1).Ytof
  Y_factor_display = 2 ;this allow the tof to fill up exactly the vertical space allowed
  
  ;change title
  id = WIDGET_INFO(wBase,find_by_uname='main_plot_base')
  WIDGET_CONTROL, id, base_set_title= (*global1).main_plot_tof_title
  i
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ERASE
  
  ;find out the range of non-zero values using the first non-empty bank
  ;bank_index = 49
  bank_index = 0
  ;img = [1000,128,920]
  tvimg1     = TOTAL(img,2)       ;tvimg1 = [1000,920]
  tvimg1     = TRANSPOSE(tvimg1)  ;tvimg1 = [920,1000]
  ngt0 = 0
  WHILE (ngt0 EQ 0) DO BEGIN
    ;sum the 8 tubes together
    tvimg2     = tvimg1[bank_index*8:(bank_index+1)*8-1,*]
    tvimg2     = TOTAL(tvimg2,1)
    NZindexes  = WHERE(tvimg2 GT 0, ngt0)
    bank_index++
  ENDWHILE
  index_start = NZindexes[0]
  index_stop  = NZindexes[ngt0-1]
  
  ;keep only all data between index_start and index_stop
  tvimg2     = tvimg1[*,index_start:index_stop]
  Npts       = (SIZE(tvimg2))(2) ;number of tof that survive the where GT 0 routine
  dim_new    = Ytof            ;number of points we want in the Y axis (tof here)
  ds         = Npts/dim_new      ;resulting downsampling ratio - how many points
  ;dim_new    *= 2
  ;to become one point
  
  ;isolate various banks of data
  ;plot banks
  for i=0,(50-1) do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    IF (ds LT (SIZE(bank))(1)) THEN BEGIN
      bank_smooth  = SMOOTH(bank,ds,/edge)
    ENDIF ELSE BEGIN
      bank_smooth = bank
    ENDELSE
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new*Y_factor_display)
    TVSCL, bank_congrid, /device, i*(Xcoeff)+i*off+xoff, off
  endfor
  
  ;plot grid
  plotGridMainPlot, global1
  
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO PlotMainPlot, histo_mapped_file
  ;build gui
  wBase = ''
  MakeGuiMainPlot, wBase
  
  global1 = PTR_NEW({ histo_file_name:      histo_mapped_file,$
    real_or_tof:          0,$;0:REAL das view, 1:tof view
    tof_scale_title:      'TOF scale',$
    Xfactor:              4,$
    Yfactor:              4,$
    Yfactor_untouched:    2,$
    Xcoeff:               8 * 4,$
    Ycoeff:               128L * 4,$
    Ytof:                 128L * 2,$
    Ytof_untouched:       128L*2,$
    off:                  5,$ ;5
    xoff:                 0,$ ;10
    big_array_rebin:      PTR_NEW(0L),$
    big_array_rebin_rescale: PTR_NEW(0L),$
    img:                  PTR_NEW(0L),$
    nexus_file_name:      '',$
    X1:                    0L,$
    Y1:                    0L,$
    X2:                    0L,$
    Y2:                    0L,$
    
    counts_vs_tof_for_play: PTR_NEW(0L),$
    background:            PTR_NEW(0L),$
    
    pause_button_activated: 0b,$
    bin_min:               0L,$
    bin_max:               0L,$
    bin_max_untouched:     0L,$
    from_bin:              1L,$
    to_bin:                0L,$
    xrange:                INTARR(2),$
    
    left_pressed:         0,$
    main_plot_real_title: 'Real View of Instrument (Y vs X integrated over TOF)',$
    main_plot_tof_title:  'TOF View (TOF vs X integrated over Y)',$
    TubeAngle:             FLTARR(400),$
    wbase:                wbase})
    
  ;This function retrieves the value of all the tube angles
  (*global1).TubeAngle = getTubeAngle()
  
  file_ext = ' - File: ' + histo_mapped_file
  (*global1).main_plot_real_title += file_ext
  (*global1).main_plot_tof_title += file_ext
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global1
  XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  ;display buttons (play, stop, next, previous, pause) -----------------------
  raw_buttons = READ_PNG('plotCNCS_images/set_of_buttons_raw.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_buttons')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, raw_buttons, 0, 0,/true
  
  pause_button = READ_PNG('plotCNCS_images/pause_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='pause_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, pause_button, 0, 0,/true
  
  stop_button = READ_PNG('plotCNCS_images/stop_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='stop_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, stop_button, 0, 0,/true
  
  previous_button = READ_PNG('plotCNCS_images/previous_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='previous_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, previous_button, 0, 0,/true
  
  play_button = READ_PNG('plotCNCS_images/play_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, play_button, 0, 0,/true
  
  next_button = READ_PNG('plotCNCS_images/next_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='next_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, next_button, 0, 0,/true
  
  ;---------------------------------------------------------------------------
  
  ;open file
  OPENR,u,histo_mapped_file,/get
  fs=FSTAT(u)
  Nx = LONG(50*8)
  Ny = LONG(128)
  Nimg = LONG(Nx*Ny)
  Ntof = fs.size/(Nimg*4L)
  
  ;read data
  data = LONARR(Ntof*Nimg)
  READU,u,data
  CLOSE, u
  FREE_LUN,u
  
  indx1 = WHERE(data GT 0, ngt0)
  img = INTARR(Ntof,Ny,Nx)
  IF (ngt0 GT 0) THEN BEGIN
    img(indx1) = data(indx1)
  ENDIF
  
  (*(*global1).img)= img
  
  ;display counts vs tof for play buttons of central row
  t_img = TOTAL(img,3)
  counts_vs_tof = t_img[*,64]
  (*(*global1).counts_vs_tof_for_play) = counts_vs_tof
  id = WIDGET_INFO(wBase,find_by_uname='play_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  bin_max = (SIZE(t_img))(1)
  (*global1).bin_max_untouched = bin_max
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='to_bin')
  WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(bin_max-1,/REMOVE_ALL)
  (*global1).to_bin = (bin_max-1)
  
  xrange = [1,bin_max-1]
  (*global1).xrange = xrange
  PLOT, counts_vs_tof, XTITLE='Bins #', $
    YTITLE='Counts', XRANGE=xrange,$
    XSTYLE=1
    
  ;take snapshot
  ;  background = TVREAD(TRUE=3)
  background = TVRD(TRUE=3)
  (*(*global1).background) = background
  
  ;disable View full TOF axis
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='tof_preview')
  WIDGET_CONTROL, id, SENSITIVE=0
  ;disable row that display TOF min and max in play base
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_tof_row')
  WIDGET_CONTROL, id, SENSITIVE=0
  
  ;plot das view of full instrument
  plotDASviewFullInstrument, global1
  
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO PlotMainPlotFromNexus, NexusFileName
  ;build gui
  wBase = ''
  MakeGuiMainPlot, wBase
  
  global1 = PTR_NEW({ NexusFileName:         NexusFileName,$
    real_or_tof:           0,$;0:REAL das view, 1:tof view
    tof_scale_title:       'TOF scale',$
    Xfactor:               4,$
    Yfactor:               4,$
    Yfactor_untouched:     2,$
    Xcoeff:                8 * 4,$
    Ycoeff:                128L * 4,$
    Ytof:                  128L * 2,$
    Ytof_untouched:        128L*2,$
    off:                   5,$ ;5
    xoff:                  0,$ ;10
    img:                   PTR_NEW(0L),$
    big_array_rebin:       PTR_NEW(0L),$
    big_array_rebin_rescale: PTR_NEW(0L),$
    left_pressed:           0,$
    X1:                    0L,$
    Y1:                    0L,$
    X2:                    0L,$
    Y2:                    0L,$
    pause_status:          0,$
    tof_array:             PTR_NEW(0L),$
    counts_vs_tof_for_play: PTR_NEW(0L),$
    background:            PTR_NEW(0L),$
    
    pause_button_activated: 0b,$
    bin_min:               0L,$
    bin_max:               0L,$
    bin_max_untouched:     0L,$
    from_bin:              1L,$
    to_bin:                0L,$
    xrange:                INTARR(2),$
    
    nexus_file_name:       NexusFileName,$
    main_plot_real_title:  'Real View of Instrument (Y vs X integrated over TOF)',$
    main_plot_tof_title:   'TOF View (TOF vs X integrated over Y)',$
    TubeAngle:             FLTARR(400),$
    wbase:                 wbase})
    
  ;This function retrieves the value of all the tube angles
  (*global1).TubeAngle = getTubeAngle()
  (*(*global1).tof_array) = retrieve_tof_array(NexusFileName)
  
  file_ext = ' - File: ' + NexusFileName
  (*global1).main_plot_real_title += file_ext
  (*global1).main_plot_tof_title += file_ext
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global1
  XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  ;display buttons (play, stop, next, previous, pause) -----------------------
  raw_buttons = READ_PNG('plotCNCS_images/set_of_buttons_raw.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_buttons')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, raw_buttons, 0, 0,/true
  
  pause_button = READ_PNG('plotCNCS_images/pause_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='pause_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, pause_button, 0, 0,/true
  
  stop_button = READ_PNG('plotCNCS_images/stop_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='stop_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, stop_button, 0, 0,/true
  
  previous_button = READ_PNG('plotCNCS_images/previous_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='previous_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, previous_button, 0, 0,/true
  
  play_button = READ_PNG('plotCNCS_images/play_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, play_button, 0, 0,/true
  
  next_button = READ_PNG('plotCNCS_images/next_disable.png')
  mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='next_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, next_button, 0, 0,/true
  
  ;---------------------------------------------------------------------------
  
  Nstep  = FLOAT(50) ;number of steps
  progressBarCancel = 0
  progressBar = OBJ_NEW("SHOWPROGRESS", $
    XOFFSET = 100, $
    YOFFSET = 50, $
    XSIZE   = 200,$
    TITLE   = 'Loading Data',$
    /CANCELBUTTON)
  progressBar->SetColor, 250
  progressBar->SetLabel, 'Retrieving Ntof ...'
  progressBar->Start
  
  img = getIMGfromNexus(NexusFileName, progressBar, Nstep, progressBarCancel)
  (*(*global1).img)= img
  
  ;display counts vs tof for play buttons of central row
  t_img = TOTAL(img,3)
  counts_vs_tof = t_img[*,64]
  (*(*global1).counts_vs_tof_for_play) = counts_vs_tof
  id = WIDGET_INFO(wBase,find_by_uname='play_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='to_bin')
  bin_max = N_ELEMENTS((*(*global1).tof_array))
  (*global1).bin_max_untouched = bin_max
  (*global1).to_bin = bin_max-1
  WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(bin_max-1,/REMOVE_ALL)
  
  xrange = [1,bin_max-1]
  (*global1).xrange = xrange
  PLOT, counts_vs_tof, XTITLE='Bins #', $
    YTITLE='Counts', XRANGE=xrange,$
    XSTYLE=1,$
    YSTYLE=1
    
  ;take snapshot
  ;background = TVREAD(TRUE = 3)
  background = TVRD(TRUE=3)
  (*(*global1).background) = background
  
  ;plot das view of full instrument
  progressBar->SetLabel, 'Generating Plot ...'
  plotDASviewFullInstrument, global1
  
  progressBar->Destroy
  OBJ_DESTROY, progressBar
  
END
