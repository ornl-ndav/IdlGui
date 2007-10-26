PRO MakeGuiSelectionTab, MAIN_TAB, MainTabSize, SelectionTitle, XYfactor

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************

CountsVsTofSize = [15,$
                   8,$
                   400,$
                   225]

OpenNeXusSelectionTab = [427,5,425,170]
OpenNeXusTitle        = ' NEXUS / ROI '
SelectionTitle        = '  SELECTION  '

XYPixelIDBaseSize     = [427,200,425,35]
xbaseSize             = [20,0,60,35]
ybasesize             = [xbaseSize[0]+80,$
                         xbaseSize[1],$
                         xbaseSize[2],$
                         xbaseSize[3]]
bankBaseSize          = [xbaseSize[0]+150,$
                         xbaseSize[1],$
                         80,$
                         xbaseSize[3]]
pixelIDbaseSize       = [xbaseSize[0]+250,$
                         xbaseSize[1],$
                         150,$
                         xbaseSize[3]]

Xfactor = XYfactor.Xfactor 
Yfactor = XYfactor.Yfactor
TopBankSize    = [15, $
                  245, $
                  56*Xfactor, $
                  64*Yfactor]
BottomBankSize = [TopBankSize[0], $
                  510, $
                  TopBankSize[2], $
                  TopBanksize[3]]

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionBase = WIDGET_BASE(MAIN_TAB,$
                            XOFFSET   = 0,$
                            YOFFSET   = 0,$
                            SCR_XSIZE = MainTabSize[2],$
                            SCR_YSIZE = MainTabSize[3],$
                            TITLE     = SelectionTitle)

;COUNTS VS TOF
COUNTS_VS_TOF = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'counts_vs_tof_draw',$
                            XOFFSET   = CountsVsTofSize[0],$
                            YOFFSET   = CountsVsTofSize[1],$
                            SCR_XSIZE = CountsVsTofSize[2],$
                            SCR_YSIZE = CountsVsTofSize[3],$
                            /MOTION_EVENTS,$
                            /BUTTON_EVENTS)

;NeXus/ROI & SELECTION tab
NeXusRoiSelectionTab = WIDGET_TAB(SelectionBase,$
                                  UNAME     = 'nexus_roi_selection_tab',$
                                  LOCATION  = 0,$
                                  XOFFSET   = OpenNeXusSelectionTab[0],$
                                  YOFFSET   = OpenNeXusSelectionTab[1],$
                                  SCR_XSIZE = OpenNeXusSelectionTab[2],$
                                  SCR_YSIZE = OpenNeXusSelectionTab[3],$
                                  SENSITIVE = 1,$
                                  /TRACKING_EVENTS)

;make NeXus/ROI tab (tab#1)
MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, OpenNeXusTitle

;make Selection tab (tab#2)
MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, SelectionTitle

;X, Y and pixelID info box
XYPixelIDBase = WIDGET_BASE(SelectionBase,$
                            XOFFSET   = XYPixelIDBaseSize[0],$
                            YOFFSET   = XYPixelIDBaseSize[1],$
                            SCR_XSIZE = XYPixelIDBaseSize[2],$
                            SCR_YSIZE = XYPixelIDBaseSize[3],$
                            FRAME     = 1)

xbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = xbaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = xbaseSize[2],$
                    SCR_YSIZE = xbaseSize[3])

Xfield = CW_FIELD(xbase,$
                  UNAME         = 'x_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'X:',$
                  ROW           = 1,$
                  XSIZE         = 2)

ybase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = ybaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = ybaseSize[2],$
                    SCR_YSIZE = ybaseSize[3])

Yfield = CW_FIELD(ybase,$
                  UNAME         = 'y_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'Y:',$
                  ROW           = 1,$
                  XSIZE         = 2)

bankBase = WIDGET_BASE(XYPixelIDBase,$
                       XOFFSET   = bankBaseSize[0],$
                       YOFFSET   = bankBaseSize[1],$
                       SCR_XSIZE = bankBaseSize[2],$
                       SCR_YSIZE = bankBaseSize[3])

bankfield = CW_FIELD(bankBase,$
                     UNAME         = 'bank_value',$
                     RETURN_EVENTS = 1,$
                     TITLE         = 'Bank:',$
                     ROW           = 1,$
                     XSIZE         = 1)


pixelIDbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = pixelIDbaseSize[0],$
                    YOFFSET   = pixelIDbaseSize[1],$
                    SCR_XSIZE = pixelIDbaseSize[2],$
                    SCR_YSIZE = pixelIDbaseSize[3])

Pixelfield = CW_FIELD(pixelIDbase,$
                      UNAME         = 'pixel_value',$
                      RETURN_EVENTS = 1,$
                      TITLE         = 'PixelID:',$
                      ROW           = 1,$
                      XSIZE         = 5)






;TOP_BANK
TOP_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'top_bank_draw',$
                            XOFFSET   = TopBankSize[0],$
                            YOFFSET   = TopBankSize[1],$
                            SCR_XSIZE = TopBankSize[2],$
                            SCR_YSIZE = TopBankSize[3],$
                            /BUTTON_EVENTS,$
                            /MOTION_EVENTS)

;BOTTOM_BANK
BOTTOM_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                               UNAME     = 'bottom_bank_draw',$
                               XOFFSET   = BottomBankSize[0],$
                               YOFFSET   = BottomBankSize[1],$
                               SCR_XSIZE = BottomBankSize[2],$
                               SCR_YSIZE = BottomBankSize[3],$
                               /BUTTON_EVENTS,$
                               /MOTION_EVENTS)



END
