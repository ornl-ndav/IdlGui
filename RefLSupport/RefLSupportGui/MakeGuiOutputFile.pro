PRO MakeGuiOutputFile, STEPS_TAB, Step1Size
                       
OutputFileNameLabelStaticSize = [5,8]
OutputfileNameLabelDynamicSize = [150,3,400,30]

OutputFileTextFieldsize = [ 5, 5+30, 515, 365-30]
OutputFileTitle = 'Output File'
OutputFileNameLabelStaticTitle = 'Output file name:'

;Build GUI
OutputFile_BASE = WIDGET_BASE(STEPS_TAB,$
                              UNAME='Output File_base',$
                              TITLE=OutputFileTitle,$
                              XOFFSET=Step1Size[0],$
                              YOFFSET=Step1Size[1],$
                              SCR_XSIZE=Step1Size[2],$
                              SCR_YSIZE=Step1Size[3])

OutputFileNameLabelStatic = widget_label(OutputFile_base,$
                                         xoffset=OutputFileNameLabelStaticSize[0],$
                                         yoffset=OutputFileNameLabelStaticSize[1],$
                                         value=OutputFileNameLabelStaticTitle)

OutputFileNameLabelDynamic = widget_label(OutputFile_base,$
                                          xoffset=OutputFileNameLabelDynamicSize[0],$
                                          yoffset=OutputFileNameLabelDynamicSize[1],$
                                          scr_xsize=OutputFileNameLabelDynamicSize[2],$
                                          scr_ysize=OutputFileNameLabelDynamicSize[3],$
                                          uname='output_file_name_label_dynmaic',$
                                          value='',$
                                         /align_left)


OutputFileTextfield = widget_text(OutputFile_base,$
                                  uname='output_file_text_field',$
                                  xoffset=OutputFileTextFieldSize[0],$
                                  yoffset=OutputFileTextFieldSize[1],$
                                  scr_xsize=OutputFileTextFieldSize[2],$
                                  scr_ysize=OutputFileTextFieldsize[3],$
                                  /scroll)
                                  


END
