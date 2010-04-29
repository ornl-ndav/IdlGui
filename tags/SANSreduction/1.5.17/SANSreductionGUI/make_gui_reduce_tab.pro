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

PRO make_gui_reduce_tab, MAIN_TAB, MainTabSize, TabTitles

  ;- base ----------------------------------------------------------------------
  sReduceBase = { size:  MainTabSize,$
    title: TabTitles.reduce,$
    uname: 'base_reduce'}
    
  sBigBase = { size: [sReduceBase.size[0],$
    sReduceBase.size[1]+60,$
    sReduceBase.size[2],$
    sReducebase.size[3]-220]}
    
  ;- Tab titles -----------------------------------------------------------------
  sReduceTab = { size:   [sReduceBase.size[0:2],$
    sReduceBase.size[3]-220],$ ;-160
    uname:  'reduce_tab',$
    title:  {tab1: ' LOAD FILES ',$
    tab2: ' PARAMETERS ',$
    tab3: ' INTERMEDIATE FILES'}}
    
  ;- data reduction status ------------------------------------------------------
  XYoff = [160,3]
  sDRstatus = { size:  [XYoff[0],$
    sBigBase.size[1]+sBigBase.size[3]+XYoff[1],$
    270,22],$
    uname: 'data_reduction_status_frame',$
    value: 'DR status:',$
    frame: 2}
    
  ;- GO DATA REDUCTION button ---------------------------------------------------
  XYoff = [450,0]
  sGobutton = { size:      [XYoff[0],$
    sBigBase.size[1]+sBigBase.size[3]+XYoff[1],$
    310,30],$
    uname:     'go_data_reduction_button',$
    value:     '> >> >>> RUN DATA REDUCTION <<< << <',$
    sensitive: 0}
    
  ;- Command Line status --------------------------------------------------------
  XYoff = [2,30]
  sCommandLine = { size:  [sBigBase.size[0]+XYoff[0],$
    sBigBase.size[1]+sBigBase.size[3]+XYoff[1],$
    750,$
    100],$
    uname: 'comamnd_line_preview'}
  XYoff = [5,-18]
  sCommandLineLabel = { size:  [sCommandLine.size[0]+XYoff[0],$
    sCommandLine.size[1]+XYoff[1]],$
    value: 'Command Line Status' }
    
  ;- DR gui status --------------------------------------------------------------
  XYoff = [5,0]
  sDRguiStatus = { size:  [sCommandLine.size[0]+sCommandLine.size[2]+XYoff[0],$
    sCommandLine.size[1]+XYoff[1],$
    240,$
    sCommandLine.size[3]-XYoff[1]],$
    uname: 'data_reduction_missing_arguments'}
  sDRguiLabel  = { size:  [sDRguiStatus.size[0]+50,$
    sDRguiStatus.size[1]-23],$
    uname: 'missing_arguments_label',$
    value: '   Missing Arguments   '}
    
  ;==============================================================================
  ;= BUILD GUI ==================================================================
  ;==============================================================================
    
  ;- base -----------------------------------------------------------------------
  wReduceBase = WIDGET_BASE(MAIN_TAB,$
    UNAME     = sReduceBase.uname,$
    XOFFSET   = sReduceBase.size[0],$
    YOFFSET   = sReduceBase.size[1],$
    SCR_XSIZE = sReduceBase.size[2],$
    SCR_YSIZE = sReduceBase.size[3],$
    TITLE     = sReduceBase.title)
    
  ;interruptor (SNS <-> JK's)
  button = WIDGET_DRAW(wReduceBase,$
    XOFFSET = 260,$
    YOFFSET = 5,$
    SCR_XSIZE = 500,$
    SCR_YSIZE = 50,$
    UNAME = 'reduction_interruptor',$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS)
    
  ;big base (SNS reduction)
  big_base = WIDGET_BASE(wReduceBase,$
    XOFFSET = sBigBase.size[0],$
    YOFFSET = sBigBase.size[1],$
    SCR_XSIZE = sBigBase.size[2],$
    SCR_YSIZE = sBigBase.size[3],$
    UNAME = 'sns_reduction_base')
    
  ;- Reduce Tabs ----------------------------------------------------------------
  REDUCE_TAB = WIDGET_TAB(big_base,$
    UNAME     = sReduceTab.uname,$
    LOCATION  = 0,$
    XOFFSET   = sReduceTab.size[0],$
    YOFFSET   = sReduceTab.size[1],$
    SCR_XSIZE = sReduceTab.size[2],$
    SCR_YSIZE = sReduceTab.size[3],$
    SENSITIVE = 1,$
    /TRACKING_EVENTS)
    
  sReduceTab.size[1] = sReduceTab.size[1]-25
  
  ;- Build LOAD FILES tab (tab #1) ----------------------------------------------
  make_gui_reduce_tab1, REDUCE_TAB, sReduceTab.size, sReduceTab.title.tab1
  
  ;- Build PARAMETERS tab (tab #4) ----------------------------------------------
  make_gui_reduce_tab2, REDUCE_TAB, sReduceTab.size, sReduceTab.title.tab2
  
  ;- Build INTERMEDIATE FILES tab (tab #4) --------------------------------------
  make_gui_reduce_tab3, REDUCE_TAB, sReduceTab.size, sReduceTab.title.tab3
  
  ;- data reduction status ------------------------------------------------------
  wDRstatus = WIDGET_LABEL(wReduceBase,$
    UNAME     = sDRstatus.uname,$
    XOFFSET   = sDRstatus.size[0],$
    YOFFSET   = sDRstatus.size[1],$
    SCR_XSIZE = sDRstatus.size[2],$
    SCR_YSIZE = sDRstatus.size[3],$
    VALUE     = sDRstatus.value,$
    FRAME     = sDRstatus.frame,$
    /ALIGN_LEFT)
    
  ;- GO data reduction button ---------------------------------------------------
  wGoButton = WIDGET_BUTTON(wReduceBase,$
    XOFFSET   = sGoButton.size[0],$
    YOFFSET   = sGoButton.size[1],$
    SCR_XSIZE = sGoButton.size[2],$
    SCR_YSIZE = sGoButton.size[3],$
    UNAME     = sGoButton.uname,$
    VALUE     = sGoButton.value,$
    SENSITIVE = sGoButton.sensitive)
    
  ;- Command Line status --------------------------------------------------------
  wCommandLine = WIDGET_TEXT(wReduceBase,$
    XOFFSET   = sCommandLine.size[0],$
    YOFFSET   = sCommandLine.size[1],$
    SCR_XSIZE = sCommandLine.size[2],$
    SCR_YSIZE = sCommandLine.size[3],$
    UNAME     = sCommandLine.uname,$
    /WRAP,$
    /SCROLL)
    
  wCommandLineLabel = WIDGET_LABEL(wReduceBase,$
    XOFFSET = sCommandLineLabel.size[0],$
    YOFFSET = sCommandLineLabel.size[1],$
    VALUE   = sCommandLineLabel.value)
    
  ;- DR gui status --------------------------------------------------------------
  wDRguilabel = WIDGET_LABEL(wReduceBase,$
    XOFFSET = sDRguiLabel.size[0],$
    YOFFSET = sDRguiLabel.size[1],$
    VALUE   = sDRguiLabel.value,$
    UNAME   = sDRguiLabel.uname)
    
  wDRguiStatus = WIDGET_TEXT(wReduceBase,$
    UNAME     = sDRguiStatus.uname,$
    XOFFSET   = sDRguiStatus.size[0],$
    YOFFSET   = sDRguiStatus.size[1],$
    SCR_XSIZE = sDRguiStatus.size[2],$
    SCR_YSIZE = sDRguiStatus.size[3],$
    /SCROLL,$
    /WRAP)

  ;second big base (JK's reduction)
  jk_base = WIDGET_BASE(wReduceBase,$
    XOFFSET = sBigBase.size[0],$
    YOFFSET = sBigBase.size[1],$
    SCR_XSIZE = sBigBase.size[2],$
    SCR_YSIZE = sBigBase.size[3],$
    UNAME = 'jk_reduction_base')
    
  jk_tab = WIDGET_TAB(jk_base,$
    UNAME     = 'jk_reduction_tab',$
    LOCATION  = 0,$
    XOFFSET   = sReduceTab.size[0],$
    YOFFSET   = sReduceTab.size[1],$
    SCR_XSIZE = sReduceTab.size[2],$
    SCR_YSIZE = sReduceTab.size[3],$
    SENSITIVE = 1,$
    /TRACKING_EVENTS)

  ;- Build input tab
  make_gui_reduce_jk_tab1, jk_tab, sReduceTab.size, '  INPUT  '
  
  ;- build output tab
  make_gui_reduce_jk_tab2, jk_tab, sReduceTab.size, '  OUTPUT  '
  
  ;- build advanced tab
  make_gui_reduce_jk_tab3, jk_tab, sReduceTab.size, '  ADVANCED  '
  
END
