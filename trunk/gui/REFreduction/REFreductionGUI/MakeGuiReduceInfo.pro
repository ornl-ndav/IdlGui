PRO MakeGuiReduceInfo, Event, REDUCE_BASE

;general info label framed
GeneralInfoFrameSize    = [725,260,450,315]
GeneralInfoLabelSize    = [740,250]
GeneralInfoLabelTitle   = 'C O M M A N D   L I N E   G E N E R A T O R   S T A T U S'
GeneralInfoTextFieldSize = [730,269,440,305] 

DataReductionStatusFrameSize = [725,595,450,40]
DataReductionStatusLabelSize = [740,585]
DataReductionStatusLabelTitle = 'R E D U C T I O N   S T A T U S'
DataReductionStatusTextFieldSize = [730,604,440,30]

;makeGuI
;general info label
GeneralInfoLabel = widget_label(REDUCE_BASE,$
                                xoffset=GeneralInfoLabelSize[0],$
                                yoffset=GeneralInfoLabelSize[1],$
                                value=GeneralInfoLabelTitle)
                                
;Text field
GeneralInfoTextField = widget_text(REDUCE_BASE,$
                                   xoffset=GeneralInfoTextFieldSize[0],$
                                   yoffset=GeneralInfoTextFieldSize[1],$
                                   scr_xsize=GeneralInfoTextFieldSize[2],$
                                   scr_ysize=GeneralInfoTextFieldSize[3],$
                                   /wrap,$
                                   /scroll,$
                                   uname='reduction_status_text_field')

;frame
GeneralInfoFrame = widget_label(REDUCE_BASE,$
                               frame=1,$
                               xoffset=GeneralInfoFrameSize[0],$
                               yoffset=GeneralInfoFrameSize[1],$
                               scr_xsize=GeneralInfoFrameSize[2],$
                               scr_ysize=GeneralInfoFrameSize[3],$
                               value='')

;Data reduction status label
DataReductionStatusLabel = widget_label(REDUCE_BASE,$
                                        xoffset=DataReductionStatusLabelSize[0],$
                                        yoffset=DataReductionStatusLabelSize[1],$
                                        value=DataReductionStatusLabelTitle)

;text field
DataReductionStatusTextField = widget_text(REDUCE_BASE,$
                                           xoffset=DataReductionStatusTextFieldSize[0],$
                                           yoffset=DataReductionStatusTextFieldSize[1],$
                                           scr_xsize=DataReductionStatusTextFieldSize[2],$
                                           scr_ysize=DataReductionStatusTextFieldSize[3],$
                                           uname='data_reduction_status_text_field',$
                                           /align_left)


;Data Reduction status frame
DataReductionStatusFrame = widget_label(REDUCE_BASE,$
                                        frame=1,$
                                        xoffset=DataReductionStatusFrameSize[0],$
                                        yoffset=DataReductionStatusFrameSize[1],$
                                        scr_xsize=DataReductionStatusFrameSize[2],$
                                        scr_ysize=DataReductionStatusFrameSize[3],$
                                        value='')




END
