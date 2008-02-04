PRO MakeGuiBankPlot, wBase, Xfactor, Yfactor

;********************************************************************************
;                           Define size arrays
;********************************************************************************

Yoff = 50
BankPlotBase = { size  : [50, $
                          50, $
                          8L*Xfactor, $
                          128L*Yfactor+Yoff],$
                 uname : 'bank_plot_base',$
                 title : 'BANK VIEW'}

BankDraw     = { size  : [0, $
                          0, $
                          BankPlotBase.size[2],$
                          BankPlotBase.size[3]],$
                 uname : 'bank_plot'}

;********************************************************************************
;                                Build GUI
;********************************************************************************
ourGroup = WIDGET_BASE()
wBase = WIDGET_BASE(TITLE        = BankPlotBase.title,$
                    UNAME        = BankPlotBase.uname,$
                    XOFFSET      = BankPlotBase.size[0],$
                    YOFFSET      = BankPlotBase.size[1],$
                    SCR_XSIZE    = BankPlotBase.size[2],$
                    SCR_YSIZE    = BankPlotBase.size[3],$
                    MAP          = 1,$
                    GROUP_LEADER = ourGroup)
;                    MBAR         = MBAR)

wBankDraw = WIDGET_DRAW(wBase,$
                        XOFFSET   = BankDraw.size[0],$
                        YOFFSET   = BankDraw.size[1],$
                        SCR_XSIZE = BankDraw.size[2],$
                        SCR_YSIZE = BankDraw.size[3],$
                        UNAME     = BankDraw.uname,$
                        /BUTTON_EVENTS,$
                        /MOTION_EVENTS)

WIDGET_CONTROL, wBase, /REALIZE

END
