pro Build_GUI, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

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
                   full_CE_name   : '',$             ;full path to CE file
                   short_CE_name  : '',$             ;short path to CE file
                   h_over_mn      : 3955.4,$         ;h/mass of neutron in USI                   
                   FirstTimePlotting : 1,$           ;1 if first plot, 0 if not
                   NbrInfoLineToDisplay : 12,$       ;the number of line to display in info box
                   distanceMD     : 14.85,$          ;distance Moderator-Detector (m)
                   XYMinMax       : ptr_new(0L),$
                   ucams          : '',$             ;remote user ucams
                   file_extension : '.txt',$         ;file extension of file to load
                   input_path     : '',$             ;default path to file to load
                   PrevTabSelect  : 0,$              ;value of previous tab selected
                   angleValue     : float(0),$              ;current value of the angle (float)
                   flt0_xaxis     : ptr_new(0L),$    ;x-axis of loaded file
                   flt1_yaxis     : ptr_new(0L),$    ;y-axis of loaded file
                   flt2_yaxis_err : ptr_new(0L),$    ;y-axis error of loaded file
                   FileHistory    : ptr_new(0L),$    ;#0:CE file #1:next file...etc
                   list_of_files  : ptr_new(0L),$    ;list of files loaded
                   Q1_array       : ptr_new(0L),$    ;Q1 array
                   Q2_array       : ptr_new(0L),$    ;Q2 array
                   SF_array       : ptr_new(0L),$    ;Scalling factor array
                   angle_array    : ptr_new(0L),$    ;Angle value
                   color_array    : ptr_new(0L),$    ;index of color for each file 
                   Qmin_array     : ptr_new(0L),$    ;list of Qmin
                   ColorSliderDefaultValue : 25,$    ;default index value of color slider
                   PreviousColorIndex : 25,$         ;color index of previous run
                   ListOfLongFileName : ptr_new(0L),$ ;list of path of file loaded
                   images_tabs    : ptr_new(0L),$    ;list of images of tabs (SF, ri...)
                   unames_tab2    : ptr_new(0L),$    ;list of widget_draw of tab2
                   unames_tab3    : ptr_new(0L),$    ;list of widget_draw of tab3
                   images_tabs_xoff : ptr_new(0L),$  ;images x_offset of tabs
                   images_tabs_yoff : ptr_new(0L)$   ;images y_offset of tabs  
                 })

FileHistory   = strarr(1)
list_of_files = strarr(1)
Qmin_array    = lonarr(1)
Q1_array      = lonarr(1)
Q2_array      = lonarr(1)
SF_array      = lonarr(1)
angle_array   = fltarr(1)
color_array   = lonarr(1)
ColorSliderDefaultValue = (*global).ColorSliderDefaultValue
color_array[0] = ColorSliderDefaultValue
ListOfLongFileName = strarr(1)
(*(*global).FileHistory) = FileHistory
(*(*global).list_of_files) = list_of_files
(*(*global).Qmin_array) = Qmin_array
(*(*global).Q1_array) = Q1_array
(*(*global).Q2_array) = Q2_array
(*(*global).SF_array) = SF_array
(*(*global).angle_array) = angle_array
(*(*global).color_array) = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*global).ucams      = ucams

if (!VERSION.os EQ 'darwin') then begin
   images_tabs = ["~/SVN/HistoTool/trunk/gui/RefLSupport/SF.bmp",$
                  "~/SVN/HistoTool/trunk/gui/RefLSupport/ri.bmp",$
                  "~/SVN/HistoTool/trunk/gui/RefLSupport/delta_ri.bmp"]
endif else begin
   images_tabs = ["/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/SF.bmp",$
                  "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/ri.bmp",$
                  "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/delta_ri.bmp"]
endelse
unames_tab2 = ["step2_sf_draw",$
               "step2_ri_draw",$
               "step2_delta_ri_draw"]
unames_tab3 = ["step3_sf_draw",$
               "step3_ri_draw",$
               "step3_delta_ri_draw"]

images_tabs_xoff = [-5,-8,-3]
images_tabs_yoff = [-4,0,-3]

(*(*global).images_tabs) = images_tabs
(*(*global).unames_tab2) = unames_tab2
(*(*global).unames_tab3) = unames_tab3
(*(*global).images_tabs_xoff) = images_tabs_xoff
(*(*global).images_tabs_yoff) = images_tabs_yoff

if (!VERSION.os EQ 'darwin') then begin
    (*global).input_path = '~/tmp/'
endif else begin
    (*global).input_path = '~' + ucams
endelse

MainBaseSize         = [50 , 500, 1200, 600]
PlotWindowSize       = [5  , 5  , 650 , 590]
StepsTabSize         = [660, 5  , 530 , 400]

;general variables
distance_L_TB        = 35
distance_L_L         = 130
distanceVertical_L_L = 35

;Define titles
Step1Title = 'LOAD FILES'
Step2Title = 'DEFINE CRITICAL EDGE FILE'
Step3Title = 'RESCALE FILES'
ListOfFiles  = ['                            ']  
MainTitle = "REF_L SUPPORT - CRITICAL EDGES PROGRAM"

;Build Main Base
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

;Build STEP3 tab
MakeGuiStep3, STEPS_TAB,$
              Step1Size,$
              Step3Title,$
              ListOfFiles

;Build SETTINGS tab
MakeGuiSettings, STEPS_TAB

;Build Main Base Components
MakeGuiMainBaseComponents, MAIN_BASE, StepsTabSize

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
Build_GUI, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
