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

PRO MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

;******************************************************************************
;                           Define size arrays
;******************************************************************************

;/////////////////////
;Raw Sample Data File/
;/////////////////////
frameSize = 4
RSDFframe     = { size  : [5,15,730,80]}
XYoff         = [10,-10]
RSDFlabel     = { size  : [RSDFframe.size[0]+XYoff[0],$
                           RSDFframe.size[1]+XYoff[1]],$
                  value : 'Raw Sample Data File',$
                  uname : 'rsdf_label'}

XYoff             = [8,5]
RSDFrunNumberBase = { size  : [RSDFframe.size[0]+XYoff[0],$
                               RSDFframe.size[1]+XYoff[1],$
                               150,35],$
                      title : 'Run Number:',$
                      xsize : 8,$
                      uname : 'rsdf_run_number_cw_field'}

XYoff             = [160,4]
RSDFbrowseButton  = { size  : [RSDFrunNumberBase.size[0]+XYoff[0],$
                               RSDFrunNumberBase.size[1]+XYoff[1],$
                               130,30],$
                      value : 'Browse NeXus...',$
                      uname : 'rsdf_browse_nexus_button'}
XYoff             = [130,-4]
RSDFNexusField    = { size : [RSDFbrowseButton.size[0]+XYoff[0],$
                              RSDFbrowseButton.size[1]+XYoff[1],$
                              430,35],$
                      xsize : 65,$
                      title : 'or',$
                      uname : 'rsdf_nexus_cw_field'}
XYoff             = [337,0]
RSDFMultipleRun   = { base : {size : [RSDFNexusField.size[0] + XYoff[0],$
                                      RSDFNexusField.size[1] + XYoff[1],$
                                      90,35]},$
                      size : [0,0,10,30],$
                      value : 'Multi. Runs',$
                      uname : 'rsdf_multiple_runs_button'}
               
XYoff = [10,40]
RSDFListOfRuns = { size : [XYoff[0],$
                           RSDFrunNumberBase.size[1]+XYoff[1],$
                           723,30],$
                   uname : 'rsdf_list_of_runs_text'}
                   
;/////////////////////
;Background Data File/
;/////////////////////
yoff = 110
BDFframe     = { size  : [5,RSDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
BDFlabel     = { size  : [BDFframe.size[0]+XYoff[0],$
                          BDFframe.size[1]+XYoff[1]],$
                 value : 'Background Data File',$
                 uname : 'bdf_label'}

XYoff             = [8,5]
BDFrunNumberBase = { size  : [BDFframe.size[0]+XYoff[0],$
                              BDFframe.size[1]+XYoff[1],$
                              150,35],$
                     title : 'Run Number:',$
                     xsize : 8,$
                     uname : 'bdf_run_number_cw_field'}

XYoff             = [160,4]
BDFbrowseButton  = { size  : [BDFrunNumberBase.size[0]+XYoff[0],$
                               BDFrunNumberBase.size[1]+XYoff[1],$
                               130,30],$
                      value : 'Browse NeXus...',$
                      uname : 'bdf_browse_nexus_button'}
XYoff             = [130,-4]
BDFNexusField    = { size : [BDFbrowseButton.size[0]+XYoff[0],$
                             BDFbrowseButton.size[1]+XYoff[1],$
                             430,35],$
                     xsize : 65,$
                     title : 'or',$
                     uname : 'bdf_nexus_cw_field'}
               
XYoff = [10,40]
BDFListOfRuns = { size : [XYoff[0],$
                          BDFrunNumberBase.size[1]+XYoff[1],$
                          723,30],$
                  uname : 'bdf_list_of_runs_text'}

;////////////////////////
;Normalization Data File/
;////////////////////////
;yoff = 95
NDFframe     = { size  : [5,BDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
NDFlabel     = { size  : [NDFframe.size[0]+XYoff[0],$
                          NDFframe.size[1]+XYoff[1]],$
                 value : 'Normalization Data File',$
                 uname : 'ndf_label'}

XYoff             = [8,5]
NDFrunNumberBase = { size  : [NDFframe.size[0]+XYoff[0],$
                              NDFframe.size[1]+XYoff[1],$
                              150,35],$
                     title : 'Run Number:',$
                     xsize : 8,$
                     uname : 'ndf_run_number_cw_field'}

XYoff             = [160,4]
NDFbrowseButton  = { size  : [NDFrunNumberBase.size[0]+XYoff[0],$
                               NDFrunNumberBase.size[1]+XYoff[1],$
                               130,30],$
                      value : 'Browse NeXus...',$
                      uname : 'ndf_browse_nexus_button'}
XYoff             = [130,-4]
NDFNexusField    = { size : [NDFbrowseButton.size[0]+XYoff[0],$
                             NDFbrowseButton.size[1]+XYoff[1],$
                             430,35],$
                     xsize : 65,$
                     title : 'or',$
                     uname : 'ndf_nexus_cw_field'}
               
XYoff = [10,40]
NDFListOfRuns = { size : [XYoff[0],$
                          NDFrunNumberBase.size[1]+XYoff[1],$
                          723,30],$
                  uname : 'ndf_list_of_runs_text'}

;////////////////////
;Empty Can Data File/
;////////////////////
;yoff = 95
ECDFframe     = { size  : [5,NDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
ECDFlabel     = { size  : [ECDFframe.size[0]+XYoff[0],$
                          ECDFframe.size[1]+XYoff[1]],$
                  value : 'Empty Can Data File',$
                  uname : 'ecdf_label'}

XYoff             = [8,5]
ECDFrunNumberBase = { size  : [ECDFframe.size[0]+XYoff[0],$
                              ECDFframe.size[1]+XYoff[1],$
                              150,35],$
                     title : 'Run Number:',$
                     xsize : 8,$
                     uname : 'ecdf_run_number_cw_field'}

XYoff             = [160,4]
ECDFbrowseButton  = { size  : [ECDFrunNumberBase.size[0]+XYoff[0],$
                               ECDFrunNumberBase.size[1]+XYoff[1],$
                               130,30],$
                      value : 'Browse NeXus...',$
                      uname : 'ecdf_browse_nexus_button'}
XYoff             = [130,-4]
ECDFNexusField    = { size : [ECDFbrowseButton.size[0]+XYoff[0],$
                             ECDFbrowseButton.size[1]+XYoff[1],$
                             430,35],$
                     xsize : 65,$
                     title : 'or',$
                     uname : 'ecdf_nexus_cw_field'}
               
XYoff = [10,40]
ECDFListOfRuns = { size : [XYoff[0],$
                          ECDFrunNumberBase.size[1]+XYoff[1],$
                          723,30],$
                  uname : 'ecdf_list_of_runs_text'}

;/////////////////////////////
;Direct Scattering background/
;/////////////////////////////
DSBframe     = { size  : [5, $
                          ECDFframe.size[1]+yoff, $
                          730, $
                          80]}
XYoff         = [10,-10]
DSBlabel     = { size  : [DSBframe.size[0]+XYoff[0],$
                          DSBframe.size[1]+XYoff[1]],$
                 value : 'Direct Scattering Background (Sample Data at ' + $
                 'Baseline T) File',$
                  uname : 'dsb_label'}

XYoff             = [8,5]
DSBrunNumberBase = { size  : [DSBframe.size[0]+XYoff[0],$
                              DSBframe.size[1]+XYoff[1],$
                              150,35],$
                     title : 'Run Number:',$
                     xsize : 8,$
                     uname : 'dsb_run_number_cw_field'}

XYoff             = [160,4]
DSBbrowseButton  = { size  : [DSBrunNumberBase.size[0]+XYoff[0],$
                               DSBrunNumberBase.size[1]+XYoff[1],$
                               130,30],$
                      value : 'Browse NeXus...',$
                      uname : 'dsb_browse_nexus_button'}
XYoff             = [130,-4]
DSBNexusField    = { size : [DSBbrowseButton.size[0]+XYoff[0],$
                             DSBbrowseButton.size[1]+XYoff[1],$
                             430,35],$
                     xsize : 65,$
                     title : 'or',$
                     uname : 'dsb_nexus_cw_field'}
               
XYoff = [10,40]
DSBListOfRuns = { size : [XYoff[0],$
                          DSBrunNumberBase.size[1]+XYoff[1],$
                          723,30],$
                  uname : 'dsb_list_of_runs_text'}

;******************************************************************************
;                                Build GUI
;******************************************************************************
tab1_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[0])

;\\\\\\\\\\\\\\\\\\\\\
;Raw Sample Data File\
;\\\\\\\\\\\\\\\\\\\\\
label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = RSDFlabel.size[0],$
                     YOFFSET = RSDFlabel.size[1],$
                     VALUE   = RSDFlabel.value,$
                     UNAME   = RSDFlabel.uname)

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = RSDFrunNumberBase.size[0],$
                   YOFFSET   = RSDFrunNumberBase.size[1],$
                   SCR_XSIZE = RSDFrunNumberBase.size[2],$
                   SCR_YSIZE = RSDFrunNumberBase.size[3])

runNumber = CW_FIELD(base,$
                     UNAME         = RSDFrunNumberBase.uname,$
                     TITLE         = RSDFrunNumberBase.title,$
                     RETURN_EVENTS = 1,$
                     ROW           = 1,$
                     XSIZE         = RSDFrunNumberBase.xsize)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = RSDFbrowseButton.size[0],$
                            YOFFSET   = RSDFbrowseButton.size[1],$
                            SCR_XSIZE = RSDFbrowseButton.size[2],$
                            SCR_YSIZE = RSDFbrowseButton.size[3],$
                            VALUE     = RSDFbrowseButton.value,$
                            UNAME     = RSDFbrowseButton.uname)

nexusBase = WIDGET_BASE(tab1_base,$
                        XOFFSET = RSDFNexusField.size[0],$
                        YOFFSET = RSDFNexusField.size[1],$
                        SCR_XSIZE = RSDFNexusField.size[2],$
                        SCR_YSIZE = RSDFNexusField.size[3])

nexusField = CW_FIELD(nexusBase,$
                      UNAME         = RSDFNexusField.uname,$
                      RETURN_EVENTS = 1,$
                      TITLE         = RSDFNexusField.title,$
                      ROW           = 1,$
                      XSIZE         = RSDFNexusField.xsize)

; base = WIDGET_BASE(tab1_base,$
;                    XOFFSET   = RSDFMultipleRun.base.size[0],$
;                    YOFFSET   = RSDFMultipleRun.base.size[1],$
;                    SCR_XSIZE = RSDFMultipleRun.base.size[2],$
;                    SCR_YSIZE = RSDFMultipleRun.base.size[3],$
;                    /NONEXCLUSIVE)

; MultipleRun = WIDGET_BUTTON(base,$
;                             XOFFSET   = RSDFMultipleRun.size[0],$
;                             YOFFSET   = RSDFMultipleRun.size[1],$
;                             SCR_XSIZE = RSDFMultipleRun.size[2],$
;                             SCR_YSIZE = RSDFMultipleRun.size[3],$
;                             UNAME     = RSDFMultipleRun.uname,$
;                             VALUE     = RSDFMultipleRun.value)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = RSDFListOfRuns.size[0],$
                         YOFFSET   = RSDFListOfRuns.size[1],$
                         SCR_XSIZE = RSDFListOfRuns.size[2],$
                         SCR_YSIZE = RSDFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = RSDFListOfRuns.uname,$
                         /EDITABLE)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = RSDFframe.size[0],$
                     YOFFSET   = RSDFframe.size[1],$
                     SCR_XSIZE = RSDFframe.size[2],$
                     SCR_YSIZE = RSDFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\
;Background Data File\
;\\\\\\\\\\\\\\\\\\\\\
label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = BDFlabel.size[0],$
                     YOFFSET = BDFlabel.size[1],$
                     VALUE   = BDFlabel.value,$
                     UNAME   = BDFlabel.uname)

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = BDFrunNumberBase.size[0],$
                   YOFFSET   = BDFrunNumberBase.size[1],$
                   SCR_XSIZE = BDFrunNumberBase.size[2],$
                   SCR_YSIZE = BDFrunNumberBase.size[3])

runNumber = CW_FIELD(base,$
                     UNAME         = BDFrunNumberBase.uname,$
                     TITLE         = BDFrunNumberBase.title,$
                     RETURN_EVENTS = 1,$
                     ROW           = 1,$
                     XSIZE         = BDFrunNumberBase.xsize)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = BDFbrowseButton.size[0],$
                            YOFFSET   = BDFbrowseButton.size[1],$
                            SCR_XSIZE = BDFbrowseButton.size[2],$
                            SCR_YSIZE = BDFbrowseButton.size[3],$
                            VALUE     = BDFbrowseButton.value,$
                            UNAME     = BDFbrowseButton.uname)

nexusBase = WIDGET_BASE(tab1_base,$
                        XOFFSET = BDFNexusField.size[0],$
                        YOFFSET = BDFNexusField.size[1],$
                        SCR_XSIZE = BDFNexusField.size[2],$
                        SCR_YSIZE = BDFNexusField.size[3])

nexusField = CW_FIELD(nexusBase,$
                      UNAME         = BDFNexusField.uname,$
                      RETURN_EVENTS = 1,$
                      TITLE         = BDFNexusField.title,$
                      ROW           = 1,$
                      XSIZE         = BDFNexusField.xsize)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = BDFListOfRuns.size[0],$
                         YOFFSET   = BDFListOfRuns.size[1],$
                         SCR_XSIZE = BDFListOfRuns.size[2],$
                         SCR_YSIZE = BDFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = BDFListOfRuns.uname,$
                         /EDITABLE)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = BDFframe.size[0],$
                     YOFFSET   = BDFframe.size[1],$
                     SCR_XSIZE = BDFframe.size[2],$
                     SCR_YSIZE = BDFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\
;Normalization Data File\
;\\\\\\\\\\\\\\\\\\\\\\\\
label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = NDFlabel.size[0],$
                     YOFFSET = NDFlabel.size[1],$
                     VALUE   = NDFlabel.value,$
                     UNAME   = NDFlabel.uname)

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = NDFrunNumberBase.size[0],$
                   YOFFSET   = NDFrunNumberBase.size[1],$
                   SCR_XSIZE = NDFrunNumberBase.size[2],$
                   SCR_YSIZE = NDFrunNumberBase.size[3])

runNumber = CW_FIELD(base,$
                     UNAME         = NDFrunNumberBase.uname,$
                     TITLE         = NDFrunNumberBase.title,$
                     RETURN_EVENTS = 1,$
                     ROW           = 1,$
                     XSIZE         = NDFrunNumberBase.xsize)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = NDFbrowseButton.size[0],$
                            YOFFSET   = NDFbrowseButton.size[1],$
                            SCR_XSIZE = NDFbrowseButton.size[2],$
                            SCR_YSIZE = NDFbrowseButton.size[3],$
                            VALUE     = NDFbrowseButton.value,$
                            UNAME     = NDFbrowseButton.uname)

nexusBase = WIDGET_BASE(tab1_base,$
                        XOFFSET = NDFNexusField.size[0],$
                        YOFFSET = NDFNexusField.size[1],$
                        SCR_XSIZE = NDFNexusField.size[2],$
                        SCR_YSIZE = NDFNexusField.size[3])

nexusField = CW_FIELD(nexusBase,$
                      UNAME         = NDFNexusField.uname,$
                      RETURN_EVENTS = 1,$
                      TITLE         = NDFNexusField.title,$
                      ROW           = 1,$
                      XSIZE         = NDFNexusField.xsize)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = NDFListOfRuns.size[0],$
                         YOFFSET   = NDFListOfRuns.size[1],$
                         SCR_XSIZE = NDFListOfRuns.size[2],$
                         SCR_YSIZE = NDFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = NDFListOfRuns.uname,$
                         /EDITABLE)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = NDFframe.size[0],$
                     YOFFSET   = NDFframe.size[1],$
                     SCR_XSIZE = NDFframe.size[2],$
                     SCR_YSIZE = NDFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\
;Empty Can Data File\
;\\\\\\\\\\\\\\\\\\\\
label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = ECDFlabel.size[0],$
                     YOFFSET = ECDFlabel.size[1],$
                     VALUE   = ECDFlabel.value,$
                     UNAME   = ECDFlabel.uname)

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = ECDFrunNumberBase.size[0],$
                   YOFFSET   = ECDFrunNumberBase.size[1],$
                   SCR_XSIZE = ECDFrunNumberBase.size[2],$
                   SCR_YSIZE = ECDFrunNumberBase.size[3])

runNumber = CW_FIELD(base,$
                     UNAME         = ECDFrunNumberBase.uname,$
                     TITLE         = ECDFrunNumberBase.title,$
                     RETURN_EVENTS = 1,$
                     ROW           = 1,$
                     XSIZE         = ECDFrunNumberBase.xsize)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = ECDFbrowseButton.size[0],$
                            YOFFSET   = ECDFbrowseButton.size[1],$
                            SCR_XSIZE = ECDFbrowseButton.size[2],$
                            SCR_YSIZE = ECDFbrowseButton.size[3],$
                            VALUE     = ECDFbrowseButton.value,$
                            UNAME     = ECDFbrowseButton.uname)

nexusBase = WIDGET_BASE(tab1_base,$
                        XOFFSET = ECDFNexusField.size[0],$
                        YOFFSET = ECDFNexusField.size[1],$
                        SCR_XSIZE = ECDFNexusField.size[2],$
                        SCR_YSIZE = ECDFNexusField.size[3])

nexusField = CW_FIELD(nexusBase,$
                      UNAME         = ECDFNexusField.uname,$
                      RETURN_EVENTS = 1,$
                      TITLE         = ECDFNexusField.title,$
                      ROW           = 1,$
                      XSIZE         = ECDFNexusField.xsize)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = ECDFListOfRuns.size[0],$
                         YOFFSET   = ECDFListOfRuns.size[1],$
                         SCR_XSIZE = ECDFListOfRuns.size[2],$
                         SCR_YSIZE = ECDFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         /EDITABLE,$
                         UNAME     = ECDFListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = ECDFframe.size[0],$
                     YOFFSET   = ECDFframe.size[1],$
                     SCR_XSIZE = ECDFframe.size[2],$
                     SCR_YSIZE = ECDFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Direct Scattering background\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = DSBlabel.size[0],$
                     YOFFSET = DSBlabel.size[1],$
                     VALUE   = DSBlabel.value,$
                     UNAME   = DSBlabel.uname)

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = DSBrunNumberBase.size[0],$
                   YOFFSET   = DSBrunNumberBase.size[1],$
                   SCR_XSIZE = DSBrunNumberBase.size[2],$
                   SCR_YSIZE = DSBrunNumberBase.size[3])

runNumber = CW_FIELD(base,$
                     UNAME         = DSBrunNumberBase.uname,$
                     TITLE         = DSBrunNumberBase.title,$
                     RETURN_EVENTS = 1,$
                     ROW           = 1,$
                     XSIZE         = DSBrunNumberBase.xsize)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = DSBbrowseButton.size[0],$
                            YOFFSET   = DSBbrowseButton.size[1],$
                            SCR_XSIZE = DSBbrowseButton.size[2],$
                            SCR_YSIZE = DSBbrowseButton.size[3],$
                            VALUE     = DSBbrowseButton.value,$
                            UNAME     = DSBbrowseButton.uname)

nexusBase = WIDGET_BASE(tab1_base,$
                        XOFFSET   = DSBNexusField.size[0],$
                        YOFFSET   = DSBNexusField.size[1],$
                        SCR_XSIZE = DSBNexusField.size[2],$
                        SCR_YSIZE = DSBNexusField.size[3])

nexusField = CW_FIELD(nexusBase,$
                      UNAME         = DSBNexusField.uname,$
                      RETURN_EVENTS = 1,$
                      TITLE         = DSBNexusField.title,$
                      ROW           = 1,$
                      XSIZE         = DSBNexusField.xsize)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = DSBListOfRuns.size[0],$
                         YOFFSET   = DSBListOfRuns.size[1],$
                         SCR_XSIZE = DSBListOfRuns.size[2],$
                         SCR_YSIZE = DSBListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         /EDITABLE,$
                         UNAME     = DSBListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = DSBframe.size[0],$
                     YOFFSET   = DSBframe.size[1],$
                     SCR_XSIZE = DSBframe.size[2],$
                     SCR_YSIZE = DSBframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

                       
END
