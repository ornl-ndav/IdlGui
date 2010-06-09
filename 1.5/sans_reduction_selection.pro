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
FUNCTION getListOfPixelExcluded, Event, Xarray, Yarray
  Xsize = 80L
  Ysize = 80L
  ;RoiPixelArrayExcluded = INTARR(Xsize * Ysize)+1
  RoiPixelArrayExcluded = INTARR(Xsize,Ysize)+1
  nbrElements           = N_ELEMENTS(Xarray)
  FOR i=0,(nbrElements-1) DO BEGIN
    RoiPixelArrayExcluded[Xarray[i],Yarray[i]]=0
  ENDFOR
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  (*(*global).RoiPixelArrayExcluded) = RoiPixelArrayExcluded
  RETURN, RoiPixelArrayExcluded
END

;------------------------------------------------------------------------------
; PRO PlotROI, Event, RoiPixelArrayExcluded
; ;get global structure
; id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
; WIDGET_CONTROL, id, GET_UVALUE=global

; id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
; WIDGET_CONTROL, id, GET_VALUE = id_value
; WSET, id_value

; ROIcolor = convert_rgb((*global).ROIcolor)
; x_coeff  = (*global).DrawXcoeff
; y_coeff  = (*global).DrawYcoeff
; NbrElements = N_ELEMENTS(RoiPixelArrayExcluded)

; FOR i=0,(80-1) DO BEGIN
;     FOR j=0,(80-1) DO BEGIN
;         IF (RoiPixelArrayExcluded[i,j] EQ 1) THEN BEGIN
;             x = i
;             y = j
;             PLOTS, x * x_coeff, y * y_coeff, /DEVICE, COLOR=color
;             PLOTS, x * x_coeff, (y+1) * y_coeff, /DEVICE, /CONTINUE, $
;               COLOR=color
;             PLOTS, (x+1) * x_coeff, (y+1) * y_coeff, /DEVICE, $
;               /CONTINUE, COLOR=color
;             PLOTS, (x+1) * x_coeff, y * y_coeff, /DEVICE, /CONTINUE, $
;               COLOR=color
;             PLOTS, x * x_coeff, y * y_coeff, /DEVICE, /CONTINUE, $
;               COLOR=color
;         ENDIF
;     ENDFOR
; ENDFOR
; END

;------------------------------------------------------------------------------
;This function returns the X and Y array of the ROI file
PRO getXYROI, StringArray, NbrRow, Xarray, Yarray
  FOR i=0,(NbrRow-1) DO BEGIN
    RoiStringArray = STRSPLIT(StringArray[i],'_',/EXTRACT)
    ON_IOERROR, L1
    Xarray[i] = FIX(RoiStringArray[1])
    Yarray[i] = FIX(RoiStringArray[2])
  ENDFOR
  L1: ;exit now
END

;------------------------------------------------------------------------------
FUNCTION retrieveStringArray, Event, FileName
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN, ['']
  ENDIF ELSE BEGIN
    OPENR, unit, FileName, /GET_LUN
    NbrLine   = FILE_LINES(FileName)
    FileArray = STRARR(NbrLine)
    READF, unit, FileArray
    FREE_LUN, unit
    RETURN, FileArray
  ENDELSE
END

;- Browse Selection File ------------------------------------------------------
PRO browse_selection_file, Event
  
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;retrieve infos
  extension  = (*global).selection_extension
  filter     = (*global).selection_filter
  title      = (*global).selection_title
  path       = (*global).selection_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  IDLsendToGeek_addLogBookText, Event, '> Browsing a ROI file:'
  
  RoiFileName = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    DIALOG_PARENT     = id, $
    GET_PATH          = new_path,$
    PATH              = path,$
    TITLE             = title,$
    /READ,$ 
    /MUST_EXIST)
    
  IF (RoiFileName NE '') THEN BEGIN
  
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/hourglass
    
    IDLsendToGeek_addLogBookText, Event, '-> File Browsed: ' + RoiFileName
    (*global).selection_path = new_path
    putTextFieldValue, Event, 'selection_file_name_text_field', RoiFileName
    putTextFieldValue, Event, 'roi_file_name_text_field', RoiFileName
    ;activate preview and load/plot buttons
    uname_list = ['selection_load_button',$
      'selection_preview_button']
    activate_widget_list, Event, uname_list, 1
    ;Load ROI button (Load, extract and plot)
    LoadPlotSelection, Event

    ;turn off hourglass
    WIDGET_CONTROL,hourglass=0
    
  ENDIF ELSE BEGIN
    IDLsendToGeek_addLogBookText, Event, '-> Operation CANCELED'
  ENDELSE
  
END

;- Preview Selection File -----------------------------------------------------
PRO preview_selection_file, Event
  roi_file_name = getTextFieldValue(Event,'selection_file_name_text_field')
  title = roi_file_name
  sans_reduction_xdisplayFile, roi_file_name, TITLE=title
END

;- Selection File Name Text Field ---------------------------------------------
PRO selection_text_field, Event
  roi_file_name = getTextFieldValue(Event,'selection_file_name_text_field')
  IF (FILE_TEST(roi_file_name)) THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  uname_list = ['selection_load_button',$
    'selection_preview_button']
  activate_widget_list, Event, uname_list, status
END

;- Selection Load Button ------------------------------------------------------
PRO LoadPlotSelection, Event

  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  IDLsendToGeek_addLogBookText, Event, '> Loading and Plotting ROI file:'
  RoiFileName = getTextFieldValue(Event,'selection_file_name_text_field')
  IDLsendToGeek_addLogBookText, Event, '-> ROI Loading : ' + RoiFileName
  IDLsendToGeek_addLogBookText, Event, '-> Retrieving information from ' + $
    'ROI file ... ' + PROCESSING
    
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
  ENDIF ELSE BEGIN
    FileStringArray = retrieveStringArray(Event, RoiFileName)
    IF (FileStringArray EQ ['']) THEN BEGIN
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
      NbrElements = N_ELEMENTS(FileStringArray)
      InfoText    = ' (Array Created has ' + $
        STRCOMPRESS(NbrElements,/REMOVE_ALL) + ' elements)'
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK + InfoText
      ;parse string array
      
      IF ((*global).facility EQ 'LENS') THEN BEGIN ;LENS ----------------------
      
        IDLsendToGeek_addLogBookText, Event, '-> Retrieve list of X,Y ... ' + $
          PROCESSING
        Xarray = INTARR(NbrElements)
        Yarray = INTARR(NbrElements)
        getXYROI, FileStringArray, NbrElements, Xarray, Yarray
        IF (Xarray[0] EQ '' AND Xarray[NbrElements-1] EQ '') THEN BEGIN ;FAILED
          IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
        ENDIF ELSE BEGIN                 ;WORKED
          IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
          ;plotting ROI
          IDLsendToGeek_addLogBookText, Event, $
            '-> Plotting ROI ... ' + PROCESSING
          plot_error = 0
          CATCH, plot_error
          IF (plot_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
          ENDIF ELSE BEGIN
            RoiPixelArrayExcluded = getListOfPixelExcluded(Event, $
              Xarray, $
              Yarray)
            (*(*global).RoiPixelArrayExcluded) = RoiPixelArrayExcluded
            
            PlotROI, Event
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
            (*global).there_is_a_selection = 1
          ENDELSE
        ENDELSE
  
      ENDIF ELSE BEGIN ;SNS ---------------------------------------------------

        load_inclusion_roi_for_sns, Event, FileStringArray
        ;;add list of pixel (bank#_x_y) to PixelArray
        ;add_to_global_exclusion_array, event, (*(*global).global_exclusion_array)
        
      ENDELSE
    ENDELSE
  ENDELSE
END

;- Refresh ROI Plot -----------------------------------------------------------
PRO RefreshRoiPlot, Event
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  RoiFileName = getTextFieldValue(Event,'selection_file_name_text_field')
  IF (FILE_TEST(RoiFileName,/READ)) THEN BEGIN
    RoiPixelArrayExcluded = (*(*global).RoiPixelArrayExcluded)
    PlotROI, Event, RoiPixelArrayExcluded
  ENDIF
END

;- Clear Selection Button -----------------------------------------------------
PRO clear_selection_tool, Event
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  IDLsendToGeek_addLogBookText, Event, '> Clearing Selection ... ' + $
    (*global).PROCESSING
  DataArray = (*(*global).DataArray)
  X         = (*global).X
  Y         = (*global).Y
  plotDataResult = plotData(Event, DataArray, X, Y) ;_plot
  (*global).there_is_a_selection = 0
  putTextFieldValue, Event, 'roi_file_name_text_field', ''
  (*(*global).RoiPixelArrayExcluded) = INTARR(80,80)
  (*(*global).global_exclusion_array) = STRARR(1)
  (*(*global).BankArray) = PTR_NEW(0L)
  (*(*global).PixelArray) = PTR_NEW(0L)
  (*(*global).TubeArray) = PTR_NEW(0L)
  
  putTextFieldValue, Event, 'corner_pixel_x0', '1'
  putTextFieldValue, Event, 'corner_pixel_y0', '0'
  putTextFieldValue, Event, 'corner_pixel_width', '1'
  putTextFieldValue, Event, 'corner_pixel_height', '1'
    
  IDLsendToGeek_ReplaceLogBookText, Event, (*global).processing, (*global).ok
END

;------------------------------------------------------------------------------
PRO change_color_OF_selection, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  color=FSC_COLOR(/SELECTCOLOR,/TRIPLE)
  (*global).ROIcolor = color
  refresh_plot, Event             ;_plot
  RefreshRoiExclusionPlot, Event  ;_selection
END
