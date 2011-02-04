PRO MakeGuiStep3, STEPS_TAB,$
                  Step1Size,$
                  Step3Title,$
                  ListOfFiles

;==============================================================================
;++++++++++++++++++++++++ Define Structures +++++++++++++++++++++++++++++++++++
;==============================================================================

;**** Main Base ***************************************************************
sMainBase = { size  : Step1Size,$
              title : Step3Title,$
              uname : 'step3',$
              map   : 1}

;**** Automatic Rescaling Button **********************************************
XYoff              = [5,5]
sAutoRescaleButton = { size      : [XYoff[0],$
                                    XYoff[1],$
                                    365,30],$
                       value     : '>     >    >   >  > >> >>> AUTOMATIC ' + $
                       'RESCALING <<< << <  <   <    <     <',$
                       uname     : 'Step3_automatic_rescale_button',$
                       sensitive : 0}

;------------------------------------------------------------------------------
;***** Manual Mode Hidden Base ************************************************
XYoff            = [10,5]
sStep3ManualBase = { size      : [XYoff[0],$
                                  sAutoRescaleButton.size[1]+ $
                                  sAutoRescaleButton.size[3]+XYoff[1],$
                                  505,325],$
                     uname     : 'Step3ManualModeFrame',$
                     frame     : 1,$
                     sensitive : 0}

;**** Manual Mode Label *******************************************************
XYoff             = [20,-8]
sStep3ManualLabel = { size  : [sStep3ManualBase.size[0]+XYoff[0],$
                               sStep3ManualBase.size[1]+XYoff[1]],$
                      value : 'Manual Rescaling'}
                               
;**** Low Q Label *************************************************************
XYoff      = [5,10]
sLowQLabel = { size  : [XYoff[0],$
                        XYoff[1]],$
               value : 'Low Q file :',$
               uname : 'Step3ManualModeLowQFileLabel'}

;**** Low Q File Name value ***************************************************
XYoff      = [78,0]
sLowQValue = { size  : [sLowQLabel.size[0]+XYoff[0],$
                        sLowQLabel.size[1]+XYoff[1],$
                        415],$
               uname : 'Step3ManualModeLowQFileName',$
               value : 'N/A'}

;***** High Q Label ***********************************************************
XYoff      = [0,30]
sHighQLabel = { size  : [sLowQLabel.size[0]+XYoff[0], $
                         sLowQLabel.size[1]+XYoff[1]],$
                value : 'High Q file:',$
                uname : 'Step3ManualModeHighQFileLabel'}

;***** High Q Droplist ********************************************************
XYoff       = [67,-10]
sHighQValue = { size  : [sHighQLabel.size[0]+XYoff[0],$
                         sHighQLabel.size[1]+XYoff[1],$
                         365,30],$
                uname : 'step3_work_on_file_droplist',$
                list  : ListOfFiles}

;------------------------------------------------------------------------------
;***** Hidden Manual Base *****************************************************
XYoff       = [0,5]
sHiddenBase = { size  : [XYoff[0],$
                         sHighQValue.size[1]+sHighQValue.size[3]+XYoff[1],$
                         500,$
                         255],$
                frame : 0,$
                uname : 'Step3ManualModeHiddenFrame',$
                map   : 0}

;------------------------------------------------------------------------------
;***** Scaling Factor Base ****************************************************
XYoff        = [5,10]
sScalingBase = { size  : [XYoff[0]+150,$
                          XYoff[1]+40,$
                          188,120],$
                 frame : 1}

;***** Scaling factor label ***************************************************
XYoff         = [50,-8]
sScalingLabel = { size  : [sScalingBase.size[0]+XYoff[0],$
                           sScalingBase.size[1]+XYoff[1]],$
                  value : 'SCALING FACTOR'}
                           
;------------------------------------------------------------------------------
;***** SF CW Field ************************************************************
XYoff           = [48,40]
sScalingCWField = { size  : [XYoff[0],$
                             XYoff[1],$
                             sScalingBase.size[2]-2*XYoff[0],$
                             45],$
                    xsize : 10,$
                    ysize : 1,$
                    uname : 'Step3SFTextField',$
                    value : '1'}

;***** +++ Button *************************************************************
XYoff = [5,10]
sButton3Plus = { size  : [XYoff[0],$
                          XYoff[1],$
                          55,30],$
                 value : '+100%',$
                 uname : 'step3_3increase_button'}

;***** ++ Button **************************************************************
XYoff = [5,0]
Xreducer = 0
sButton2Plus = { size  : [sButton3Plus.size[0]+sButton3Plus.size[2]+XYoff[0],$
                          sButton3Plus.size[1]+XYoff[1],$
                          sButton3Plus.size[2]-Xreducer,30],$
                 value : '+10%',$
                 uname : 'step3_2increase_button'}

;***** + Button ***************************************************************
XYoff = [5,0]
sButton1Plus = { size  : [sButton2Plus.size[0]+sButton2Plus.size[2]+XYoff[0],$
                          sButton2Plus.size[1]+XYoff[1],$
                          sButton2Plus.size[2]-Xreducer,30],$
                 value : '+1%',$
                 uname : 'step3_1increase_button'}

;***** --- Button *************************************************************
XYoff = [0,85]
sButton3Less = { size  : [sButton3Plus.size[0]+XYoff[0],$
                          XYoff[1],$
                          55,30],$
                 value : '-99%',$
                 uname : 'step3_3decrease_button'}

;***** -- Button **************************************************************
XYoff = [0,0]
sButton2Less = { size  : [sButton2Plus.size[0]+XYoff[0],$
                          sButton3Less.size[1]+XYoff[1],$
                          sButton3Plus.size[2]-Xreducer,30],$
                 value : '-10%',$
                 uname : 'step3_2decrease_button'}

;***** - Button ***************************************************************
XYoff = [0,0]
sButton1Less = { size  : [sButton1Plus.size[0]+XYoff[0],$
                          sButton2Less.size[1]+XYoff[1],$
                          sButton2Plus.size[2]-Xreducer,30],$
                 value : '-1%',$
                 uname : 'step3_1decrease_button'}

;------------------------------------------------------------------------------

;***** Display or not data ****************************************************
XYoff             = [35,40]
sDisplayDataLabel = { size  : [XYoff[0],$
                               sScalingBase.size[1]+ $
                               sScalingBase.size[3]+XYoff[1]],$
                      value : 'Display Data ? ------>'}

;***** Display data cw_bgroup *************************************************
XYoff             = [0,25]
SDisplayDataGroup = { size  : [sDisplayDataLabel.size[0]+XYoff[0],$
                               sDisplayDataLabel.size[1]+XYoff[1]],$
                      list  : [' Y E S ',' N O'],$
                      value : 1.0,$
                      uname : 'display_value_yes_no'}

;------------------------------------------------------------------------------
;***** flt0, flt1_low and flt1_high text field ********************************
XYoff       = [200,15]
sStep3FltTextField = { size  : [XYoff[0],$
                                XYoff[1],$
                                300,240],$
                       uname : 'step3_flt_text_field'}

;***** flt0, flt1_low and flt1_high label *************************************
XYoff          = [10,-17]
sStep3FltLabel = { size  : [sStep3FltTextField.size[0]+XYoff[0],$
                            sStep3FltTextField.size[1]+XYoff[1]],$
                   value : ' flt0        flt1 Low Q       flt1 High Q'}
                          
;==============================================================================
;+++++++++++++++++++++++++++; Build GUI +++++++++++++++++++++++++++++++++++++++
;==============================================================================

;***** Main Base **************************************************************
wMainBase = WIDGET_BASE(STEPS_TAB,$
                        UNAME     = sMainBase.uname,$
                        XOFFSET   = sMainBase.size[0],$
                        YOFFSET   = sMainBase.size[1],$
                        SCR_XSIZE = sMainBase.size[2],$
                        SCR_YSIZE = sMainBase.size[3],$
                        TITLE     = sMainBase.title,$
                        MAP       = sMainBase.map)

;***** Automatic Rescaling Button *********************************************
wAutoRescaleButton = WIDGET_BUTTON(wMainBase,$
                                   UNAME     = sAutoRescaleButton.uname,$
                                   XOFFSET   = sAutoRescaleButton.size[0],$
                                   YOFFSET   = sAutoRescaleButton.size[1],$
                                   SCR_XSIZE = sAutoRescaleButton.size[2],$
                                   SCR_YSIZE = sAutoRescaleButton.size[3],$
                                   VALUE     = sAutoRescaleButton.value,$
                                   SENSITIVE = sAutoRescaleButton.sensitive)

wCleanup = widget_button(wMainBase,$
    uname='start_cleanup_button',$
    xoffset = sAutoRescaleButton.size[2]+5,$
    yoffset = sAutoRescaleButton.size[1],$
    scr_xsize = 150,$
    scr_ysize = sAutoRescaleButton.size[3],$
    value = 'CLEANING DATA...',$
    sensitive = 1)

;------------------------------------------------------------------------------
;***** Manual Mode Label ******************************************************
wStep3ManualLabel = WIDGET_LABEL(wMainBase,$
                                 XOFFSET = sStep3ManualLabel.size[0],$
                                 YOFFSET = sStep3ManualLabel.size[1],$
                                 VALUE   = sStep3ManualLabel.value)

;***** Manual Mode Base *******************************************************
wStep3ManualBase = WIDGET_BASE(wMainBase,$
                               UNAME     = sStep3ManualBase.uname,$
                               XOFFSET   = sStep3ManualBase.size[0],$
                               YOFFSET   = sStep3ManualBase.size[1],$
                               SCR_XSIZE = sStep3ManualBase.size[2],$
                               SCR_YSIZE = sStep3ManualBase.size[3],$
                               SENSITIVE = sStep3ManualBase.sensitive,$
                               FRAME     = sStep3ManualBase.frame)

;***** Low Q Label ************************************************************
wLowQLabel = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME   = sLowQLabel.uname,$
                          XOFFSET = sLowQLabel.size[0],$
                          YOFFSET = sLowQLabel.size[1],$
                          VALUE   = sLowQLabel.value)
                          
;**** Low Q File Name Label ***************************************************
wLowQValue = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME     = sLowQValue.uname,$
                          XOFFSET   = sLowQValue.size[0],$
                          YOFFSET   = sLowQValue.size[1],$
                          SCR_XSIZE = sLowQValue.size[2],$
                          VALUE     = sLowQValue.value,$
                          /ALIGN_LEFT)

;***** High Q Label ***********************************************************
wHighQLabel = WIDGET_LABEL(wStep3ManualBase,$
                          UNAME   = sHighQLabel.uname,$
                          XOFFSET = sHighQLabel.size[0],$
                          YOFFSET = sHighQLabel.size[1],$
                          VALUE   = sHighQLabel.value)

;***** High Q Droplist ********************************************************
wHighQValue = WIDGET_DROPLIST(wStep3ManualBase,$
                              UNAME = sHighQValue.uname,$
                              XOFFSET = sHighQValue.size[0],$
                              YOFFSET = sHighQValue.size[1],$
                              SCR_XSIZE = sHighQValue.size[2],$
                              SCR_YSIZE = sHighQValue.size[3],$
                              VALUE     = sHighQValue.list)

;------------------------------------------------------------------------------
;***** Hidden Manual Base *****************************************************
wHiddenBase = WIDGET_BASE(wStep3ManualBase,$
                          XOFFSET   = sHiddenBase.size[0],$
                          YOFFSET   = sHiddenBase.size[1],$
                          SCR_XSIZE = sHiddenBase.size[2],$
                          SCR_YSIZE = sHiddenBase.size[3],$
                          UNAME     = sHiddenBase.uname,$
                          FRAME     = sHiddenBase.frame,$
                          MAP       = sHiddenBase.map)

;------------------------------------------------------------------------------
;***** Scaling Factor Label ***************************************************
wScalingLabel = WIDGET_LABEL(wHiddenBase,$
                             XOFFSET = sScalingLabel.size[0],$
                             YOFFSET = sScalingLabel.size[1],$
                             VALUE   = sScalingLabel.value)

;***** Scaling Factor Base ****************************************************
wScalingBase = WIDGET_BASE(wHiddenBase,$
                           XOFFSET   = sScalingBase.size[0],$
                           YOFFSET   = sScalingBase.size[1],$
                           SCR_XSIZE = sScalingBase.size[2],$
                           SCR_YSIZE = sScalingBase.size[3],$
                           FRAME     = sScalingBase.frame)

;------------------------------------------------------------------------------
;***** SF base and cw_field****************************************************
wScalingInputBase = WIDGET_BASE(wScalingBase,$
                                XOFFSET   = sScalingCWField.size[0],$
                                YOFFSET   = sScalingCWField.size[1],$
                                SCR_XSIZE = sScalingCWField.size[2],$
                                SCR_YSIZE = sScalingCWField.size[3],$
                                ROW       = 1)

wScalingInput = CW_FIELD(wScalingInputBase,$
                         XSIZE = sScalingCWField.xsize,$
                         YSIZE = sScalingCWField.ysize,$
                         UNAME = sScalingCWField.uname,$
                         TITLE = '',$
                         /RETURN_EVENTS,$
                         /FLOAT)

;***** +++ Button *************************************************************
wButton3Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton3Plus.uname,$
                             XOFFSET   = sButton3Plus.size[0],$
                             YOFFSET   = sButton3Plus.size[1],$
                             SCR_XSIZE = sButton3Plus.size[2],$
                             SCR_YSIZE = sButton3Plus.size[3],$
                             VALUE     = sButton3Plus.value)

;***** ++ Button **************************************************************
wButton2Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton2Plus.uname,$
                             XOFFSET   = sButton2Plus.size[0],$
                             YOFFSET   = sButton2Plus.size[1],$
                             SCR_XSIZE = sButton2Plus.size[2],$
                             SCR_YSIZE = sButton2Plus.size[3],$
                             VALUE     = sButton2Plus.value)

;***** + Button ***************************************************************
wButton1Plus = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton1Plus.uname,$
                             XOFFSET   = sButton1Plus.size[0],$
                             YOFFSET   = sButton1Plus.size[1],$
                             SCR_XSIZE = sButton1Plus.size[2],$
                             SCR_YSIZE = sButton1Plus.size[3],$
                             VALUE     = sButton1Plus.value)

;***** --- Button *************************************************************
wButton3Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton3Less.uname,$
                             XOFFSET   = sButton3Less.size[0],$
                             YOFFSET   = sButton3Less.size[1],$
                             SCR_XSIZE = sButton3Less.size[2],$
                             SCR_YSIZE = sButton3Less.size[3],$
                             VALUE     = sButton3Less.value)

;***** -- Button **************************************************************
wButton2Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton2Less.uname,$
                             XOFFSET   = sButton2Less.size[0],$
                             YOFFSET   = sButton2Less.size[1],$
                             SCR_XSIZE = sButton2Less.size[2],$
                             SCR_YSIZE = sButton2Less.size[3],$
                             VALUE     = sButton2Less.value)

;***** - Button ***************************************************************
wButton1Less = WIDGET_BUTTON(wScalingBase,$
                             UNAME     = sButton1Less.uname,$
                             XOFFSET   = sButton1Less.size[0],$
                             YOFFSET   = sButton1Less.size[1],$
                             SCR_XSIZE = sButton1Less.size[2],$
                             SCR_YSIZE = sButton1Less.size[3],$
                             VALUE     = sButton1Less.value)

;------------------------------------------------------------------------------

;;***** Display or not data ****************************************************
;wDisplayDataLabel = WIDGET_LABEL(wHiddenBase,$
;                                 XOFFSET = sDisplayDataLabel.size[0],$
;                                 YOFFSET = sDisplayDataLabel.size[1],$
;                                 VALUE   = sDisplayDataLabel.value)
;
;;***** Display data cw_bgroup *************************************************
;wDisplayDataGroup = CW_BGROUP(wHiddenBase,$
;                              sDisplayDataGroup.list,$
;                              XOFFSET   = sDisplayDataGroup.size[0],$
;                              YOFFSET   = sDisplayDataGroup.size[1],$
;                              SET_VALUE = sDisplayDataGroup.value,$
;                              UNAME     = sDisplayDataGroup.uname,$
;                              ROW       = 1,$
;                              /EXCLUSIVE)
;
;;***** flt0, flt1_low and flt1_high text field ********************************
;wStep3FltTextField = WIDGET_TEXT(wHiddenBase,$
;                                 UNAME     = sStep3FltTextField.uname,$
;                                 XOFFSET   = sStep3FltTextField.size[0],$
;                                 YOFFSET   = sStep3FltTextField.size[1],$
;                                 SCR_XSIZE = sStep3FltTextField.size[2],$
;                                 SCR_YSIZE = sStep3FltTextField.size[3],$
;                                 /SCROLL)
;
;;***** flt0, flt1_low and flt1_high label *************************************
;wStep3FltLabel = WIDGET_LABEL(wHiddenBase,$
;                              XOFFSET = sStep3FltLabel.size[0],$
;                              YOFFSET = sStep3FltLabel.size[1],$
;                              VALUE   = sStep3FltLabel.value)
END

;------------------------------------------------------------------------------
PRO make_gui_step3
END
