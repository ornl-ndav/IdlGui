PRO MakeGuiTofBase, wBase

;********************************************************************************
;                           Define size arrays
;********************************************************************************
TofPlotBase = { size  : [0,0,500,500],$
                uname : 'tof_plot_base',$
                title : '' }

TofPlotDraw = { size  : [0,0, $
                         TofPlotBase.size[2], $
                         TofPlotBase.size[3]],$
                uname : 'tof_plot_draw' }

;********************************************************************************
;                                Build GUI
;********************************************************************************
ourGroup = WIDGET_BASE()
wBase = WIDGET_BASE(TITLE        = TofPlotBase.title,$
                    UNAME        = TofPlotBase.uname,$
                    XOFFSET      = TofPlotBase.size[0],$
                    YOFFSET      = TofPlotBase.size[1],$
                    SCR_XSIZE    = TofPlotBase.size[2],$
                    SCR_YSIZE    = TofPlotBase.size[3],$
                    MAP          = 1,$
                    GROUP_LEADER = ourGroup)
;                    MBAR         = MBAR)

wTofDraw = WIDGET_DRAW(wBase,$
                       XOFFSET   = TofPLotDraw.size[0],$
                       YOFFSET   = TofPLotDraw.size[1],$
                       SCR_XSIZE = TofPLotDraw.size[2],$
                       SCR_YSIZE = TofPLotDraw.size[3],$
                       UNAME     = TofPLotDraw.uname,$
                       /BUTTON_EVENTS,$
                       /MOTION_EVENTS)

WIDGET_CONTROL, wBase, /REALIZE


END
