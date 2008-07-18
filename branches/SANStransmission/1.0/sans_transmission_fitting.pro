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
;This method parse the 1 column string array into 3 columns string array
PRO ParseDataStringArray, DataStringArray, Xarray, Yarray, SigmaYarray
Nbr = N_ELEMENTS(DataStringArray)
j=0
i=0
WHILE (i LE Nbr-2) DO BEGIN
    IF (j EQ 0) THEN BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
    ENDIF ELSE BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
    ENDELSE
    j++
ENDWHILE
END

;------------------------------------------------------------------------------
PRO CleanUpData, Xarray, Yarray, SigmaYarray
;remove -Inf, Inf and NaN
RealMinIndex = WHERE(FINITE(Yarray))
Xarray = Xarray(RealMinIndex)
Yarray = Yarray(RealMinIndex)
SigmaYarray = SigmaYarray(RealMinIndex)
END

;------------------------------------------------------------------------------
;change the label of the automatic button
PRO ChangeDegreeOfPolynome, Event
value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
IF (value_OF_group EQ 0) THEN BEGIN
    label = 'AUTOMATIC FITTING with Y = A + BX'
ENDIF ELSE BEGIN
    label = 'AUTOMATIC FITTING with Y = A + BX + CX^2'
ENDELSE
putNewButtonValue, Event, 'auto_fitting_button', label
END

;==============================================================================
PRO ChangeAlternateAxisOption, Event
value_OF_group = getCWBgroupValue(Event,'alternate_wavelength_axis_cw_group')
IF (value_OF_group EQ 0) THEN BEGIN
    status = 1
ENDIF ELSE BEGIN
    status = 0
ENDELSE
map_base, Event, 'alternate_base', status
END

;==============================================================================
PRO BrowseInputAsciiFile, Event 
;get global structure
;id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;retrieve parameters
OK         = (*global).ok
PROCESSING = (*global).processing
FAILED     = (*global).failed
filter     = (*global).ascii_filter
extension  = (*global).ascii_extension
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
    putTextFieldValue, Event, 'input_file_text_field', ascii_file_name
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    text = '-> Ascii file loaded: ' + ascii_file_name
    IDLsendToGeek_addLogBookText, Event, text
ENDIF ELSE BEGIN
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, 'INCOMPLETE!'
ENDELSE
;check if we can activate or not the preview and load button
AsciiInputTextField, Event 
;Load File
LoadAsciiFile, Event
END

;==============================================================================
PRO AsciiInputTextField, Event 
file_name = getTextFieldValue(Event, 'input_file_text_field')
IF (FILE_TEST(file_name)) THEN BEGIN
    activate = 1
ENDIF ELSE BEGIN
    activate = 0
ENDELSE
uname_list = ['input_file_load_button',$
              'input_file_preview_button']
activate_widget_list, Event, uname_list, activate
END

;==============================================================================
;Plot Data in widget_draw
PRO PlotAsciiData, Event, Xarray, Yarray, SigmaYarray
draw_id = widget_info(Event.top, find_by_uname='fitting_draw_uname')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id
DEVICE, DECOMPOSED = 0
loadct,5,/SILENT
plot, Xarray, Yarray, color=250
errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,color=100
END

;==============================================================================
;Load data
PRO LoadAsciiFile, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;retrieve parameters
OK         = (*global).ok
PROCESSING = (*global).processing
FAILED     = (*global).failed

file_name = getTextFieldValue(Event, 'input_file_text_field')
IDLsendToGeek_addLogBookText, Event, 'Loading ASCII file ' + $
  file_name
IDLsendToGeek_addLogBookText, Event, '-> Retrieving data ... ' + PROCESSING
iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name)
IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
    no_error = 0
    CATCH,no_error   
    IF (no_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
        sAscii = iAsciiFile->getData()
        DataStringArray = *(*sAscii.data)[0].data
;this method will creates a 3 columns array (x,y,sigma_y)
        Nbr = N_ELEMENTS(DataStringArray)
        IF (Nbr GT 1) THEN BEGIN
            Xarray      = STRARR(1)
            Yarray      = STRARR(1)
            SigmaYarray = STRARR(1)
            ParseDataStringArray, $
              DataStringArray,$
              Xarray,$
              Yarray,$
              SigmaYarray
;Remove all rows with NaN, -inf, +inf ...
            CleanUpData, Xarray, Yarray, SigmaYarray
;Change format of array (string -> float)
            Xarray = FLOAT(Xarray)
            Yarray = FLOAT(Yarray)
            SigmaYarray = FLOAT(SigmaYarray)
;Plot Data in widget_draw
            PlotAsciiData, Event, Xarray, Yarray, SigmaYarray
        ENDIF 
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
ENDIF ELSE BEGIN
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
ENDELSE
    
END

;==============================================================================
;PREVIEW ascii file
PRO PreviewAsciiFile, Event
file_name = getTextFieldValue(Event, 'input_file_text_field')
XDISPLAYFILE, file_name
END
