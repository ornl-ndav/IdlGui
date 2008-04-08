pro Build_GUI, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'ref_scale_eventcb',/COMPILE_FULL_FILE  ;Load event callback routines

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux 
;and set ucams to 'j35' if running on darwin
if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

APPLICATIoN   = 'REFscale' 
VERSION       = '1.0.8'

StrArray      = strsplit(VERSION,'.',/extract)
VerArray      = StrArray[0]
TagArray      = StrArray[1]
BranchArray   = StrArray[2]
CurrentBranch =  VerArray + '.' + TagArray

global = PTR_NEW({ $
                   processing       : '(PROCESSING)',$
                   ok               : 'OK',$
                   failed           : 'FAILED',$
                   delta_x_draw     : 0.01,$
                   Q1x              : 0L,$ ;event.x for Q1
                   Q2x              : 0L,$ ;event.x for Q2
                   draw_xmin        : 60L,$
                   draw_xmax        : 632L,$
                   draw_ymin        : 40L,$
                   draw_ymax        : 570L,$
                   qminmax_label    : 'Enter or Select Qmin and Qmax',$
                   Q_selection      : 0,$ ;1 or 2
                   left_mouse_pressed : 0,$
                   Q1               : 0.,$ ;Qmin or Qmax
                   Q2               : 0.,$ ;Qmin or Qmax
                   X                : 0,$ ;current event.x of Q1 or Q2
                   Y                : 0,$ ;current event.y of Q1 or Q2
                   angleDisplayPrecision: 1000L,$ ;the precision of the angle value displayed
                   replot_me        : 1,$ ;to replot main plot will be 0 just after being replot
                   replotQnew       : 0,$
                   flt0_ptr         : ptrarr(20,/allocate_heap),$ ;arrays of all the x-axis
                   flt1_ptr         : ptrarr(20,/allocate_heap),$ ;arrays of all the y-axis
                   flt2_ptr         : ptrarr(20,/allocate_heap),$ ;arrays of all the y-error-axis
                   flt0_rescale_ptr : ptrarr(20,/allocate_heap),$ ;arrays of all the x-axis after rescaling
                   flt1_rescale_ptr : ptrarr(20,/allocate_heap),$ ;arrays of all the y-axis after rescaling
                   flt2_rescale_ptr : ptrarr(20,/allocate_heap),$ ;arrays of all the y-error-axis after rescaling
                   fit_cooef_ptr    : ptrarr(20,/allocate_heap),$ 
                   flt0_range       : ptrarr(2,/allocate_heap) ,$ ;flt0 between Q1 and Q2 for lowQ and hihgQ files
                   rescaling_ymax : 1.2,$ ;ymax when rescalling data
                   rescaling_ymin : 0,$ ;ymin when rescalling data
                   full_CE_name   : '',$ ;full path to CE file
                   short_CE_name  : '',$ ;short path to CE file
                   h_over_mn      : 0.0039554,$ ;h/mass of neutron in USI                   
                   FirstTimePlotting : 1,$ ;1 if first plot, 0 if not
                   NbrInfoLineToDisplay : 12,$ ;the number of line to display in info box
                   distanceMD     : 14.85,$ ;distance Moderator-Detector (m)
                   XYMinMax       : ptr_new(0L),$
                   ucams          : '',$ ;remote user ucams
                   file_extension : '.txt',$ ;file extension of file to load
                   input_path     : '',$ ;default path to file to load
                   PrevTabSelect  : 0,$ ;value of previous tab selected
                   angleValue     : float(0),$ ;current value of the angle (float)
                   CEcooef        : ptr_new(0L),$ ;the fitting coeff of the CE file
                   flt0_CE_range  : ptr_new(0L),$ ;flt0 between Q1 and Q2 for CE file
                   CE_scaling_factor : float(0),$ ;The CE scaling factor to go from Y to 1
                   metadata_CE_file: ptr_new(0L),$ ;first part of the CE input file
                   flt0_xaxis     : ptr_new(0L),$ ;x-axis of loaded file
                   flt1_yaxis     : ptr_new(0L),$ ;y-axis of loaded file
                   flt2_yaxis_err : ptr_new(0L),$ ;y-axis error of loaded file
                   FileHistory    : ptr_new(0L),$ ;#0:CE file #1:next file...etc
                   list_of_files  : ptr_new(0L),$ ;list of files loaded
                   NbrFilesLoaded : 0,$ ;number of files loaded
                   Q1_array       : ptr_new(0L),$ ;Q1 array
                   Q2_array       : ptr_new(0L),$ ;Q2 array
                   SF_array       : ptr_new(0L),$ ;Scalling factor array
                   angle_array    : ptr_new(0L),$ ;Angle value
                   color_array    : ptr_new(0L),$ ;index of color for each file 
                   Qmin_array     : ptr_new(0L),$ ;list of Qmin
                   Qmax_array     : ptr_new(0L),$ ;list of Qmax
                   ColorSliderDefaultValue : 25,$ ;default index value of color slider
                   PreviousColorIndex : 25,$ ;color index of previous run
                   ListOfLongFileName : ptr_new(0L),$ ;list of path of file loaded
                   show_CE_fit      : 0,$ ;0 means the step2 has not been performed
                   show_other_fit   : 0$ ;0 means that the step3 has not been done yet
})

CEcooef          = LONARR(3)
FileHistory      = STRARR(1)
list_of_files    = STRARR(1)
metadata_CE_file = STRARR(1)
Qmin_array       = FLTARR(1)
Qmax_array       = FLTARR(1)
Q1_array         = LONARR(1)
Q2_array         = LONARR(1)
SF_array         = LONARR(1)
angle_array      = FLTARR(1)
color_array      = LONARR(1)
ColorSliderDefaultValue = (*global).ColorSliderDefaultValue
color_array[0]     = ColorSliderDefaultValue
ListOfLongFileName = STRARR(1)

(*(*global).CEcooef)            = CEcooef
(*(*global).FileHistory)        = FileHistory
(*(*global).list_of_files)      = list_of_files
(*(*global).Qmin_array)         = Qmin_array
(*(*global).Qmax_array)         = Qmax_array
(*(*global).Q1_array)           = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).angle_array)        = angle_array
(*(*global).color_array)        = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*(*global).metadata_CE_file)   = metadata_CE_file
(*global).ucams                 = ucams

IF (!VERSION.os EQ 'darwin') THEN BEGIN
    (*global).input_path = '~/tmp/'
ENDIF ELSE BEGIN
    (*global).input_path = '~' + ucams
   (*global).input_path = '/SNS/REF_L/shared/' ;REMOVE_ME
ENDELSE

MainBaseSize         = [50 , 50, 1200, 600]
PlotWindowSize       = [5  , 5  , 650 , 590]
StepsTabSize         = [660, 5  , 530 , 400]

;general variables
distance_L_TB        = 35
distance_L_L         = 130
distanceVertical_L_L = 35

;Define titles
Step1Title  = 'STEP1: Load'
Step2Title  = 'STEP2: Critical Edge'
Step3Title  = 'STEP3: Other Files'
ListOfFiles = ['                                                   ']  
MainTitle   = "REFLECTOMETER RESCALING PROGRAM - " + VERSION

;Build Main Base
MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME     = 'MAIN_BASE',$
                        XOFFSET   = MainBaseSize[0],$
                        YOFFSET   = MainBaseSize[1],$
                        SCR_XSIZE = MainBaseSize[2], $
                        SCR_YSIZE = MainBaseSize[3], $
                        TITLE     = MainTitle)
;                        MBAR      = WID_BASE_0_MBAR)

PLOT_WINDOW = WIDGET_DRAW(MAIN_BASE,$
                          UNAME     = 'plot_window',$
                          XOFFSET   = PlotWindowSize[0],$
                          YOFFSET   = PlotWindowSize[1],$
                          SCR_XSIZE = PlotWindowSize[2],$
                          SCR_YSIZE = PlotWindowSize[3],$
                          RETAIN    = 2,$
                          /BUTTON_EVENTS,$
                          /MOTION_EVENTS)

STEPS_TAB = WIDGET_TAB(MAIN_BASE,$
                       UNAME     = 'steps_tab',$
                       LOCATION  = 0,$
                       XOFFSET   = StepsTabSize[0],$
                       YOFFSET   = StepsTabSize[1],$
                       SCR_XSIZE = StepsTabSize[2],$
                       SCR_YSIZE = StepsTabSize[3],$
                       /TRACKING_EVENTS)

;Build STEP1 tab
Step1Size = MakeGuiStep1(StepsTabSize, $
                         STEPS_TAB, $
                         strcompress((*global).distanceMD),$
                         strcompress((*global).angleValue),$
                         ListOfFiles,$
                         Step1Title)
                      
;Build STEP2 tab
MakeGuiStep2, STEPS_TAB,$
              Step1Size,$
              Step2Title,$
              distance_L_TB,$
              distance_L_L,$
              distanceVertical_L_L,$
              ListOfFiles

ListOfFiles = ['                                ' + $
               '                                ']
;Build STEP3 tab
MakeGuiStep3, STEPS_TAB,$
              Step1Size,$
              Step3Title,$
              ListOfFiles

;Buid OUTPUT_PLOT tab
MakeGuiOutputFile, STEPS_TAB,$
                   Step1Size

;Build SETTINGS tab
MakeGuiSettings, STEPS_TAB

;Build LogBook Tab
MakeGuiLogBook, STEPS_TAB, StepsTabSize

;Build Main Base Components
MakeGuiMainBaseComponents, MAIN_BASE, StepsTabSize

;Realize the widgets, set the user value of the top-level
;base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;; default tabs shown 
;id1 = widget_info(MAIN_BASE, find_by_uname='steps_tab') 
;widget_control, id1, set_tab_current = 5  ;remove_me (log book)

;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
ENDIF ELSE BEGIN
    spawn, logger_message
ENDELSE

end

;
; Empty stub procedure used for autoloading.
;
pro ref_scale, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
Build_GUI, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
