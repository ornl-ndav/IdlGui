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

;name of file plotted ---------------------------------------------------------
XYoff = [380,10]
sNameOfFile = { size: [FileNameDroplist.size[0]+XYoff[0],$
                       FileNameDroplist.size[1]+XYoff[1],$
                       800],$
                value: '   ',$
                frame: 1,$
                uname: 'output_plot_file_name'}
XYoff = [0,0]
sHiddenBase = { size: [sNameOfFile.size[0]+XYoff[0],$
                       sNameOfFile.size[1]+XYoff[1],$
                       sNameOfFile.size[2]+30,$
                       40],$
                uname: 'output_plot_file_hidden_base',$
                map: 0}

;Preview of file --------------------------------------------------------------
XYoff = [235,35]
DataLabel      = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            FileNameDroplist.size[1]+XYoff[1]],$
                   value : 'P R E V I E W'}
                              
XYoff = [10,19]
DataText       = { size  : [FileNameDroplist.size[0]+XYoff[0],$
                            DataLabel.size[1]+XYoff[1],$
                            600,630],$
                     uname : 'output_file_data_text'}
                        
;Browse for a file to plot ---------------------------------------------------
XYoff = [15,0]
sBrowseButton = { size: [DataText.size[0]+$
                         DataText.size[2]+$
                         XYoff[0],$
                         DataText.size[1]+$
                         XYoff[1],$
                         550],$
                  value: ' FILE BROWSER ... ',$
                  uname: 'output_plot_browse_button'}

;get plot button -------------------------------------------------------------
XYoff = [80,100]
sPlotButtonBase = { size: [DataText.size[0]+$
                           DataText.size[2]+$
                           XYoff[0],$
                           DataText.size[1]+$
                           XYoff[1],$
                           400,$
                           400],$
                    uname: 'output_plot_data_base',$
                    map: 0}
XYoff = [0,0]
sPlotButton = { size: [XYoff[0],$
                       XYoff[1]],$
                value: 'BSSreduction_images/bss_reduction_plot_data.bmp',$
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

;name of file plotted ---------------------------------------------------------
wHiddenBase = WIDGET_BASE(OutputBase,$
                          XOFFSET   = sHiddenBase.size[0],$
                          YOFFSET   = sHiddenBase.size[1],$
                          SCR_XSIZE = sHiddenBase.size[2],$
                          SCR_YSIZE = sHiddenBase.size[3],$
                          UNAME     = sHiddenBase.uname,$
                          MAP       = sHiddenBase.map)

wNameOfFile = WIDGET_LABEL(OutputBase,$
                           XOFFSET   = sNameOfFile.size[0],$
                           YOFFSET   = sNameOfFile.size[1],$
                           SCR_XSIZE = sNameOfFile.size[2],$
                           VALUE     = sNameOfFile.value,$
                           UNAME     = sNameOfFile.uname,$
                           FRAME     = sNameOfFile.frame)


;Preview of file --------------------------------------------------------------
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

;Browse for a file to plot ---------------------------------------------------
wBrowseButton = WIDGET_BUTTON(OutputBase,$
                              XOFFSET   = sBrowseButton.size[0],$
                              YOFFSET   = sBrowseButton.size[1],$
                              SCR_XSIZE = sBrowseButton.size[2],$
                              UNAME     = sBrowseButton.uname,$
                              VALUE     = sBrowseButton.value)

;get plot button -------------------------------------------------------------
wPlotBase = WIDGET_BASE(OutputBase,$
                        XOFFSET   = sPlotButtonBase.size[0],$
                        YOFFSET   = sPlotButtonBase.size[1],$
                        SCR_XSIZE = sPlotButtonBase.size[2],$
                        SCR_YSIZE = sPlotButtonBase.size[3],$
                        UNAME     = sPlotButtonBase.uname,$
                        MAP       = sPlotButtonBase.map)

wPlotButton = WIDGET_BUTTON(wPlotBase,$
                            XOFFSET   = sPlotButton.size[0],$
                            YOFFSET   = sPlotButton.size[1],$
                            VALUE     = sPlotButton.value,$
                            UNAME     = sPlotButton.uname,$
                            SENSITIVE = sPlotButton.sensitive,$
                            /BITMAP)



END
