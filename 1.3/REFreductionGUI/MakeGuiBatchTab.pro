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

PRO MakeGuiBatchTab, MAIN_TAB, MainTabSize, BatchTabTitle, structure

  ;check if we want LAUNCH REFSCALE button or not
  with_launch_button = structure.with_launch_button
  
  ;******************************************************************************
  ;                           Define size arrays
  ;                 [xoffset, yoffset, scr_xsize, scr_ysize]
  ;******************************************************************************
  ;Main Base
  BatchTab = { size  : [0,0,MainTabSize[2],MainTabSize[3]],$
    uname : 'batch_base',$
    title : BatchTabTitle }
    
  ;////////////////////////////////////////////////////////
  ;Processing base
  ProBase = { size  : [350,250,500,50],$ ;50->365
    uname : 'processing_base',$
    frame : 5}
  value = 'PROCESSING  NEW  DATA  INPUT  . . .  ( P L E A S E   W A I T ) '
  ProLabel = { size  : [0,0,495,45],$
    uname : 'pro_top_label',$
    frame : 2,$
    value : value}
    
  XYoff = [0,35]
  value = '___________________________________________________________________'
  value += '__________________'
  ProLign = { size  : [XYoff[0], $
    ProLabel.size[1]+XYoff[1]],$
    value : value }
    
  XYoff = [10,35]
  ProLabel2 = { size  : [XYoff[0], $
    ProLign.size[1]+XYoff[1]],$
    value : 'The DATA runs you entered DO NOT have the same ' + $
    'Angle, S1 or S2 parameters values.'}
    
  XYoff = [35,35]
  TableAlign = INTARR(4,10)+1
  ProTable = { size         : [XYoff[0],$
    ProLabel2.size[1]+XYoff[1],$
    430, $
    200,$
    4, $
    10],$
    uname        : 'pro_table',$
    sensitive    : 1,$
    label        : ['Run #',$
    'Angle (deg.)',$
    'S1 (mm)',$
    'S2 (mm)'],$
    align        : TableAlign,$
    column_width : [100,100,100,100]}
    
  XYoff = [10,20]
  ProQLabel = { size  : [XYoff[0],$
    ProTable.size[1]+ProTable.size[3]+XYoff[1]],$
    value : 'DO YOU WANT TO VALIDATE THE NEW INPUT ANYWAY ?'}
  XYoff = [295,-8]
  ProYesButton = { size  : [ProQLabel.size[0]+XYoff[0],$
    ProQLabel.size[1]+XYoff[1],$
    90,35],$
    uname : 'pro_yes',$
    value : 'Y E S'}
  XYoff = [10,0]
  ProNoButton = { size  : [ProYesButton.size[0]+ProYesButton.size[2]+XYoff[0],$
    ProYesButton.size[1],$
    ProYesButton.size[2],$
    ProYesButton.size[3]],$
    uname : 'pro_no',$
    value : 'N O'}
    
  ;////////////////////////////////////////////////////////
  ;Table Widget
  NbrRow = 20
  RowAlign   = [1,0,0,0,1,1,1,0,1,0]
  sz         = (size(RowAlign))(1)
  TableAlign = intarr(sz,NbrRow)
  FOR i=0,(NbrRow-1) DO BEGIN
    TableAlign(*,i)=RowAlign
  ENDFOR
  dTable = { size      : [0,0,MainTabSize[2],420,sz,NbrRow],$
    uname     : 'batch_table_widget',$
    sensitive : 1,$
    label     : ['ACTIVE', $
    'DATA RUNS', $
    'NORM. RUNS',$
    'E.C. RUN',$
    'ANGLE (degrees)', $
    'S1 (mm)', $
    'S2 (mm)', $
    'DATE',$
    'SF',$
    'Command Line                                        '],$
    align        : TableAlign,$
    column_width : [60,150,150,100,120,80,80,160,60,425]}
    
  ;/////////////////////////////////////////////////////////
  ;Frame that will display the content of the selected run #
  ;widget_label (frame)
  XYoff  = [5,15]
  dFrame = { size  : [0+XYoff[0],$
    dTable.size[1]+dTable.size[3]+XYoff[1],$
    1178,$
    270],$
    frame : 1}
    
  ;title
  XYoff = [300,-8]
  title = 'Information Box of Selected Run Number'
  dTitle = { size  : [(long(dFrame.size[2])-STRLEN(title)*5)/2L,$
    dFrame.size[1]+XYoff[1]],$
    value : title}
    
  ;Active or not
  XYoff = [10,20]
  dActive = { size  : [dFrame.size[0]+XYoff[0],$
    dFrame.size[1]+XYoff[1]],$
    title : 'ACTIVE:',$
    list  : ['YES','NO'],$
    uname : 'batch_run_active_status'}
    
  ;Data Run number field
  XYOff = [180,0]
  dRunBase = { size  : [dActive.size[0]+XYoff[0],$
    dActive.size[1]+XYoff[1],$
    220,40],$
    uname : 'batch_data_run_base_status'}
  dDataRunField = { size  : [20,1],$
    uname : 'batch_data_run_field_status',$
    title : 'DATA RUNS:'}
    
  xoff = 15                ;distance between components of first row
  ;Normalization Run number field
  XYOff = [230,0]
  dNormRunBase = { size  : [dRunBase.size[0]+XYoff[0],$
    dRunBase.size[1]+XYoff[1],$
    220,40],$
    uname : 'batch_norm_run_base_status'}
  dNormRunField = { size  : [20,1],$
    uname : 'batch_norm_run_field_status',$
    title : 'NORM. RUNS:'}
  ;Angle value
  XYoff = [xoff,0]
  dAngleLabel = { size  : [dNormRunBase.size[0]+dNormRunBase.size[2]+XYoff[0],$
    dNormRunBase.size[1]+XYoff[1],$
    150,35],$
    uname : 'angle_value_status',$
    value : 'Angle : ? degrees'}
    
  ;S1 value
  XYoff = [xoff,0]
  dS1Label = { size  : [dAngleLabel.size[0]+dAngleLabel.size[2]+XYoff[0],$
    dAngleLabel.size[1]+XYoff[1],$
    150,35],$
    uname : 's1_value_status',$
    value : 'Slit 1 : ? mm'}
    
  ;S2 value
  XYoff = [xoff,0]
  dS2Label = { size  : [dS1Label.size[0]+dS1Label.size[2]+XYoff[0],$
    dS1Label.size[1]+XYoff[1],$
    150,35],$
    uname : 's2_value_status',$
    value : 'Slit 2 : ? mm'}
    
  ;Command line preview
  XYoff = [10,40]
  dCMDlineLabel = { size  : [dFrame.size[0]+XYoff[0],$
    dActive.size[1]+XYoff[1]],$
    value : 'COMMAND LINE PREVIEW :'}
  XYoff = [0,20]
  dCMDlineText = { size  : [dCMDlineLabel.size[0]+XYoff[0],$
    dCMDlineLabel.size[1]+XYoff[1],$
    dFrame.size[2]-20,$
    150],$
    uname : 'cmd_status_preview'}
    
  ;Repopulate GUI
  ;XYoff = [180,45]
  XYoff = [0,5]
  dPopulateGui = { size  : [dCMDlineText.size[0]+XYoff[0],$
    dCMDlineText.size[1]+dCMDlineText.size[3]+XYoff[1],$
    dCMDlineText.size[2],30],$
    value : 'R E P O P U L A T E   G U I' + $
    '  with  S E L E C T E D   R O W',$
    uname : 'repopulate_gui',$
    sensitive : 0}
    
  ;/////////////////////////////////////////////////////////
  ;widgets_buttons
  XYoff = [10,10]
  dMUButton = { size      : [XYoff[0],$
    dFrame.size[1]+dFrame.size[3]+XYoff[1],$
    140,35],$
    uname     : 'move_up_selection_button',$
    value     : 'MOVE UP SELECTION',$
    sensitive : 0}
    
  XYoff = [10,0]
  dMDButton = { size  : [dMUButton.size[0]+dMUButton.size[2]+XYoff[0],$
    dMUButton.size[1],$
    dMUButton.size[2],$
    dMUButton.size[3]],$
    uname : 'move_down_selection_button',$
    value : 'MOVE DOWN SELECTION'}
    
  XYoff = [10,0]
  dDeleteSelectionButton = { size      : [dMDButton.size[0]+ $
    dMDButton.size[2]+XYoff[0],$
    dMDButton.size[1],$
    200,35],$
    uname     : 'delete_selection_button',$
    value     : 'DELETE  SELECTION',$
    sensitive : 0}
    
  XYoff = [10,0]
  dDeleteButton = { size      : [dDeleteSelectionButton.size[0]+ $
    dDeleteSelectionButton.size[2]+ $
    XYoff[0],$
    dMDButton.size[1],$
    200,35],$
    uname     : 'delete_active_button',$
    value     : 'DELETE  ACTIVE',$
    sensitive : 0}
    
  XYoff = [10,0]
  dRunButton = { size      : [dDeleteButton.size[0]+ $
    dDeleteButton.size[2]+XYoff[0],$
    dDeleteButton.size[1]+XYoff[1],$
    dDeleteButton.size[2:3]],$
    uname     : 'run_active_button',$
    value     : 'RUN  ACTIVE  LIVE',$
    sensitive : 0}
    
  ;RUN ACTIVE in BACKGROUND
  XYoff = [10,0]
  dRunBackgroundButton = { size      : [dRunButton.size[0]+ $
    dRunButton.size[2]+XYoff[0],$
    dRunButton.size[1]+XYoff[1],$
    dRunButton.size[2],$
    dRunButton.size[3]],$
    uname     : 'run_active_background_button',$
    value     : 'RUN  ACTIVE  in  BACKGROUND',$
    sensitive : 0}
    
  ;Progress bar base
  XYoff = [5,0]
  dProgressBarBase = { size  : [dRunButton.size[0]+dRunButton.size[2]+XYoff[0],$
    dRunButton.size[1]+XYoff[1],$
    250,35],$
    uname : 'progress_bar_base',$
    map   : 0}
  XYoff = [0,2]
  ;black background
  dProgressBarBackground = { size  : [XYoff[0],$
    XYoff[1],$
    150,30],$
    uname : 'progress_bar_draw'}
  ;red background
  dProgressBarBackground1 = { size  : [XYoff[0],$
    XYoff[1],$
    150,30],$
    uname : 'progress_bar_draw_1'}
  ;yellow background
  dProgressBarBackground2 = { size  : [XYoff[0],$
    XYoff[1],$
    150,30],$
    uname : 'progress_bar_draw_2'}
  XYoff = [8,8]
  dProgressBarLabel = { size  : [dProgressBarBackground.size[0]+ $
    dProgressBarBackground.size[2]+XYoff[0],$
    XYoff[1],$
    100,30],$
    uname : 'progress_bar_label',$
    value : ''}
    
  ;frame for batch widgets
  XYoff = [5,45]
  dBatchFrame = { size  : [XYoff[0],$
    dDeleteButton.size[1]+XYoff[1],$
    1178,90],$
    frame : 1}
    
  ;save as label
  XYoff = [0,60]
  dSaveasLabel = { size  : [dMUButton.size[0]+XYoff[0],$
    dDeleteButton.size[1]+XYoff[1]],$
    value : 'SAVE AS :'}
    
  XYoff = [70,-8]
  dSApathButton = { size  : [ dSaveasLabel.size[0]+XYoff[0],$
    dSaveasLabel.size[1]+XYoff[1],$
    450,35],$
    uname : 'save_as_path',$
    value : '~/results/'}
    
  XYoff = [0,0]
  dSAfileText = { size  : [dSApathButton.size[0]+ $
    dSApathButton.size[2]+XYoff[0],$
    dSApathButton.size[1]+XYoff[1],$
    dSApathButton.size[2], $
    35],$
    uname : 'save_as_file_name',$
    value : ''}
    
  XYoff = [0,0]
  dSaveButton = { size      : [dSAfileText.size[0]+dSAfileText.size[2]+XYoff[0],$
    dSAfileText.size[1]+XYoff[1],$
    200,35],$
    uname     : 'save_as_file_button',$
    value     : 'SAVE BATCH FILE',$
    sensitive : 0}
    
  ;Load batch file
  XYoff = [0,35]
  dLoadBatchButton = { size  : [dSaveasLabel.size[0]+XYoff[0],$
    dSaveasLabel.size[1]+XYoff[1],$
    dDeleteButton.size[2:3]],$
    uname : 'load_batch_button',$
    value : 'LOAD BATCH FILE'}
    
  ;Launch REFscale button
  XYoff = [0,0]
  dLaunchREFscaleButton = { size  : [dLoadBatchButton.size[0]+ $
    dLoadBatchButton.size[2]+XYoff[0],$
    dLoadBatchButton.size[1]+XYoff[1],$
    dLoadBatchButton.size[2:3]],$
    uname : 'launch_refscale_button',$
    value : 'LAUNCH REFscale'}
    
  ;Refresh Base
  XYoff = [0,0]
  dRefreshBase = { size: [dLoadBatchButton.size[0]+$
    dLoadBatchButton.size[2]+XYoff[0],$
    dLoadBatchButton.size[1]+XYoff[1],$
    970,$
    35],$
    frame: 0,$
    map:   1,$
    uname: 'refresh_bash_base' }
    
  ;Refresh REFscale button
  XYoff = [0,0]
  dRefreshREFscaleButton = { size:      [XYoff[0],$
    XYoff[1],$
    dLoadBatchButton.size[2:3]],$
    uname:     'refresh_batch_file_button',$
    sensitive: 1,$
    value:     'REFRESH BATCH FILE'}
    
  ;Static label
  XYoff = [10,10]
  dRefreshStaticLabel = { size: [dRefreshREFScaleButton.size[0]+$
    dRefreshREFscaleButton.size[2]+XYoff[0],$
    dRefreshREFscaleButton.size[1]+XYOff[1]],$
    value: 'Loaded File Name: '}
    
  ;Name of current file opened
  XYoff = [110,0]
  dBatchFileLoadedLabel = { size: [dRefreshStaticLabel.size[0]+XYoff[0],$
    dRefreshStaticLabel.size[1]+XYoff[1],$
    400],$
    value: 'N/A',$
    frame: 0,$
    uname: 'loaded_batch_file_name'}
    
  ;******************************************************************************
  ;                                Build GUI
  ;******************************************************************************
  BATCH_BASE = WIDGET_BASE(MAIN_TAB,$
    UNAME     = BatchTab.uname,$
    TITLE     = BatchTab.title,$
    XOFFSET   = BatchTab.size[0],$
    YOFFSET   = BatchTab.size[1],$
    SCR_XSIZE = BatchTab.size[2],$
    SCR_YSIZE = BatchTab.size[3])
    
  ;\\\\\\\\\\\\\\\\
  ;Processing base\
  ;\\\\\\\\\\\\\\\\
  wProBase = WIDGET_BASE(BATCH_BASE,$
    XOFFSET   = ProBase.size[0],$
    YOFFSET   = ProBase.size[1],$
    SCR_XSIZE = ProBase.size[2],$
    SCR_YSIZE = ProBase.size[3],$
    UNAME     = ProBase.uname,$
    FRAME     = ProBase.frame,$
    MAP       = 0)
    
  wProLabel = WIDGET_LABEL(wProBase,$
    XOFFSET = ProLabel.size[0],$
    YOFFSET = ProLabel.size[1],$
    XSIZE   = ProLabel.size[2],$
    YSIZE   = ProLabel.size[3],$
    VALUE   = ProLabel.value,$
    UNAME   = ProLabel.uname,$
    FRAME   = ProLabel.frame,$
    /ALIGN_CENTER)
    
  wProLabel2 = WIDGET_LABEL(wProBase,$
    XOFFSET = ProLabel2.size[0],$
    YOFFSET = ProLabel2.size[1],$
    VALUE   = ProLabel2.value,$
    /ALIGN_CENTER)
    
  wProTable = WIDGET_TABLE(wProBase,$
    XOFFSET       = ProTable.size[0],$
    YOFFSET       = ProTable.size[1],$
    SCR_XSIZE     = ProTable.size[2],$
    SCR_YSIZE     = ProTable.size[3],$
    XSIZE         = ProTable.size[4],$
    YSIZE         = ProTable.size[5],$
    UNAME         = ProTable.uname,$
    SENSITIVE     = ProTable.sensitive,$
    COLUMN_LABELS = ProTable.label,$
    COLUMN_WIDTHS = ProTable.column_width,$
    ALIGNMENT     = ProTable.align,$
    /NO_ROW_HEADERS,$
    /ROW_MAJOR,$
    /RESIZEABLE_COLUMNS)
    
  wProQLabel = WIDGET_LABEL(wProBase,$
    XOFFSET = ProQLabel.size[0],$
    YOFFSET = ProQLabel.size[1],$
    VALUE   = ProQLabel.value)
    
  wProYesButton = WIDGET_BUTTON(wProBase,$
    XOFFSET   = ProYesButton.size[0],$
    YOFFSET   = ProYesButton.size[1],$
    SCR_XSIZE = ProYesButton.size[2],$
    SCR_YSIZE = ProYesButton.size[3],$
    VALUE     = ProYesButton.value,$
    UNAME     = ProYesButton.uname)
    
  wProNoButton = WIDGET_BUTTON(wProBase,$
    XOFFSET   = ProNoButton.size[0],$
    YOFFSET   = ProNoButton.size[1],$
    SCR_XSIZE = ProNoButton.size[2],$
    SCR_YSIZE = ProNoButton.size[3],$
    VALUE     = ProNoButton.value,$
    UNAME     = ProNoButton.uname)
    
  ;\\\\\\\\\\\\\
  ;Table Widget\
  ;\\\\\\\\\\\\\
  wTable = WIDGET_TABLE(BATCH_BASE,$
    XOFFSET       = dTable.size[0],$
    YOFFSET       = dTable.size[1],$
    SCR_XSIZE     = dTable.size[2],$
    SCR_YSIZE     = dTable.size[3],$
    XSIZE         = dTable.size[4],$
    YSIZE         = dTable.size[5],$
    UNAME         = dTable.uname,$
    SENSITIVE     = dTable.sensitive,$
    COLUMN_LABELS = dTable.label,$
    COLUMN_WIDTHS = dTable.column_width,$
    ALIGNMENT     = dTable.align,$
    /NO_ROW_HEADERS,$
    /ROW_MAJOR,$
    /RESIZEABLE_COLUMNS,$
    /ALL_EVENTS)
    
  ;\\\\\\\\\\\\\\\\\\\
  ;Display Data Title\
  ;\\\\\\\\\\\\\\\\\\\
  wTitle = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET = dTitle.size[0],$
    YOFFSET = dTitle.size[1],$
    VALUE   = dTitle.value)
    
  ;\\\\\\\\\\\\\
  ;Active group\
  ;\\\\\\\\\\\\\
  wActive = CW_BGROUP(BATCH_BASE,$
    dActive.list,$
    /EXCLUSIVE,$
    XOFFSET    = dActive.size[0],$
    YOFFSET    = dActive.size[1],$
    SET_VALUE  = 0,$
    UNAME      = dActive.uname,$
    ROW        = 1,$
    LABEL_LEFT = dActive.title)
    
    
  ;\\\\\\\\\\\\\\\\
  ;Data Run Number\
  ;\\\\\\\\\\\\\\\\
  wRunBase = WIDGET_BASE(BATCH_BASE,$
    UNAME     = dRunBase.uname,$
    XOFFSET   = dRunBase.size[0],$
    YOFFSET   = dRunBase.size[1],$
    SCR_XSIZE = dRunBase.size[2],$
    SCR_YSIZE = dRunBase.size[3])
    
    
  wRunField = CW_FIELD(wRunBase,$
    XSIZE  = dDataRunField.size[0],$
    YSIZE  = dDataRunField.size[1],$
    UNAME  = dDataRunField.uname,$
    TITLE  = dDataRunField.title,$
    /RETURN_EVENTS)
    
  ;\\\\\\\\\\\\\\\\
  ;Norm Run Number\
  ;\\\\\\\\\\\\\\\\
  wNormRunBase = WIDGET_BASE(BATCH_BASE,$
    UNAME     = dNormRunBase.uname,$
    XOFFSET   = dNormRunBase.size[0],$
    YOFFSET   = dNormRunBase.size[1],$
    SCR_XSIZE = dNormRunBase.size[2],$
    SCR_YSIZE = dNormRunBase.size[3])
    
  wNormRunField = CW_FIELD(wNormRunBase,$
    XSIZE = dNormRunField.size[0],$
    YSIZE = dNormRunField.size[1],$
    UNAME = dNormRunField.uname,$
    TITLE = dNormRunField.title,$
    /RETURN_EVENTS)
    
  ;\\\\\\\\\\\\
  ;Angle value\
  ;\\\\\\\\\\\\
  wAngleLabel = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET   = dAngleLabel.size[0],$
    YOFFSET   = dAngleLabel.size[1],$
    SCR_XSIZE = dAngleLabel.size[2],$
    SCR_YSIZE = dAngleLabel.size[3],$
    UNAME     = dAngleLabel.uname,$
    VALUE     = dAngleLabel.value)
    
  ;\\\\\\\\\
  ;S1 value\
  ;\\\\\\\\\
  wS1Label = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET   = dS1Label.size[0],$
    YOFFSET   = dS1Label.size[1],$
    SCR_XSIZE = dS1Label.size[2],$
    SCR_YSIZE = dS1Label.size[3],$
    UNAME     = dS1Label.uname,$
    VALUE     = dS1Label.value)
    
  ;\\\\\\\\\
  ;S2 value\
  ;\\\\\\\\\
  wS2Label = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET   = dS2Label.size[0],$
    YOFFSET   = dS2Label.size[1],$
    SCR_XSIZE = dS2Label.size[2],$
    SCR_YSIZE = dS2Label.size[3],$
    UNAME     = dS2Label.uname,$
    VALUE     = dS2Label.value)
    
  ;\\\\\\\\\\\\\\\
  ;Repopulate GUI\
  ;\\\\\\\\\\\\\\\
  wPopulateGui = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dPopulateGui.size[0],$
    YOFFSET   = dPopulateGui.size[1],$
    SCR_XSIZE = dPopulateGui.size[2],$
    SCR_YSIZE = dPopulateGui.size[3],$
    UNAME     = dPopulateGui.uname,$
    VALUE     = dPopulateGui.value,$
    SENSITIVE = dPopulateGui.sensitive)
    
  ;\\\\\\\\\\\\\\\\\\\
  ;Command line label\
  ;\\\\\\\\\\\\\\\\\\\
  wCMDlineLabel = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET = dCMDlineLabel.size[0],$
    YOFFSET = dCMDlineLabel.size[1],$
    VALUE   = dCMDlineLabel.value)
    
  ;\\\\\\\\\\\\\\\\\\
  ;Command line text\
  ;\\\\\\\\\\\\\\\\\\
  wCMDlineText = WIDGET_TEXT(BATCH_BASE,$
    XOFFSET   = dCMDlineText.size[0],$
    YOFFSET   = dCMDlineText.size[1],$
    SCR_XSIZE = dCMDlineText.size[2],$
    SCR_YSIZE = dCMDlineText.size[3],$
    UNAME     = dCMDlineText.uname,$
    /WRAP,$
    /SCROLL)
    
  ;\\\\\\\\\\\\\\\\\\\
  ;Display Data Frame\
  ;\\\\\\\\\\\\\\\\\\\
  wFrame = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET   = dFrame.size[0],$
    YOFFSET   = dFrame.size[1],$
    SCR_XSIZE = dFrame.size[2],$
    SCR_YSIZE = dFrame.size[3],$
    FRAME     = dFrame.frame,$
    VALUE     = '')
    
    
  ;\\\\\\\\\\\\\\\\\\\\\\
  ;MOVE UP ACTIVE BUTTON\
  ;\\\\\\\\\\\\\\\\\\\\\\
  wMUButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dMUButton.size[0],$
    YOFFSET   = dMUButton.size[1],$
    SCR_XSIZE = dMUButton.size[2],$
    SCR_YSIZE = dMUButton.size[3],$
    UNAME     = dMUButton.uname,$
    VALUE     = dMUButton.value,$
    SENSITIVE = dMUButton.sensitive)
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\
  ;MOVE DOWN ACTIVE BUTTON\
  ;\\\\\\\\\\\\\\\\\\\\\\\\
  wMDButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dMDButton.size[0],$
    YOFFSET   = dMDButton.size[1],$
    SCR_XSIZE = dMDButton.size[2],$
    SCR_YSIZE = dMDButton.size[3],$
    UNAME     = dMDButton.uname,$
    VALUE     = dMDButton.value)
    
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\
  ;Delete Selection Button\
  ;\\\\\\\\\\\\\\\\\\\\\\\\
  wDeleteSelectionButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = $
    dDeleteSelectionButton.size[0],$
    YOFFSET   = $
    dDeleteSelectionButton.size[1],$
    SCR_XSIZE = $
    dDeleteSelectionButton.size[2],$
    SCR_YSIZE = $
    dDeleteSelectionButton.size[3],$
    UNAME     = $
    dDeleteSelectionButton.uname,$
    VALUE     = $
    dDeleteSelectionButton.value,$
    SENSITIVE = $
    dDeleteSelectionButton.sensitive)
    
  ;\\\\\\\\\\\\\\\\\\\\\
  ;Delete Active Button\
  ;\\\\\\\\\\\\\\\\\\\\\
  wDeleteButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dDeleteButton.size[0],$
    YOFFSET   = dDeleteButton.size[1],$
    SCR_XSIZE = dDeleteButton.size[2],$
    SCR_YSIZE = dDeleteButton.size[3],$
    UNAME     = dDeleteButton.uname,$
    VALUE     = dDeleteButton.value,$
    SENSITIVE = dDeleteButton.sensitive)
    
  ;\\\\\\\\\\\\\\\\\\
  ;Run Active Button\
  ;\\\\\\\\\\\\\\\\\\
  wRunButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dRunButton.size[0],$
    YOFFSET   = dRunButton.size[1],$
    SCR_XSIZE = dRunButton.size[2],$
    SCR_YSIZE = dRunButton.size[3],$
    UNAME     = dRunButton.uname,$
    VALUE     = dRunButton.value,$
    SENSITIVE = dRunButton.sensitive)
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Run Active Button in Background\
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  wRunButtonBackground = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dRunBackgroundButton.size[0],$
    YOFFSET   = dRunBackgroundButton.size[1],$
    SCR_XSIZE = dRunBackgroundButton.size[2],$
    SCR_YSIZE = dRunBackgroundButton.size[3],$
    UNAME     = dRunBackgroundButton.uname,$
    VALUE     = dRunBackgroundButton.value,$
    SENSITIVE = $
    dRunBackgroundButton.sensitive)
    
  ;\\\\\\\\\\\\\
  ;Progress Bar\
  ;\\\\\\\\\\\\\
  wProgressBarBase = WIDGET_BASE(BATCH_BASE,$
    XOFFSET   = dProgressBarBase.size[0],$
    YOFFSET   = dProgressBarBase.size[1],$
    SCR_XSIZE = dProgressBarBase.size[2],$
    SCR_YSIZE = dProgressBarBase.size[3],$
    UNAME     = dProgressBarBase.uname,$
    MAP       = dProgressBarBase.map)
    
  wProgressBarBackground1 = WIDGET_DRAW(wProgressBarBase,$
    XOFFSET   = $
    dProgressBarBackground1.size[0],$
    YOFFSET   = $
    dProgressBarBackground1.size[1],$
    SCR_XSIZE = $
    dProgressBarBackground1.size[2],$
    SCR_YSIZE = $
    dProgressBarBackground1.size[3],$
    UNAME     = $
    dProgressBarBackground1.uname)
    
  wProgressBarBackground2 = WIDGET_DRAW(wProgressBarBase,$
    XOFFSET   = $
    dProgressBarBackground2.size[0],$
    YOFFSET   = $
    dProgressBarBackground2.size[1],$
    SCR_XSIZE = $
    dProgressBarBackground2.size[2],$
    SCR_YSIZE = $
    dProgressBarBackground2.size[3],$
    UNAME     = $
    dProgressBarBackground2.uname)
    
  wProgressBarBackground = WIDGET_DRAW(wProgressBarBase,$
    XOFFSET   = $
    dProgressBarBackground.size[0],$
    YOFFSET   = $
    dProgressBarBackground.size[1],$
    SCR_XSIZE = $
    dProgressBarBackground.size[2],$
    SCR_YSIZE = $
    dProgressBarBackground.size[3],$
    UNAME     = $
    dProgressBarBackground.uname)
    
  wProgressBarLabel = WIDGET_LABEL(wProgressBarBase,$
    XOFFSET   = dProgressBarLabel.size[0],$
    YOFFSET   = dProgressBarLabel.size[1],$
    SCR_XSIZE = dProgressBarLabel.size[2],$
    SCR_YSIZE = dProgressbarLabel.size[3],$
    VALUE     = dProgressBarLabel.value,$
    UNAME     = dProgressBarLabel.uname,$
    /ALIGN_LEFT)
    
  ;\\\\\\\\\\\\\\\\\\
  ;Load batch button\
  ;\\\\\\\\\\\\\\\\\\
  wLoadBatchButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dLoadBatchButton.size[0],$
    YOFFSET   = dLoadBatchButton.size[1],$
    SCR_XSIZE = dLoadBatchButton.size[2],$
    SCR_YSIZE = dLoadBatchButton.size[3],$
    UNAME     = dLoadBatchButton.uname,$
    VALUE     = dLoadBatchButton.value)
    
  IF (with_launch_button EQ 'yes') THEN BEGIN
    ;\\\\\\\\\\\\\\\\\\\\\\\
    ;Launch REFscale Button\
    ;\\\\\\\\\\\\\\\\\\\\\\\
    wLaunchREFscalebutton = $
      WIDGET_BUTTON(BATCH_BASE,$
      XOFFSET   = dLaunchREFscalebutton.size[0],$
      YOFFSET   = dLaunchREFscalebutton.size[1],$
      SCR_XSIZE = dLaunchREFscalebutton.size[2],$
      SCR_YSIZE = dLaunchREFscalebutton.size[3],$
      UNAME     = dLaunchREFscalebutton.uname,$
      VALUE     = dLaunchREFscalebutton.value)
  ENDIF
  
  ;------------------------------------------------------------------------------
  ;\\\\\\\\\\\\\\\\\\\
  ;Refresh Batch Base\
  ;\\\\\\\\\\\\\\\\\\\
  wRefreshBase = WIDGET_BASE(BATCH_BASE,$
    XOFFSET   = dRefreshBase.size[0],$
    YOFFSET   = dRefreshBase.size[1],$
    SCR_XSIZE = dRefreshBase.size[2],$
    SCR_YSIZE = dRefreshBase.size[3],$
    UNAME     = dRefreshBase.uname,$
    FRAME     = dRefreshBase.frame,$
    MAP       = dRefreshBase.map)
    
  ;\\\\\\\\\\\\\\\\\\\\\
  ;Refresh Batch Button\
  ;\\\\\\\\\\\\\\\\\\\\\
  wRefreshREFscalebutton = $
    WIDGET_BUTTON(wRefreshBase,$
    XOFFSET   = dRefreshREFscalebutton.size[0],$
    YOFFSET   = dRefreshREFscalebutton.size[1],$
    SCR_XSIZE = dRefreshREFscalebutton.size[2],$
    SCR_YSIZE = dRefreshREFscalebutton.size[3],$
    UNAME     = dRefreshREFscalebutton.uname,$
    VALUE     = dRefreshREFscalebutton.value,$
    SENSITIVE = dRefreshREFscalebutton.sensitive)
    
    
  ;\\\\\\\\\\\\\
  ;Static Label\
  ;\\\\\\\\\\\\\
  wRefreshStaticLabel = WIDGET_LABEL(wRefreshBase,$
    XOFFSET = dRefreshStaticLabel.size[0],$
    YOFFSET = dRefreshStaticLabel.size[1],$
    VALUE   = dRefreshStaticLabel.value)
    
    
  ;\\\\\\\\\\\\\\\\\\
  ;Loaded Batch File\
  ;\\\\\\\\\\\\\\\\\\
  wBatchFileLoadedLabel = $
    WIDGET_LABEL(wRefreshBase,$
    XOFFSET   = dBatchFileLoadedLabel.size[0],$
    YOFFSET   = dBatchFileLoadedLabel.size[1],$
    SCR_XSIZE = dBatchFileLoadedLabel.size[2],$
    VALUE     = dBatchFileLoadedLabel.value,$
    UNAME     = dBatchFileLoadedLabel.uname,$
    FRAME     = dBatchFileLoadedLabel.frame,$
    /ALIGN_LEFT)
    
  ;------------------------------------------------------------------------------
    
  ;\\\\\\\\\\\\\\
  ;save as label\
  ;\\\\\\\\\\\\\\
  wSaveasLabel = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET = dSaveasLabel.size[0],$
    YOFFSET = dSaveasLabel.size[1],$
    VALUE   = dSaveasLabel.value)
    
  ;\\\\\\\\\\\\
  ;Path Button\
  ;\\\\\\\\\\\\
  wSApathButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dSApathButton.size[0],$
    YOFFSET   = dSApathButton.size[1],$
    SCR_XSIZE = dSApathButton.size[2],$
    SCR_YSIZE = dSApathButton.size[3],$
    UNAME     = dSApathButton.uname,$
    VALUE     = dSApathButton.value)
    
  ;\\\\\\\\\\
  ;File name\
  ;\\\\\\\\\\
  wSAfileText = WIDGET_TEXT(BATCH_BASE,$
    XOFFSET   = dSAfileText.size[0],$
    YOFFSET   = dSAfileText.size[1],$
    SCR_XSIZE = dSAfileText.size[2],$
    SCR_YSIZE = dSAfileText.size[3],$
    VALUE     = dSAfileText.value,$
    UNAME     = dSAfileText.uname,$
    /ALL_EVENTS,$
    /EDITABLE)
    
    
  ;\\\\\\\\\\\\
  ;Save Button\
  ;\\\\\\\\\\\\
  wSaveButton = WIDGET_BUTTON(BATCH_BASE,$
    XOFFSET   = dSaveButton.size[0],$
    YOFFSET   = dSaveButton.size[1],$
    SCR_XSIZE = dSaveButton.size[2],$
    SCR_YSIZE = dSaveButton.size[3],$
    UNAME     = dSaveButton.uname,$
    VALUE     = dSaveButton.value,$
    SENSITIVE = dSaveButton.sensitive)
    
  ;\\\\\\\\\\\\
  ;Batch Frame\
  ;\\\\\\\\\\\\
  wBatchFrame = WIDGET_LABEL(BATCH_BASE,$
    XOFFSET   = dBatchFrame.size[0],$
    YOFFSET   = dBatchFrame.size[1],$
    SCR_XSIZE = dBatchFrame.size[2],$
    SCR_YSIZE = dBatchFrame.size[3],$
    FRAME     = dBatchFrame.frame,$
    VALUE     = '')
    
END
