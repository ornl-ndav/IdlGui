PRO MakeGuiBankPlot, wBase, Xfactor, Yfactor

;********************************************************************************
;                           Define size arrays
;********************************************************************************

Yoff = 180
BankPlotBase = { size  : [50, $
                          50, $
                          8L*Xfactor, $
                          128L*Yfactor+Yoff],$
                 uname : 'bank_plot_base',$
                 title : 'BANK VIEW'}

InfoBase = { size  : [0,0,8L*Xfactor,Yoff]}
Xinput   = { size  : [0,0,8L*Xfactor,35],$
             uname : 'x_input',$
             value : 'Tube:',$
             xsize : 1}
Yinput   = { size  : [0,Xinput.size[3],8L*Xfactor,Xinput.size[3]],$
             uname : 'y_input',$
             value : 'Row:',$
             xsize : 3}
PixelID  = { size  : [0,Yinput.size[3]+Yinput.size[1],8L*Xfactor,1.5*Xinput.size[3]],$
             uname : 'pixelid_input',$
             value : 'PixelID:',$
             xsize : 6}
Counts   = { size   : [0,120,$
                       8L*Xfactor,2*Xinput.size[3]],$
             uname : 'counts',$
             value : 'Counts:',$
             xsize : 10}

;draw
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

wInputBase = WIDGET_BASE(wBase,$
                         XOFFSET   = InfoBase.size[0],$
                         YOFFSET   = InfoBase.size[1],$
                         SCR_XSIZE = InfoBase.size[2],$
                         SCR_YSIZE = InfoBase.size[3])

;X
wXinputBase = WIDGET_BASE(wInputBase,$
                          XOFFSET   = Xinput.size[0],$
                          YOFFSET   = Xinput.size[1],$
                          SCR_XSIZE = Xinput.size[2],$
                          SCR_YSIZE = Xinput.size[3])

wXinputField = CW_FIELD(wXinputBase,$
                        XSIZE = Xinput.xsize,$
                        UNAME = Xinput.uname,$
                        TITLE = Xinput.value,$
                        /ALL_EVENTS,$
                        /ROW,$
                        /INTEGER)

;Y 
wYinputBase = WIDGET_BASE(wInputBase,$
                          XOFFSET   = Yinput.size[0],$
                          YOFFSET   = Yinput.size[1],$
                          SCR_XSIZE = Yinput.size[2],$
                          SCR_YSIZE = Yinput.size[3])

wYinputField = CW_FIELD(wYinputBase,$
                        XSIZE = Yinput.xsize,$
                        UNAME = Yinput.uname,$
                        TITLE = Yinput.value,$
                        /ALL_EVENTS,$
                        /ROW,$
                        /INTEGER)

;PixelID
wPixelidBase = WIDGET_BASE(wInputBase,$
                           XOFFSET   = PixelID.size[0],$
                           YOFFSET   = PixelID.size[1],$
                           SCR_XSIZE = PixelID.size[2],$
                           SCR_YSIZE = PixelID.size[3])

wPixelidField = CW_FIELD(wPixelidBase,$
                        XSIZE = Pixelid.xsize,$
                        UNAME = Pixelid.uname,$
                        TITLE = Pixelid.value,$
                        /ALL_EVENTS,$
                        /COLUMN,$
                        /LONG)

;counts
wCountsBase = WIDGET_BASE(wInputBase,$
                          XOFFSET   = Counts.size[0],$
                          YOFFSET   = Counts.size[1],$
                          SCR_XSIZE = Counts.size[2],$
                          SCR_YSIZE = Counts.size[3])

wCountsField = CW_FIELD(wCountsBase,$
                        XSIZE = Counts.xsize,$
                        UNAME = Counts.uname,$
                        TITLE = Counts.value,$
                        /ALL_EVENTS,$
                        /COLUMN,$
                        /LONG)

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
