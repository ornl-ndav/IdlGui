pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
;    Widget_Info(wWidget, FIND_BY_UNAME='open_nexus_button'): begin
;        open_nexus_cb, Event
;    end
    
else:
    
endcase

end



pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user


Resolve_Routine, 'refl_support_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

;working_path = '/SNS/users/' + user + '/local/more_nexus/'

global = ptr_new({  $
                   Ntof			: 0L$
;                   img_ptr 		: ptr_new(0L),$
                 })



;def of parameters used for positioning and sizing widgets
;[xoff,yoff,width,height]

MainBaseSize    = [150, 150, 1200, 600]
PlotWindowSize  = [5  , 5  , 650 , 590]
StepsTabSize    = [660, 5  , 530 , 400]
Step1Size       = [0  , 0  , StepsTabSize[2] , StepsTabSize[3]]
LoadButton      = [5  , 5  , 100 , 30 ]
ClearButton     = [110, 5  , 100 , 30 ]
ListOfFilesSize = [220, 5  , 250 , 30 ]
FileInfoSize    = [5  , 40 , 510 , 260]
ListOfColorSize = [5  , 300, 100 , 30 ]

MainTitle = "REF_L SUPPORT - CRITICAL EDGES PROGRAM"
Step1Title = 'LOAD FILES'
Step2Title = 'DEFINED CRITICAL EDGE FILE'
Step3Title = 'RESCALE FILES'
LoadButtonTitle = 'Load File'
ClearButtonTitle = 'Clear File'
ListOfFilesTitle = 'List of files:'
ListOfColorTitle = 'Color of plot:'

ListOfFiles = ['                            ']
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









;--STEP 2--
STEP2_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step2',$
                         TITLE=Step2Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])

;--STEP 3--
STEP3_BASE = WIDGET_BASE(STEPS_TAB,$
                         UNAME='step3',$
                         TITLE=Step3Title,$
                         XOFFSET=Step1Size[0],$
                         YOFFSET=Step1Size[1],$
                         SCR_XSIZE=Step1Size[2],$
                         SCR_YSIZE=Step1Size[3])


;Realize the widgets, set the user value of the top-level
;base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro refl_support, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
wTLB, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
