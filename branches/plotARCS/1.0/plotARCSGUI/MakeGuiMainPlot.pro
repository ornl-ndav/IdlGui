PRO MakeGuiMainPlot, wBase

;********************************************************************************
;                           Define size arrays
;********************************************************************************

MainPlotBase = { size  : [50,50,1425,790],$
                 uname : 'main_plot_base',$
                 title : 'Real View of Instrument (Y,X integrated over TOF)'}

MainDraw     = { size  : [0,0,MainPlotBase.size[2],$
                          MainPlotBase.size[3]],$
                 uname : 'main_plot'}

PSbutton     = { uname : 'plot_selection_button_mbar',$
                 value : 'PLOT SELECTION'}

PDVbutton    = { uname : 'plot_das_view_button_mbar',$
                 value : 'DAS view (Y vs X integrated over TOF)'}

PtofVbutton  = { uname : 'plot_tof_view_button_mbar',$
                 value : 'TOF view (tof vs X integrated over Y)'}

;********************************************************************************
;                                Build GUI
;********************************************************************************
ourGroup = WIDGET_BASE()
wBase = WIDGET_BASE(TITLE        = MainPlotBase.title,$
                    UNAME        = MainPlotBase.uname,$
                    XOFFSET      = MainPlotBase.size[0],$
                    YOFFSET      = MainPlotBase.size[1],$
                    SCR_XSIZE    = MainPlotBase.size[2],$
                    SCR_YSIZE    = MainPlotBase.size[3],$
                    MAP          = 1,$
                    GROUP_LEADER = ourGroup,$
                    MBAR         = MBAR)

wMainDraw = WIDGET_DRAW(wBase,$
                        XOFFSET   = MainDraw.size[0],$
                        YOFFSET   = MainDraw.size[1],$
                        SCR_XSIZE = MainDraw.size[2],$
                        SCR_YSIZE = MainDraw.size[3],$
                        UNAME     = MainDraw.uname)

plot_selection_button = WIDGET_BUTTON(MBAR,$
                                      UNAME = PSbutton.uname,$
                                      VALUE = PSbutton.value,$
                                      /MENU)

plot_das_view_button = WIDGET_BUTTON(plot_selection_button,$
                                     UNAME = PDVbutton.uname,$
                                     VALUE = PDVbutton.value)

plot_tof_view_button = WIDGET_BUTTON(plot_selection_button,$
                                     UNAME = PtofVbutton.uname,$
                                     VALUE = PtofVbutton.value)

WIDGET_CONTROL, wBase, /REALIZE

END
