PRO REFreduction_DisplayPreviewOfDataRoiFile, Event, OutputArray, NbrToDisplay

putTextFieldArray,$
  Event,$
  'DATA_left_interaction_help_text',$
  OutputArray, NbrToDisplay,0

text = '[...]'
putTextFieldValue, Event, $
  'DATA_left_interaction_help_text',$
  text, 1

outputArraySize = (size(OutputArray))(1)
OutputArray = OutputArray[OutputArraySize-1-NbrToDisplay:outputArraySize-1]
putTextFieldArray,$
  Event,$
  'DATA_left_interaction_help_text',$
  OutputArray, NbrToDisplay, 1

END




PRO REFreduction_DisplayPreviewOfNormRoiFile, Event, OutputArray, NbrToDisplay

putTextFieldArray,$
  Event,$
  'NORM_left_interaction_help_text',$
  OutputArray, NbrToDisplay,0

text = '[...]'
putTextFieldValue, Event, $
  'NORM_left_interaction_help_text',$
  text, 1

outputArraySize = (size(OutputArray))(1)
OutputArray = OutputArray[OutputArraySize-1-NbrToDisplay:outputArraySize-1]
putTextFieldArray,$
  Event,$
  'NORM_left_interaction_help_text',$
  OutputArray, NbrToDisplay, 1

END
