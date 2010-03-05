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

FUNCTION getNexusInfo, file_name, PATH=path, result

  fileID = H5F_OPEN(file_name)
  path   = PATH
  
  error_value = 0
  CATCH, error_value
  IF (error_value NE 0) THEN BEGIN
    CATCH,/CANCEL
    result = 0
    RETURN, ''
  ENDIF ELSE BEGIN
    pathID     = H5D_OPEN(fileID, path)
    tof_array  = H5D_READ(pathID)
    H5D_CLOSE, pathID
    result     = 1
    RETURN, tof_array
  ENDELSE
END

;..............................................................................
FUNCTION getTOFArray, Event, FILE_NAME=file_name, result
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  path      = (*global).nexus_tof_path
  tof_array = getNexusInfo(FILE_NAME, PATH=path, result)
  RETURN, tof_array
END

;..............................................................................
FUNCTION retrieveProtonCharge, event, FILE_NAME=file_name, result
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  path =  (*global).nexus_proton_charge_path
  proton_charge = getNexusInfo(FILE_NAME, PATH=path, result)
  RETURN, proton_charge
END

;..............................................................................
FUNCTION retrieveModeratorSampleDistance, Event, $
    FILE_NAME=file_name,$
    result
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  path =  (*global).distance_moderator_sample
  distance = getNexusInfo(FILE_NAME, PATH=path, result)
  RETURN, distance
END

;..............................................................................
FUNCTION retrieveSamplePixelArray, Event,$
    FILE_NAME=file_name,$
    result
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  path =  (*global).distance_sample_pixel_path
  distance = getNexusInfo(FILE_NAME, PATH=path, result)
  RETURN, distance
END

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
;This procedure is reached by the CALCULATE SF button of the empty cell
PRO start_sf_scaling_factor_calculation_mode, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  widget_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='empty_cell_scaling_factor_button')
    
  ;IF ((*global).debugging_version EQ 'yes') THEN BEGIN
  ;
  ;    data_nexus_file       = (*global).empty_cell_full_nexus_name
  ;    empty_cell_nexus_file = data_nexus_file
  ;    (*global).data_full_nexus_name = data_nexus_file
  ;    (*(*global).DATA_D_TOTAL_ptr) = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  ;
  ;ENDIF
    
  ;check that there are data and empty cell nexus file loaded
  data_nexus_file       = (*global).data_full_nexus_name
  empty_cell_nexus_file = (*global).empty_cell_full_nexus_name
  
  IF (data_nexus_file EQ '' OR $
    empty_cell_nexus_file EQ '') THEN BEGIN
    
    text   = ['Data and/or Empty Cell NeXus file is/are missing!',$
      'Please load the missing NeXus file(s)']
    title  = 'NeXus File Missing!'
    
    result = DIALOG_MESSAGE(text,$
      /INFORMATION,$
      /CENTER,$
      TITLE = title,$
      DIALOG_PARENT = widget_id)
    RETURN
  ENDIF
  
  ;retrieve the tof of data and empty_cell
  data_tof = getTOFArray(Event, $
    FILE_NAME=data_nexus_file, $
    result_data) ;_sf_empty
  IF (result_data NE 1) THEN BEGIN
    text   = 'Problem Retrieving the TOF axis from ' + data_nexus_file
    title  = 'TOF axis ERROR!'
    result = DIALOG_MESSAGE(text,$
      /ERROR,$
      /CENTER,$
      TITLE = title,$
      DIALOG_PARENT = widget_id)
    RETURN
  ENDIF
  (*(*global).sf_data_tof) = data_tof
  
  empty_cell_tof = getTOFArray(Event, $
    FILE_NAME=empty_cell_nexus_file, $
    result_empty_cell)
  IF (result_empty_cell NE 1) THEN BEGIN
    text   = 'Problem Retrieving the TOF axis from ' + $
      empty_cell_nexus_file
    title  = 'TOF axis ERROR!'
    result = DIALOG_MESSAGE(text,$
      /ERROR,$
      /CENTER,$
      TITLE = title,$
      DIALOG_PARENT = widget_id)
    RETURN
  ENDIF
  (*(*global).sf_empty_cell_tof) = empty_cell_tof
  
  ;check that both tof arrays are identical
  IF (~ARRAY_EQUAL(data_tof, empty_cell_tof)) THEN BEGIN
    text   = ['Data and Empty Cell NeXus files do not have the same ' + $
      'histogramming schema (TOF axis).',$
      'Please use MakeNeXus to have them use the same TOF axis']
    title  = 'TOF axis INCOMPATIBLE!'
    result = DIALOG_MESSAGE(text,$
      /ERROR,$
      /CENTER,$
      TITLE = title,$
      DIALOG_PARENT = widget_id)
    RETURN
  END
  
  ;load the data file
  plot_data_file_in_sf_calculation_base, Event, FILE_NAME=data_nexus_file
  
  ;load the empty cell file
  plot_empty_cell_file_in_sf_calculation_base, Event, $
    FILE_NAME=empty_cell_nexus_file
    
  ;retrive value of proton charge for data and empty cell ***********************
  data_proton_charge = retrieveProtonCharge(event, $
    FILE_NAME=data_nexus_file,$
    result_data_proton)
  IF (result_data_proton NE 1) THEN BEGIN
    data_proton_charge = ''
  ENDIF
  (*global).data_proton_charge = data_proton_charge
  
  empty_cell_proton_charge = $
    retrieveProtonCharge(event, $
    FILE_NAME=empty_cell_nexus_file,$
    result_empty_cell_proton)
  IF (result_empty_cell_proton NE 1) THEN BEGIN
    empty_cell_proton_charge = ''
  ENDIF
  (*global).empty_cell_proton_charge = empty_cell_proton_charge
  
  ;retrive Sample Moderator distance ********************************************
  distance_sample_moderator = $
    retrieveModeratorSampleDistance(Event,$
    FILE_NAME=data_nexus_file,$
    result_distance_moderator)
  IF (result_distance_moderator NE 1) THEN BEGIN
    distance_sample_moderator = ''
  ENDIF
  (*global).empty_cell_distance_moderator_sample = distance_sample_moderator
  
  ;retrieve distance pixel/sample array *****************************************
  distance_sample_pixel_array = $
    retrieveSamplePixelArray(Event,$
    FILE_NAME=data_nexus_file,$
    result_distance_pixel)
  IF (result_distance_pixel NE 1) THEN BEGIN
    distance_sample_pixel_array = ['']
  ENDIF ELSE BEGIN ;keep only the row #127
    distance_sample_pixel_array = distance_sample_pixel_array[*,127]
  ENDELSE
  (*(*global).distance_sample_pixel_array) = distance_sample_pixel_array
  
  ;copy SF value into sf_calculation base
  SFvalue = getTextFieldValue(Event,'empty_cell_scaling_factor')
  putTextFieldValue, Event, 'scaling_factor_equation_value', $
    STRCOMPRESS(SFvalue,/REMOVE_ALL), 0
    
  ;show recap plot using SF
  replot_recap_with_manual_sf, Event
  
  ;show up calculation base
  MapBase, Event, 'empty_cell_scaling_factor_calculation_base', 1
  
  ;refresh the equation plot (widget_draw)
  RefreshEquationDraw, Event
END
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV



;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

;load the data into the widget_draw uname specified
PRO plot_file_in_sf_calculation_base, Event,$
    FILE_NAME  = file_name,$
    TYPE       = type,$
    draw_uname = draw_uname,$
    DATA       = data
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;IF ((*global).debugging_version EQ 'yes') THEN BEGIN
  ;    data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  ;ENDIF ELSE BEGIN
  CASE (TYPE) OF
    'data': data = (*(*global).DATA_D_TOTAL_ptr)
    'empty_cell': data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
    'recap': data = data
  ENDCASE
  ;ENDELSE
  
  DEVICE, DECOMPOSED = 0
  LOADCT, 13, /SILENT
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  Ntof_size = (size(data))(1)
  ;  WIDGET_CONTROL, id_draw, DRAW_XSIZE=Ntof_size
  
  lin_log_value = getCWBgroupValue(Event, 'empty_cell_sf_z_axis')
  case (type) OF
    'data': BEGIN
      data = (*(*global).DATA_D_TOTAL_ptr)
      IF (lin_log_value EQ 1) THEN BEGIN
        zero_index = WHERE(data EQ 0., nbr)
        IF (nbr GT 0) THEN BEGIN
          data[zero_index] = !VALUES.D_NAN
        ENDIF
        data = ALOG10(data)
        cleanup_array, data
      ENDIF
      (*(*global).in_empty_cell_data_ptr) = data
    END
    'empty_cell': BEGIN
      data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
      IF (lin_log_value EQ 1) THEN BEGIN
        zero_index = WHERE(data EQ 0., nbr)
        IF (nbr GT 0) THEN BEGIN
          data[zero_index] = !VALUES.D_NAN
        ENDIF
        data = ALOG10(data)
        cleanup_array, data
      ENDIF
      (*(*global).in_empty_cell_empty_cell_ptr) = data
    END
    ELSE:
  ENDCASE
  
  IF ((*global).miniVersion) THEN BEGIN
    xsize = (*global).empty_cell_draw_xsize_mini_version
  ENDIF ELSE BEGIN
    xsize = (*global).empty_cell_draw_xsize_big_version
  ENDELSE
  
  file_Ntof = (size(data))(1)
  IF (file_Ntof LT xsize) THEN BEGIN
    coeff_congrid_tof = xsize / FLOAT(file_Ntof)
  ENDIF ELSE BEGIN
    coeff_congrid_tof = 1
  ENDELSE
  
  (*global).congrid_x_coeff_empty_cell_sf = coeff_congrid_tof
  
  ;change the size of the data draw true plotting area
  ;widget_control, id_draw, DRAW_XSIZE=file_Ntof
  ;tvimg = rebin(img, file_Ntof, new_N,/sample)
  new_N = (size(data))(2)
  tvimg = CONGRID(data, file_Ntof * coeff_congrid_tof, new_N)
  
  IF (type EQ 'data') THEN BEGIN
  (*(*global).empty_cell_d_tvimg) = tvimg
  ENDIF ELSE BEGIN
  (*(*global).empty_cell_ec_tvimg) = tvimg
  ENDELSE
  
  TVSCL, tvimg, /DEVICE
  
END

;..............................................................................
;load the data file
PRO plot_data_file_in_sf_calculation_base, Event, FILE_NAME=file_name
  draw_uname = 'empty_cell_scaling_factor_base_data_draw'
  plot_file_in_sf_calculation_base, $
    Event, $
    FILE_NAME = file_name, $
    TYPE      = 'data',$
    DRAW_UNAME = draw_uname
END

;..............................................................................
;load the empty cell file
PRO plot_empty_cell_file_in_sf_calculation_base, Event, FILE_NAME=file_name
  draw_uname = 'empty_cell_scaling_factor_base_empty_cell_draw'
  plot_file_in_sf_calculation_base, $
    Event, $
    FILE_NAME  = file_name, $
    TYPE       = 'empty_cell',$
    DRAW_UNAME = draw_uname
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

PRO display_sf_calculation_base_info, Event, $
    X = x,$
    Y = y,$
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    TOF_ARRAY    = tof_array,$
    DATA         = data
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;Pixel
  putTextFieldValue, Event, PIXEL_UNAME, STRCOMPRESS(Y,/REMOVE_ALL), 0
  
  ;TOF
  x /= (*global).congrid_x_coeff_empty_cell_sf
  x = FIX(x)
  tof_value = TOF_ARRAY[x]
  putTextFieldValue, Event, TOF_UNAME, STRCOMPRESS(tof_value,/REMOVE_ALL), 0
  
  ;Counts
  help, data
  counts_value = DATA[x,y]
  putTextFieldValue, Event, COUNTS_UNAME, $
    STRCOMPRESS(counts_value,/REMOVE_ALL), 0
    
END

;..............................................................................
PRO display_sf_calculation_base_data_info, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x = Event.X
  y = Event.Y
  
  pixel_uname  = 'empty_cell_data_draw_y_value'
  tof_uname    = 'empty_cell_data_draw_x_value'
  counts_uname = 'empty_cell_data_draw_counts_value'
  
  data     = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  data_tof = (*(*global).sf_empty_cell_tof)
  
  display_sf_calculation_base_info, Event,$
    X            = x,$
    Y            = y,$
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    TOF_ARRAY    = data_tof,$
    DATA         = data
    
END

;..............................................................................
PRO display_sf_calculation_base_empty_cell_info, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x = Event.X
  y = Event.Y
  
  pixel_uname  = 'empty_cell_empty_cell_draw_y_value'
  tof_uname    = 'empty_cell_empty_cell_draw_x_value'
  counts_uname = 'empty_cell_empty_cell_draw_counts_value'
  
  data_tof     = (*(*global).sf_empty_cell_tof)
  data         = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  
  display_sf_calculation_base_info, Event,$
    X            = x,$
    Y            = y,$
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    TOF_ARRAY    = data_tof,$
    DATA         = data
    
END

;..............................................................................
PRO display_sf_calculation_base_recap_info, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x = Event.X
  y = Event.Y
  
  pixel_uname  = 'empty_cell_recap_draw_y_value'
  tof_uname    = 'empty_cell_recap_draw_x_value'
  counts_uname = 'empty_cell_recap_draw_counts_value'
  
  data_tof     = (*(*global).sf_empty_cell_tof)
  data         = (*(*global).SF_RECAP_D_TOTAL_ptr)
  
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    reset_sf_calculation_base_recap_info, Event
  ENDIF ELSE BEGIN
    display_sf_calculation_base_info, Event,$
      X            = x,$
      Y            = y,$
      PIXEL_UNAME  = pixel_uname,$
      TOF_UNAME    = tof_uname,$
      COUNTS_UNAME = counts_uname,$
      TOF_ARRAY    = data_tof,$
      DATA         = data
  ENDELSE
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

PRO reset_sf_calculation_base_info, Event,$
    PIXEL_UNAME = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    VALUE        = value
    
  ;Pixel
  putTextFieldValue, Event, PIXEL_UNAME, VALUE, 0
  
  ;TOF
  putTextFieldValue, Event, TOF_UNAME, VALUE, 0
  
  ;Counts
  putTextFieldValue, Event, COUNTS_UNAME, VALUE, 0
  
END

;..............................................................................
PRO reset_sf_calculation_base_data_info, Event

  value = 'N/A'
  
  pixel_uname  = 'empty_cell_data_draw_y_value'
  tof_uname    = 'empty_cell_data_draw_x_value'
  counts_uname = 'empty_cell_data_draw_counts_value'
  
  reset_sf_calculation_base_info, Event, $
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    VALUE        = value
    
END

;..............................................................................
PRO reset_sf_calculation_base_empty_cell_info, Event

  value = 'N/A'
  
  pixel_uname  = 'empty_cell_empty_cell_draw_y_value'
  tof_uname    = 'empty_cell_empty_cell_draw_x_value'
  counts_uname = 'empty_cell_empty_cell_draw_counts_value'
  
  reset_sf_calculation_base_info, Event, $
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    VALUE        = value
    
END

;..............................................................................
PRO reset_sf_calculation_base_recap_info, Event

  value = 'N/A'
  
  pixel_uname  = 'empty_cell_recap_draw_y_value'
  tof_uname    = 'empty_cell_recap_draw_x_value'
  counts_uname = 'empty_cell_recap_draw_counts_value'
  
  reset_sf_calculation_base_info, Event, $
    PIXEL_UNAME  = pixel_uname,$
    TOF_UNAME    = tof_uname,$
    COUNTS_UNAME = counts_uname,$
    VALUE        = value
    
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

PRO refresh_sf_data_plot_plot, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;data = (*(*global).DATA_D_TOTAL_ptr)
  
  DEVICE, DECOMPOSED = 0
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='empty_cell_scaling_factor_base_data_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  tvimg = (*(*global).empty_cell_d_tvimg)
  
  ;  lin_log_value = getCWBgroupValue(Event, 'empty_cell_sf_z_axis')
  ;  IF (lin_log_value EQ 1) THEN BEGIN
  ;    zero_index = WHERE(data EQ 0., nbr)
  ;    IF (nbr GT 0) THEN BEGIN
  ;      data[zero_index] = !VALUES.D_NAN
  ;    ENDIF
  ;    data = ALOG10(data)
  ;    cleanup_array, data
  ;  ENDIF
  
  TVSCL, tvimg, /DEVICE
  
END

;..............................................................................
PRO display_sf_data_selection, Event, X1 = x1, Y1 = y1
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x0 = (*global).sf_x0
  y0 = (*global).sf_y0
  x1 = X1
  y1 = Y1
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  
  refresh_sf_data_plot_plot, Event
  
  color = 150
  
  PLOTS, [x0, x0, x1, x1, x0],$
    [y0,y1, y1, y0, y0],$
    /DEVICE,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO calculate_sf, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL, /HOURGLASS
  
  ;local_debugger_flag
  local_debugger_flag = 0   ;0 for no, 1 for yes
  
  ;retrieve all parameters required to calculate SF
  x0 = (*global).sf_x0
  y0 = (*global).sf_y0
  x1 = (*global).sf_x1
  y1 = (*global).sf_y1
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  
  data_proton_charge          = (*global).data_proton_charge
  empty_cell_proton_charge    = (*global).empty_cell_proton_charge
  distance_sample_moderator   = (*global).empty_cell_distance_moderator_sample
  distance_sample_pixel_array = (*(*global).distance_sample_pixel_array)
  
  data_data       = (*(*global).DATA_D_TOTAL_ptr)
  empty_cell_data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  data_tof_axis   = (*(*global).sf_empty_cell_tof)
  
  A = getTextFieldValue(Event, 'empty_cell_substrate_a')
  B = getTextFieldValue(Event, 'empty_cell_substrate_b')
  D = getTextFieldValue(Event, 'empty_cell_diameter')
  
  Mn = 1.674928E-27 ;neutron mass (kg)
  h  = 6.62606876E-34 ;Plank's constant (J.s)
  
  IF ((*global).debugging_version EQ 'yes' AND $
    local_debugger_flag EQ 1) THEN BEGIN
    print, '***** Recap of parameters *****'
    print
    print, 'data_proton_charge:          ' + strcompress(data_proton_charge)
    print, 'empty_cell_proton_charge:    ' + $
      strcompress(empty_cell_proton_charge)
    print, 'distance_sample_moderator:   ' + $
      strcompress(distance_sample_moderator)
    help, distance_sample_pixel_array
    print
    help, data_data
    help, empty_cell_data
    help, data_tof_axis
    print
    print, 'A:  ' + strcompress(A)
    print, 'B:  ' + strcompress(B)
    print, 'D:  ' + strcompress(D)
    print
    print, 'Mn: ' + strcompress(Mn)
    print, 'h:  ' + strcompress(h)
  ENDIF
  
  ;start the calculation of SF
  
  ;#1 calculate the numerator (sigma over x and y of data)

  xmin = FLOAT(xmin) / (*global).congrid_x_coeff_empty_cell_sf
  xmax = FLOAT(xmax) / (*global).congrid_x_coeff_empty_cell_sf
  
  xmin = FIX(xmin)
  xmax = FIX(xmax)

  Num1 = data_data[xmin:xmax,ymin:ymax]
  Num = TOTAL(Num1)
  
  IF ((*global).debugging_version EQ 'yes' AND $
    local_debugger_flag EQ 1) THEN BEGIN
    print
    print, '-- Start calculation of SF --'
    print
    print, '#1'
    help, Num1
    print, 'Num = TOTAL(Num1) = ' + strcompress(Num)
  ENDIF
  
  ;#2 divide by proton_charge of data and multiply by proton charge of
  ;empty cell
  Pdata   = STRCOMPRESS(data_proton_charge,/REMOVE_ALL)
  f_Pdata = FLOAT(Pdata)
  
  Pempty_cell   = STRCOMPRESS(empty_cell_proton_charge,/REMOVE_ALL)
  f_Pempty_cell = FLOAT(Pempty_cell)
  
  fNum1 = FLOAT(Num)
  fNum2 = fNum1 * f_Pempty_cell
  fNum  = fNum2 / f_Pdata
  
  IF ((*global).debugging_version EQ 'yes' AND $
    local_debugger_flag EQ 1) THEN BEGIN
    print
    print, '#2 '
    print, 'Pdata:       ' + Pdata
    print, 'Pempty_cell: ' + Pempty_cell
    print, 'fNum1:       ' + strcompress(fNum1)
    print, 'fNum2:       ' + strcompress(fNum2)
    print, 'fNum:        ' + strcompress(fNum)
  ENDIF
  
  ;#3 calculate the denominator
  ;calculate the constant used
  
  fAm = FLOAT(A) * 100
  fBm = FLOAT(B) * 10000
  fDm = FLOAT(D) * 0.01
  
  ;A*(Substrate Diameter)
  A1 = fAm * fDm
  
  ;B*(Substrate diameter) * h/(masse neutron)
  B1 = fBm * fDm * FLOAT(h)
  B1 /= FLOAT(Mn)
  
  ;Counts_empty_cell(t,p)
  Counts = empty_cell_data[xmin:xmax,ymin:ymax]
  
  ;number of tof and pixel selected
  Ntof = (SIZE(Counts))(1)
  Npix = (SIZE(Counts))(2)
  
  IF ((*global).debugging_version EQ 'yes' AND $
    local_debugger_flag EQ 1) THEN BEGIN
    print
    print, '#3 '
    print, 'fAm: ' + strcompress(fAm)
    print, 'fBm: ' + strcompress(fBm)
    print, 'fDm: ' + strcompress(fDm)
    print, 'A*(substrate diameter):                     ' + strcompress(A1)
    print, 'B*(substrate diameter) * h/(masse neutron): ' + strcompress(B1)
    help, Counts
  ENDIF
  
  fDenom = 0 ;initial denominator sum
  IF ((*global).debugging_version EQ 'yes' AND $
    local_debugger_flag EQ 1) THEN BEGIN
    print
    print, 'Entering the FOR loop with'
    print, ' t= 0 -> ' + strcompress(Ntof-1)
    print, ' p= 0 -> ' + strcompress(Npix-1)
  ENDIF
  FOR t=0,(Ntof-1) DO BEGIN
    FOR p=0,(Npix-1) DO BEGIN
      ;part 1
      ;Counts at this pixel and tof
      Counts = empty_cell_data[xmin+t,ymin+p]
      
      ;part 2
      ;TOF value
      TOF    = FLOAT(data_tof_axis[xmin+t])
      TOF    *= 1.e-6 ;in s
      
      ;distance sample - detector
      Lsd    = distance_sample_pixel_array[ymin+p]
      
      ;distance total
      Ltotal = FLOAT(Lsd) + ABS(FLOAT(distance_sample_moderator))
      
      ;TOF/Ltotal
      B2     = TOF / Ltotal
      ;exp[-(A1+B1*B2)]
      exp1   = A1 + B1 * B2
      
      exp    = EXP(-exp1)
      
      ;*Counts
      fDenom_local = exp * Counts
      
      ;update total
      fDenom += fDenom_local
      
      IF ((*global).debugging_version EQ 'yes' AND $
        local_debugger_flag EQ 1) THEN BEGIN
        print
        print, 't=' + strcompress(t) + ' ; p=' + strcompress(p)
        print, 'Counts: ' + strcompress(Counts)
        print, 'TOF:    ' + strcompress(TOF)
        print, 'Lsd:    ' + strcompress(Lsd)
        print, 'Ltotal: ' + strcompress(Ltotal)
        print, 'B2:     ' + strcompress(B2)
        print, 'exp1 = A1 + B1 * B2 = ' + strcompress(exp1)
        print, 'exp =                 ' + strcompress(exp)
        print, 'fDenom_local = exp * Counts = ' + strcompress(fDenom_local)
        print, 'fDenom = ' + strcompress(fDenom)
      ENDIF
    ENDFOR
  ENDFOR
  
  SF = fNum / fDenom
  sSF = STRCOMPRESS(SF,/REMOVE_ALL)
  putTextFieldValue, Event, 'scaling_factor_equation_value', sSF, 0
  
  ;check that the SF found is a real number and not undefined
  
  IF (FINITE(SF)) THEN BEGIN ;launch the refresh
  
    plot_recap_empty_cell_sf, Event,$
      data_proton_charge       = f_Pdata,$
      empty_cell_proton_charge = f_Pempty_cell,$
      distance_sample_moderator = distance_sample_moderator,$
      distance_sample_pixel_array = distance_sample_pixel_array,$
      data_data = data_data,$
      empty_cell_data = empty_cell_data,$
      data_tof_axis = data_tof_axis,$
      fAm = fAm,$
      fBm = fBm,$
      fDm = fDm,$
      Mn = Mn,$
      h = h,$
      SF = SF
      
    (*global).bRecapPlot =  1b ;we can create the output file
    
  ENDIF ELSE BEGIN ;SF is NaN, stop here
  
    (*global).bRecapPlot =  0b ;we can not create the output file
    
  ENDELSE
  
  check_empty_cell_recap_output_file_name, Event
  
  WIDGET_CONTROL, HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO plot_recap_empty_cell_sf, Event,$
    data_proton_charge = $
    data_proton_charge,$
    empty_cell_proton_charge = $
    empty_cell_proton_charge,$
    distance_sample_moderator = $
    distance_sample_moderator,$
    distance_sample_pixel_array = $
    distance_sample_pixel_array,$
    data_data = data_data,$
    empty_cell_data = empty_cell_data,$
    data_tof_axis = data_tof_axis,$
    fAm = fAm,$
    fBm = fBm,$
    fDm = fDm,$
    Mn = Mn,$
    h = h,$
    SF = SF
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  debugging_on_mac = (*global).debugging_on_mac
  
  ;determine the size (number of TOF and of pixels)
  Ntof = (SIZE(data_data))(1)
  Npix = (SIZE(data_data))(2)
  
  ;initialize recap_data
  recap_data = FLTARR(Ntof,Npix)
  
  ;h/Mn
  h_over_Mn = h / Mn
  A_times_diameter = fAm * fDm
  B_times_diameter = fBm * fDm
  
  ;print, 'data proton charge: ' + strcompress(data_proton_charge)
  ;print, 'empty_cell_proton_charge: ' + strcompress(empty_cell_proton_charge)
  ;print, 'h_over_Mn: ' + strcompress(h_over_Mn)
  ;print, 'A_times_diameter: ' + strcompress(A_times_diameter)
  ;print, 'B_times_diameter: ' + strcompress(B_times_diameter)
  ;print, '_____________________________________'
  
  FOR t=0,(Ntof-1) DO BEGIN
  
    FOR p=0,(Npix-1) DO BEGIN
    
      ;      IF (t EQ 82 AND p EQ 137) THEN print, 't=82 and p=137'
    
      ;1st part (data)
      part1 = data_data[t,p]
      IF (t EQ 82 AND $
        p EQ 137 AND $
        debugging_on_mac EQ 'yes') THEN print, 'part1: ' + strcompress(part1)
        
      ;2nd part (empty_cell)
      TOF = FLOAT(data_tof_axis[t]) * 1.E-6 ;to be in s
      IF (t EQ 82 AND $
        p EQ 137 AND $
        debugging_on_mac EQ 'yes') THEN print, 'TOF: ' + strcompress(TOF)
        
      Lsd = FLOAT(distance_sample_pixel_array[p]) ;distance sample detector
      IF (t EQ 82 AND $
        p EQ 137 AND $
        debugging_on_mac EQ 'yes') THEN print, 'Lsd: ' + strcompress(lsd)
        
      Lsm = ABS(FLOAT(distance_sample_moderator)) ;distance sample moderator
      IF (t EQ 82 AND $
        p EQ 137 AND $
        debugging_on_mac EQ 'yes') THEN print, 'lsm: ' + strcompress(lsm)
        
      Ldm = Lsd + Lsm
      
      lambda = (h_over_Mn * TOF) / Ldm
      ;      IF (t EQ 82 AND p EQ 137) THEN print, 'lambda: ' + strcompress(lambda)
      
      exp1 = A_times_diameter + lambda * B_times_diameter
      ;     IF (t EQ 82 AND p EQ 137) THEN print, 'exp1: ' + strcompress(exp1)
      
      exp  = EXP(-exp1)
      ;    IF (t EQ 82 AND p EQ 137) THEN print, 'exp: ' + strcompress(exp)
      
      part2  = exp / empty_cell_proton_charge
      part2 *= data_proton_charge
      part2 *= empty_cell_data[t,p]
      ;   IF (t EQ 82 AND p EQ 137) THEN BEGIN
      ;     print, 'part2: ' + strcompress(part2)
      ;     print, '******'
      ;     print, 'SF: ' + strcompress(sf)
      ;     print, 'empty_cell_data[t,p]: ' + strcompress(empty_cell_data[t,p])
      ;   ENDIF
      
      ;difference
      recap_data[t,p] = part1 - SF * part2
    ;   IF (t EQ 82 AND p EQ 137) THEN print, 'recap_data[t,p]=' + $
    ;     strcompress(part1 - SF * part2)
      
    ENDFOR
    
  ENDFOR
  
  (*(*global).SF_RECAP_D_TOTAL_ptr) = recap_data
  (*global).bRecapPlot =  1b ;we can create the output file
  
  draw_uname = 'empty_cell_scaling_factor_base_recap_draw'
  plot_file_in_sf_calculation_base, $
    Event, $
    FILE_NAME  = file_name, $
    TYPE       = 'recap',$
    DRAW_UNAME = draw_uname,$
    DATA       = recap_data
    
END

;------------------------------------------------------------------------------
PRO replot_recap_with_manual_sf, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL, /HOURGLASS
  
  ;get SF value
  SF = getTextFieldValue(Event,'scaling_factor_equation_value')
  SF = FLOAT(SF)
  
  ;retrieve other parameters used
  data_proton_charge = (*global).data_proton_charge
  Pdata              = STRCOMPRESS(data_proton_charge,/REMOVE_ALL)
  f_Pdata            = FLOAT(Pdata)
  
  empty_cell_proton_charge = (*global).empty_cell_proton_charge
  Pempty_cell              = STRCOMPRESS(empty_cell_proton_charge,/REMOVE_ALL)
  f_Pempty_cell            = FLOAT(Pempty_cell)
  
  distance_sample_moderator   = (*global).empty_cell_distance_moderator_sample
  distance_sample_pixel_array = (*(*global).distance_sample_pixel_array)
  
  data_data       = (*(*global).DATA_D_TOTAL_ptr)
  empty_cell_data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  data_tof_axis   = (*(*global).sf_empty_cell_tof)
  
  A   = getTextFieldValue(Event, 'empty_cell_substrate_a')
  B   = getTextFieldValue(Event, 'empty_cell_substrate_b')
  D   = getTextFieldValue(Event, 'empty_cell_diameter')
  fAm = FLOAT(A) * 100
  fBm = FLOAT(B) * 10000
  fDm = FLOAT(D) * 0.01
  
  Mn = 1.674928E-27 ;neutron mass (kg)
  h  = 6.62606876E-34 ;Plank's constant (J.s)
  
  plot_recap_empty_cell_sf, Event,$
    data_proton_charge = $
    f_Pdata,$
    empty_cell_proton_charge = $
    f_Pempty_cell,$
    distance_sample_moderator = $
    distance_sample_moderator,$
    distance_sample_pixel_array = $
    distance_sample_pixel_array,$
    data_data = data_data,$
    empty_cell_data = empty_cell_data,$
    data_tof_axis = data_tof_axis,$
    fAm = fAm,$
    fBm = fBm,$
    fDm = fDm,$
    Mn = Mn,$
    h = h,$
    SF = SF
    
  WIDGET_CONTROL, HOURGLASS=0
END
