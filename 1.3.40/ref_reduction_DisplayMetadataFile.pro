;get the string array (metadata) of the Main Data Reduction File
PRO RefReduction_DisplayMainDataReductionMetadataFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

info_array = (*(*global).fltPreview_ptr)

;put the metadata in the text field of the Plots tab
putTextFieldArray, Event, $
  'plots_text_field', $
  info_array, $
  (*global).PreviewFileNbrLine, 0

END



PRO RefReduction_DisplayXmlFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

info_array = (*(*global).fltPreview_xml_ptr)
sz = (size(info_array))(1)

;put the metadata in the text field of the Plots tab
putTextFieldArray, Event, 'xml_text_field', info_array, sz, 0

END



