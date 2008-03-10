PRO miniMakeGuiBatchTab, MAIN_TAB, MainTabSize, BatchTabTitle

;*******************************************************************************
;                           Define size arrays
;                 [xoffset, yoffset, scr_xsize, scr_ysize]
;*******************************************************************************
;Main Base
BatchTab = { size  : [0,0,MainTabSize[2],MainTabSize[3]],$
             uname : 'batch_base',$
             title : BatchTabTitle }

;////////////////////////////////////////////////////////
;Processing base
ProBase = { size  : [170,130,500,50],$ ;50->365
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
RowAlign   = [1,0,0,1,1,1,1,0]
TableAlign = intarr(8,NbrRow)
FOR i=0,(NbrRow-1) DO BEGIN
    TableAlign(*,i)=RowAlign
ENDFOR
dTable = { size      : [0,0,MainTabSize[2],320,8,20],$
           uname     : 'batch_table_widget',$
           sensitive : 1,$
           label     : ['ACTIVE', $
                        'DATA', $
                        'NORM.',$
                        'ANGLE (deg)', $
                        'S1 (mm)', $
                        'S2 (mm)', $
                        'DATE',$
                        'Command Line                            '],$
           align        : TableAlign,$
           column_width : [50,140,140,80,70,70,150,360]}

;/////////////////////////////////////////////////////////
;Frame that will display the content of the selected run #
;widget_label (frame)
XYoff  = [5,15]
dFrame = { size  : [0+XYoff[0],$
                    dTable.size[1]+dTable.size[3]+XYoff[1],$
                    860,$
                    200],$
           frame : 1}

;title 
XYoff = [300,-8]
title = 'Selected Run Number Information Box'
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
XYOff = [170,0]
dRunBase = { size  : [dActive.size[0]+XYoff[0],$
                      dActive.size[1]+XYoff[1],$
                      200,40],$
             uname : 'batch_run_base_status'}
dDataRunField = { size  : [20,1],$
                  uname : 'batch_data_run_field_status',$
                  title : 'DATA: '}
          
;Norm Run number field
XYOff = [30,0]
dNormRunBase = { size  : [dRunBase.size[0]+dRunBase.size[2]+XYoff[0],$
                          dRunBase.size[1]+XYoff[1],$
                          200,40],$
                 uname : 'batch_norm_run_base_status'}
dNormRunField = { size  : [20,1],$
                  uname : 'batch_norm_run_field_status',$
                  title : 'NORM.: '}

xoff = 50 ;distance between components of first row    
;Angle value
XYoff = [xoff,0]
dAngleLabel = { size  : [dNormRunBase.size[0]+dRunBase.size[2]+XYoff[0],$
                         dNormRunBase.size[1]+XYoff[1],$
                         150,35],$
                uname : 'angle_value_status',$
                value : 'Angle : ? degrees'}

;S1 value
XYoff = [-120,35]
dS1Label = { size  : [dAngleLabel.size[0]+XYoff[0],$
                      dAngleLabel.size[1]+XYoff[1],$
                      150,35],$
             uname : 's1_value_status',$
             value : 'Slit 1 : ? mm'}

;S2 value
XYoff = [0,0]
dS2Label = { size  : [dS1Label.size[0]+dS1Label.size[2]+XYoff[0],$
                      dS1Label.size[1]+XYoff[1],$
                      150,35],$
             uname : 's2_value_status',$
             value : 'Slit 2 : ? mm'}

;Repopulate GUI
XYoff = [190,40]
dPopulateGui = { size  : [dActive.size[0]+XYoff[0],$
                          dActive.size[1]+XYoff[1],$
                          200,25],$
                 value : 'R E P O P U L A T E   G U I',$
                 uname : 'repopulate_gui',$
                 sensitive : 0}

;Command line preview
XYoff = [10,45]
dCMDlineLabel = { size  : [dFrame.size[0]+XYoff[0],$
                           dActive.size[1]+XYoff[1]],$
                  value : 'COMMAND LINE PREVIEW :'}
XYoff = [0,25]
dCMDlineText = { size  : [dCMDlineLabel.size[0]+XYoff[0],$
                          dCMDlineLabel.size[1]+XYoff[1],$
                          dFrame.size[2]-20,$
                          100],$
                 uname : 'cmd_status_preview'}
                          
;/////////////////////////////////////////////////////////
;widgets_buttons 
XYoff = [10,10]
dMUButton = { size      : [XYoff[0],$
                           dFrame.size[1]+dFrame.size[3]+XYoff[1],$
                           130,35],$
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
                                        dMDbutton.size[1]+XYoff[1],$
                                        130,35],$
                           uname     : 'delete_selection_button',$
                           value     : 'DELETE SELECTION',$
                           sensitive : 0}

XYoff = [10,0]
dDeleteButton = { size      : [dDeleteSelectionButton.size[0] + $
                               dDeleteSelectionButton.size[2] + $
                               XYoff[0],$
                               dMDbutton.size[1]+XYoff[1],$
                               dDeleteSelectionButton.size[2:3]],$
                  uname     : 'delete_active_button',$
                  value     : 'DELETE ACTIVE',$
                  sensitive : 0}

XYoff = [10,0]
dRunButton = { size      : [dDeleteButton.size[0]+ $
                            dDeleteButton.size[2]+XYoff[0],$
                            dDeleteButton.size[1]+XYoff[1],$
                            dDeleteButton.size[2:3]],$
               uname     : 'run_active_button',$
               value     : 'RUN ACTIVE',$
               sensitive : 0}
                 
;Progress bar base
XYoff = [10,0]
dProgressBarBase = { size  : [dRunButton.size[0]+dRunButton.size[2]+XYoff[0],$
                             dRunButton.size[1]+XYoff[1],$
                             250,35],$
                     uname : 'progress_bar_base',$
                     map   : 0}
XYoff = [0,2]
dProgressBarBackground = { size  : [XYoff[0],$
                                   XYoff[1],$
                                   100,30],$
                          uname : 'progress_bar_draw'}
XYoff = [0,8]
dProgressBarLabel = { size  : [dProgressBarBackground.size[0]+ $
                               dProgressBarBackground.size[2]+XYoff[0],$
                               XYoff[1],$
                               100,30],$
                      uname : 'progress_bar_label',$
                      value : ''}

;save as label
XYoff = [0,45]
dSaveasLabel = { size  : [dMUButton.size[0]+XYoff[0],$
                          dDeleteButton.size[1]+XYoff[1]],$
                 value : 'SAVE AS :'}

XYoff = [70,-8]
dSApathButton = { size  : [ dSaveasLabel.size[0]+XYoff[0],$
                            dSaveasLabel.size[1]+XYoff[1],$
                            320,35],$
                  uname : 'save_as_path',$
                  value : '~/'}

XYoff = [0,0]
dSAfileText = { size  : [dSApathButton.size[0]+ $
                         dSApathButton.size[2]+XYoff[0],$                   
                         dSApathButton.size[1]+XYoff[1],$
                         dSApathButton.size[2], $
                         35],$
                uname : 'save_as_file_name',$
                value : ''}

XYoff = [0,0]
dSaveButton = { size      : [dSAfileText.size[0]+ $
                             dSAfileText.size[2]+XYoff[0],$
                             dSAfileText.size[1]+XYoff[1],$
                             150,35],$
                uname     : 'save_as_file_button',$
                value     : 'SAVE BATCH FILE',$
                sensitive : 0}

;Load Batch File
XYoff = [0,30]
dLoadBatchButton = { size  : [dSaveasLabel.size[0]+XYoff[0],$
                              dSaveasLabel.size[1]+XYoff[1],$
                              150,$
                              30],$
                     uname : 'load_batch_button',$
                     value : 'LOAD BATCH'}

;*******************************************************************************
;                                Build GUI
;*******************************************************************************
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
                           VALUE     = dAngleLabel.value,$
                           /ALIGN_LEFT)

;\\\\\\\\\
;S1 value\
;\\\\\\\\\
wS1Label = WIDGET_LABEL(BATCH_BASE,$
                        XOFFSET   = dS1Label.size[0],$
                        YOFFSET   = dS1Label.size[1],$
                        SCR_XSIZE = dS1Label.size[2],$
                        SCR_YSIZE = dS1Label.size[3],$
                        UNAME     = dS1Label.uname,$
                        VALUE     = dS1Label.value,$
                        /ALIGN_LEFT)

;\\\\\\\\\
;S2 value\
;\\\\\\\\\
wS2Label = WIDGET_LABEL(BATCH_BASE,$
                        XOFFSET   = dS2Label.size[0],$
                        YOFFSET   = dS2Label.size[1],$
                        SCR_XSIZE = dS2Label.size[2],$
                        SCR_YSIZE = dS2Label.size[3],$
                        UNAME     = dS2Label.uname,$
                        VALUE     = dS2Label.value,$
                        /ALIGN_LEFT)

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
wDeleteSelectionButton = $
  WIDGET_BUTTON(BATCH_BASE,$
                XOFFSET   = dDeleteSelectionButton.size[0],$
                YOFFSET   = dDeleteSelectionButton.size[1],$
                SCR_XSIZE = dDeleteSelectionButton.size[2],$
                SCR_YSIZE = dDeleteSelectionButton.size[3],$
                UNAME     = dDeleteSelectionButton.uname,$
                VALUE     = dDeleteSelectionButton.value,$
                SENSITIVE = dDeleteSelectionButton.sensitive)

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
                                 SCR_YSIZE = dProgressBarLabel.size[3],$
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

END
