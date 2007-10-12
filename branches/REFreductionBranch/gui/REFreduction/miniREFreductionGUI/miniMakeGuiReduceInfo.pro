PRO miniMakeGuiReduceInfo, Event, REDUCE_BASE

;general info and xml preview tab
GeneralInfoAndXmlBaseSize = [580,240,292,245]
GeneralInfoTabSize = [0, $
                      0, $
                      GeneralInfoAndXmlBaseSize[2],$
                      GeneralInfoAndXmlBaseSize[3]]
ReduceTab1BaseSize = [0, $
                      0, $
                      GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab1BaseTitle = 'COMMAND  LINE STATUS'
ReduceTab2BaseSize = [0, $
                      0, $
                      GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab2BaseTitle = 'REDUCTION XML FILE'

;general info label frame
GeneralInfoTextFieldSize = [0,0,445,218] 

DataReductionStatusFrameSize = [580,500,288,40]
DataReductionStatusLabelSize = [585,493]
DataReductionStatusLabelTitle = 'R E D U C T I O N   S T A T U S'
DataReductionStatusTextFieldSize = [585,509,280,30]


;makeGuI
GeneralInfoAndXmlBase = widget_base(REDUCE_BASE,$
                                    xoffset=GeneralInfoAndXmlBaseSize[0],$
                                    yoffset=GeneralInfoAndXmlBaseSize[1],$
                                    scr_xsize=GeneralInfoAndXmlBaseSize[2],$
                                    scr_ysize=GeneralInfoAndXmlBaseSize[3],$
                                    uname='general_info_and_xml_base')

GeneralInfoTab = widget_tab(GeneralInfoAndXmlBase,$
                            uname='GeneralInfoTab',$
                            location=0,$
                            xoffset=GeneralInfoTabSize[0],$
                            yoffset=GeneralInfoTabSize[1],$
                            scr_xsize=GeneralInfoTabSize[2],$
                            scr_ysize=GeneralInfoTabSize[3],$
                            sensitive=1)

;tab1
reduce_tab1_base = widget_base(GeneralInfoTab,$
                               uname='reduce_tab1_base',$
                               title=ReduceTab1BaseTitle,$
                               xoffset=ReduceTab1BaseSize[0],$
                               yoffset=ReduceTab1BaseSize[1],$
                               scr_xsize=ReduceTab1BaseSize[2],$
                               scr_ysize=ReduceTab1BaseSize[3])
                               
;Text field
GeneralInfoTextField = widget_text(reduce_tab1_base,$
                                   xoffset=GeneralInfoTextFieldSize[0],$
                                   yoffset=GeneralInfoTextFieldSize[1],$
                                   scr_xsize=GeneralInfoTextFieldSize[2],$
                                   scr_ysize=GeneralInfoTextFieldSize[3],$
                                   /wrap,$
                                   /scroll,$
                                   uname='reduction_status_text_field')

;tab2
reduce_tab2_base = widget_base(GeneralInfoTab,$
                               uname='reduce_tab2_base',$
                               title=ReduceTab2BaseTitle,$
                               xoffset=ReduceTab2BaseSize[0],$
                               yoffset=ReduceTab2BaseSize[1],$
                               scr_xsize=ReduceTab2BaseSize[2],$
                               scr_ysize=ReduceTab2BaseSize[3])


;Text field
XmlTextField = widget_text(reduce_tab2_base,$
                           xoffset=GeneralInfoTextFieldSize[0],$
                           yoffset=GeneralInfoTextFieldSize[1],$
                           scr_xsize=GeneralInfoTextFieldSize[2],$
                           scr_ysize=GeneralInfoTextFieldSize[3],$
                           /wrap,$
                           /scroll,$
                           uname='xml_text_field')


;Data reduction status label
DataReductionStatusLabel = widget_label(REDUCE_BASE,$
                                        xoffset=DataReductionStatusLabelSize[0],$
                                        yoffset=DataReductionStatusLabelSize[1],$
                                        FONT = 'lucidasans-10',$
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
