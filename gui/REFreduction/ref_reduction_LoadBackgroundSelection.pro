PRO DisplayHeadTailBackgroundFile, Event, FileName, uname

;get the first 20 elements
cmd = 'head ' + FileName + ' -n 20'
spawn, cmd, First20Lines

FinalArray = [First20Lines,'...']

;get the last 20 elements
cmd = 'tail ' + FileName + ' -n 20'
spawn, cmd, Last20Lines

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




PRO DisplayHeadTailBackgroundDataFile, Event, BackROIFullFileName
uname = 'DATA_left_interaction_help_text'
DisplayHeadTailBackgroundFile, Event, BackROIFullFileName, uname
END






FUNCTION ParseBackgroundFileString, Event, StringText

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

result_array = strsplit(StringText,'_',/extract)

if ((*global).instrument EQ 'REF_L') then begin
    Y = result_array[2]
endif else begin
    Y = result_array[1]
endelse

return, Y
END



FUNCTION retrieveYMinMaxFromFile, Event, FileName

;to get the first line of the file
cmd = 'head ' + FileName + ' -n 1'
spawn, cmd, first_line

;to get the last line of the file
cmd = 'tail ' + FileName + ' -n 1'
spawn, cmd, last_line

Ymin = ParseBackgroundFileString(Event, first_line)
Ymax = ParseBackgroundFileString(Event, last_line)

return, [Ymin,Ymax]
END




PRO REFreduction_LoadDataBackgroundSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;define filter
instrument = (*global).instrument
data_back_roi_ext = (*global).data_back_roi_ext
filter = instrument + '_*' + data_back_roi_ext

;get default path 
WorkingPath = (*global).working_path

title = instrument + ' Data Background Selection File' ;title of pickfile

;open file
BackROIFullFileName = dialog_pickfile(path=WorkingPath,$
                                      get_path=path,$
                                      title=title,$
                                      filter=filter,$
                                      default_extension='.dat',$
                                      /fix_filter)

if (BackROIFullFileName NE '') then begin

;display name of new file name in text field
putTextFieldValue,$
  Event,$
  'data_background_selection_file_text_field',$
  BackROIFullFileName,$
  0 ;do not append

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

;replot
REFreduction_DataBackgroundPeakSelection, Event

;display 20 first data and last 20 in HELP text data box
DisplayHeadTailBackgroundDataFile, Event, BackROIFullFileName

endif

END



PRO REFreduction_LoadNormBackgroundSelecton, Event

print, 'here1'

END
