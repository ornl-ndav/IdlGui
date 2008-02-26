PRO MakeGuiBatchTab, MAIN_TAB, MainTabSize, BatchTabTitle

;***********************************************************************************
;                           Define size arrays
;                 [xoffset, yoffset, scr_xsize, scr_ysize]
;***********************************************************************************

;Main Base
BatchTab = { size  : [0,0,MainTabSize[2],MainTabSize[3]],$
             uname : 'batch_base',$
             title : BatchTabTitle }

;////////////////////////////////////////////////////////
;Table Widget
NbrRow = 20
RowAlign   = [1,0,0,1,1,1,1,0]
TableAlign = intarr(8,NbrRow)
FOR i=0,(NbrRow-1) DO BEGIN
    TableAlign(*,i)=RowAlign
ENDFOR
dTable = { size      : [0,0,MainTabSize[2],420,8,20],$
           uname     : 'batch_table_widget',$
           sensitive : 1,$
           label     : ['ACTIVE', $
                        'DATA RUNS', $
                        'NORM. RUNS',$
                        'ANGLE (degrees)', $
                        'S1 (mm)', $
                        'S2 (mm)', $
                        'DATE',$
                        'Command Line'],$
           align        : TableAlign,$
           column_width : [60,150,150,120,80,80,150,425]}

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
XYoff = [300,-5]
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
XYOff = [180,0]
dRunBase = { size  : [dActive.size[0]+XYoff[0],$
                      dActive.size[1]+XYoff[1],$
                      210,40],$
             uname : 'batch_data_run_base_status'}
dRunLabel = { size  : [0,10],$
              value : 'DATA RUNS:'}
dRunField = { size  : [65,3,120,35],$
              uname : 'batch_data_run_field_status'}
          
xoff = 15                ;distance between components of first row    
;Normalization Run number field
XYOff = [230,0]
dNormRunBase = { size  : [dRunBase.size[0]+XYoff[0],$
                          dRunBase.size[1]+XYoff[1],$
                          210,40],$
                 uname : 'batch_norm_run_base_status'}
dNormRunLabel = { size  : [0,10],$
                  value : 'NORM. RUNS:'}
dNormRunField = { size  : [70,3,120,35],$
                  uname : 'batch_norm_run_field_status'}
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
XYoff = [10,55]
dCMDlineLabel = { size  : [dFrame.size[0]+XYoff[0],$
                           dActive.size[1]+XYoff[1]],$
                  value : 'COMMAND LINE PREVIEW :'}
XYoff = [0,25]
dCMDlineText = { size  : [dCMDlineLabel.size[0]+XYoff[0],$
                          dCMDlineLabel.size[1]+XYoff[1],$
                          dFrame.size[2]-20,$
                          150],$
                 uname : 'cmd_status_preview'}
                          
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
dDeleteSelectionButton = { size      : [dMDButton.size[0]+dMDButton.size[2]+XYoff[0],$
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
dRunButton = { size      : [dDeleteButton.size[0]+dDeleteButton.size[2]+XYoff[0],$
                            dDeleteButton.size[1]+XYoff[1],$
                            dDeleteButton.size[2:3]],$
               uname     : 'run_active_button',$
               value     : 'RUN  ACTIVE',$
               sensitive : 0}
                          
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
                  value : '~/'}

XYoff = [0,0]
dSAfileText = { size  : [dSApathButton.size[0]+dSApathButton.size[2]+XYoff[0],$                         
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
                value     : 'SAVE ACTIVE(S)',$
                sensitive : 0}

;Load batch file
XYoff = [0,35]
dLoadBatchButton = { size  : [dSaveasLabel.size[0]+XYoff[0],$
                              dSaveasLabel.size[1]+XYoff[1],$
                              dDeleteButton.size[2:3]],$
                     uname : 'load_batch_button',$
                     value : 'LOAD BATCH FILE'}

;current batch file name is
XYoff = [30,8]
dBatchNameLabel = { size  : [dLoadBatchButton.size[0]+dLoadBatchButton.size[2]+XYoff[0],$
                             dLoadBatchButton.size[1]+XYoff[1]],$
                    value : 'Current Batch file Name is: '}
XYoff = [180,0]
dBatchFileName = { size  : [dBatchNameLabel.size[0]+XYoff[0],$
                            dBatchNameLabel.size[1]+XYoff[1],$
                            300,40],$
                   uname : 'current_batch_file_name',$
                   value : 'N/A'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
BATCH_BASE = WIDGET_BASE(MAIN_TAB,$
                         UNAME     = BatchTab.uname,$
                         TITLE     = BatchTab.title,$
                         XOFFSET   = BatchTab.size[0],$
                         YOFFSET   = BatchTab.size[1],$
                         SCR_XSIZE = BatchTab.size[2],$
                         SCR_YSIZE = BatchTab.size[3])

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


wRunLabel = WIDGET_LABEL(wRunBase,$
                         XOFFSET = dRunLabel.size[0],$
                         YOFFSET = dRunLabel.size[1],$
                         VALUE   = dRunLabel.value)

wRunField = WIDGET_TEXT(wRunBase,$
                        XOFFSET   = dRunField.size[0],$
                        YOFFSET   = dRunField.size[1],$
                        SCR_XSIZE = dRunField.size[2],$
                        SCR_YSIZE = dRunField.size[3],$
                        UNAME     = dRunField.uname,$
                        /EDITABLE,$
                        /ALL_EVENTS)

;\\\\\\\\\\\\\\\\
;Norm Run Number\
;\\\\\\\\\\\\\\\\
wNormRunBase = WIDGET_BASE(BATCH_BASE,$
                           UNAME     = dNormRunBase.uname,$
                           XOFFSET   = dNormRunBase.size[0],$
                           YOFFSET   = dNormRunBase.size[1],$
                           SCR_XSIZE = dNormRunBase.size[2],$
                           SCR_YSIZE = dNormRunBase.size[3])

wNormRunLabel = WIDGET_LABEL(wNormRunBase,$
                             XOFFSET = dNormRunLabel.size[0],$
                             YOFFSET = dNormRunLabel.size[1],$
                             VALUE   = dNormRunLabel.value)

wNormRunField = WIDGET_TEXT(wNormRunBase,$
                            XOFFSET   = dNormRunField.size[0],$
                            YOFFSET   = dNormRunField.size[1],$
                            SCR_XSIZE = dNormRunField.size[2],$
                            SCR_YSIZE = dNormRunField.size[3],$
                            UNAME     = dNormRunField.uname,$
                            /EDITABLE,$
                            /ALL_EVENTS)

                     
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

;\\\\\\\\\\\\\\\\\\\\\\
;Batch file name Label\
;\\\\\\\\\\\\\\\\\\\\\\
wBatchNameLabel = WIDGET_LABEL(BATCH_BASE,$
                               XOFFSET = dBatchNameLabel.size[0],$
                               YOFFSET = dBatchNameLabel.size[1],$
                               VALUE   = dBatchNameLabel.value)

;\\\\\\\\\\\\\\\\\\\\\\\\
;Current Batch File Name\
;\\\\\\\\\\\\\\\\\\\\\\\\
wBatchFileName = WIDGET_LABEL(BATCH_BASE,$
                              XOFFSET    = dBatchFileName.size[0],$
                              YOFFSET    = dBatchFileName.size[1],$
                              SCR_XSIZE  = dBatchFileName.size[2],$
                              VALUE      = dBatchFileName.value,$
                              UNAME      = dBatchFileName.uname,$
                              /ALIGN_LEFT)
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
