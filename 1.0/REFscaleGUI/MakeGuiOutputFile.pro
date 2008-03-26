PRO MakeGuiOutputFile, STEPS_TAB, Step1Size
                       
OutputFileNameLabelStaticSize = [5,8]
OutputfileNameLabelDynamicSize = [150,3,400,30]

OutputFileTextFieldsize = [ 5, 5+30, 515, 365-30]
OutputFileTitle = 'OUTPUT FILE'
OutputFileNameLabelStaticTitle = 'Output file name:'

;Build GUI
OutputFile_BASE = WIDGET_BASE(STEPS_TAB,$
                              UNAME     = 'output_file_base',$
                              TITLE     = OutputFileTitle,$
                              XOFFSET   = Step1Size[0],$
                              YOFFSET   = Step1Size[1],$
                              SCR_XSIZE = Step1Size[2],$
                              SCR_YSIZE = Step1Size[3],$
                              MAP       = 0)

OutputFileNameLabelStatic = WIDGET_LABEL(OutputFile_base,$
                                         XOFFSET = OutputFileNameLabelStaticSize[0],$
                                         YOFFSET = OutputFileNameLabelStaticSize[1],$
                                         VALUE   = OutputFileNameLabelStaticTitle)

OutputFileNameLabelDynamic = WIDGET_LABEL(OutputFile_base,$
                                          XOFFSET   = OutputFileNameLabelDynamicSize[0],$
                                          YOFFSET   = OutputFileNameLabelDynamicSize[1],$
                                          SCR_XSIZE = OutputFileNameLabelDynamicSize[2],$
                                          SCR_YSIZE = OutputFileNameLabelDynamicSize[3],$
                                          UNAME     = 'output_file_name_label_dynmaic',$
                                          VALUE     = '',$
                                          /ALIGN_LEFT)

OutputFileTextfield = WIDGET_TEXT(OutputFile_base,$
                                  UNAME     = 'output_file_text_field',$
                                  XOFFSET   = OutputFileTextFieldSize[0],$
                                  YOFFSET   = OutputFileTextFieldSize[1],$
                                  SCR_XSIZE = OutputFileTextFieldSize[2],$
                                  SCR_YSIZE = OutputFileTextFieldsize[3],$
                                  /SCROLL)
                                  
END
