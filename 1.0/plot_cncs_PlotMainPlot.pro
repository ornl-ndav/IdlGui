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
      replot_main_plot, Event
      plot_selection_box, Event
    END
    
    ;linear plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_linear_plot'): BEGIN
      replot_main_plot_with_scale, Event
      plot_selection_box, Event
    END
    
    ;log plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_log_plot'): BEGIN
      replot_main_plot_with_scale, Event
      plot_selection_box, Event
    END
    
    ;counts vs tof of full detector
    WIDGET_INFO(event.top, FIND_BY_UNAME='counts_vs_tof_full_detector'): BEGIN
      plot_counts_vs_tof_of_full_detector, Event
    END
    
    ;    ;selection of mbar button - DAS view
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='plot_das_view_button_mbar'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      activateWidget, event, 'tof_scale_button', 0
    ;      (*global1).real_or_tof =0
    ;      plotDASviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;selection of mbar button - tof view
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='plot_tof_view_button_mbar'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      activateWidget, event, 'tof_scale_button', 1
    ;      (*global1).real_or_tof = 1
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /9
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d9'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 9)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 9
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /8
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d8'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 8)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 8
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /7
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d7'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 7)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 7
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /6
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d6'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 6)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 6
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /5
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d5'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 5)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 5
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /4
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d4'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 4)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 4
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /3
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d3'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 3)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 3
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale /2
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_d2'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (/ 2)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched / 2
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale reset
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_reset'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 1)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *2
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m2'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 2)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 2
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *3
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m3'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 3)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 3
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *4
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m4'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 4)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 4
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *5
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m5'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 5)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 5
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *6
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m6'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 6)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 6
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *7
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m7'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 7)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 7
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *8
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m8'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 8)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 8
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    ;
    ;    ;tof scale *9
    ;    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_scale_m9'): begin
    ;      WIDGET_CONTROL, /HOURGLASS
    ;      id = WIDGET_INFO(event.top,find_by_uname='tof_scale_button')
    ;      title = (*global1).tof_scale_title + ' (* 9)'
    ;      WIDGET_CONTROL, id, set_value= title
    ;      (*global1).Ytof = (*global1).Ytof_untouched * 9
    ;      plotTOFviewFullInstrument, global1
    ;      WIDGET_CONTROL, HOURGLASS = 0
    ;    end
    
    ;Main plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot'): begin
      MainPlotInteraction, Event
      
      IF (Event.press EQ 1) THEN BEGIN ;press left button
        (*global1).left_pressed = 1
        (*global1).X1 = Event.x
        (*global1).Y1 = Event.y
      ENDIF
      
      IF (Event.type EQ 1 AND $
        (*global1).left_pressed EQ 1) THEN BEGIN ;release of left button only
        (*global1).left_pressed = 0
        WIDGET_CONTROL, /HOURGLASS
        job_base = counts_vs_tof_info_base(Event)
        plot_counts_vs_tof_of_selection, Event
        WIDGET_CONTROL, HOURGLASS=0
        WIDGET_CONTROL, job_base,/DESTROY
        
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
        print, index
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
  
  ;display min and max in cw_fields
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='main_base_min_value')
  WIDGET_CONTROL, id, SET_VALUE=MIN
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='main_base_max_value')
  WIDGET_CONTROL, id, SET_VALUE=MAX
  
  ;rebin big array
  big_array_rebin = REBIN(big_array, xsize_total*Xfactor, ysize*Yfactor,/SAMPLE)
  
  ;remove_me
  ;  big_array_rebin[0:3,0:1] = 1500
  
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
  
  color = 150
  
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
  
  ;min value
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
  
  TVSCL, big_array_rebin, /DEVICE, xoff, off
  
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
    nexus_file_name:       NexusFileName,$
    main_plot_real_title:  'Real View of Instrument (Y vs X integrated over TOF)',$
    main_plot_tof_title:   'TOF View (TOF vs X integrated over Y)',$
    TubeAngle:             FLTARR(400),$
    wbase:                 wbase})
    
  ;This function retrieves the value of all the tube angles
  (*global1).TubeAngle = getTubeAngle()
  
  file_ext = ' - File: ' + NexusFileName
  (*global1).main_plot_real_title += file_ext
  (*global1).main_plot_tof_title += file_ext
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global1
  XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
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
  
  ;plot das view of full instrument
  progressBar->SetLabel, 'Generating Plot ...'
  plotDASviewFullInstrument, global1
  
  progressBar->Destroy
  OBJ_DESTROY, progressBar
  
END
