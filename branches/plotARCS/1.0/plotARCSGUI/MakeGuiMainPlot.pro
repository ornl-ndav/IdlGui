PRO MakeGuiMainPlot, Event, wBase

;********************************************************************************
;                           Define size arrays
;********************************************************************************

MainPlotBase = { size  : [50,50,1425,790],$
                 uname : 'main_plot_base',$
                 title : 'Real View of Instrument (Y,X integrated over TOF)'}

MainDraw     = { size  : [0,0,MainPlotBase.size[2],$
                          MainPlotBase.size[3]],$
                 uname : 'main_plot'}

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
                    GROUP_LEADER = ourGroup)

wMainDraw = WIDGET_DRAW(wBase,$
                        XOFFSET   = MainDraw.size[0],$
                        YOFFSET   = MainDraw.size[1],$
                        SCR_XSIZE = MainDraw.size[2],$
                        SCR_YSIZE = MainDraw.size[3],$
                        UNAME     = MainDraw.uname)

WIDGET_CONTROL, wBase, /REALIZE
XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
END
