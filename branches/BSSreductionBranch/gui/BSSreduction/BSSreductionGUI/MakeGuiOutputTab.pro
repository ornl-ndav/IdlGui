PRO MakeGuiOutputTab, MAIN_TAB, MainTabSize, OutputBaseTitle

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************
FileNameDroplist = { size  : [5,5,150,40],$
                     list  : [''],$
                     uname : 'output_file_name_droplist'}

XYoff = [220,40]
HeaderLabel      = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                              FileNameDroplist.size[1]+XYoff[1]],$
                     value : 'H  E  A  D  E  R'}
                              
XYoff = [0,19]
HeaderText       = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                              HeaderLabel.size[1]+XYoff[1],$
                              550,200],$
                     uname : 'output_file_header_text'}
                             
XYoff = [230,210]
DataLabel      = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            HeaderText.size[1]+XYoff[1]],$
                   value : 'D  A  T  A'}
                              
XYoff = [0,19]
DataText       = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            DataLabel.size[1]+XYoff[1],$
                            550,400],$
                     uname : 'output_file_data_text'}
                             
XYoff = [570,15]
draw           = { size  : [XYoff[0],$
                            XYoff[1],$
                            610,550],$
                   uname : 'output_file_plot'}


;***********************************************************************************
;                                Build GUI
;***********************************************************************************
OutputBase = WIDGET_BASE(MAIN_TAB,$
                         XOFFSET   = 0,$
                         YOFFSET   = 0,$
                         SCR_XSIZE = MainTabSize[2],$
                         SCR_YSIZE = MainTabSize[3],$
                         TITLE     = OutputBaseTitle,$
                         UNAME     = 'output_base')


FileNameDroplist = WIDGET_DROPLIST(OutputBase,$
                                   /DYNAMIC_RESIZE,$
                                   XOFFSET = FileNameDroplist.size[0],$
                                   YOFFSET = FileNameDroplist.size[1],$
                                   VALUE   = FileNameDroplist.list,$
                                   UNAME   = FileNameDroplist.uname)

label = WIDGET_LABEL(OutputBase,$
                     XOFFSET = HeaderLabel.size[0],$
                     YOFFSET = HeaderLabel.size[1],$
                     VALUE   = HeaderLabel.value)

Header = WIDGET_TEXT(OutputBase,$
                     /WRAP,$
                     /SCROLL,$
                     XOFFSET = HeaderText.size[0],$
                     YOFFSET = HeaderText.size[1],$
                     SCR_XSIZE = HeaderText.size[2],$
                     SCR_YSIZE = HeaderText.size[3],$
                     UNAME     = HeaderText.uname)

label = WIDGET_LABEL(OutputBase,$
                     XOFFSET = DataLabel.size[0],$
                     YOFFSET = DataLabel.size[1],$
                     VALUE   = DataLabel.value)

Data = WIDGET_TEXT(OutputBase,$
                     /WRAP,$
                     /SCROLL,$
                     XOFFSET = DataText.size[0],$
                     YOFFSET = DataText.size[1],$
                     SCR_XSIZE = DataText.size[2],$
                     SCR_YSIZE = DataText.size[3],$
                     UNAME     = DataText.uname)

draw = WIDGET_DRAW(OutputBase,$
                   XOFFSET = draw.size[0],$
                   YOFFSET = draw.size[1],$
                   SCR_XSIZE = draw.size[2],$
                   SCR_YSIZE = draw.size[3],$
                   UNAME     = draw.uname)



END
