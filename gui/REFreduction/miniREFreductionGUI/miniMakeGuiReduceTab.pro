PRO miniMakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle, PlotsTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
ReduceTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]
IndividualBaseWidth = 720

;Build widgets
REDUCE_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME='reduce_base',$
                          TITLE=ReduceTabTitle,$
                          XOFFSET=ReduceTabSize[0],$
                          YOFFSET=ReduceTabSize[1],$
                          SCR_XSIZE=ReduceTabSize[2],$
                          SCR_YSIZE=ReduceTabSize[3])

;create data base
miniMakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

;create normalization base
miniMakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;create Q base
miniMakeGuiReduceQBase, Event, REDUCE_BASE, IndividualBaseWidth

;create detector angle
miniMakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;create intermediate plot base
miniMakeGuiReduceIntermediatePlotBase, Event, REDUCE_BASE, IndividualBaseWidth, PlotsTitle

;create other component of base
miniMakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;create GeneralInfoTextField
miniMakeGuiReduceInfo, Event, REDUCE_BASE

END
