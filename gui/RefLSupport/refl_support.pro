pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    Widget_Info(wWidget, FIND_BY_UNAME='steps_tab'): begin
        steps_tab, Event, 0
    end

    ;--step1--
    Widget_Info(wWidget, FIND_BY_UNAME='load_button'): begin
        load_file, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='list_of_files_droplist'): begin
        display_info_about_file, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='clear_button'): begin
        clear_file, Event
    end
    
    ;--step2--
    Widget_Info(wWidget, FIND_BY_UNAME='base_file_droplist'): begin
         step2_base_file_droplist, Event
         print, 'here'
    end

    Widget_Info(wWidget, FIND_BY_UNAME='Step2_button'): begin
        run_step2, Event
    end

    ;--step3--
    Widget_Info(wWidget, FIND_BY_UNAME='step3_base_file_droplist'): begin
        step3_base_file_droplist, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): begin
        step3_work_on_file_droplist, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='Step3_button'): begin
        run_step3, Event
    end

    ;--reset all button
    Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): begin
        reset_all_button, Event
    end
    
    ;--refresh plots
    Widget_Info(wWidget, FIND_BY_UNAME='refresh_plot_button'): begin
        steps_tab, Event, 1
    end

else:
    
endcase

end



pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'refl_support_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux 
;and set ucams to 'j35' if runningon darwin
if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

global = ptr_new({  $
                   FirstTimePlotting : 1,$         ;1 if first plot, 0 if not
                   ucams          : '',$             ;remote user ucams
                   file_extension : '.txt',$         ;file extension of file to load
                   input_path     : '',$             ;default path to file to load
                   PrevTabSelect  : 0,$              ;value of previous tab selected
                   FileHistory    : ptr_new(0L),$    ;#0:CE file #1:next file...etc
                   list_of_files  : ptr_new(0L),$    ;list of files loaded
                   Q1_array       : ptr_new(0L),$    ;Q1 array
                   Q2_array       : ptr_new(0L),$    ;Q2 array
                   SF_array       : ptr_new(0L),$    ;Scalling factor array
                   color_array    : ptr_new(0L),$    ;index of color for each file 
                   ColorSliderDefaultValue : 100,$   ;default index value of color slider
                   ListOfLongFileName : ptr_new(0L)$ ;list of path of file loaded
                 })

FileHistory   = strarr(1)
list_of_files = strarr(1)
Q1_array      = lonarr(1)
Q2_array      = lonarr(1)
SF_array      = lonarr(1)
color_array   = lonarr(1)
ColorSliderDefaultValue = (*global).ColorSliderDefaultValue
color_array[0] = ColorSliderDefaultValue
ListOfLongFileName = strarr(1)
(*(*global).FileHistory) = FileHistory
(*(*global).list_of_files) = list_of_files
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
(*(*global).color_array) = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*global).ucams      = ucams

if (!VERSION.os EQ 'darwin') then begin
   (*global).input_path = '~/tmp/'
endif else begin
   (*global).input_path = '~' + ucams
endelse


;def of parameters used for positioning and sizing widgets
;[xoff,yoff,width,height]

MainBaseSize         = [50 , 500, 1200, 600]
PlotWindowSize       = [5  , 5  , 650 , 590]
StepsTabSize         = [660, 5  , 530 , 400]

;--Step1--
Step1Size            = [0  , 0  , StepsTabSize[2] , StepsTabSize[3]]
LoadButton           = [5  , 5  , 100 , 30 ]
ClearButton          = [110, 5  , 100 , 30 ]
ListOfFilesSize      = [220, 5  , 250 , 30 ]
FileInfoSize         = [5  , 40 , 510 , 260]
ListOfColorLabelSize = [5  , 310, 100 , 30 ]
ListOfColorSize      = [110, 300, 310 , 35 ]
BlackLabelsize       = [100, 330, 50  , 30 ]
ColorYoff = 55
BlueLabelSize        = [BlackLabelSize[0]+ColorYoff,$
                        330, 50  , 30 ]
RedLabelSize         = [BlackLabelSize[0]+2*ColorYoff,$
                        330, 50  , 30 ]
OrangeLabelSize      = [BlackLabelSize[0]+3*ColorYoff,$
                        330, 50  , 30 ]
YellowLabelSize      = [BlackLabelSize[0]+4*ColorYoff,$
                        330, 50  , 30 ]
WhiteLabelSize       = [BlackLabelSize[0]+5*ColorYoff,$
                        330, 50  , 30 ]

;--Step2--
BaseFileSize         = [5  , 5  , 250 , 30 ]
Step2GoButtonSize    = [350, 7  , 170 , 30 ]
distance_L_TB        = 30
Step2Q1LabelSize     = [5  , 45 , 30  , 30 ]
Step2Q1TextFieldSize = [Step2Q1LabelSize[0]+distance_L_TB, $
                        Step2Q1LabelSize[1],$
                        120,$
                        Step2Q1LabelSize[3]]
distance_L_L         = 155
Step2Q2LabelSize     = [Step2Q1LabelSize[0]+distance_L_L, $
                        Step2Q1LabelSize[1],$
                        Step2Q1LabelSize[2],$
                        Step2Q1LabelSize[3]]
Step2Q2TextFieldSize = [Step2Q2LabelSize[0]+distance_L_TB, $
                        Step2Q1LabelSize[1],$
                        Step2Q1TextFieldSize[2],$
                        Step2Q1LabelSize[3]]
Step2SFLabelSize     = [Step2Q1LabelSize[0]+2*distance_L_L, $
                        Step2Q1LabelSize[1],$
                        Step2Q1LabelSize[2],$
                        Step2Q1LabelSize[3]]
Step2SFTextFieldSize = [Step2SFLabelSize[0]+distance_L_TB,$
                        Step2Q1LabelSize[1],$
                        Step2Q1TextFieldSize[2],$
                        Step2Q1LabelSize[3]]
;--Step3
Step3BaseFileSize    = [5  , 5  , 300 , 30 ]
Step3WorkOnFileSize  = [Step3BaseFileSize[0],$
                        45 ,$
                        Step3BaseFileSize[2],$
                        Step3BaseFileSize[3]]
Step3GoButtonSize    = [310, 7  , 205 , 70 ]
Step3Q1LabelSize     = [5  , 90 , 30  , 30 ]
Step3Q1TextFieldSize = [Step3Q1LabelSize[0]+distance_L_TB, $
                        Step3Q1LabelSize[1],$
                        120,$
                        Step3Q1LabelSize[3]]
Step3Q2LabelSize     = [Step3Q1LabelSize[0]+distance_L_L, $
                        Step3Q1LabelSize[1],$
                        Step3Q1LabelSize[2],$
                        Step3Q1LabelSize[3]]
Step3Q2TextFieldSize = [Step3Q2LabelSize[0]+distance_L_TB, $
                        Step3Q1LabelSize[1],$
                        Step3Q1TextFieldSize[2],$
                        Step3Q1LabelSize[3]]
Step3SFLabelSize     = [Step3Q1LabelSize[0]+2*distance_L_L, $
                        Step3Q1LabelSize[1],$
                        Step3Q1LabelSize[2],$
                        Step3Q1LabelSize[3]]
Step3SFTextFieldSize = [Step3SFLabelSize[0]+distance_L_TB,$
                        Step3Q1LabelSize[1],$
                        Step3Q1TextFieldSize[2],$
                        Step3Q1LabelSize[3]]
;--RESET ALL
yoff = 5
ResetAllButtonSize   = [StepsTabSize[0],$
                        StepsTabSize[3]+yoff,$
                        200,$
                        30]
RefreshPlotSize      = [StepsTabSize[0]+ResetAllButtonSize[2],$
                        StepsTabSize[3]+yoff,$
                        ResetAllButtonSize[2],$
                        ResetAllButtonSize[3]]
;--RESCALE 
yoff = 40
xoff = 5
RescaleBaseSize      = [StepsTabSize[0],$
                        StepsTabSize[3]+yoff,$
                        StepsTabSize[2]-xoff,$
                        80]
d12 = 50  ;distance between 'x-axis:' and 'min:'
d23 = 35  ;distance between 'min' and text field
d34 = 80  ;distance between text field and 'max'
d45 = d23  ;distance between 'max' and text field
d56 = 80  ;distance between text field and lin/log
d67 = 95 ;distance between lin/log and validate button
d78 = 70  ;distance between validate button and reset button
axis_lin_log = ['lin','log']
LabelSize    = [35,30]   ;scr_xsize and scr_ysize
TextBoxSize  = [70,30]   ;scr_xsize and scr_ysize
ResetButton  = [70,30]  ;scr_xsize and scr_ysize
ValidateButton = [70,65] ;scr_xsize and scr_ysize
;xaxis
XaxisLabelSize       = [5,$
                        5,$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMinLabelSize    = [XaxisLabelSize[0]+d12,$
                        XaxisLabelSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMinTextFieldSize= [XaxisMinLabelSize[0]+d23,$
                        XaxisMinLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
XaxisMaxLabelSize    = [XaxisMinTextFieldSize[0]+d34,$
                        XaxisMinTextFieldSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
XaxisMaxTextFieldSize= [XaxisMaxLabelSize[0]+d45,$
                        XaxisMaxLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
XaxisLinLogSize      = [XaxisMaxTextFieldSize[0]+d56,$
                        XaxisMaxTextFieldSize[1]]
ValidateButtonSize = [XAxisLinLogsize[0]+d67,$
                      XAxisLinLogSize[1],$
                      ValidateButton[0],$
                      ValidateButton[1]]
XResetButtonSize     = [ValidateButtonSize[0]+d78,$
                        ValidateButtonSize[1],$
                        ResetButton[0],$
                        ResetButton[1]]
                                
;yaxis
yoff= 35
YaxisLabelSize       = [5,$
                        5+yoff,$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMinLabelSize    = [YaxisLabelSize[0]+d12,$
                        YaxisLabelSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMinTextFieldSize= [YaxisMinLabelSize[0]+d23,$
                        YaxisMinLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
YaxisMaxLabelSize    = [YaxisMinTextFieldSize[0]+d34,$
                        YaxisMinTextFieldSize[1],$
                        LabelSize[0],$
                        LabelSize[1]]
YaxisMaxTextFieldSize= [YaxisMaxLabelSize[0]+d45,$
                        YaxisMaxLabelSize[1],$
                        TextBoxSize[0],$
                        TextBoxSize[1]]
YaxisLinLogSize      = [YaxisMaxTextFieldSize[0]+d56,$
                        YaxisMaxTextFieldSize[1]]
YResetButtonSize     = [ValidateButtonSize[0]+d78,$
                        YAxisLinLogSize[1],$
                        ResetButton[0],$
                        ResetButton[1]]


MainTitle = "REF_L SUPPORT - CRITICAL EDGES PROGRAM"
;--Step1--
Step1Title = 'LOAD FILES'
Step2Title = 'DEFINE CRITICAL EDGE FILE'
Step3Title = 'RESCALE FILES'
LoadButtonTitle = 'Load File'
ClearButtonTitle = 'Clear File'
ListOfFilesTitle = 'List of files:'
ListOfColorTitle = 'Color index:'
BlackLabelTitle = 'Black'
BlueLabelTitle = 'Blue'
RedLabelTitle = 'Red'
OrangeLabelTitle = 'Orange'
YellowLabelTitle = 'Yellow'
WhiteLabelTitle = 'White'

;--Step2--
BaseFileTitle = 'Critical edge file:'
Step2GoButtonTitle = 'Rescale Critical Edge'
Step2Q1LabelTitle = 'Q1:'
Step2Q2LabelTitle = 'Q2:'
Step2SFLabelTitle = 'SF:'
;--Step3--
Step3BaseFileTitle   = 'Base File:'
Step3WorkOnFileTitle = '  Work On:'
Step3GoButtonTitle = 'Rescale Work-on file'
ListOfFiles  = ['                            ']  
;Main Base
RefreshPlotButtonTitle = 'Refresh Plot'

MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME='MAIN_BASE',$
                        XOFFSET=MainBaseSize[0],$
                        YOFFSET=MainBaseSize[1],$
                        SCR_XSIZE=MainBaseSize[2], $
                        SCR_YSIZE=MainBaseSize[3], $
                        TITLE=MainTitle,$
                        MBAR=WID_BASE_0_MBAR)

PLOT_WINDOW = WIDGET_DRAW(MAIN_BASE,$
                          UNAME='plot_window',$
                          XOFFSET=PlotWindowSize[0],$
                          YOFFSET=PlotWindowSize[1],$
                          SCR_XSIZE=PlotWindowSize[2],$
                          SCR_YSIZE=PlotWindowSize[3],$
                          RETAIN=2,$
                          /BUTTON_EVENTS,$
                          /MOTION_EVENTS)

STEPS_TAB = WIDGET_TAB(MAIN_BASE,$
                       UNAME='steps_tab',$
                       LOCATION=0,$
                       XOFFSET=StepsTabSize[0],$
                       YOFFSET=StepsTabSize[1],$
                       SCR_XSIZE=StepsTabSize[2],$
                       SCR_YSIZE=StepsTabSize[3],$
                       /TRACKING_EVENTS)

;--STEP 1-----------------------------------------------------------------------
STEP1_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step1',$
                         TITLE=Step1Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

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
                                     VALUE=ColorSliderDefaultValue)

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
;--STEP 2-----------------------------------------------------------------------
STEP2_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step2',$
                         TITLE=Step2Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

BASE_FILE_DROPLIST = WIDGET_DROPLIST(STEP2_BASE,$
                                     UNAME='base_file_droplist',$
                                     XOFFSET=BaseFileSize[0],$
                                     YOFFSET=BaseFileSize[1],$
                                     SCR_XSIZE=BaseFileSize[2],$
                                     SCR_YSIZE=BaseFileSize[3],$
                                     VALUE=ListOfFiles,$
                                     TITLE=BaseFileTitle)

STEP2_BUTTON = WIDGET_BUTTON(STEP2_BASE,$
                             UNAME='Step2_button',$
                             XOFFSET=Step2GoButtonSize[0],$
                             YOFFSET=Step2GoButtonSize[1],$
                             SCR_XSIZE=Step2GoButtonSize[2],$
                             SCR_YSIZE=Step2GoButtonSize[3],$
                             SENSITIVE=1,$
                             VALUE=Step2GoButtonTitle)

STEP2_Q1_LABEL = WIDGET_LABEL(STEP2_BASE,$
                              XOFFSET=Step2Q1LabelSize[0],$
                              YOFFSET=Step2Q1LabelSize[1],$
                              SCR_XSIZE=Step2Q1LabelSize[2],$
                              SCR_YSIZE=Step2Q1LabelSize[3],$
                              VALUE=Step2Q1LabelTitle)

STEP2_Q1_TEXT_FIELD = WIDGET_TEXT(STEP2_BASE,$
                                  UNAME='step2_q1_text_field',$
                                  XOFFSET=Step2Q1TextFieldSize[0],$
                                  YOFFSET=Step2Q1TextFieldSize[1],$
                                  SCR_XSIZE=Step2Q1TextFieldSize[2],$
                                  SCR_YSIZE=Step2Q1TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP2_Q2_LABEL = WIDGET_LABEL(STEP2_BASE,$
                              XOFFSET=Step2Q2LabelSize[0],$
                              YOFFSET=Step2Q2LabelSize[1],$
                              SCR_XSIZE=Step2Q2LabelSize[2],$
                              SCR_YSIZE=Step2Q2LabelSize[3],$
                              VALUE=Step2Q2LabelTitle)

STEP2_Q2_TEXT_FIELD = WIDGET_TEXT(STEP2_BASE,$
                                  UNAME='step2_q2_text_field',$
                                  XOFFSET=Step2Q2TextFieldSize[0],$
                                  YOFFSET=Step2Q2TextFieldSize[1],$
                                  SCR_XSIZE=Step2Q2TextFieldSize[2],$
                                  SCR_YSIZE=Step2Q2TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP2_SF_LABEL = WIDGET_LABEL(STEP2_BASE,$
                              XOFFSET=Step2SFLabelSize[0],$
                              YOFFSET=Step2SFLabelSize[1],$
                              SCR_XSIZE=Step2SFLabelSize[2],$
                              SCR_YSIZE=Step2SFLabelSize[3],$
                              VALUE=Step2SFLabelTitle)

STEP2_SF_TEXT_FIELD = WIDGET_TEXT(STEP2_BASE,$
                                  UNAME='step2_sf_text_field',$
                                  XOFFSET=Step2SFTextFieldSize[0],$
                                  YOFFSET=Step2SFTextFieldSize[1],$
                                  SCR_XSIZE=Step2SFTextFieldSize[2],$
                                  SCR_YSIZE=Step2SFTextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

;--STEP 3--
STEP3_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step3',$
                         TITLE=Step3Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

STEP3_BASE_FILE_DROPLIST = WIDGET_DROPLIST(STEP3_BASE,$
                                           UNAME='step3_base_file_droplist',$
                                           XOFFSET=Step3BaseFileSize[0],$
                                           YOFFSET=Step3BaseFileSize[1],$
                                           SCR_XSIZE=Step3BaseFileSize[2],$
                                           SCR_YSIZE=Step3BaseFileSize[3],$
                                           VALUE=ListOfFiles,$
                                           TITLE=Step3BaseFileTitle)

STEP3_WORK_ON_FILE_DROPLIST = WIDGET_DROPLIST(STEP3_BASE,$
                                           UNAME='step3_work_on_file_droplist',$
                                           XOFFSET=Step3WorkOnFileSize[0],$
                                           YOFFSET=Step3WorkOnFileSize[1],$
                                           SCR_XSIZE=Step3WorkOnFileSize[2],$
                                           SCR_YSIZE=Step3WorkOnFileSize[3],$
                                           VALUE=ListOfFiles,$
                                           TITLE=Step3WorkOnFileTitle)

STEP3_BUTTON = WIDGET_BUTTON(STEP3_BASE,$
                             UNAME='Step3_button',$
                             XOFFSET=Step3GoButtonSize[0],$
                             YOFFSET=Step3GoButtonSize[1],$
                             SCR_XSIZE=Step3GoButtonSize[2],$
                             SCR_YSIZE=Step3GoButtonSize[3],$
                             SENSITIVE=1,$
                             VALUE=Step3GoButtonTitle)

STEP3_Q1_LABEL = WIDGET_LABEL(STEP3_BASE,$
                              XOFFSET=Step3Q1LabelSize[0],$
                              YOFFSET=Step3Q1LabelSize[1],$
                              SCR_XSIZE=Step3Q1LabelSize[2],$
                              SCR_YSIZE=Step3Q1LabelSize[3],$
                              VALUE=Step2Q1LabelTitle)

STEP3_Q1_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_q1_text_field',$
                                  XOFFSET=Step3Q1TextFieldSize[0],$
                                  YOFFSET=Step3Q1TextFieldSize[1],$
                                  SCR_XSIZE=Step3Q1TextFieldSize[2],$
                                  SCR_YSIZE=Step3Q1TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP3_Q2_LABEL = WIDGET_LABEL(STEP3_BASE,$
                              XOFFSET=Step3Q2LabelSize[0],$
                              YOFFSET=Step3Q2LabelSize[1],$
                              SCR_XSIZE=Step3Q2LabelSize[2],$
                              SCR_YSIZE=Step3Q2LabelSize[3],$
                              VALUE=Step2Q2LabelTitle)

STEP3_Q2_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_q2_text_field',$
                                  XOFFSET=Step3Q2TextFieldSize[0],$
                                  YOFFSET=Step3Q2TextFieldSize[1],$
                                  SCR_XSIZE=Step3Q2TextFieldSize[2],$
                                  SCR_YSIZE=Step3Q2TextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$
                                  /ALIGN_LEFT,$
                                  /ALL_EVENTS)

STEP3_SF_LABEL = WIDGET_LABEL(STEP3_BASE,$
                              XOFFSET=Step3SFLabelSize[0],$
                              YOFFSET=Step3SFLabelSize[1],$
                              SCR_XSIZE=Step3SFLabelSize[2],$
                              SCR_YSIZE=Step3SFLabelSize[3],$
                              VALUE=Step2SFLabelTitle)

STEP3_SF_TEXT_FIELD = WIDGET_TEXT(STEP3_BASE,$
                                  UNAME='step3_sf_text_field',$
                                  XOFFSET=Step3SFTextFieldSize[0],$
                                  YOFFSET=Step3SFTextFieldSize[1],$
                                  SCR_XSIZE=Step3SFTextFieldSize[2],$
                                  SCR_YSIZE=Step3SFTextFieldSize[3],$
                                  VALUE='',$
                                  /EDITABLE,$ 
                                  /ALIGN_LEFT,$ 
                                  /ALL_EVENTS)
;--RESET ALL BUTTONS--
RESET_ALL_BUTTON = WIDGET_BUTTON(MAIN_BASE,$
                                 UNAME='reset_all_button',$
                                 XOFFSET=ResetAllButtonSize[0],$
                                 YOFFSET=ResetAllButtonSize[1],$
                                 SCR_XSIZE=ResetAllButtonSize[2],$
                                 SCR_YSIZE=ResetAllButtonSize[3],$
                                 VALUE='RESET FULL SESSION',$
                                 sensitive=0)

REFRESH_PLOT_BUTTON = WIDGET_BUTTON(MAIN_BASE,$
                                    UNAME='refresh_plot_button',$
                                    XOFFSET=RefreshPlotSize[0],$
                                    YOFFSET=RefreshPlotSize[1],$
                                    SCR_XSIZE=RefreshPlotSize[2],$
                                    SCR_YSIZE=RefreshPlotSize[3],$
                                    VALUE=RefreshPlotButtonTitle,$
                                    sensitive=0)

;--rescale base
RescaleBase = WIDGET_BASE(MAIN_BASE,$
                          UNAME='RescaleBase',$
                          XOFFSET=RescaleBaseSize[0],$
                          YOFFSET=RescaleBaseSize[1],$
                          SCR_XSIZE=RescaleBaseSize[2],$
                          SCR_YSIZE=RescaleBaseSize[3],$
                          FRAME=1,$
                          SENSITIVE=1)

;xaxis
XaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET=XaxisLabelSize[0],$
                          YOFFSET=XaxisLabelSize[1],$
                          SCR_XSIZE=XaxisLabelSize[2],$
                          SCR_YSIZE=XaxisLabelSize[3],$
                          VALUE='X-axis')

XaxisMinLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET=XaxisMinLabelSize[0],$
                             YOFFSET=XaxisMinLabelSize[1],$
                             SCR_XSIZE=XaxisMinLabelSize[2],$
                             SCR_YSIZE=XaxisMinLabelSize[3],$
                             VALUE='min:')

XaxisMinTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME='XaxisMinTextField',$
                                XOFFSET=XaxisMinTextFieldSize[0],$
                                YOFFSET=XaxisMinTextFieldSize[1],$
                                SCR_XSIZE=XaxisMinTextFieldSize[2],$
                                SCR_YSIZE=XaxisMinTextFieldSize[3],$
                                VALUE='',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)
            
XaxisMaxLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET=XaxisMaxLabelSize[0],$
                             YOFFSET=XaxisMaxLabelSize[1],$
                             SCR_XSIZE=XaxisMaxLabelSize[2],$
                             SCR_YSIZE=XaxisMaxLabelSize[3],$
                             VALUE='max:')

XaxisMaxTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME='XaxisMaxTextField',$
                                XOFFSET=XaxisMaxTextFieldSize[0],$
                                YOFFSET=XaxisMaxTextFieldSize[1],$
                                SCR_XSIZE=XaxisMaxTextFieldSize[2],$
                                SCR_YSIZE=XaxisMaxTextFieldSize[3],$
                                VALUE='',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)    

XaxisLinLog = CW_BGROUP(RescaleBase,$ 
                         axis_lin_log,$
                         /exclusive,$
                         /RETURN_NAME,$
                         XOFFSET=XaxisLinLogSize[0],$
                         YOFFSET=XaxisLinLogSize[1],$
                         SET_VALUE=0.0,$
                         row=1,$
                         uname='XaxisLinLog')                 

ValidateButton = WIDGET_BUTTON(RescaleBase,$
                               XOFFSET=ValidateButtonSize[0],$
                               YOFFSET=ValidateButtonSize[1],$
                               SCR_XSIZE=ValidateButtonSize[2],$
                               SCR_YSIZE=ValidateButtonSize[3],$
                               UNAME='ValidateButton',$
                               VALUE='VALIDATE')

XResetButton = WIDGET_BUTTON(RescaleBase,$
                             XOFFSET=XResetButtonSize[0],$
                             YOFFSET=XResetButtonSize[1],$
                             SCR_XSIZE=XResetButtonSize[2],$
                             SCR_YSIZE=XResetButtonSize[3],$
                             UNAME='XResetButton',$
                             VALUE='Reset X')

;yaxis
YaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET=YaxisLabelSize[0],$
                          YOFFSET=YaxisLabelSize[1],$
                          SCR_XSIZE=YaxisLabelSize[2],$
                          SCR_YSIZE=YaxisLabelSize[3],$
                          VALUE='Y-axis')

YaxisMinLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET=YaxisMinLabelSize[0],$
                             YOFFSET=YaxisMinLabelSize[1],$
                             SCR_XSIZE=YaxisMinLabelSize[2],$
                             SCR_YSIZE=YaxisMinLabelSize[3],$
                             VALUE='min:')

YaxisMinTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME='YaxisMinTextField',$
                                XOFFSET=YaxisMinTextFieldSize[0],$
                                YOFFSET=YaxisMinTextFieldSize[1],$
                                SCR_XSIZE=YaxisMinTextFieldSize[2],$
                                SCR_YSIZE=YaxisMinTextFieldSize[3],$
                                VALUE='',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)
            
YaxisMaxLabel = WIDGET_LABEL(RescaleBase,$
                             XOFFSET=YaxisMaxLabelSize[0],$
                             YOFFSET=YaxisMaxLabelSize[1],$
                             SCR_XSIZE=YaxisMaxLabelSize[2],$
                             SCR_YSIZE=YaxisMaxLabelSize[3],$
                             VALUE='max:')

YaxisMaxTextField = WIDGET_TEXT(RescaleBase,$
                                UNAME='YaxisMaxTextField',$
                                XOFFSET=YaxisMaxTextFieldSize[0],$
                                YOFFSET=YaxisMaxTextFieldSize[1],$
                                SCR_XSIZE=YaxisMaxTextFieldSize[2],$
                                SCR_YSIZE=YaxisMaxTextFieldSize[3],$
                                VALUE='',$
                                /EDITABLE,$ 
                                /ALIGN_LEFT,$ 
                                /ALL_EVENTS)                     

YaxisLinLog = CW_BGROUP(RescaleBase,$ 
                         axis_lin_log,$
                         /exclusive,$
                         /RETURN_NAME,$
                         XOFFSET=YaxisLinLogSize[0],$
                         YOFFSET=YaxisLinLogSize[1],$
                         SET_VALUE=0.0,$
                         row=1,$
                         uname='YaxisLinLog')      

YResetButton = WIDGET_BUTTON(RescaleBase,$
                             XOFFSET=YResetButtonSize[0],$
                             YOFFSET=YResetButtonSize[1],$
                             SCR_XSIZE=YResetButtonSize[2],$
                             SCR_YSIZE=YResetButtonSize[3],$
                             UNAME='YResetButton',$
                             VALUE='Reset Y')


;Realize the widgets, set the user value of the top-level
;base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro refl_support, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
wTLB, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
