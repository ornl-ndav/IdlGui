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

PRO MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************

;//////////////////////////////
;Pixel Region-of-interest file/
;//////////////////////////////
frameSize = 4
yoff = 95
PRoIFframe     = { size  : [5,15,730,50]}
XYoff         = [10,-10]
PRoIFlabel     = { size  : [PRoIFframe.size[0]+XYoff[0],$
                            PRoIFframe.size[1]+XYoff[1]],$
                   value : 'Pixel Region of Interest File',$
                   uname : 'proif_label'}

XYoff             = [10,10]
PRoIFbrowseButton  = { size  : [PRoIFframe.size[0]+XYoff[0],$
                                PRoIFframe.size[1]+XYoff[1],$
                                130,30],$
                       value : 'Browse ROI...',$
                       uname : 'proif_browse_nexus_button'}
XYoff = [135,40]
PRoIFListOfRuns = { size : [PRoIFbrowseButton.size[0]+XYoff[0],$
                            PRoIFbrowseButton.size[1],$
                            583,30],$
                    uname : 'proif_text'}

;//////////////////////////////
;Alternate Instrument Geometry/
;//////////////////////////////
AIGframe     = { size  : [5,PRoIFframe.size[1]+yoff,730,50]}
XYoff         = [10,-10]
AIGlabel     = { size  : [AIGframe.size[0]+XYoff[0],$
                          AIGframe.size[1]+XYoff[1]],$
                 value : 'Alternate Instrument Geometry',$
                 uname : 'aig_label'}

XYoff             = [10,10]
AIGbrowseButton  = { size  : [AIGframe.size[0]+XYoff[0],$
                              AIGframe.size[1]+XYoff[1],$
                              130,30],$
                     value : 'Browse NeXus...',$
                     uname : 'aig_browse_nexus_button'}
XYoff = [135,40]
AIGListOfRuns = { size : [AIGbrowseButton.size[0]+XYoff[0],$
                          AIGbrowseButton.size[1],$
                          583,30],$
                  uname : 'aig_list_of_runs_text'}

;/////////////
;Ouput folder/
;/////////////
XYoff = [10,80]
sOFbutton = { size: [XYoff[0],$
                     AIGframe.size[1]+XYoff[1],$
                     730],$
              value: '~/results/',$
              uname: 'output_folder_name'}

;////////////////
;Ouput file name/
;////////////////
XYoff = [0,35]
OFlabel     = { size  : [sOFbutton.size[0]+XYoff[0],$
                         sOFbutton.size[1]+XYoff[1]],$
                value : 'Outupt File Name:',$
                uname : 'of_label'}

XYoff             = [110,-8]
OFListOfRuns = { size : [OFlabel.size[0]+XYoff[0],$
                         OFlabel.size[1]+XYoff[1],$
                         620,32],$
                 uname : 'of_list_of_runs_text'}


;******************************************************************************
;                                Build GUI
;******************************************************************************
tab2_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[5])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Pixel Region-of-interest file\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab2_base,$
                     XOFFSET = PRoIFlabel.size[0],$
                     YOFFSET = PRoIFlabel.size[1],$
                     VALUE   = PRoIFlabel.value,$
                     UNAME   = PRoIFlabel.uname)

browseNexus = WIDGET_BUTTON(tab2_base,$
                            XOFFSET   = PRoIFbrowseButton.size[0],$
                            YOFFSET   = PRoIFbrowseButton.size[1],$
                            SCR_XSIZE = PRoIFbrowseButton.size[2],$
                            SCR_YSIZE = PRoIFbrowseButton.size[3],$
                            VALUE     = PRoIFbrowseButton.value,$
                            UNAME     = PRoIFbrowseButton.uname)

ListOfRuns = WIDGET_TEXT(tab2_base,$
                         XOFFSET   = PRoIFListOfRuns.size[0],$
                         YOFFSET   = PRoIFListOfRuns.size[1],$
                         SCR_XSIZE = PRoIFListOfRuns.size[2],$
                         /ALIGN_LEFT,$
                         UNAME     = PRoIFListOfRuns.uname,$
                         /EDITABLE)
                        
frame = WIDGET_LABEL(tab2_base,$
                     XOFFSET   = PRoIFframe.size[0],$
                     YOFFSET   = PRoIFframe.size[1],$
                     SCR_XSIZE = PRoIFframe.size[2],$
                     SCR_YSIZE = PRoIFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Alternate Instrument Geometry\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab2_base,$
                     XOFFSET = AIGlabel.size[0],$
                     YOFFSET = AIGlabel.size[1],$
                     VALUE   = AIGlabel.value,$
                     UNAME   = AIGlabel.uname)

browseNexus = WIDGET_BUTTON(tab2_base,$
                            XOFFSET   = AIGbrowseButton.size[0],$
                            YOFFSET   = AIGbrowseButton.size[1],$
                            SCR_XSIZE = AIGbrowseButton.size[2],$
                            SCR_YSIZE = AIGbrowseButton.size[3],$
                            VALUE     = AIGbrowseButton.value,$
                            UNAME     = AIGbrowseButton.uname)

ListOfRuns = WIDGET_TEXT(tab2_base,$
                         XOFFSET   = AIGListOfRuns.size[0],$
                         YOFFSET   = AIGListOfRuns.size[1],$
                         SCR_XSIZE = AIGListOfRuns.size[2],$
                         /ALIGN_LEFT,$
                         /EDITABLE,$
                         UNAME     = AIGListOfRuns.uname,$
                         /ALL_EVENTS)
                        
frame = WIDGET_LABEL(tab2_base,$
                     XOFFSET   = AIGframe.size[0],$
                     YOFFSET   = AIGframe.size[1],$
                     SCR_XSIZE = AIGframe.size[2],$
                     SCR_YSIZE = AIGframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\
;Output Folder\
;\\\\\\\\\\\\\\
wOFbutton = WIDGET_BUTTON(tab2_base,$
                          XOFFSET   = sOFbutton.size[0],$
                          YOFFSET   = sOFbutton.size[1],$
                          SCR_XSIZE = sOFbutton.size[2],$
                          VALUE     = sOFbutton.value,$
                          UNAME     = sOFbutton.uname)

;\\\\\\\\\\\\\\\\\
;Output File Name\
;\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab2_base,$
                     XOFFSET = OFlabel.size[0],$
                     YOFFSET = OFlabel.size[1],$
                     VALUE   = OFlabel.value,$
                     UNAME   = OFlabel.uname)

ListOfRuns = WIDGET_TEXT(tab2_base,$
                         XOFFSET   = OFListOfRuns.size[0],$
                         YOFFSET   = OFListOfRuns.size[1],$
                         SCR_XSIZE = OFListOfRuns.size[2],$
                         SCR_YSIZE = OFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         /ALL_EVENTS,$
                         /EDITABLE,$
                         UNAME     = OFListOfRuns.uname)
                       
END
