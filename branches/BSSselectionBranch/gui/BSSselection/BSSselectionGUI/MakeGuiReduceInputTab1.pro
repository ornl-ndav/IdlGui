PRO MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;/////////////////////
;Raw Sample Data File/
;/////////////////////
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
BDFframe     = { size  : [5,15+yoff,730,80]}
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
                     FRAME     = 1,$
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
                     FRAME     = 1,$
                     VALUE     = '')








END
