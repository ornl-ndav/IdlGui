PRO MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

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

;////////////////
;Ouput file name/
;////////////////
OFlabel     = { size  : [10,$
                         AIGframe.size[1]+yoff],$
                value : 'Outupt File Name:',$
                uname : 'of_label'}

XYoff             = [110,-8]
OFListOfRuns = { size : [OFlabel.size[0]+XYoff[0],$
                         OFlabel.size[1]+XYoff[1],$
                         620,32],$
                 uname : 'of_list_of_runs_text'}


;***********************************************************************************
;                                Build GUI
;***********************************************************************************
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
                         SCR_YSIZE = PRoIFListOfRuns.size[3],$
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
                         SCR_YSIZE = AIGListOfRuns.size[3],$
                         /ALIGN_LEFT,$
                         /EDITABLE,$
                         UNAME     = AIGListOfRuns.uname)
                        
frame = WIDGET_LABEL(tab2_base,$
                     XOFFSET   = AIGframe.size[0],$
                     YOFFSET   = AIGframe.size[1],$
                     SCR_XSIZE = AIGframe.size[2],$
                     SCR_YSIZE = AIGframe.size[3],$
                     FRAME     = frameSize,$
                     VALUE     = '')

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
