PRO MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;/////////////////////
;Raw Sample Data File/
;/////////////////////
frameSize = 4
RSDFframe     = { size  : [5,15,730,80]}
XYoff         = [10,-10]
RSDFlabel     = { size  : [RSDFframe.size[0]+XYoff[0],$
                           RSDFframe.size[1]+XYoff[1]],$
                  value : 'Raw Sample Data File'}

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
                              342,35],$
                      xsize : 50,$
                      title : 'or',$
                      uname : 'rsdf_nexus_cw_field'}
XYoff             = [337,0]
RSDFMultipleRun   = { base : {size : [RSDFNexusField.size[0] + XYoff[0],$
                                      RSDFNexusField.size[1] + XYoff[1],$
                                      90,35]},$
                      size : [0,0,10,30],$
                      value : 'Multi. Runs',$
                      uname : 'rsdf_multiple_runs_cw_group'}
               
XYoff = [10,40]
RSDFListOfRuns = { size : [XYoff[0],$
                           RSDFrunNumberBase.size[1]+XYoff[1],$
                           723,30],$
                   uname : 'rsdf_list_of_runs_text'}
                   

;/////////////////////
;Background Data File/
;/////////////////////
yoff = 95
BDFframe     = { size  : [5,RSDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
BDFlabel     = { size  : [BDFframe.size[0]+XYoff[0],$
                          BDFframe.size[1]+XYoff[1]],$
                  value : 'Background Data File'}

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
yoff = 95
NDFframe     = { size  : [5,BDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
NDFlabel     = { size  : [NDFframe.size[0]+XYoff[0],$
                          NDFframe.size[1]+XYoff[1]],$
                  value : 'Normalization Data File'}

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
yoff = 95
ECDFframe     = { size  : [5,NDFframe.size[1]+yoff,730,80]}
XYoff         = [10,-10]
ECDFlabel     = { size  : [ECDFframe.size[0]+XYoff[0],$
                          ECDFframe.size[1]+XYoff[1]],$
                  value : 'Empty Can Data File'}

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


;//////////////////////////////
;Pixel Region-of-interest file/
;//////////////////////////////
yoff = 95
PRoIFframe     = { size  : [5,ECDFframe.size[1]+yoff,730,50]}
XYoff         = [10,-10]
PRoIFlabel     = { size  : [PRoIFframe.size[0]+XYoff[0],$
                          PRoIFframe.size[1]+XYoff[1]],$
                  value : 'Pixel Region of Interest File'}

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
                  uname : 'proif_list_of_runs_text'}

;//////////////////////////////
;Alternate Instrument Geometry/
;//////////////////////////////
yoff = 65
AIGframe     = { size  : [5,PRoIFframe.size[1]+yoff,730,50]}
XYoff         = [10,-10]
AIGlabel     = { size  : [AIGframe.size[0]+XYoff[0],$
                          AIGframe.size[1]+XYoff[1]],$
                  value : 'Alternate Instrument Geometry'}

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

;////////////////
;Ouput file name/
;////////////////
yoff = 65
OFlabel     = { size  : [10,$
                          AIGframe.size[1]+yoff],$
                value : 'Outupt File Name:'}

XYoff             = [110,-8]
OFListOfRuns = { size : [OFlabel.size[0]+XYoff[0],$
                         OFlabel.size[1]+XYoff[1],$
                         620,30],$
                 uname : 'of_list_of_runs_text'}


;***********************************************************************************
;                                Build GUI
;***********************************************************************************
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
                     VALUE   = RSDFlabel.value)

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

base = WIDGET_BASE(tab1_base,$
                   XOFFSET   = RSDFMultipleRun.base.size[0],$
                   YOFFSET   = RSDFMultipleRun.base.size[1],$
                   SCR_XSIZE = RSDFMultipleRun.base.size[2],$
                   SCR_YSIZE = RSDFMultipleRun.base.size[3],$
                   /NONEXCLUSIVE)

MultipleRun = WIDGET_BUTTON(base,$
                            XOFFSET   = RSDFMultipleRun.size[0],$
                            YOFFSET   = RSDFMultipleRun.size[1],$
                            SCR_XSIZE = RSDFMultipleRun.size[2],$
                            SCR_YSIZE = RSDFMultipleRun.size[3],$
                            UNAME     = RSDFMultipleRun.uname,$
                            VALUE     = RSDFMultipleRun.value)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = RSDFListOfRuns.size[0],$
                         YOFFSET   = RSDFListOfRuns.size[1],$
                         SCR_XSIZE = RSDFListOfRuns.size[2],$
                         SCR_YSIZE = RSDFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = RSDFListOfRuns.uname)
                        
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
                     VALUE   = BDFlabel.value)

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
                         UNAME     = BDFListOfRuns.uname)
                        
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
                     VALUE   = NDFlabel.value)

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
                         UNAME     = NDFListOfRuns.uname)
                        
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
                     VALUE   = ECDFlabel.value)

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
                         UNAME     = ECDFListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = ECDFframe.size[0],$
                     YOFFSET   = ECDFframe.size[1],$
                     SCR_XSIZE = ECDFframe.size[2],$
                     SCR_YSIZE = ECDFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Pixel Region-of-interest file\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = PRoIFlabel.size[0],$
                     YOFFSET = PRoIFlabel.size[1],$
                     VALUE   = PRoIFlabel.value)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = PRoIFbrowseButton.size[0],$
                            YOFFSET   = PRoIFbrowseButton.size[1],$
                            SCR_XSIZE = PRoIFbrowseButton.size[2],$
                            SCR_YSIZE = PRoIFbrowseButton.size[3],$
                            VALUE     = PRoIFbrowseButton.value,$
                            UNAME     = PRoIFbrowseButton.uname)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = PRoIFListOfRuns.size[0],$
                         YOFFSET   = PRoIFListOfRuns.size[1],$
                         SCR_XSIZE = PRoIFListOfRuns.size[2],$
                         SCR_YSIZE = PRoIFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = PRoIFListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = PRoIFframe.size[0],$
                     YOFFSET   = PRoIFframe.size[1],$
                     SCR_XSIZE = PRoIFframe.size[2],$
                     SCR_YSIZE = PRoIFframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Alternate Instrument Geometry\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = AIGlabel.size[0],$
                     YOFFSET = AIGlabel.size[1],$
                     VALUE   = AIGlabel.value)

browseNexus = WIDGET_BUTTON(tab1_base,$
                            XOFFSET   = AIGbrowseButton.size[0],$
                            YOFFSET   = AIGbrowseButton.size[1],$
                            SCR_XSIZE = AIGbrowseButton.size[2],$
                            SCR_YSIZE = AIGbrowseButton.size[3],$
                            VALUE     = AIGbrowseButton.value,$
                            UNAME     = AIGbrowseButton.uname)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = AIGListOfRuns.size[0],$
                         YOFFSET   = AIGListOfRuns.size[1],$
                         SCR_XSIZE = AIGListOfRuns.size[2],$
                         SCR_YSIZE = AIGListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = AIGListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab1_base,$
                     XOFFSET   = AIGframe.size[0],$
                     YOFFSET   = AIGframe.size[1],$
                     SCR_XSIZE = AIGframe.size[2],$
                     SCR_YSIZE = AIGframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')


;\\\\\\\\\\\\\\\\\
;Output File Name\
;\\\\\\\\\\\\\\\\\
Label = WIDGET_LABEL(tab1_base,$
                     XOFFSET = OFlabel.size[0],$
                     YOFFSET = OFlabel.size[1],$
                     VALUE   = OFlabel.value)

ListOfRuns = WIDGET_TEXT(tab1_base,$
                         XOFFSET   = OFListOfRuns.size[0],$
                         YOFFSET   = OFListOfRuns.size[1],$
                         SCR_XSIZE = OFListOfRuns.size[2],$
                         SCR_YSIZE = OFListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         UNAME     = OFListOfRuns.uname)
                        

END
