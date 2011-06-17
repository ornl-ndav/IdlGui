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

PRO DisplayHeadTailFile, Event, FileName, uname
;get the first 20 elements
cmd = 'head ' + FileName + ' -n 20'
SPAWN, cmd, First20Lines
FinalArray = [First20Lines,'...']
;get the last 20 elements
cmd = 'tail ' + FileName + ' -n 20'
SPAWN, cmd, Last20Lines
FinalArray = [FinalArray, Last20Lines]
;display result in HELP text field
sz=(size(FinalArray))(1)
putTextFieldArray,$
  Event,$
  uname,$
  FinalArray,$
  sz,$
  0
END

;------------------------------------------------------------------------------
PRO DisplayHeadTailBackgroundDataFile, Event, BackROIFullFileName
uname = 'DATA_left_interaction_help_text'
DisplayHeadTailFile, Event, BackROIFullFileName, uname
END

;------------------------------------------------------------------------------
PRO DisplayHeadTailBackgroundNormFile, Event, BackROIFullFileName
uname = 'NORM_left_interaction_help_text'
DisplayHeadTailFile, Event, BackROIFullFileName, uname
END

;------------------------------------------------------------------------------
FUNCTION ParseBackgroundFileString, Event, StringText
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global
result_array = strsplit(StringText,'_',/extract)
IF ((*global).instrument EQ 'REF_L') THEN BEGIN
    Y = result_array[2]
ENDIF ELSE BEGIN
    Y = result_array[1]
ENDELSE
RETURN, Y
END

;------------------------------------------------------------------------------
FUNCTION retrieveYMinMaxFromFile, Event, FileName
;to get the first line of the file
cmd = 'head ' + FileName + ' -n 1'
SPAWN, cmd, first_line
;to get the last line of the file
cmd = 'tail ' + FileName + ' -n 1'
SPAWN, cmd, last_line
Ymin = ParseBackgroundFileString(Event, first_line)
Ymax = ParseBackgroundFileString(Event, last_line)
RETURN, [Ymin,Ymax]
END

;******************************************************************************
;******************************************************************************
PRO REFreduction_LoadDataROISelection, Event
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;define Parameters
instrument   = (*global).instrument
load_roi_ext = (*global).load_roi_ext
filter       = instrument + '_*' + load_roi_ext
PROCESSING   = (*global).processing_message
;get default path 
WorkingPath  = (*global).working_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
title        = instrument + ' Data ROI Selection File' ;title of pickfile

;open file
ROIFullFileName = DIALOG_PICKFILE(PATH              = WorkingPath,$
                                  GET_PATH          = path,$
                                  dialog_parent     = widget_id,$
                                  TITLE             = title,$
                                  FILTER            = filter,$
                                  DEFAULT_EXTENSION = '.dat',$
                                  /FIX_FILTER)

IF (ROIFullFileName NE '') THEN BEGIN
;put info in logbook
    text  = '-> Loading Data ROI Selection File '
    text += ROIFullFileName

    text += ' ... ' + PROCESSING
    putLogBookMessage, Event, Text, Append=1

;display name of new file name in text field
    putTextFieldValue,$
      Event,$
      'data_roi_selection_file_text_field',$
      ROIFullFileName,$
      0                         ;do not append

;update REDUCE gui with name of data background roi file
    putTextFieldValue,$
      Event,$
      'reduce_data_region_of_interest_file_name',$
      ROIFullFileName,$
      0                         ;do not append

;display preview message in help data box
    ;Message = 'Preview of ' + ROIFullFileName
    Message = 'Preview of ROI file saved'
    putLabelValue, Event, 'left_data_interaction_help_message_help', Message
    
    YMinYMaxArray = retrieveYMinMaxFromFile(Event, ROIFullFileName)
;put Ymin and Ymax in their text fields
    putTextFieldValue, $
      Event,$
      'data_d_selection_roi_ymin_cw_field',$
      strcompress(YMinYMaxArray[0],/remove_all),$
      0 
    putTextFieldValue, $
      Event,$
      'data_d_selection_roi_ymax_cw_field',$
      strcompress(YMinYMaxArray[1],/remove_all),$
      0 

;replot
    REFreduction_DataBackgroundPeakSelection, Event    

;display 20 first data and last 20 in HELP text data box
    DisplayHeadTailFile, $
      Event, $
      ROIFullFileName, $
      'DATA_left_interaction_help_text'

;put info in logbook
    LogBookText = getLogBookText(Event)
    Message = 'OK  '
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;copy file name into reduce tab
        putTextFieldValue, Event, $
          'reduce_data_region_of_interest_file_name', ROIFullFileName, 0

ENDIF
END

;******************************************************************************
;******************************************************************************
PRO REFreduction_LoadDataBackSelection, Event
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global
;define Parameters
instrument    = (*global).instrument
load_back_ext = (*global).load_back_ext
filter        = instrument + '_*' + load_back_ext
PROCESSING    = (*global).processing_message
;get default path 
WorkingPath   = (*global).working_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
;title of pickfile
title         = instrument + ' Data Background Selection File' 

;open file
BackFullFileName = DIALOG_PICKFILE(PATH              = WorkingPath,$
                                  GET_PATH          = path,$
                                  dialog_parent     = widget_id,$
                                  TITLE             = title,$
                                  FILTER            = filter,$
                                  DEFAULT_EXTENSION = '.dat',$
                                  /FIX_FILTER)

IF (BackFullFileName NE '') THEN BEGIN
;put info in logbook
    text  = '-> Loading Data Background Selection File '
    text += BackFullFileName

    text += ' ... ' + PROCESSING
    putLogBookMessage, Event, Text, Append=1

;display name of new file name in text field
    putTextFieldValue,$
      Event,$
      'data_back_d_selection_file_text_field',$
      BackFullFileName,$
      0                         ;do not append

;update REDUCE gui with name of data background roi file
    putTextFieldValue,$
      Event,$
      'data_back_selection_file_value',$
      BackFullFileName,$
      0                         ;do not append

;display preview message in help data box
    Message = 'Preview of ' + BackFullFileName
    putLabelValue, Event, 'left_data_interaction_help_message_help', Message
    
    YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackFullFileName)
;put Ymin and Ymax in their text fields
    putTextFieldValue, $
      Event,$
      'data_d_selection_background_ymin_cw_field',$
      strcompress(YMinYMaxArray[0],/remove_all),$
      0 
    putTextFieldValue, $
      Event,$
      'data_d_selection_background_ymax_cw_field',$
      strcompress(YMinYMaxArray[1],/remove_all),$
      0 

;replot
    REFreduction_DataBackgroundPeakSelection, Event    

;display 20 first data and last 20 in HELP text data box
    DisplayHeadTailFile, $
      Event, $
      BackFullFileName, $
      'DATA_left_interaction_help_text'

;put info in logbook
    LogBookText = getLogBookText(Event)
    Message = 'OK  '
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;copy file name into reduce tab
    putTextFieldValue, Event, 'data_back_selection_file_value', $
      BackFullFileName , 0

ENDIF
END

;******************************************************************************

;This function is reached by the UpdateDataRoiFileName of the
;IDLupdateGUI class
PRO REFreduction_LoadDataROIFile, Event, DataRoiFileName
BackROIFullFileName = DataRoiFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;update REDUCE gui with name of data background roi file
putTextFieldValue,$
  Event,$
  'reduce_data_region_of_interest_file_name',$
  BackROIFullFileName,$
  0                             ;do not append
;display preview message in help data box
Message = 'Preview of ' + BackROIFullFileName
putLabelValue, Event, 'left_data_interaction_help_message_help', Message
YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackROIFullFileName)
;put Ymin and Ymax in their text fields
putTextFieldValue, $
  Event,$
  'data_d_selection_roi_ymin_cw_field',$
  strcompress(YMinYMaxArray[0],/remove_all),$
  0 
putTextFieldValue, $
  Event,$
  'data_d_selection_roi_ymax_cw_field',$
  strcompress(YMinYMaxArray[1],/remove_all),$
  0 
;display 20 first data and last 20 in HELP text data box
DisplayHeadTailBackgroundDataFile, Event, BackROIFullFileName
END

;******************************************************************************

;This function is reached by the UpdateDataRoiFileName of the
;IDLupdateGUI class
PRO REFreduction_LoadDataBackFile, Event, DataRoiFileName
BackROIFullFileName = DataRoiFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;update REDUCE gui with name of data background roi file
putTextFieldValue,$
  Event,$
  'data_back_selection_file_value',$
  BackROIFullFileName,$
  0                             ;do not append
;display preview message in help data box
Message = 'Preview of ' + BackROIFullFileName
putLabelValue, Event, 'left_data_interaction_help_message_help', Message
YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackROIFullFileName)
;put Ymin and Ymax in their text fields
putTextFieldValue, $
  Event,$
  'data_d_selection_background_ymin_cw_field',$
  strcompress(YMinYMaxArray[0],/remove_all),$
  0 
putTextFieldValue, $
  Event,$
  'data_d_selection_background_ymax_cw_field',$
  strcompress(YMinYMaxArray[1],/remove_all),$
  0 
;display 20 first data and last 20 in HELP text data box
DisplayHeadTailBackgroundDataFile, Event, BackROIFullFileName
END


;******************************************************************************
;******************************************************************************

PRO REFreduction_LoadNormROISelection, Event
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;define Parameters
instrument   = (*global).instrument
load_roi_ext = (*global).load_roi_ext
filter       = instrument + '_*' + load_roi_ext
PROCESSING   = (*global).processing_message
;get default path 
WorkingPath  = (*global).working_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
title        = instrument + ' Normalization ROI Selection File' 
;title of pickfile

;open file
ROIFullFileName = DIALOG_PICKFILE(PATH              = WorkingPath,$
                                  GET_PATH          = path,$
                                  TITLE             = title,$
                                  dialog_parent     = widget_id,$
                                  FILTER            = filter,$
                                  DEFAULT_EXTENSION = '.dat',$
                                  /FIX_FILTER)

IF (ROIFullFileName NE '') THEN BEGIN
;put info in logbook
    text  = '-> Loading Normalization ROI Selection File '
    text += ROIFullFileName
    
    text += ' ... ' + PROCESSING
    putLogBookMessage, Event, Text, Append=1
    
;display name of new file name in text field
    putTextFieldValue,$
      Event,$
      'norm_roi_selection_file_text_field',$
      ROIFullFileName,$
      0                         ;do not append

;update REDUCE gui with name of data background roi file
    putTextFieldValue,$
      Event,$
      'reduce_normalization_region_of_interest_file_name',$
      ROIFullFileName,$
      0                         ;do not append

;display preview message in help data box
    Message = 'Preview of ' + ROIFullFileName
    putLabelValue, Event, 'left_normalization_interaction_help_message_help', $
      Message
    
    YMinYMaxArray = retrieveYMinMaxFromFile(Event, ROIFullFileName)
;put Ymin and Ymax in their text fields
    putTextFieldValue, $
      Event,$
      'norm_d_selection_roi_ymin_cw_field',$
      strcompress(YMinYMaxArray[0],/remove_all),$
      0 
    putTextFieldValue, $
      Event,$
      'norm_d_selection_roi_ymax_cw_field',$
      strcompress(YMinYMaxArray[1],/remove_all),$
      0 

;replot
    REFreduction_NormBackgroundPeakSelection, Event    

;display 20 first data and last 20 in HELP text data box
    DisplayHeadTailFile, $
      Event, $
      ROIFullFileName, $
      'NORM_left_interaction_help_text'

;put info in logbook
    LogBookText = getLogBookText(Event)
    Message = 'OK  '
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;copy file name into reduce tab
        putTextFieldValue, Event, $
          'reduce_normalization_region_of_interest_file_name', $
          ROIFullFileName, 0

ENDIF
END

;------------------------------------------------------------------------------
PRO REFreduction_LoadNormBackgroundSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;define filter
instrument        = (*global).instrument
load_back_ext     = (*global).load_back_ext
filter            = instrument + '_*' + load_back_ext
PROCESSING        = (*global).processing_message
;get default path 
WorkingPath       = (*global).working_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
;title of pickfile
title             = instrument + ' Normalization Background Selection File' 

;open file
BackROIFullFileName = DIALOG_PICKFILE(PATH=WorkingPath,$
                                      GET_PATH          = path,$
                                      TITLE             = title,$
                                      dialog_parent     = widget_id,$
                                      FILTER            = filter,$
                                      DEFAULT_EXTENSION = '.dat',$
                                      /FIX_FILTER)

IF (BackROIFullFileName NE '') THEN BEGIN

;put info in logbook
    text = '-> Loading Normalization Background Selection File '
    text += BackROIFullFileName
    text += ' ... ' + PROCESSING
    putLogBookMessage, Event, Text, Append=1

;display name of new file name in text field
    putTextFieldValue,$
      Event,$
      'norm_back_d_selection_file_text_field',$
      BackROIFullFileName,$
      0                         ;do not append
    
;display preview message in help norm. box
    Message = 'Preview of ' + BackROIFullFileName
    putLabelValue, Event, $
      'left_normalization_interaction_help_message_help', $
      Message

    YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackROIFullFileName)
    
;put Ymin and Ymax in their text fields
    putTextFieldValue, $
      Event,$
      'norm_d_selection_background_ymin_cw_field',$
      strcompress(YMinYMaxArray[0],/remove_all),$
      0 
    
    putTextFieldValue, $
      Event,$
      'norm_d_selection_background_ymax_cw_field',$
      strcompress(YMinYMaxArray[1],/remove_all),$
      0 
    
;replot
    REFreduction_NormBackgroundPeakSelection, Event
    
;display 20 first data and last 20 in HELP text data box
    DisplayHeadTailBackgroundNormFile, Event, BackROIFullFileName
    
;put info in logbook
    LogBookText = getLogBookText(Event)
    Message = 'OK  '
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;copy file name into reduce tab
    putTextFieldValue, Event, 'norm_back_selection_file_value', $
      BackROIFullFileName , 0

ENDIF
END

;******************************************************************************
;******************************************************************************

PRO REFreduction_LoadNormROIFile, Event, NormRoiFileName
BackROIFullFileName = NormRoiFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;display name of new file name in text field
putTextFieldValue,$
  Event,$
  'norm_roi_selection_file_text_field',$
  BackROIFullFileName,$
  0                             ;do not append
;update REDUCE gui with name of data background roi file
putTextFieldValue,$
  Event,$
  'reduce_normalization_region_of_interest_file_name',$
  BackROIFullFileName,$
  0                             ;do not append
;display preview message in help norm. box
Message = 'Preview of ' + BackROIFullFileName
putLabelValue, Event, 'left_normalization_interaction_help_message_help', $
  Message
YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackROIFullFileName)
;put Ymin and Ymax in their text fields
putTextFieldValue, $
  Event,$
  'norm_d_selection_roi_ymin_cw_field',$
  strcompress(YMinYMaxArray[0],/remove_all),$
  0 
putTextFieldValue, $
  Event,$
  'norm_d_selection_roi_ymax_cw_field',$
  strcompress(YMinYMaxArray[1],/remove_all),$
  0 
;display 20 first data and last 20 in HELP text data box
DisplayHeadTailBackgroundNormFile, Event, BackROIFullFileName
END

;------------------------------------------------------------------------------
PRO REFreduction_LoadNormBackFile, Event, NormRoiFileName
BackROIFullFileName = NormRoiFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;display name of new file name in text field
putTextFieldValue,$
  Event,$
  'norm_back_d_selection_file_text_field',$
  BackROIFullFileName,$
  0                             ;do not append
;update REDUCE gui with name of data background roi file
putTextFieldValue,$
  Event,$
  'norm_back_selection_file_value',$
  BackROIFullFileName,$
  0                             ;do not append
;display preview message in help norm. box
Message = 'Preview of ' + BackROIFullFileName
putLabelValue, Event, 'left_normalization_interaction_help_message_help', $
  Message
YMinYMaxArray = retrieveYMinMaxFromFile(Event, BackROIFullFileName)
;put Ymin and Ymax in their text fields
putTextFieldValue, $
  Event,$
  'norm_d_selection_background_ymin_cw_field',$
  strcompress(YMinYMaxArray[0],/remove_all),$
  0 
putTextFieldValue, $
  Event,$
  'norm_d_selection_background_ymax_cw_field',$
  strcompress(YMinYMaxArray[1],/remove_all),$
  0 
;display 20 first data and last 20 in HELP text data box
DisplayHeadTailBackgroundNormFile, Event, BackROIFullFileName
END
