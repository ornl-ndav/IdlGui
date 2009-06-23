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
FUNCTION calculateValue, A=A, B=B, C=C, D=D, x
  step1 = A + x * B
  step2 = step1 + x * x * C
  step3 = step2 + x * x * x * D
  RETURN, step3
END

;==============================================================================
FUNCTION getUserDefinedXaxis, Event
  ;get Min, Max, Width and scale values
  Min    = getTextFieldValue(Event,'alternate_wave_min_text_field')
  Max    = getTextFieldValue(Event,'alternate_wave_max_text_field')
  Width  = getTextFieldValue(Event,'alternate_wave_width_text_field')
  linear = getCWBgroupValue(Event, $
    'alternate_wave_scale_group')
  dMin = DOUBLE(Min)
  dMax = DOUBLE(Max)
  dWidth = DOUBLE(Width)
  Xarray = [STRCOMPRESS(dMin)]
  index  = 0
  min    = dMin
  value  = dMin
  NbrData = 0
  WHILE(value LT dMax) DO BEGIN
    IF (linear EQ 0) THEN BEGIN
      value = dMin + dWidth
    ENDIF ELSE BEGIN
      value = dMin * (1+ dWidth)
      IF (value EQ dMin) THEN value += 0.001
    ENDELSE
    dMin = value
    Xarray = [Xarray,STRCOMPRESS(value)]
    NbrData++
  ENDWHILE
  RETURN, Xarray
END

;==============================================================================
PRO WaveUserDefinedAxisPreview, Event
  Xarray = getUserDefinedXaxis(Event)
  title = 'Preview of the X-axis that will be used in the output file.'
  XDISPLAYFILE, 'no_file_here', $
    TEXT        = Xarray, $
    TITLE       = title, $
    DONE_BUTTON = 'Done with Preview of x-axis'
END

;==============================================================================
FUNCTION createDataArray, Event
  ;check if user wants default or defined x-axis
  alternate_wave_axis = getCWBgroupValue(Event, $
    'alternate_wavelength_axis_cw_group')
  IF (alternate_wave_axis EQ 0) THEN BEGIN
    Xarray = getUserDefinedXaxis(Event)
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    Xarray = (*(*global).Xarray_untouched)
  ENDELSE
  nbr = N_ELEMENTS(Xarray)
  output_data_array = STRARR(nbr)
  ;retrieve polynome used
  A = getTextFieldValue(Event,'result_fit_a_text_field')
  B = getTextFieldValue(Event,'result_fit_b_text_field')
  C = getTextFieldValue(Event,'result_fit_c_text_field')
  D = getTextFieldValue(Event,'result_fit_d_text_field')
  fA = DOUBLE(A)
  fB = DOUBLE(B)
  fC = DOUBLE(C)
  fD = DOUBLE(D)
  FOR i=0,(nbr-2) DO BEGIN
    xleft  = DOUBLE(Xarray[i])
    xright = DOUBLE(Xarray[i+1])
    new_value = calculateValue(A=fA, B=fB, C=fC, D=fD, (xleft+xright)/2.)
    output_data_array[i] = STRCOMPRESS(Xarray[i]) + ' '
    output_data_array[i] += STRCOMPRESS(new_value) + ' 0.0'
  ENDFOR
  output_data_array[nbr-1] = STRCOMPRESS(Xarray[nbr-1])
  RETURN, output_data_array
END

;==============================================================================
FUNCTION getPolyString, Event
  A = getTextFieldValue(Event,'result_fit_a_text_field')
  B = getTextFieldValue(Event,'result_fit_b_text_field')
  C = getTextFieldValue(Event,'result_fit_c_text_field')
  D = getTextFieldValue(Event,'result_fit_d_text_field')
  ;get degree of poly selected
  value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
  CASE (value_OF_group) OF
    0: degree = 1
    1: degree = 2
    2: degree = 3
  ENDCASE
  poly_string = '#C fitting function: '
  poly_string += STRCOMPRESS(A,/REMOVE_ALL) + ' + '
  poly_string += STRCOMPRESS(B,/REMOVE_ALL) + '.X '
  IF (degree GE 2) THEN BEGIN
    poly_string += '+ ' + STRCOMPRESS(C,/REMOVE_ALL) + '.X^2 '
    IF (degree GE 3) THEN BEGIN
      poly_string += '+ ' + STRCOMPRESS(D,/REMOVE_ALL) + '.X^3 '
    ENDIF
  ENDIF
  RETURN, poly_string
END

;==============================================================================
FUNCTION createOutputArray, Event
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN ;trans. mode
    ;retrieve list of #X tags from the input ascii file
    file_name = getTextFieldValue(Event,'input_file_text_field')
    iClass = OBJ_NEW('IDL3columnsASCIIparser',file_name)
    output_array = iClass->getAllTag(Event)
    ;add information about polynome used
    poly_string = getPolyString(Event)
    output_array = [output_array,poly_string]
    ;add emtpy line, and scale informations
    output_array = [output_array,'']
    outputStructure = iClass->getData(Event)
    ;#S 1 Spectrum ID ('bank1',(38,38))
    bank = (*outputStructure.data[0]).bank
    x    = (*outputStructure.data[0]).x
    y    = (*outputStructure.data[0]).y
    new_line  = "#S 1 Spectrum ID ('" + bank + "', (" + x
    new_line += ', ' + y + '))'
    output_array = [output_array, new_line]
    ;#N #
    output_array = [output_array, '#N 3']
    ;#L wavelength(Angstroms) Intensity(Counts/A) Sigma(Counts/A)
    xaxis             = outputStructure.xaxis
    xaxis_units       = outputStructure.xaxis_units
    yaxis             = outputStructure.yaxis
    yaxis_units       = outputStructure.yaxis_units
    sigma_yaxis       = outputStructure.sigma_yaxis
    sigma_yaxis_units = outputStructure.sigma_yaxis_units
    new_line  = '#L ' + xaxis + '(' + xaxis_units + ') '
    new_line += yaxis + '(' + yaxis_units + ') '
    new_line += sigma_yaxis + '(' + sigma_yaxis_units + ')'
    output_array = [output_array, new_line]
    ;Data
    DataArray = createDataArray(Event)
    output_array = [output_array, DataArray]
    obj_destroy, iClass
  ENDIF ELSE BEGIN ;background mode
    ;get degree of poly selected
    value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
    CASE (value_OF_group) OF
      0: degree = 1
      1: degree = 2
      2: degree = 3
    ENDCASE
    output_array = STRARR(degree+2)
    A = getTextFieldValue(Event,'result_fit_a_text_field')
    output_array[0] = 'A: ' + A
    B = getTextFieldValue(Event,'result_fit_b_text_field')
    output_array[1] = 'B: ' + B
    IF (degree GE 2) THEN BEGIN
      C = getTextFieldValue(Event,'result_fit_c_text_field')
      output_array[2] = 'C: ' + C
      IF (degree GE 3) THEN BEGIN
        D = getTextFieldValue(Event,'result_fit_d_text_field')
        output_array[3] = 'D: ' + D
      ENDIF
    ENDIF
    ;retrieve scaling factor for input file (if there)
    file_name = getTextFieldValue(Event,'input_file_text_field')
    iClass = OBJ_NEW('IDL3columnsASCIIparser',file_name)
    scaling_factor = IClass->get_tag('#C background Scaling:', Event)
    output_array[degree+1] = 'Scaling Factor: ' + $
      STRCOMPRESS(scaling_factor,/REMOVE_ALL)
    obj_destroy, iClass
  ENDELSE
  RETURN, output_array
END

;==============================================================================
;This procedure created the output file
PRO OutputFileSave, Event
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;create the output string array
  output_array = createOutputArray(Event)
  ;get name of new output file
  output_path = getButtonValue(Event, 'output_folder_button')
  output_name = getTextFieldValue(Event, 'output_file_text_field')
  output_file_name = output_path + output_name
  ;write file
  no_error = 0
  CATCH, no_error
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='output_file_save_button')
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = ['CREATE OUTPUT FILE FAILED !',$
      'FILE NAME : ' + output_file_name]
    ;turn off hourglass
    widget_control,hourglass=0
    status = DIALOG_MESSAGE(message, $
      /ERROR,$
      DIALOG_PARENT = id)
  ENDIF ELSE BEGIN
    OPENW, 1, output_file_name
    sz = N_ELEMENTS(output_array)
    FOR i=0,(sz-1) DO BEGIN
      PRINTF, 1, output_array[i]
    ENDFOR
    CLOSE, 1
    FREE_LUN, 1
    ;turn off hourglass
    widget_control,hourglass=0
    message = ['OUTPUT FILE HAS BEEN CREATED WITH SUCCESS',$
      'FILE NAME : ' + output_file_name]
    status = DIALOG_MESSAGE(message,$
      /INFORMATION,$
      DIALOG_PARENT = id)
  ENDELSE
END

;==============================================================================
PRO OutputFileEditSave, Event ;_fitting
  ;create the output string array
  output_array = createOutputArray(Event)
  ;get name of new output file
  output_path = getButtonValue(Event, 'output_folder_button')
  output_name = getTextFieldValue(Event, 'output_file_text_field')
  output_file_name = output_path + output_name
  sans_calibration_xdisplayfile, $
    output_file_name,$
    TEXT = output_array,$
    /EDITABLE,$
    /GROW_TO_SCREEN
END

;==============================================================================
PRO UpdateFittingGui_save, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;Activate or not the SAVE buttons
  activate_save_button = 0
  activate_wave_preview_button = 0
  ;*************************************
  ;if fitting has been done with success
  ;and if min, max and width are real foat values and min<max
  fitting_status = (*global).fitting_status
  A = getTextFieldValue(Event,'result_fit_a_text_field')
  B = getTextFieldValue(Event,'result_fit_b_text_field')
  C = getTextFieldValue(Event,'result_fit_c_text_field')
  D = getTextFieldValue(Event,'result_fit_d_text_field')
  no_error = 0
  ON_IOERROR, bad_parameters
  fA = FLOAT(A)
  fB = FLOAT(B)
  fC = FLOAT(C)
  fD = FLOAT(D)
  IF (getCWBgroupValue(Event,'alternate_wavelength_axis_cw_group') EQ 0) $
    THEN BEGIN
    ON_IOERROR, bad_parameters
    Min    = getTextFieldValue(Event,'alternate_wave_min_text_field')
    Max    = getTextFieldValue(Event,'alternate_wave_max_text_field')
    Width  = getTextFieldValue(Event,'alternate_wave_width_text_field')
    dMin   = FLOAT(Min)
    dMax   = FLOAT(Max)
    dWidth = FLOAT(Width)
  ENDIF
  IF (fitting_status EQ 0 AND $   ;then activate button
    FINITE(fA) AND $
    FINITE(fB) AND $
    FINITE(fC) AND $
    FINITE(fD)) THEN BEGIN
    IF (getCWBgroupValue(Event,$
      'alternate_wavelength_axis_cw_group') EQ 0) THEN BEGIN
        IF (dMin LT dMax AND $
          dWidth NE '') THEN BEGIN
          activate_save_button = 1
          activate_wave_preview_button = 1
        ENDIF
      ENDIF ELSE BEGIN
        activate_save_button = 1
      ENDELSE
    ENDIF ELSE BEGIN
      IF (getCWBgroupValue(Event,$
        'alternate_wavelength_axis_cw_group') EQ 0) THEN BEGIN
          IF (dMin LT dMax AND $
            dWidth NE '') THEN BEGIN
            activate_wave_preview_button = 1
          ENDIF
        ENDIF
      ENDELSE
      no_error = 1
      bad_parameters: IF (no_error EQ 0) THEN BEGIN
        activate_save_button = 0
        activate_wave_preview_button = 0
      ENDIF
      activate_widget, Event, 'output_file_save_button', activate_save_button
      activate_widget, Event, 'output_file_edit_save_button', activate_save_button
      activate_widget, Event, 'wavelength_axis_preview_button', $
        activate_wave_preview_button
    END
    
    ;==============================================================================
    PRO UpdateFittingGui_preview, Event
      ascii_file_name = getTextFieldValue(Event,'input_file_text_field')
      IF (FILE_TEST(ascii_file_name,/READ)) THEN BEGIN
        activate_button = 1
      ENDIF ELSE BEGIN
        activate_button = 0
      ENDELSE
      activate_widget, Event, 'input_file_preview_button', activate_button
      ;get global structure
      WIDGET_CONTROL, Event.top, GET_UVALUE=global
      load_status = (*global).ascii_file_load_status
      IF (load_status EQ 1) THEN BEGIN
        activate_fitting_button = 1
      ENDIF ELSE BEGIN
        activate_fitting_button = 0
      ENDELSE
      uname_list = ['auto_fitting_button',$
        'manual_fitting_button',$
        'refresh_fitting_button']
      activate_widget_list, Event, uname_list, activate_fitting_button
    END
    
    ;==============================================================================
    PRO FittingFunction, Event, Xarray, Yarray, SigmaYarray
      ;get degree of poly selected
      value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
      CASE (value_OF_group) OF
        0: degree = 1
        1: degree = 2
        2: degree = 3
      ENDCASE
      
      ;with error bars or not
      WithErrorBars = getCWBgroupValue(Event,'fitting_error_bars_group')
      
      ; Compute the polynomial fit to the data:
      IF (WithErrorBars EQ 0) THEN BEGIN ;with Error bars
        coeff = POLY_FIT(Xarray, $
          Yarray, $
          degree,$
          MEASURE_ERRORS = sigmaYarray, $
          SIGMA          = sigma, $
          STATUS         = status,$
          /double)
      ENDIF ELSE BEGIN
        coeff = POLY_FIT(Xarray, $
          Yarray, $
          degree,$
          SIGMA          = sigma, $
          STATUS         = status,$
          /double)
      ENDELSE
      
      ;get global structure
      WIDGET_CONTROL, Event.top, GET_UVALUE=global
      (*global).fitting_status = status
      
      ;replot ASCII file
      rePlotAsciiData, Event
      
      ;plot fit data
      draw_id = widget_info(Event.top, find_by_uname='fitting_draw_uname')
      WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
      wset,view_plot_id
      
      A = coeff[0]
      B = coeff[1]
      
      IF (status EQ 0 AND $
        FINITE(A) AND $
        FINITE(B)) THEN BEGIN
        CASE (degree) OF
          1: BEGIN
            C = 0
            D = 0
            newXarray = B*Xarray + A
          END
          2: BEGIN
            C = coeff[2]
            D = 0
            newXarray = C*Xarray*Xarray + B*Xarray + A
          END
          3: BEGIN
            C = coeff[2]
            D = coeff[3]
            newXarray = D*Xarray^3 + C*Xarray^2+ B*Xarray + A
          END
        ENDCASE
        oplot,Xarray,newXarray,COLOR=150,THICK=1.5
        sA = STRCOMPRESS(A,/REMOVE_ALL)
        sB = STRCOMPRESS(B,/REMOVE_ALL)
        sC = STRCOMPRESS(C,/REMOVE_ALL)
        sD = STRCOMPRESS(D,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        sA = 'N/A'
        sB = 'N/A'
        CASE (degree) OF
          1: BEGIN
            sC = '0'
            sD = '0'
          END
          2: BEGIN
            sC = 'N/A'
            sD = '0'
          END
          3: BEGIN
            sC = 'N/A'
            sD = 'N/A'
          END
        ENDCASe
      ENDELSE
      putTextFieldValue, Event, 'result_fit_a_text_field', sA
      putTextFieldValue, Event, 'result_fit_b_text_field', sB
      putTextFieldValue, Event, 'result_fit_c_text_field', sC
      putTextFieldValue, Event, 'result_fit_d_text_field', sD
    END
    
    ;==============================================================================
    ;Manual fitting of data. Plot fit using data from text_field
    PRO ManualFitting, Event
      ;replot ASCII file
      rePlotAsciiData, Event
      ;plot fit data
      draw_id = widget_info(Event.top, find_by_uname='fitting_draw_uname')
      WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
      wset,view_plot_id
      sA = getTextFieldValue(Event, 'result_fit_a_text_field')
      sB = getTextFieldValue(Event, 'result_fit_b_text_field')
      sC = getTextFieldValue(Event, 'result_fit_c_text_field')
      sD = getTextFieldValue(Event, 'result_fit_d_text_field')
      ON_IOERROR, bad_parameters
      no_error = 0
      CATCH, no_error
      IF (no_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        RETURN
      ENDIF ELSE BEGIN
        dA = DOUBLE(sA)
        dB = DOUBLE(sB)
        dC = DOUBLE(sC)
        dD = DOUBLE(sD)
        ;get global structure
        WIDGET_CONTROL, Event.top, GET_UVALUE=global
        Xarray = (*(*global).Xarray)
        newXarray = dD*Xarray^3 + dC*Xarray^2 + dB*Xarray + dA
        oplot,Xarray,newXarray,COLOR=150,THICK=1.5
      ENDELSE
      bad_parameters:
    END
    
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
    ;change the label of the automatic button
    PRO ChangeDegreeOfPolynome, Event
      value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
      CASE (value_OF_group) OF
        0: label = 'AUTOMATIC FITTING with Y = A + BX'
        1: label = 'AUTOMATIC FITTING with Y = A + BX + CX^2'
        2: label = 'AUTOMATIC FITTING with Y = A + BX + CX^2 + DX^3'
        ELSE: label = ''
      ENDCASE
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
      WIDGET_CONTROL, Event.top, GET_UVALUE=global
      
      ;retrieve parameters
      OK         = (*global).ok
      PROCESSING = (*global).processing
      FAILED     = (*global).failed
      
      ;Check mode (trans or back)
      IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN ;trans
        extension  = (*global).ascii_trans_extension
        filter     = (*global).ascii_trans_filter
      ENDIF ELSE BEGIN ;back
        extension  = (*global).ascii_back_extension
        filter     = (*global).ascii_back_filter
      ENDELSE
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
    PRO rePlotAsciiData, Event
      draw_id = widget_info(Event.top, find_by_uname='fitting_draw_uname')
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
        ;plot with error bars or not
        WithErrorBars = getCWBgroupValue(Event,'plot_error_bars_group')
        IF (WithErrorBars EQ 0) THEN BEGIN ;yes, with error bars
          errplot, Xarray,Yarray-SigmaYarray,Yarray+SigmaYarray,color=100
        ENDIF
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
    
    ;==============================================================================
    ;Populate output folder/file name with path and default file name
    PRO DefineOutputFileName, Event
      ;get name of input file name
      FullFileName = getTextFieldValue(Event,'input_file_text_field')
      ;isolate path from file name only
      aPathNameIndex = STRSPLIT(FullFileName,'/') ;to check if '/' is first ot not
      aPathName      = STRSPLIT(FullFileName,'/',/EXTRACT,COUNT=nbr)
      FileNameOnly = aPathName[nbr-1]
      IF (nbr GT 2) THEN BEGIN
        Path = STRJOIN(aPathName[0:nbr-2],'/')
      ENDIF ELSE BEGIN
        Path = aPathName[0]
      ENDELSE
      IF (aPathNameIndex[0] EQ 1) THEN BEGIN
        Path = '/' + Path
      ENDIF
      putNewButtonValue, Event, 'output_folder_button', Path + '/'
      ;get new file name (ex: input: SANS_175.txt -> SANS_175_p1.txt)
      aFileNameOnly = STRSPLIT(FileNameOnly,'.',/EXTRACT)
      ;get polynomial degree
      value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
      IF (value_OF_group EQ 0) THEN BEGIN ;degree 1
        sAdd = '_p1'
      ENDIF ELSE BEGIN
        sAdd = '_p2'
      ENDELSE
      ;timeStamp = GenerateIsoTimeStamp()
      ;sAdd += timeStamp
      FileName = aFileNameOnly[0]+sAdd+'.'+aFileNameOnly[1]
      putTextFieldValue, Event, 'output_file_text_field', FileName
    END
    
    ;==============================================================================
    PRO redefinedOutputFileNameOnly, Event
      ;get name of input file name
      FullFileName = getTextFieldValue(Event,'input_file_text_field')
      ;isolate path from file name only
      aPathName = STRSPLIT(FullFileName,'/',/EXTRACT,COUNT=nbr)
      FileNameOnly = aPathName[nbr-1]
      ;get new file name (ex: input: SANS_175.txt -> SANS_175_p1.txt)
      aFileNameOnly = STRSPLIT(FileNameOnly,'.',/EXTRACT)
      ;get polynomial degree
      value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
      CASE (value_OF_group) OF
        0: sAdd = '_p1' ;degree 1
        1: sAdd = '_p2' ;degree 2
        2: sADD = '_p3' ;degree 3
      ENDCASE
      FileName = aFileNameOnly[0]+sAdd+'.'+aFileNameOnly[1]
      putTextFieldValue, Event, 'output_file_text_field', FileName
    END
    
    ;==============================================================================
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
      
      file_name = getTextFieldValue(Event, 'input_file_text_field')
      IDLsendToGeek_addLogBookText, Event, 'Loading ASCII file ' + $
        file_name
      IDLsendToGeek_addLogBookText, Event, '-> Retrieving data ... ' + PROCESSING
      loading_error = 0
      CATCH,loading_error
      IF (loading_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
        text = 'Error while loading ' + file_name
        result = DIALOG_MESSAGE(text,/ERROR)
      ENDIF ELSE BEGIN
        iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name)
        IF (OBJ_VALID(iAsciiFile)) THEN BEGIN
          no_error = 0
          ;CATCH,no_error ;remove_me
          IF (no_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
            text = 'Error while loading ' + file_name
            result = DIALOG_MESSAGE(text,/ERROR)
          ENDIF ELSE BEGIN
            sAscii = iAsciiFile->getData(event)
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
              ;Populate output folder/file name with path and default file name
              DefineOutputFileName, Event
            ENDIF
            ;file has been loaded with success
            (*global).ascii_file_load_status = 1
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
          ENDELSE
        ENDIF ELSE BEGIN
          IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
          text = 'Error while loading ' + file_name
          result = DIALOG_MESSAGE(text,/ERROR)
        ENDELSE
        UpdateFittingGui_preview, Event
      ENDELSE
      ;turn off hourglass
      widget_control,hourglass=0
    END
    
    ;==============================================================================
    ;This procedure is reached by the Automatic fitting button
    PRO  AutoFit, Event
      ;get global structure
      WIDGET_CONTROL, Event.top, GET_UVALUE=global
      Xarray = (*(*global).Xarray)
      Yarray = (*(*global).Yarray)
      SigmaYarray = (*(*global).SigmaYarray)
      FittingFunction, Event, Xarray, Yarray, SigmaYarray
    END
    
    ;==============================================================================
    ;PREVIEW ascii file
    PRO PreviewAsciiFile, Event
      file_name = getTextFieldValue(Event, 'input_file_text_field')
      XDISPLAYFILE, file_name
    END
