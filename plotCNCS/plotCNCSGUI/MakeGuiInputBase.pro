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

PRO MakeGuiInputBase, MAIN_BASE, MainBaseSize


;*******************************************************************************
;                           Define size arrays
;*******************************************************************************

base   = { size  : [0,0,MainBaseSize[2:3]],$
           uname : 'create_histo_mapped_base'} 

;/////////////////Histo and Nexus tab///////////////////////////////////////////
HistoNexusTab = { size  : [0, $
                           0, $
                           MainBaseSize[2],$
                           395],$
                  uname : 'histo_nexus_tab'}

;///////////////////////////////////////////////////////////////////////////////
;////////////////Histo base/////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////
HistoBase = { size  : [0,0,MainBaseSize[2],HistoNexusTab.size[3]],$
              title : 'DAS PRENEXUS FILES'} 

;///////////////////INPUT BASE//////////////////////////////////////////////////
iFrame1 = { size  : [5,10,MainBaseSize[2]-15,95],$
            frame : 1}

XYoff    = [10,-8]
iLabel1  = { size  : [iFrame1.size[0]+XYoff[0],$
                      iFrame1.size[1]+XYoff[1]],$
             value : 'I N P U T'}

XYoff       = [20,10]
iBaseField1 = { size  : [iFrame1.size[0]+XYoff[0],$
                         iFrame1.size[1]+XYoff[1],$
                         120,$
                         35],$
                sensitive  : 1,$
                title      : 'Run #',$
                xsize      : 10,$
                base_uname : 'run_number_base',$
                uname      : 'run_number'}

XYoff   = [10,10]
iLabel2 = { size  : [iBaseField1.size[0]+iBaseField1.size[2]+XYoff[0],$
                     iBaseField1.size[1]+XYoff[1]],$
            value : 'OR'}

XYoff    = [30,-5]
iButton1 = { size  : [iLabel2.size[0]+XYoff[0],$
                      iLabel2.size[1]+XYoff[1],$
                      350,30],$
             uname : 'browse_event_file_button',$
             value : 'B R O W S E   E V E N T   F I L E ...'}
                      
;Display runinfo file
XYOff    = [0,0]
iDisplayButton = { size      : [iButton1.size[0]+iButton1.size[2]+XYoff[0],$
                                iButton1.size[1],$
                                140,30],$
                   value     : 'PREVIEW RUNINFO FILE',$
                   uname     : 'preview_runinfo_file',$
                   sensitive : 0}

XYoff   = [0,50]
iElabel = { size  : [iBaseField1.size[0]+XYoff[0],$
                     iBaseField1.size[1]+XYoff[1]],$
            value : 'Event File:'}
XYoff   = [70,-5]
iEtext  = { size  : [iElabel.size[0]+XYoff[0],$
                     iElabel.size[1]+XYoff[1],$
                     580,30],$
            value : '',$
            uname : 'event_file'}

;///////////////////HISTOGRAMMING BASE//////////////////////////////////////////
XYoff   = [0,20]
histogramming_sensitive = 0
iFrame3 = {size  : [iFrame1.size[0]+XYoff[0],$
                    iFrame1.size[1]+iFrame1.size[3]+XYoff[1], $
                    MainBaseSize[2]-15,53], $
           uname : 'histo_frame',$
           frame : 1}

XYoff    = [10,-8]
iLabel4  = { size  : [iFrame3.size[0]+XYoff[0],$
                      iFrame3.size[1]+XYoff[1]],$
             uname : 'histo_frame_label',$
             value : 'H I S T O G R A M M I N G - (*) : mandatory fields'}

Xoff     = 10 ;x_off between two label/text consecutive parts
;----------------
XYoff    = [15,20]
iLabel5  = { size  : [iFrame3.size[0]+XYoff[0],$
                      iFrame3.size[1]+XYoff[1]],$
             value : 'Min. time bin:',$
             uname : 'min_time_bin_label'}
XYoff    = [90,-5]
iText1   = { size  : [iLabel5.size[0]+XYoff[0],$
                      iLabel5.size[1]+XYoff[1],$
                      50,30],$
             uname : 'min_time_bin',$
             value : ''}
             
;---------------
XYoff    = [10+Xoff,0]
iLabel6  = { size  : [iText1.size[0]+iText1.size[2]+XYoff[0],$
                      iLabel5.size[1]],$
             value : 'Max. time bin:           (*)',$
             uname : 'max_time_bin_label'}
XYoff    = [90,-5]
iText2   = { size  : [iLabel6.size[0]+XYoff[0],$
                      iLabel6.size[1]+XYoff[1],$
                      60,30],$
             uname : 'max_time_bin',$
             value : ''}

;---------------
XYoff    = [30+Xoff,0]
iLabel7  = { size  : [iText2.size[0]+iText2.size[2]+XYoff[0],$
                      iLabel5.size[1]],$
             value : 'Bin width:            (*)',$
             uname : 'bin_width_label'}
XYoff    = [70,-5]
iText3   = { size  : [iLabel7.size[0]+XYoff[0],$
                      iLabel7.size[1]+XYoff[1],$
                      60,30],$
             uname : 'bin_width',$
             value : ''}

;---------------
XYoff    = [30+Xoff,0]
iLabel8  = { size  : [iText3.size[0]+iText3.size[2]+XYoff[0],$
                      iLabel5.size[1]],$
             value : 'Bin type:',$
             uname : 'bin_type_label'}
XYoff      = [53,-9]
iDroplist2 = { size  : [iLabel8.size[0]+XYoff[0],$
                        iLabel8.size[1]+XYoff[1]],$
               uname : 'bin_type_droplist',$
               list  : ['Linear','Log.']}
 

;///////////////////MAPPING FILE  BASE//////////////////////////////////////////
XYOFF   = [0,20]
iFrame2 = { size  : [iFrame3.size[0]+XYoff[0], $
                     iFrame3.size[1]+iFrame3.size[3]+XYoff[1], $
                     MainBaseSize[2]-15,53], $
            uname : 'mapping_frame',$
            frame : 1}

XYoff    = [10,-8]
iLabel3  = { size  : [iFrame2.size[0]+XYoff[0],$
                      iFrame2.size[1]+XYoff[1]],$
             uname : 'mapping_label',$
             value : 'M A P P I N G   F I L E'}

XYoff      = [10,10]
iDroplist1 = { size      : [iFrame2.size[0]+XYoff[0],$
                            iFrame2.size[1]+XYoff[1]],$
               uname     : 'mapping_droplist',$
               sensitive : 1,$
               list      : '                                        ' + $
               '                      '}

;/////////////////////CREATE HISTO BASE//////////////////////////////////////////
XYoff    = [0,20]
iFrameCH = { size  : [iFrame2.size[0]+XYoff[0],$
                      iFrame2.size[1]+iFrame2.size[3]+XYoff[1],$
                      MainBaseSize[2]-15,90],$
             frame : 1}
XYoff     = [10,-8]
iLabelCH  = { size  : [iFrameCH.size[0]+XYoff[0],$
                       iFrameCH.size[1]+XYoff[1]],$
              value : 'C R E A T E / G E T   H I S T O _ M A P P E D' + $
              '    F I L E '}
XYoff     = [10,15]
iButtonCH = { size  : [iFrameCH.size[0]+XYoff[0],$
                       iFrameCH.size[1]+XYoff[1],$
                       310,30],$
              value : 'C R E A T E   H I S T O _ M A P P E D',$
              uname : 'create_histo_mapped_button'}
XYoff     = [5,7]
iLabelCH1 = { size  : [iButtonCH.size[0]+iButtonCH.size[2]+XYoff[0],$
                       iButtonCH.size[1]+XYoff[1]],$
              value : 'OR'}
XYoff     = [20,0]
iButtonCH1 = { size  : [iLabelCh1.size[0]+XYoff[0],$
                        iButtonCH.size[1]+XYoff[1],$
                        330,$
                        iButtonCH.size[3]],$
               value : 'B R O W S E   H I S T O _ M A P P E D   F I L E ...',$
               uname : 'browse_histo_mapped_button'}
XYoff     = [0,10]
iTextCH   = { size  : [iButtonCH.size[0]+XYoff[0],$
                       iButtonCH.size[1]+iButtonCH.size[3]+XYoff[1],$
                       565,33],$
              value : '',$
              uname : 'histo_mapped_text_field'}
XYoff      = [0,0]
iButtonCH2 = { size      : [iTextCH.size[0]+iTextCH.size[2]+XYoff[0],$
                            iTextCH.size[1]+XYoff[1],$
                            100,33],$
               value     : 'SAVE AS ...',$
               sensitive : 0,$
               uname     : 'save_as_histo_mapped_button'}

;///////////////////////////////////////////////////////////////////////////////
;////////////////Nexus base/////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////
NexusBase = { size  : [0,0,MainBaseSize[2],HistoNexusTab.size[3]],$
              title : 'NEXUS FILES'} 

;///////////////////////////////////////////////////////////////////////////////
;/////////////////// PLOT //////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////
XYoff  = [0,45]
iButtonP =  { size      : [iFrameCH.size[0]+XYoff[0],$
                           iFrameCH.size[1]+iFrameCH.size[3]+XYoff[1],$
                           MainBaseSize[2]-10,35],$
              uname     : 'plot_button',$
              value     : '> > > >     > > >     > >     >     P  L  O  T  ' + $
              '   <     < <     < < <     < < < <',$
              sensitive : 0} 

;///////////////// STATUS ///////////////////////////////////////////
XYoff  = [5,15]
iStatusLabel = { size  : [iButtonP.size[0]+XYoff[0],$
                          iButtonP.size[1]+iButtonP.size[3]+XYoff[1],$
                          MainBaseSize[2]-20,30],$
                 value : '',$
                 frame : 1,$
                 uname : 'status_label'}

;//////////////// SEND TO GEEK //////////////////////////////////////
XYoff     = [0,50]
iFrameSTG = { size  : [iStatusLabel.size[0]+XYoff[0],$
                       iStatusLabel.size[1]+XYoff[1],$
                       MainBaseSize[2]-20,45],$
              frame : 1}
XYoff    = [10,-8]
iLabelSTG  = { size  : [iFrameSTG.size[0]+XYoff[0],$
                        iFrameSTG.size[1]+XYoff[1]],$
               value : 'S E N D   T O   G E E K'}
                         
XYoff      = [5,25]
iSTGMlabel = { size  : [iLabelSTG.size[0]+XYoff[0],$
                        iLabelSTG.size[1]+XYoff[1]],$
               value : 'Message:',$
               uname : 'send_to_geek_message_label'}
XYoff      = [60,-7]
iSTGtext   = { size  : [iSTGMlabel.size[0]+XYoff[0],$
                        iSTGMlabel.size[1]+XYoff[1],$
                        500,33],$
               uname : 'send_to_geek_message_text',$
               value : '>> Put your message here <<'}
XYoff      = [5,0]
iSTGbutton = { size  : [iSTGtext.size[0]+iSTGtext.size[2]+XYoff[0],$
                        iSTGtext.size[1],$
                        100,30],$
               value : 'SEND TO GEEK',$
               uname : 'send_to_geek_button'}

;/////////////////////// LOG BOOK ////////////////////////////////////
XYoff      = [0,15]
iLogBook   = { size  : [iFrameSTG.size[0]+XYoff[0],$
                        iFrameSTG.size[1]+iFrameSTG.size[3]+XYoff[1],$
                        MainBaseSize[2]-15,$
                        160],$
               uname : 'log_book'}
               
;********************************************************************************
;                                Build GUI
;********************************************************************************
wBase = WIDGET_BASE(MAIN_BASE,$
                    UNAME     = base.uname,$
                    XOFFSET   = 0,$
                    YOFFSET   = 0,$
                    SCR_XSIZE = base.size[2],$
                    SCR_YSIZE = base.size[3],$
                    map       = 1)

;\\\\\\\\\\\\\\\\\\Histo and Nexus tabs\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wHistoNexusTab = WIDGET_TAB(wBase,$
                            XOFFSET   = HistoNexusTab.size[0],$
                            YOFFSET   = HistoNexusTab.size[1],$
                            SCR_XSIZE = HistoNexusTab.size[2],$
                            SCR_YSIZE = HistoNexusTab.size[3],$
                            UNAME     = HistoNexusTab.uname,$
                            LOCATION  = 0,$
                            /TRACKING_EVENTS)
                       
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\ NeXus base \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wNexusBase = WIDGET_BASE(wHistoNexusTab,$
                         XOFFSET   = NexusBase.size[0],$
                         YOFFSET   = NexusBase.size[1],$
                         SCR_XSIZE = NexusBase.size[2],$
                         SCR_YSIZE = NexusBase.size[3],$
                         TITLE     = NexusBase.title)

sInput = { MainBase              : wNexusBase,$
           ListInstr             : ['CNCS'],$
           DefaultInstr          : 'CNCS'}

instanceGui = OBJ_NEW('IDLloadNexus',sInput)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\ PLOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wButtonP = WIDGET_BUTTON(wBase,$
                         XOFFSET   = iButtonP.size[0],$
                         YOFFSET   = iButtonP.size[1],$
                         SCR_XSIZE = iButtonP.size[2],$
                         SCR_YSIZE = iButtonP.size[3],$
                         UNAME     = iButtonP.uname,$
                         VALUE     = iButtonP.value,$
                         SENSITIVE = iButtonP.sensitive)

;\\\\\\\\\\\\\\\\\\STATUS LABEL\\\\\\\\\\\\\\\\\\\\\\\\\
wStatusLabel = WIDGET_LABEL(wBase,$
                            XOFFSET   = iStatusLabel.size[0],$
                            YOFFSET   = iStatusLabel.size[1],$
                            SCR_XSIZE = iStatusLabel.size[2],$
                            SCR_YSIZE = iStatusLabel.size[3],$
                            VALUE     = iStatusLabel.value,$
                            UNAME     = iStatusLabel.uname,$
                            FRAME     = iStatusLabel.frame,$
                            /ALIGN_LEFT)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\Histo Base\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wHistoBase = WIDGET_BASE(wHistoNexusTab,$
                         XOFFSET   = HistoBase.size[0],$
                         YOFFSET   = HistoBase.size[1],$
                         SCR_XSIZE = HistoBase.size[2],$
                         SCR_YSIZE = HistoBase.size[3],$
                         TITLE     = HistoBase.title)

;\\\\\\\\\\\\\\\\\\\INPUT BASE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLabel1 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET = iLabel1.size[0],$
                       YOFFSET = iLabel1.size[1],$
                       VALUE   = iLabel1.value)

wBase1 = WIDGET_BASE(wHistoBase,$
                     XOFFSET   = iBaseField1.size[0],$
                     YOFFSET   = iBaseField1.size[1],$
                     SCR_XSIZE = iBaseField1.size[2],$
                     SCR_YSIZE = iBaseField1.size[3],$
                     UNAME     = iBaseField1.base_uname,$
                     SENSITIVE = iBaseField1.sensitive)

wField1 = CW_FIELD(wBase1,$
                   XSIZE         = iBaseField1.xsize,$
                   ROW           = 1,$
                   UNAME         = iBaseField1.uname,$
                   RETURN_EVENTS = 1,$
                   TITLE         = iBaseField1.title,$
                   /LONG)

wLabel2 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET = iLabel2.size[0],$
                       YOFFSET = iLabel2.size[1],$
                       VALUE   = iLabel2.value)

wButton1 = WIDGET_BUTTON(wHistoBase,$
                         XOFFSET   = iButton1.size[0],$
                         YOFFSET   = iButton1.size[1],$
                         SCR_XSIZE = iButton1.size[2],$
                         SCR_YSIZE = iButton1.size[3],$
                         UNAME     = iButton1.uname,$
                         VALUE     = iButton1.value)

;display runinfo file
wDisplayButton = WIDGET_BUTTON(wHistoBase,$
                               XOFFSET   = iDisplayButton.size[0],$
                               YOFFSET   = iDisplayButton.size[1],$
                               SCR_XSIZE = iDisplayButton.size[2],$
                               SCR_YSIZE = iDisplayButton.size[3],$
                               UNAME     = iDisplayButton.uname,$
                               SENSITIVE = iDisplayButton.sensitive,$
                               VALUE     = iDisplayButton.value)

wElabel = WIDGET_LABEL(wHistoBase,$
                       XOFFSET = iElabel.size[0],$
                       YOFFSET = iElabel.size[1],$
                       VALUE   = iElabel.value)

wEtext = WIDGET_TEXT(wHistoBase,$
                     XOFFSET   = iEtext.size[0],$
                     YOFFSET   = iEtext.size[1],$
                     SCR_XSIZE = iEtext.size[2],$
                     SCR_YSIZE = iEtext.size[3],$
                     UNAME     = iEtext.uname,$
                     /ALL_EVENTS,$
                     /EDITABLE)

wFrame1 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iFrame1.size[0],$
                       YOFFSET   = iFrame1.size[1],$
                       SCR_XSIZE = iFrame1.size[2],$
                       SCR_YSIZE = iFrame1.size[3],$
                       FRAME     = iFrame1.frame,$
                       VALUE     = '')

;\\\\\\\\\\\\\\\\\\\HISTOGRAMMING\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLabel4 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel4.size[0],$
                       YOFFSET   = iLabel4.size[1],$
                       VALUE     = iLabel4.value,$
                       UNAME     = iLabel4.uname,$
                       SENSITIVE = histogramming_sensitive)

wText1 = WIDGET_TEXT(wHistoBase,$
                     XOFFSET   = iText1.size[0],$
                     YOFFSET   = iText1.size[1],$
                     SCR_XSIZE = iText1.size[2],$
                     SCR_YSIZE = iText1.size[3],$
                     UNAME     = iText1.uname,$
                     SENSITIVE = histogramming_sensitive,$
                     /EDITABLE,$
                     /ALIGN_LEFT)

wLabel5 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel5.size[0],$
                       YOFFSET   = iLabel5.size[1],$
                       VALUE     = iLabel5.value,$
                       UNAME     = iLabel5.uname,$
                       SENSITIVE = histogramming_sensitive)

wText2 = WIDGET_TEXT(wHistoBase,$
                     XOFFSET   = iText2.size[0],$
                     YOFFSET   = iText2.size[1],$
                     SCR_XSIZE = iText2.size[2],$
                     SCR_YSIZE = iText2.size[3],$
                     UNAME     = iText2.uname,$
                     SENSITIVE = histogramming_sensitive,$
                     /ALL_EVENTS,$
                     /EDITABLE,$
                     /ALIGN_LEFT)

wLabel6 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel6.size[0],$
                       YOFFSET   = iLabel6.size[1],$
                       VALUE     = iLabel6.value,$
                       UNAME     = iLabel6.uname,$
                       SENSITIVE = histogramming_sensitive)

wText1 = WIDGET_TEXT(wHistoBase,$
                     XOFFSET   = iText3.size[0],$
                     YOFFSET   = iText3.size[1],$
                     SCR_XSIZE = iText3.size[2],$
                     SCR_YSIZE = iText3.size[3],$
                     UNAME     = iText3.uname,$
                     SENSITIVE = histogramming_sensitive,$
                     /ALL_EVENTS,$
                     /EDITABLE,$
                     /ALIGN_LEFT)

wLabel7 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel7.size[0],$
                       YOFFSET   = iLabel7.size[1],$
                       VALUE     = iLabel7.value,$
                       UNAME     = iLabel7.uname,$
                       SENSITIVE = histogramming_sensitive)

wLabel8 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel8.size[0],$
                       YOFFSET   = iLabel8.size[1],$
                       VALUE     = iLabel8.value,$
                       UNAME     = iLabel8.uname,$
                       SENSITIVE = histogramming_sensitive)

wDroplist2 = WIDGET_DROPLIST(wHistoBase,$
                             VALUE     = iDroplist2.list,$
                             XOFFSET   = iDroplist2.size[0],$
                             YOFFSET   = iDroplist2.size[1],$
                             UNAME     = iDroplist2.uname,$
                             SENSITIVE = histogramming_sensitive,$
                             /DYNAMIC_RESIZE)

wFrame3 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iFrame3.size[0],$
                       YOFFSET   = iFrame3.size[1],$
                       SCR_XSIZE = iFrame3.size[2],$
                       SCR_YSIZE = iFrame3.size[3],$
                       FRAME     = iFrame3.frame,$
                       UNAME     = iFrame3.uname,$
                       VALUE     = '',$
                       SENSITIVE = histogramming_sensitive)

;\\\\\\\\\\\\\\\\\\\MAPPING FILE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLabel3 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iLabel3.size[0],$
                       YOFFSET   = iLabel3.size[1],$
                       UNAME     = iLabel3.uname,$
                       SENSITIVE = histogramming_sensitive,$
                       VALUE     = iLabel3.value)

wDroplist1 = WIDGET_DROPLIST(wHistoBase,$
                             VALUE     = iDroplist1.list,$
                             XOFFSET   = iDroplist1.size[0],$
                             YOFFSET   = iDroplist1.size[1],$
                             UNAME     = iDroplist1.uname,$
                             SENSITIVE = histogramming_sensitive,$
                             /DYNAMIC_RESIZE)

wFrame2 = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iFrame2.size[0],$
                       YOFFSET   = iFrame2.size[1],$
                       SCR_XSIZE = iFrame2.size[2],$
                       SCR_YSIZE = iFrame2.size[3],$
                       FRAME     = iFrame2.frame,$
                       UNAME     = iFrame2.uname,$
                       SENSITIVE = histogramming_sensitive,$
                       VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\CREATE HISTO BASE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLabelCH = WIDGET_LABEL(wHistoBase,$
                       XOFFSET = iLabelCH.size[0],$
                       YOFFSET = iLabelCH.size[1],$
                       VALUE   = iLabelCH.value)

wButtonCH = WIDGET_BUTTON(wHistoBase,$
                          XOFFSET   = iButtonCH.size[0],$
                          YOFFSET   = iButtonCH.size[1],$
                          SCR_XSIZE = iButtonCH.size[2],$
                          SCR_YSIZE = iButtonCH.size[3],$
                          VALUE     = iButtonCH.value,$
                          SENSITIVE = histogramming_sensitive,$
                          UNAME     = iButtonCH.uname)

iLabelCH1 = WIDGET_LABEL(wHistoBase,$
                         XOFFSET = iLabelCH1.size[0],$
                         YOFFSET = iLabelCH1.size[1],$
                         VALUE   = iLabelCH1.value)
                         
wButtonCH1 = WIDGET_BUTTON(wHistoBase,$
                           XOFFSET   = iButtonCH1.size[0],$
                           YOFFSET   = iButtonCH1.size[1],$
                           SCR_XSIZE = iButtonCH1.size[2],$
                           SCR_YSIZE = iButtonCH1.size[3],$
                           VALUE     = iButtonCH1.value,$
                           UNAME     = iButtonCH1.uname)

wTextCH = WIDGET_TEXT(wHistoBase,$
                      XOFFSET   = iTextCH.size[0],$
                      YOFFSET   = iTextCH.size[1],$
                      SCR_XSIZE = iTextCH.size[2],$
                      SCR_YSIZE = iTextCH.size[3],$
                      UNAME     = iTextCH.uname,$
                      VALUE     = iTextCH.value,$
                      /ALL_EVENTS,$
                      /ALIGN_LEFT,$
                      /EDITABLE)

wButtonCH2 = WIDGET_BUTTON(wHistoBase,$
                           XOFFSET   = iButtonCH2.size[0],$
                           YOFFSET   = iButtonCH2.size[1],$
                           SCR_XSIZE = iButtonCH2.size[2],$
                           SCR_YSIZE = iButtonCH2.size[3],$
                           VALUE     = iButtonCH2.value,$
                           UNAME     = iButtonCH2.uname,$
                           SENSITIVE = iButtonCH2.sensitive)

wFrameCH = WIDGET_LABEL(wHistoBase,$
                       XOFFSET   = iFrameCH.size[0],$
                       YOFFSET   = iFrameCH.size[1],$
                       SCR_XSIZE = iFrameCH.size[2],$
                       SCR_YSIZE = iFrameCH.size[3],$
                       FRAME     = iFrameCH.frame,$
                       VALUE     = '')

;\\\\\\\\\\\\\\\\\\SEND TO GEEK\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLabelSTG = WIDGET_LABEL(wBase,$
                         XOFFSET = iLabelSTG.size[0],$
                         YOFFSET = iLabelSTG.size[1],$
                         VALUE   = iLabelSTG.value)

wLabelSTGM = WIDGET_LABEL(wBase,$
                          XOFFSET = iSTGMlabel.size[0],$
                          YOFFSET = iSTGMlabel.size[1],$
                          VALUE   = iSTGMlabel.value,$
                          UNAME   = iSTGMlabel.uname)

wSTGtext = WIDGET_TEXT(wBase,$
                       XOFFSET   = iSTGtext.size[0],$
                       YOFFSET   = iSTGtext.size[1],$
                       SCR_XSIZE = iSTGtext.size[2],$
                       SCR_YSIZE = iSTGtext.size[3],$
                       UNAME     = iSTGtext.uname,$
                       VALUE     = iSTGtext.value,$
                       /EDITABLE,$
                       /ALIGN_LEFT)

WSTGbutton = WIDGET_BUTTON(wBase,$
                           XOFFSET = iSTGbutton.size[0],$
                           YOFFSET = iSTGbutton.size[1],$
                           SCR_XSIZE = iSTGbutton.size[2],$
                           SCR_YSIZE = iSTGbutton.size[3],$
                           VALUE     = iSTGbutton.value,$
                           UNAME     = iSTGbutton.uname)

wFrameSTG = WIDGET_LABEL(wBase,$
                         XOFFSET   = iFrameSTG.size[0],$
                         YOFFSET   = iFrameSTG.size[1],$
                         SCR_XSIZE = iFrameSTG.size[2],$
                         SCR_YSIZE = iFrameSTG.size[3],$
                         FRAME     = iFrameSTG.frame,$
                         VALUE     = '')

;\\\\\\\\\\\\\\\\\\\\\ LOG BOOK \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wLogBook = WIDGET_TEXT(wBase,$
                       XOFFSET = iLogBook.size[0],$
                       YOFFSET = iLogBook.size[1],$
                       SCR_XSIZE = iLogBook.size[2],$
                       SCR_YSIZE = iLogBook.size[3],$
                       UNAME     = iLogBook.uname,$
                       /SCROLL,$
                       /WRAP)


END
