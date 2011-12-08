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

;##############################################################################
;******************************************************************************

;This function gives the size of the array given
;as a parameter
FUNCTION getSizeOfArray, ListOfFiles
  sizeArray = size(ListOfFiles)
  RETURN, sizeArray[1]
END

;##############################################################################
;******************************************************************************

;This function returns the selected index of the droplist uname given
FUNCTION getSelectedIndex, Event, uname
  id= widget_info(Event.top, find_by_uname=uname)
  TextBoxIndex= widget_info(id,/droplist_select)
  RETURN, TextBoxIndex
END

;##############################################################################
;******************************************************************************

;This function returns the number of element found in the droplist
;uname given
FUNCTION getNbrElementsInDroplist, Event, uname
  id  = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  nbr_elements = WIDGET_INFO(id, /DROPLIST_NUMBER)
  WIDGET_CONTROL, id, get_value=value
  IF (nbr_elements EQ 1) THEN BEGIN
    IF (STRCOMPRESS(value,/REMOVE_ALL) EQ '') THEN RETURN, 0
  ENDIF
  RETURN, nbr_elements
END

;##############################################################################
;******************************************************************************

FUNCTION getFileFromIndex, Event, index
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='list_of_files_droplist')
  WIDGET_CONTROL, id, GET_VALUE=ListOfFiles
  RETURN, ListOfFiles[index]
END

;##############################################################################
;******************************************************************************

FUNCTION getNbrOfFiles, Event
  RETURN, getNbrElementsInDroplist(Event,'list_of_files_droplist')
END

;##############################################################################
;******************************************************************************

;+
; :Description:
;   returns 0 if the first button is validated, 1 if the second button
;   is validated....etc
;
; :Params:
;    Event
;    uname
;
;  @returns, index of button validated
;
; :Author: j35
;-
FUNCTION getButtonValidated, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=value
  RETURN, value
END

;##############################################################################
;******************************************************************************


;This function will retrieve the values of Xmin/max and Ymin/max
FUNCTION retrieveXYMinMax, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  ;min-xaxis
  XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
  widget_control, XminId, get_value=Xmin
  
  ;max-xaxis
  XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
  widget_control, XmaxId, get_value=Xmax
  
  ;min-yaxis
  YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
  widget_control, YminId, get_value=Ymin
  
  ;max-yaxis
  YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
  widget_control, YmaxId, get_value=Ymax
  
  return_array = [Xmin,Xmax,Ymin,Ymax]
  RETURN, return_array
END

;##############################################################################
;******************************************************************************

;This function returns the true min and max value of the first array
;argument. True min and max means that the flt1 value of the
;corresponding min and max is defined, not NAN or not negative
FUNCTION getQminQmaxValue, flt0, flt1

  flt1_size_array = size(flt1)
  flt1_size = flt1_size_array[1]
  flt1_GE0_index = where(flt1 GT 0)
  
  flt0_tmp = fltarr(flt1_size)
  flt0_tmp = flt0(flt1_GE0_index)
  
  Qmin = min(flt0_tmp,max=Qmax,/nan)
  QminQmax = [Qmin,Qmax]
  
  return, QminQmax
END

;##############################################################################
;******************************************************************************

;This functions gives the index of the color selected
FUNCTION getColorIndex, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  id = widget_info(event.top,find_by_uname='list_of_color_slider')
  widget_control, id, get_value = ColorIndex
  RETURN, colorIndex
END

;##############################################################################
;******************************************************************************

;this function gives the long name of the file selected in the uname droplist
FUNCTION getLongFileNameSelected, Event, uname
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;get the selected index of the load list droplist
  TextBoxIndex = getSelectedIndex(Event, uname) ;_get
  ListOfLongFileName = (*(*global).ListOfLongFileName)
  LongFileName = ListOfLongFileName[TextBoxIndex]
  RETURN, LongFileName
END

;##############################################################################
;******************************************************************************

;This function outputs the value of the angle of the current selected
;file (degrees)
FUNCTION getAngleValue, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  angle_array = (*(*global).angle_array)
  fileIndex   = getSelectedIndex(Event,'list_of_files_droplist')
  angleValue  = angle_array[fileIndex]
  RETURN, angleValue
END

;##############################################################################
;******************************************************************************

;This function returns an index array of all the not inf data
FUNCTION getArrayRangeOfNotNanValues, flt1_new
  index = WHERE(FINITE(flt1_new))
  RETURN, index
END

;##############################################################################
;******************************************************************************

;This function gives a list of point to keep, for which the Y value is
;greater than the error bar
FUNCTION GEValue, flt1, flt2, nbr
  new_flt2 = flt2 ^ 2
  new_flt1 = flt1 ^ 2
  index = WHERE(flt2 LT flt1,nbr)
  RETURN, index
END

;##############################################################################
;******************************************************************************

;This function takes array as an argument and will
;return the first index  >= Q1 and the last one <=Q2
;To determine in which order the search should be done (increasing
;or decreasing order) the first and last argument will be checked first
FUNCTION getArrayRangeFromQ1Q2, flt0, Q1, Q2

  FirstValue = flt0[0]
  flt0_size  = (size(flt0))[1]
  LastValue  = flt0[flt0_size-1]
  
  left_index  = 0
  right_index = (flt0_size-1)
  
  found_left_index = 0
  IF (FirstValue LT LastValue) THEN BEGIN ;increasing order
    FOR i=0,(flt0_size-1) DO BEGIN
      IF (found_left_index EQ 0) THEN BEGIN
        IF (flt0[i] GE Q1) THEN BEGIN
          left_index       = i
          found_left_index = 1
        ENDIF
      ENDIF ELSE BEGIN
        IF (flt0[i] GT Q2) THEN BEGIN
          right_index = i-1
          BREAK
        ENDIF
      ENDELSE
    ENDFOR
  ENDIF ELSE BEGIN                ;decreasing order
    FOR i=0,(flt0_size-1) DO BEGIN
      IF (found_left_index EQ 0) THEN BEGIN
        IF (flt0[i] LE Q2) THEN BEGIN
          left_index       = i
          found_left_index = 1
        ENDIF
      ENDIF ELSE BEGIN
        IF (flt0[i] LT Q1) THEN BEGIN
          right_index = i-1
          BREAK
        ENDIF
      ENDELSE
    ENDFOR
  ENDELSE
  
  returnArray = [left_index, right_index]
  RETURN, returnArray
END

;##############################################################################
;******************************************************************************

;This function removes the infinite values of the array
FUNCTION getArrayOfInfValues, flt1_new
  index = where(~finite(flt1_new),Nindx)
  IF (Nindx) GT 0 THEN BEGIN
    flt1_new[index] = 0            ;need to get rid of infs
  ENDIF
  RETURN, flt1_new
END

;##############################################################################
;******************************************************************************

;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
  TextFieldID = widget_info(Event.top,find_by_uname=uname)
  widget_control, TextFieldID, get_value = string
  RETURN, string
END

;##############################################################################
;******************************************************************************

;This function returns 1 if the specified axis scale is linear
;and 0 if it's logarithmic
FUNCTION getScale, Event, axis
  IF (axis EQ 'X') THEN BEGIN
    value = 0
  ENDIF ELSE BEGIN
    axis_id = widget_info(Event.top,find_by_uname='YaxisLinLog')
    widget_control, axis_id, get_value=value
  ENDELSE
  RETURN, value
END

;##############################################################################
;******************************************************************************

;This function will retrieve the values of Xmin/max and Ymin/max
FUNCTION getXYMinMax, Event

  ;min-xaxis
  XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
  widget_control, XminId, get_value=Xmin
  
  ;max-xaxis
  XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
  widget_control, XmaxId, get_value=Xmax
  
  ;min-yaxis
  YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
  widget_control, YminId, get_value=Ymin
  
  ;max-yaxis
  YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
  widget_control, YmaxId, get_value=Ymax
  
  return_array = [Xmin,Xmax,Ymin,Ymax]
  RETURN, return_array
END

;##############################################################################
;******************************************************************************

;This function returns the current angle value from the text box
FUNCTION getCurrentAngleValue, Event
  angleTextBoxId = widget_info(Event.top,find_by_uname='AngleTextField')
  widget_control, angleTextBoxId, get_value=angleValue
  return, angleValue
END

;##############################################################################
;******************************************************************************

;This function returns Q1, Q2 and SF of the current selected tab
FUNCTION getQ1Q2SF, Event, TAB

  IF (TAB EQ 'STEP2') then begin
    Q1 = getValue(event=event, uname='step2_q1_text_field')
    Q2 = getValue(event=event, uname='step2_q2_text_field')
    SF = getValue(even=event, uname='step2_sf_text_field')
  ENDIF ELSE BEGIN
    Q1 = getValue(event=event, uname='step3_q1_text_field')
    Q2 = getValue(event=event, uname='step3_q2_text_field')
    SF = getValue(event=event, uname='step3_sf_text_field')
  ENDELSE
  Q1Q2SF = [float(Q1),float(Q2),float(SF)]
  RETURN, Q1Q2SF
END

;##############################################################################
;******************************************************************************

;this function changes the format of the input variable
;into a 3 digit precision float
Function getndigits, Event, angleValue

  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  angleDisplayPrecision = (*global).angleDisplayPrecision
  
  step1Variable = float(angleValue)*angleDisplayPrecision
  ;print, step1Variable
  step2Variable = floor(step1Variable)
  ;print, step2Variable
  step3Variable = float(step2Variable) / angleDisplayPrecision
  ;print, step3Variable
  RETURN, step3Variable
END

;##############################################################################
;******************************************************************************
FUNCTION getTabSelected, Event
  steps_tab_id  = WIDGET_INFO(Event.top, FIND_BY_UNAME='steps_tab')
  CurrTabSelect = WIDGET_INFO(steps_tab_id,/TAB_CURRENT)
  RETURN, CurrTabSelect
END

;##############################################################################
;******************************************************************************
FUNCTION getDrawXMin, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  delta_x_draw = (*global).delta_x_draw
  ;retrieve xmin and xmax
  XYMinMax  = FLOAT(getXYMinMax(Event))
  xMinAsked = XYMinMax[0]
  xMaxAsked = XYMinMax[1]
  ;calculate real xmin and real xmax
  ;x1    = xMinAsked / delta_x_draw
  ;x_min = FLOOR(x1) * delta_x_draw
  ;x2    = xMaxAsked / delta_x_draw
  ;x_max = FLOOR(x2) * delta_x_draw
  ;RETURN, [x_min,x_max]
  RETURN, [xMinAsked, xMaxAsked]
END

;##############################################################################
;******************************************************************************
FUNCTION getBatchFileName, Event
  BatchFileName = getTextFieldValue(Event,'load_batch_file_text_field')
  RETURN, BatchFileName[0]
END

;##############################################################################
;******************************************************************************
FUNCTION getIndexArrayOfActiveBatchRow, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  BatchTable = (*(*global).BatchTable)
  NbrRow = (size(BatchTable))(2)
  NbrIndex = 0
  IndexArray = [0]
  FOR i=0,(NbrRow-1) DO BEGIN
    IF (STRCOMPRESS(BatchTable[0,i],/REMOVE_ALL) EQ 'YES') THEN BEGIN
      IF (NbrIndex EQ 0) THEN BEGIN
        IndexArray = [i]
      ENDIF ELSE BEGIN
        IndexArray = [IndexArray,i]
      ENDELSE
      NbrIndex++
    ENDIF
  ENDFOR
  RETURN, IndexArray
END

;##############################################################################
;******************************************************************************
FUNCTION getDataNexusFileNamePreviewed, Event
  FullPreviewText = getTextFieldValue(Event, 'file_info')
  sz = (size(FullPreviewText))(1)
  FOR i=0,(sz-1) DO BEGIN
    IF (STRMATCH(FullPreviewText[i],'#F data: *')) THEN BEGIN
      str_array = STRSPLIT(FullPreviewText[i],'#F data: ', $
        /EXTRACT, $
        /REGEX)
      RETURN, STRCOMPRESS(str_array[0],/REMOVE_ALL)
    ENDIF
  ENDFOR
  RETURN, ''
END

;##############################################################################
;******************************************************************************
PRO SaveAngleValueFromNexus, Event, index
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  DataNexusFileName = getDataNexusFileNamePreviewed(Event)
  iNexus      = OBJ_NEW("idl_get_metadata",DataNexusFileName)
  IF (OBJ_VALID(iNexus)) THEN BEGIN
    angle_value = iNexus->getAngle()
  ENDIF ELSE BEGIN
    angle_value = 0.0
  ENDELSE
  angle_array = (*(*global).angle_array)
  angle_array[index] = angle_value
  (*(*global).angle_array) = angle_array
END

;##############################################################################
;******************************************************************************
FUNCTION getOutputFileName, Event
  widget_control, event.top, get_uvalue=global
  outputFileName = getTextFieldValue(Event,'scaled_data_file_name_value_0')
  path = (*global).BatchDefaultPath
  RETURN, path+outputFileName
END

;+
; :Description:
;    This function returns the full name of the combined scaled data file
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function  getCombinedOutputFileName, event
  widget_control, event.top, get_uvalue=global
  outputFileName = getTextFieldValue(Event,$
    'combined_scaled_data_file_name_value_0')
  path = (*global).BatchDefaultPath
  RETURN, path+outputFileName
END
