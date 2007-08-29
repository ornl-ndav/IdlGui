PRO MakeGuiReduceInfo, Event, REDUCE_BASE

;general info label framed
GeneralInfoFrameSize    = [725,260,450,380]
GeneralInfoLabelSize    = [740,250]
GeneralInfoLabelTitle   = 'R E D U C T I O N    S T A T U S'
GeneralInfoTextFieldSize = [730,270,440,365] 

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



END
