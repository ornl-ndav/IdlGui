FUNCTION MakeGuiStep1, StepsTabSize, STEPS_TAB, distanceMD, angleValue, ListOfFiles, Step1Title

;define default values
ColorSliderDefaultValue = 25

;Define widgets position and size
Step1Size                = [0  , 0  , StepsTabSize[2] , StepsTabSize[3]]
LoadButton               = [5  , 5  , 100 , 30 ]
ClearButton              = [110, 5  , 100 , 30 ]
ListOfFilesSize          = [220, 5  , 250 , 30 ]
InputFileFormatLabelSize = [5  , 45 , 120 , 30 ]
InputFileFormatSize      = [130 , InputFileFormatLabelSize[1]]

;value of selected angle and dMD
dMDAngleInfoLabelSize = [InputFileFormatSize[0]+100,$
                         InputFileFormatSize[1],$
                         300,30]

;base that covers the entire first part and will contain the angle/dMD widgets
dMDAngleBaseSize      = [5,5,StepsTabSize[2]-20,105]
dMDAngleMainLabelSize = [5,5]
dMDAngleMainLabelTitle = 'To go from TOF to Q, the file you are about to'
dMDAngleMainLabelTitle += ' load will use:'

ModeratorDetectorDistanceLabelSize = [5,35]
ModeratorDetectorDistanceLabelTitle = 'Distance Moderator-Detector (m):'
ModeratorDetectorDistanceTextFieldSize = [210,$
                                          ModeratorDetectorDistanceLabelSize[1]-6,$
                                          100,$
                                          30]
yoff = 35
AngleLabelSize = [5,ModeratorDetectorDistanceLabelSize[1]+yoff]
                  
AngleTextFieldSize = [100,$
                      AngleLabelSize[1]-6,$
                      100,$
                      ModeratorDetectorDistanceTextFieldSize[3]]
AngleUnitsSize = [ 200, AngleLabelSize[1]-6]

ErrorMessageBaseSize = [ModeratorDetectorDistanceLabelSize[0]+308,$
                        ModeratorDetectorDistanceLabelSize[1]-8,$
                        190,$
                        30]
ErrorMessageLabelSize = [0, 0, 210, 30]

OkLoadButtonSize     = [312,AngleTextFieldSize[1],$
                        95,30]
OkLoadButtonTitle = 'OK'
CancelLoadButtonsize = [412,AngleTextFieldSize[1],$
                        okLoadButtonsize[2],$
                        okLoadButtonSize[3]]
CancelLoadButtonTitle = 'CANCEL'

;text box that gives info about selected file
FileInfoSize         = [5 , 80, 510 , 240]
ListOfColorLabelSize = [5 , 330, 50  , 30 ]
ListOfColorSize      = [60, 320, 310 , 35 ]
ColorFileLabelSize   = [ListOfColorSize[0]+ListOfColorSize[2],$
                        ListOfColorLabelSize[1],$
                        150,$
                        35]
BlackLabelsize       = [50, 350, 50  , 30 ]
ColorYoff = 55
BlueLabelSize        = [BlackLabelSize[0]+ColorYoff,$
                        BlackLabelSize[1], 50 , 30 ]
RedLabelSize         = [BlackLabelSize[0]+2*ColorYoff,$
                        BlackLabelSize[1], 50 , 30 ]
OrangeLabelSize      = [BlackLabelSize[0]+3*ColorYoff,$
                        BlackLabelSize[1], 50  , 30 ]
YellowLabelSize      = [BlackLabelSize[0]+4*ColorYoff,$
                        BlackLabelSize[1], 50  , 30 ]
WhiteLabelSize       = [BlackLabelSize[0]+5*ColorYoff,$
                        BlackLabelSize[1], 50  , 30 ]


;Define titles
LoadButtonTitle = 'Load File'
ClearButtonTitle = 'Clear File'
ListOfFilesTitle = 'List of files:'
ListOfColorTitle = 'Color:'
BlackLabelTitle = 'Black'
BlueLabelTitle = 'Blue'
RedLabelTitle = 'Red'
OrangeLabelTitle = 'Orange'
YellowLabelTitle = 'Yellow'
WhiteLabelTitle = 'White'
input_file_label = 'Input file format:'
input_file_format = ['TOF','Q']


;Build GUI
STEP1_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step1',$
                         TITLE=Step1Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

;---------------------------------------------------------
dMDAngleBase = widget_base(STEP1_BASE,$
                           uname='dMD_angle_base',$
                           xoffset=dMDAngleBaseSize[0],$
                           yoffset=dMDAngleBaseSize[1],$
                           scr_xsize=dMDAngleBaseSize[2],$
                           scr_ysize=dMDAngleBaseSize[3],$
                           frame=1,$
                           map=0)

ErrorMessageBase = widget_base(dMDAngleBase,$
                               xoffset=ErrorMessageBaseSize[0],$
                               yoffset=ErrorMessageBaseSize[1],$
                               scr_xsize=ErrorMessageBaseSize[2],$
                               scr_ysize=ErrorMessageBaseSize[3],$
                               uname='ErrorMessageBase',$
                               frame=1,$
                               map=0)

ErrorMessageLabel = widget_label(ErrorMessageBase,$
                                 uname='ErrorMessageLabel',$
                                 xoffset=ErrorMessageLabelSize[0],$
                                 yoffset=ErrorMessageLabelSize[1],$
                                 scr_xsize=ErrorMessageLabelSize[2],$
                                 scr_ysize=ErrorMessageLabelSize[3],$
                                 value='')


dMDAngleMainLabel = widget_label(dMDAngleBase,$
                                 xoffset=dMDAngleMainLabelSize[0],$
                                 yoffset=dMDAngleMainLabelSize[1],$
                                 value=dMDAngleMainLabelTitle)

ModeratorDetectorDistanceLabel = WIDGET_LABEL(dMDAngleBase,$
                                              XOFFSET=ModeratorDetectorDistanceLabelSize[0],$
                                              YOFFSET=ModeratorDetectorDistanceLabelSize[1],$
                                              VALUE=ModeratorDetectorDistanceLabelTitle)

ModeratorDetectorDistanceTextField = WIDGET_TEXT(dMDAngleBase,$
                                                 XOFFSET=ModeratorDetectorDistanceTextFieldSize[0],$
                                                 YOFFSET=ModeratorDetectorDistanceTextFieldSize[1],$
                                                 SCR_XSIZE=ModeratorDetectorDistanceTextFieldSize[2],$
                                                 SCR_YSIZE=ModeratorDetectorDistanceTextFieldSize[3],$
                                                 UNAME='ModeratorDetectorDistanceTextField',$
                                                 VALUE=distanceMD,$
                                                 /editable,$
                                                 /align_left,$
                                                 /all_events)


AngleUnitList = ['rad','degree']
AngleUnits = CW_BGROUP(dMDAngleBase,$
                       AngleUnitList,$
                       /exclusive,$
                       /return_name,$
                       XOFFSET=AngleUnitsSize[0],$
                       YOFFSET=AngleUnitsSize[1],$
                       SET_VALUE=1.0,$
                       row=1,$
                       uname='AngleUnits')                 

AngleLabel = WIDGET_LABEL(dMDAngleBase,$
                          XOFFSET=AngleLabelSize[0],$
                          YOFFSET=AngleLabelSize[1],$
                          VALUE='Polar angle:')

AngleTextField = WIDGET_TEXT(dMDAngleBase,$
                             UNAME='AngleTextField',$
                             XOFFSET=AngleTextFieldSize[0],$
                             YOFFSET=AngleTextFieldSize[1],$
                             SCR_XSIZE=AngleTextFieldSize[2],$
                             SCR_YSIZE=AngleTextFieldSize[3],$
                             /EDITABLE,$
                             /align_left,$
                             /all_events)

OkLoadButton = widget_button(dMDAngleBase,$
                             uname='ok_load_button',$
                             xoffset=OkLoadButtonSize[0],$
                             yoffset=OkLoadButtonSize[1],$
                             scr_xsize=OkLoadButtonSize[2],$
                             scr_ysize=OkLoadButtonSize[3],$
                             sensitive=0,$
                             value=okLoadButtonTitle)

CancelLoadButton = widget_button(dMDAngleBase,$
                                 uname='cancel_load_button',$
                                 xoffset=CancelLoadButtonSize[0],$
                                 yoffset=CancelLoadButtonSize[1],$
                                 scr_xsize=CancelLoadButtonSize[2],$
                                 scr_ysize=CancelLoadButtonSize[3],$
                                 sensitive=1,$
                                 value=CancelLoadButtonTitle)

;------------------end of angle and distance base

LOAD_BUTTON = WIDGET_BUTTON(STEP1_BASE,$
                            UNAME='load_button',$
                            XOFFSET=LoadButton[0],$
                            YOFFSET=LoadButton[1],$
                            SCR_XSIZE=LoadButton[2],$
                            SCR_YSIZE=LoadButton[3],$
                            SENSITIVE=1,$
                            VALUE=LoadButtonTitle)

CLEAR_BUTTON = WIDGET_BUTTON(STEP1_BASE,$
                            UNAME='clear_button',$
                            XOFFSET=ClearButton[0],$
                            YOFFSET=ClearButton[1],$
                            SCR_XSIZE=ClearButton[2],$
                            SCR_YSIZE=ClearButton[3],$
                            SENSITIVE=0,$
                            VALUE=ClearButtonTitle)

LIST_OF_FILES_DROPLIST = WIDGET_DROPLIST(STEP1_BASE,$
                                         UNAME='list_of_files_droplist',$
                                         XOFFSET=ListOfFilesSize[0],$
                                         YOFFSET=ListOfFilesSize[1],$
                                         SCR_XSIZE=ListOfFilesSize[2],$
                                         SCR_YSIZE=ListOfFilesSize[3],$
                                         VALUE=ListOfFiles,$
                                         TITLE=ListOfFilesTitle)

InputFileFormatLabel = WIDGET_LABEL(STEP1_BASE,$
                                    XOFFSET=InputFileFormatLabelSize[0],$
                                    YOFFSET=InputFileFormatLabelSize[1],$
                                    SCR_XSIZE=InputFileFormatLabelSize[2],$
                                    SCR_YSIZE=InputFileFormatLabelSize[3],$
                                    VALUE='Input file format:')


InputFileFormat = CW_BGROUP(STEP1_BASE,$ 
                            input_file_format,$
                            /exclusive,$
                            /RETURN_NAME,$
                            XOFFSET=InputFileFormatSize[0],$
                            YOFFSET=InputFileFormatSize[1],$
                            SET_VALUE=1.0,$
                            row=1,$
                            uname='InputFileFormat')                 

;Info label that show the current angle value and dMD
dMDAngleInfoLabel = widget_label(STEP1_BASE,$
                                 uname='dMD_angle_info_label',$
                                 xoffset=dMDAngleInfoLabelSize[0],$
                                 yoffset=dMDAngleInfoLabelSize[1],$
                                 scr_xsize=dMDAngleInfoLabelSize[2],$
                                 scr_ysize=dMDAngleInfoLabelSize[3],$
                                 value ='')
                                 ;value='(Angle: 3.14 degrees & dMD: 14.50 m)')



FILE_INFO = WIDGET_TEXT(STEP1_BASE,$
                        UNAME='file_info',$
                        XOFFSET=FileInfoSize[0],$
                        YOFFSET=FileInfoSize[1],$
                        SCR_XSIZE=FileInfoSize[2],$
                        SCR_YSIZE=FileInfoSize[3],$
                        /SCROLL,$
                        /WRAP)
                        
LIST_OF_COLOR_LABEL = WIDGET_LABEL(STEP1_BASE,$
                                   VALUE=ListOfColorTitle,$
                                   XOFFSET=ListOfColorLabelSize[0],$
                                   YOFFSET=ListOfColorLabelSize[1],$
                                   SCR_XSIZE=ListOfColorLabelSize[2],$
                                   SCR_YSIZE=ListOfColorLabelSize[3])

LIST_OF_COLOR_SLIDER = WIDGET_SLIDER(STEP1_BASE,$
                                     UNAME='list_of_color_slider',$
                                     MINIMUM=0,$
                                     MAXIMUM=255,$
                                     XOFFSET=ListOfColorSize[0],$
                                     YOFFSET=ListOfColorSize[1],$
                                     SCR_XSIZE=ListOfColorSize[2],$
                                     SCR_YSIZE=ListOfColorSize[3],$
                                     TITLE=ListOfColorTitle,$
                                     VALUE=ColorSliderDefaultValue,$
                                     sensitive=1)

ColorFileLabel = WIDGET_LABEL(STEP1_BASE,$
                              UNAME='ColorFileLabel',$
                              XOFFSET=ColorFileLabelSize[0],$
                              YOFFSET=ColorFileLabelSize[1],$
                              SCR_XSIZE=ColorFileLabelSize[2],$
                              SCR_YSIZE=ColorFileLabelSize[3],$
                              VALUE='')

BlackLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=BlackLabelSize[0],$
                          YOFFSET=BlackLabelSize[1],$
                          SCR_XSIZE=BlackLabelSize[2],$
                          SCR_YSIZE=BlackLabelSize[3],$
                          VALUE=BlackLabelTitle)

BlueLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=BlueLabelSize[0],$
                          YOFFSET=BlueLabelSize[1],$
                          SCR_XSIZE=BlueLabelSize[2],$
                          SCR_YSIZE=BlueLabelSize[3],$
                          VALUE=BlueLabelTitle)

RedLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=RedLabelSize[0],$
                          YOFFSET=RedLabelSize[1],$
                          SCR_XSIZE=RedLabelSize[2],$
                          SCR_YSIZE=RedLabelSize[3],$
                          VALUE=RedLabelTitle)

OrangeLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=OrangeLabelSize[0],$
                          YOFFSET=OrangeLabelSize[1],$
                          SCR_XSIZE=OrangeLabelSize[2],$
                          SCR_YSIZE=OrangeLabelSize[3],$
                          VALUE=OrangeLabelTitle)

YellowLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=YellowLabelSize[0],$
                          YOFFSET=YellowLabelSize[1],$
                          SCR_XSIZE=YellowLabelSize[2],$
                          SCR_YSIZE=YellowLabelSize[3],$
                          VALUE=YellowLabelTitle)

WhiteLabel = WIDGET_LABEL(STEP1_BASE,$
                          XOFFSET=WhiteLabelSize[0],$
                          YOFFSET=WhiteLabelSize[1],$
                          SCR_XSIZE=WhiteLabelSize[2],$
                          SCR_YSIZE=WhiteLabelSize[3],$
                          VALUE=WhiteLabelTitle)

Return, Step1Size
END
