;get the string array (metadata) of the Main Data Reduction File
PRO RefReduction_DisplayMainDataReductionMetadataFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

fltPreview_ptr = (*global).fltPreview_ptr
info_array = *fltPreview_ptr[0]

;put the metadata in the text field of the Plots tab
putTextFieldArray, Event, 'plots_text_field', info_array, (*global).PreviewFileNbrLine, 0

END








