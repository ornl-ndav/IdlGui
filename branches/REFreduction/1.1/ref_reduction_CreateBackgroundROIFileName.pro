;This function creates the name of the Data Background ROI file
PRO REFreduction_CreateDefaultDataBackgroundROIFileName, Event,$
                                                         instrument,$
                                                         working_path,$
                                                         run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DefaultBackRoiFileName = working_path + strcompress(instrument,/remove_all)
DefaultBackRoiFileName += '_' + strcompress(run_number,/remove_all)
DefaultBackRoiFileName += (*global).data_back_roi_ext

putTextFieldValue, Event,$
  'data_background_selection_file_text_field',$
  DefaultBackRoiFileName,0
  
END



;This function creates the name of the Normalization Background ROI file
PRO REFreduction_CreateDefaultNormBackgroundROIFileName, Event,$
                                                         instrument,$
                                                         working_path,$
                                                         run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DefaultBackRoiFileName = working_path + strcompress(instrument,/remove_all)
DefaultBackRoiFileName += '_' + strcompress(run_number,/remove_all)
DefaultBackRoiFileName += (*global).norm_back_roi_ext

putTextFieldValue, Event,$
  'normalization_background_selection_file_text_field',$
  DefaultBackRoiFileName,0

END
