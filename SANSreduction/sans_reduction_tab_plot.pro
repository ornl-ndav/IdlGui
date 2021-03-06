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

;==============================================================================
;This method parse the 1 column string array into 3 columns string array
PRO ParseDataStringArray, Event, DataStringArray, Xarray, Yarray, SigmaYarray
  Nbr = N_ELEMENTS(DataStringArray)
  j=0
  i=0
  WHILE (i LE Nbr-1) DO BEGIN
    CASE j OF
      0: BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
      END
      ELSE: BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
      END
    ENDCASE
    j++
  ENDWHILE
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  (*(*global).Xarray_untouched) = Xarray
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
END

;------------------------------------------------------------------------------
PRO CleanUpData, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END

;------------------------------------------------------------------------------
PRO preview_ascii_file, Event
  FileName = getTextFieldValue(Event, 'plot_input_file_text_field')
  TITLE = 'Preview of the ASCII File: ' + FileName
  sans_reduction_xdisplayFile,  FileName,$
    TITLE       = title, $
    DONE_BUTTON = 'Done with Preview of ASCii file'
END

;------------------------------------------------------------------------------
PRO check_IF_file_exist, Event
  FileName = getTextFieldValue(Event, 'plot_input_file_text_field')
  IF (FILE_TEST(FileName)) THEN BEGIN
    activate_preview_button = 1
  ENDIF ELSE BEGIN
    activate_preview_button = 0
  ENDELSE
  uname_list = ['plot_input_file_load_button',$
    'plot_input_file_preview_button']
  activate_widget_list, Event, uname_list, activate_preview_button
END

;==============================================================================
;Plot Data in widget_draw
PRO rePlotAsciiData, Event
  draw_id = widget_info(Event.top, find_by_uname='plot_draw_uname')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  wset,view_plot_id
  DEVICE, DECOMPOSED = 0
  loadct,5,/SILENT
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  Xarray      = (*(*global).Xarray)
  Yarray      = (*(*global).Yarray)
  SigmaYarray = (*(*global).SigmaYarray)
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    xaxis = (*global).xaxis
    xaxis_units = (*global).xaxis_units
    yaxis = (*global).yaxis
    yaxis_units = (*global).yaxis_units
    xLabel = xaxis + ' (' + xaxis_units + ')'
    yLabel = yaxis + ' (' + yaxis_units + ')'
    ;plot
    plot, Xarray, Yarray, color=250, PSYM=2, XTITLE=xLabel, YTITLE=yLabel
    errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,color=100
  ENDELSE
END

;==============================================================================
;Plot Data in widget_draw
PRO PlotAsciiData, Event, Xarray, Yarray, SigmaYarray
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  (*(*global).Xarray)      = Xarray
  (*(*global).Yarray)      = Yarray
  (*(*global).SigmaYarray) = SigmaYarray
  replotAsciiData, Event
END

;------------------------------------------------------------------------------
;Load data
PRO LoadAsciiFile, Event
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;retrieve parameters
  OK         = (*global).ok
  PROCESSING = (*global).processing
  FAILED     = (*global).failed
  
  file_name = getTextFieldValue(Event, 'plot_input_file_text_field')
  IDLsendToGeek_addLogBookText, Event, 'Loading ASCII file ' + $
    file_name
  IDLsendToGeek_addLogBookText, Event, '-> Retrieving data ... ' + PROCESSING
  loading_error = 0
  ;CATCH,loading_error
  IF (loading_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    text = 'Error while loading ' + file_name
    result = DIALOG_MESSAGE(text,/ERROR)
    activate_widget, Event, 'plot_refresh_plot_ascii_button', 0
  ENDIF ELSE BEGIN
    iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name)
    IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
      no_error = 0
      CATCH,no_error
      IF (no_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
        text = 'Error while loading ' + file_name
        result = DIALOG_MESSAGE(text,/ERROR)
        activate_widget, Event, 'plot_refresh_plot_ascii_button', 0
      ENDIF ELSE BEGIN
        sAscii = iAsciiFile->getData()
        (*global).xaxis       = sAscii.xaxis
        (*global).xaxis_units = sAScii.xaxis_units
        (*global).yaxis       = sAscii.yaxis
        (*global).yaxis_units = sAscii.yaxis_units
        
        DataStringArray = *(*sAscii.data)[0].data
        ;this method will creates a 3 columns array (x,y,sigma_y)
        Nbr = N_ELEMENTS(DataStringArray)
        IF (Nbr GT 1) THEN BEGIN
          Xarray      = STRARR(1)
          Yarray      = STRARR(1)
          SigmaYarray = STRARR(1)
          ParseDataStringArray, $
            Event,$
            DataStringArray,$
            Xarray,$
            Yarray,$
            SigmaYarray
          ;Remove all rows with NaN, -inf, +inf ...
          CleanUpData, Xarray, Yarray, SigmaYarray
          ;Change format of array (string -> float)
          Xarray      = FLOAT(Xarray)
          Yarray      = FLOAT(Yarray)
          SigmaYarray = FLOAT(SigmaYarray)
          ;Store the data in the global structure
          (*(*global).Xarray)      = Xarray
          (*(*global).Yarray)      = Yarray
          (*(*global).SigmaYarray) = SigmaYarray
          ;Plot Data in widget_draw
          PlotAsciiData, Event, Xarray, Yarray, SigmaYarray
        ENDIF
        ;file has been loaded with success
        (*global).ascii_file_load_status = 1
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
        activate_widget, Event, 'plot_refresh_plot_ascii_button', 1
      ENDELSE
    ENDIF ELSE BEGIN
      IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
      text = 'Error while loading ' + file_name
      result = DIALOG_MESSAGE(text,/ERROR)
      activate_widget, Event, 'plot_refresh_plot_ascii_button', 0
    ENDELSE
  ENDELSE
  ;turn off hourglass
  widget_control,hourglass=0
END

;------------------------------------------------------------------------------
PRO BrowseInputAsciiFile, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve parameters
  OK         = (*global).ok
  PROCESSING = (*global).processing
  FAILED     = (*global).failed
  
  extension  = (*global).ascii_extension
  filter     = (*global).ascii_filter
  path       = (*global).ascii_path
  title      = (*global).ascii_title
  
  text = 'Browsing for an ASCII file ... ' + PROCESSING
  IDLsendToGeek_addLogBookText, Event, text
  
  ascii_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    TITLE             = title,$
    /MUST_EXIST)
    
  IF (ascii_file_name NE '') THEN BEGIN ;get one
    (*global).ascii_path = new_path
    putTextFieldValue, Event, 'plot_input_file_text_field', ascii_file_name
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    text = '-> Ascii file loaded: ' + ascii_file_name
    IDLsendToGeek_addLogBookText, Event, text
  ENDIF ELSE BEGIN
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, 'INCOMPLETE!'
  ENDELSE
  ;check if we can activate or not the preview and load button
  check_IF_file_exist, Event
  ;Load File
  LoadAsciiFile, Event
END
