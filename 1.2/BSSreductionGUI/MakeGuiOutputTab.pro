;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO MakeGuiOutputTab, MAIN_TAB, MainTabSize, OutputBaseTitle

;******************************************************************************
;                             Define size arrays
;******************************************************************************
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
                              MainTabSize[2]-20,100],$
                     uname : 'output_file_header_text'}
                             
XYoff = [230,110]
DataLabel      = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            HeaderText.size[1]+XYoff[1]],$
                   value : 'D  A  T  A'}
                              
XYoff = [0,19]
DataText       = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            DataLabel.size[1]+XYoff[1],$
                            550,500],$
                     uname : 'output_file_data_text'}
                        
;get plot button -------------------------------------------------------------
XYoff = [100,30]
sPlotButton = { size: [DataText.size[0]+$
                       DataText.size[2]+$
                       XYoff[0],$
                       DataText.size[1]+$
                       XYoff[1]],$
                value: 'images/bss_reduction_plot_data.bmp',$
                uname: 'output_plot_data',$
                sensitive: 1}

;******************************************************************************
;                                Build GUI
;******************************************************************************
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

;get plot button -------------------------------------------------------------
wPlotButton = WIDGET_BUTTON(OutputBase,$
                            XOFFSET   = sPlotButton.size[0],$
                            YOFFSET   = sPlotButton.size[1],$
                            VALUE     = sPlotButton.value,$
                            UNAME     = sPlotButton.uname,$
                            SENSITIVE = sPlotButton.sensitive,$
                            /BITMAP)



END
