pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
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

    Widget_Info(wWidget, FIND_BY_UNAME='list_of_color_droplist'): begin
        change_color_of_plot, Event
    end

    ;--step2--
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
                   ucams          : '',$             ;remote user ucams
                   file_extension : '.txt',$         ;file extension of file to load
                   input_path     : '',$             ;default path to file to load
                   list_of_files  : ptr_new(0L),$    ;list of files loaded
                   Q1_array       : ptr_new(0L),$    ;Q1 array
                   Q2_array       : ptr_new(0L),$    ;Q2 array
                   SF_array       : ptr_new(0L),$    ;Scalling factor array
                   ListOfLongFileName : ptr_new(0L)$     ;list of path of file loaded
                 })

list_of_files = strarr(1)
Q1_array      = lonarr(1)
Q2_array      = lonarr(1)
SF_array      = lonarr(1)
ListOfLongFileName = strarr(1)
(*(*global).list_of_files) = list_of_files
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*global).ucams      = ucams
(*global).input_path = '~' + ucams

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
ListOfColorSize      = [5  , 300, 100 , 30 ]
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

MainTitle = "REF_L SUPPORT - CRITICAL EDGES PROGRAM"
;--Step1--
Step1Title = 'LOAD FILES'
Step2Title = 'DEFINED CRITICAL EDGE FILE'
Step3Title = 'RESCALE FILES'
LoadButtonTitle = 'Load File'
ClearButtonTitle = 'Clear File'
ListOfFilesTitle = 'List of files:'
ListOfColorTitle = 'Color of plot:'
;--Step2--
BaseFileTitle = 'Critical edge file:'
Step2GoButtonTitle = 'Rescale Critical Edge'
Step2Q1LabelTitle = 'Q1:'
Step2Q2LabelTitle = 'Q2:'
Step2SFLabelTitle = 'SF:'
;--Step3--
Step3BaseFileTitle   = 'Base File:'
Step3WorkOnFileTitle = '  Work On:'

ListOfFiles  = ['                            ']  
ListOfcolor = ['red','white','green','purple']

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
                            SENSITIVE=1,$
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
                        
LIST_OF_COLOR_DROPLIST = WIDGET_DROPLIST(STEP1_BASE,$
                                         UNAME='list_of_color_droplist',$
                                         XOFFSET=ListOfColorSize[0],$
                                         YOFFSET=ListOfColorSize[1],$
                                         SCR_XSIZE=ListOfColorSize[2],$
                                         SCR_YSIZE=ListOfColorSize[3],$
                                         VALUE=ListOfColor,$
                                         TITLE=ListOfColorTitle)

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
                             VALUE=Step2GoButtonTitle)

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
